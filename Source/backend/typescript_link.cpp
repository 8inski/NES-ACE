/* JSON Bridge Between Electron and NES ACE Backend */

#include <cstddef>
#include <cstdint>
#include <exception>
#include <iostream>
#include <string>
#include <type_traits>
#include <utility>
#include <vector>

#include <glaze/glaze.hpp>

#include "nes_ace.assembler.hpp"
#include "nes_ace.convert_tas.hpp"
#include "nes_ace.generate_ppu.hpp"
#include "nes_ace.glossary.hpp"
#include "nes_ace.utils.hpp"

namespace {

	/* ============================= JSON Request and Response Types ============================= */

	// Define Every Possible Value That Can Be Sent in a Backend Request
	struct Payload {
		std::string mnemonic;
		std::string source;
		bool useUndocumented{};
		std::string address;
		std::string text;
		std::string emulator;
	};

	// Represent One Complete Request Received from Electron
	struct Request {
		std::uint64_t id{};
		std::string action;
		Payload payload;
	};

	// Wrap Any Backend Result in a Consistent JSON Response
	template <typename Result>
	struct Response {
		std::uint64_t id{};
		bool ok{};
		Result result;
		std::string error;
	};

	// Represent One Cleaned Assembler Line for GUI Display
	struct AssemblerLine {
		std::string cleanedLine;
	};

	// Represent One Indexed Assembler Error for GUI Display
	struct AssemblerError {
		std::size_t index{};
		std::string cleanedLine;
		std::string error;
	};

	// Represent One Assembled Segment and Its Address Range
	struct AssemblerSegment {
		std::size_t index{};
		std::size_t length{};
		std::uint16_t origin{};
		std::uint16_t end{};
	};

	// Store the Complete Frontend-Facing Assembler Result
	struct AssemblerResponse {
		std::vector<AssemblerLine> cleanedProgram;
		std::vector<AssemblerError> errors;
		std::vector<AssemblerSegment> segments;
		std::vector<std::uint8_t> byteCode;
		std::vector<std::string> inputs;
	};

	// Store the Complete Frontend-Facing PPU Conversion Result
	struct PpuResponse {
		bool valid{};
		std::string error;
		std::string cleanedPayload;
		std::string wrappedPayload;
		bool canWrap{};
		std::size_t length{};
		std::size_t overflow{};
		std::vector<std::uint8_t> byteCode;
		std::vector<std::string> inputs;
	};

	// Store the Original and Converted TAS Input Lines
	struct TasResponse {
		std::vector<std::string> inputs;
		std::vector<std::string> convertedInputs;
		std::size_t lagFrames{};
	};

	/* ==================================== JSON Error Codes ===================================== */

	// Convert an Assembler Error Type into a JSON Error Code
	std::string assemblerErrorCode(Assembler::ErrorType error) {

		switch (error) {

			case Assembler::ErrorType::None:
				return "none";

			case Assembler::ErrorType::Syntax:
				return "syntax";

			case Assembler::ErrorType::InvalidLabel:
				return "invalid-label";

			case Assembler::ErrorType::InvalidInstruction:
				return "invalid-instruction";

			case Assembler::ErrorType::UndocumentedInstruction:
				return "undocumented-instruction";

			case Assembler::ErrorType::InvalidOperand:
				return "invalid-operand";

			case Assembler::ErrorType::InvalidMode:
				return "invalid-mode";

			case Assembler::ErrorType::InvalidOrg:
				return "invalid-origin";

			case Assembler::ErrorType::InvalidConst:
				return "invalid-constant";

			case Assembler::ErrorType::InvalidData:
				return "invalid-data";

			case Assembler::ErrorType::DuplicateSymbol:
				return "duplicate-symbol";

			case Assembler::ErrorType::UndefinedSymbol:
				return "undefined-symbol";

			case Assembler::ErrorType::BranchOutOfRange:
				return "branch-out-of-range";

			case Assembler::ErrorType::MissingOrg:
				return "missing-origin";
		}

		return "unknown-assembler-error";
	}

	// Convert a PPU Conversion Error into a JSON Error Code
	std::string ppuErrorCode(GeneratePPU::ErrorType error) {

		switch (error) {

			case GeneratePPU::ErrorType::InvalidInitial:
				return "invalid-initial";

			case GeneratePPU::ErrorType::PayloadOutsidePPU:
				return "outside-nametable";

			case GeneratePPU::ErrorType::PayloadLength:
				return "exceeds-buffer";
		}

		return "unknown-ppu-error";
	}

	/* ================================ Backend Result Conversion ================================ */

	// Convert an Assembler Backend Result into Its Frontend Response Format
	AssemblerResponse makeAssemblerResponse(Assembler::Result result) {

		AssemblerResponse response;

		response.cleanedProgram.reserve(result.cleaned_program.size());
		response.errors.reserve(result.errors.size());
		response.segments.reserve(result.segments.size());

		for (auto& line : result.cleaned_program) {
			response.cleanedProgram.push_back({
				.cleanedLine = std::move(line.cleaned_line)
			});
		}

		for (auto& error : result.errors) {
			response.errors.push_back({
				.index = error.index,
				.cleanedLine = std::move(error.cleaned_line),
				.error = assemblerErrorCode(error.error)
			});
		}

		for (const auto& segment : result.segments) {
			response.segments.push_back({
				.index = segment.index,
				.length = segment.length,
				.origin = segment.origin,
				.end = segment.end
			});
		}

		response.byteCode = std::move(result.byte_code);
		response.inputs = std::move(result.inputs);

		return response;
	}

	// Convert a Successful PPU Backend Result into Its Frontend Response Format
	PpuResponse makePpuResponse(GeneratePPU::Result result) {

		return {
			.valid = true,
			.cleanedPayload = std::move(result.cleaned_payload),
			.wrappedPayload = std::move(result.wrapped_payload),
			.canWrap = result.can_wrap,
			.length = result.length,
			.byteCode = std::move(result.byte_code),
			.inputs = std::move(result.inputs)
		};
	}

	// Convert a PPU Backend Error into Its Frontend Response Format
	PpuResponse makePpuResponse(GeneratePPU::Error error) {

		return {
			.valid = false,
			.error = ppuErrorCode(error.error),
			.cleanedPayload = std::move(error.cleaned_payload),
			.overflow = error.overflow
		};
	}

	// Convert a TAS Backend Result into Its Frontend Response Format
	TasResponse makeTasResponse(ConvertTAS::Result result) {

		return {
			.inputs = std::move(result.valid_inputs),
			.convertedInputs = std::move(result.converted_inputs),
			.lagFrames = result.lag_frames
		};
	}

	/* ================================== JSON Response Output =================================== */

	// Serialize One Backend Response and Write It to Electron
	template <typename Result>
	void writeResponse(const Response<Result>& response) {

		std::string output;

		const auto error = glz::write_json(response, output);

		if (error) {

			std::cerr << "Failed to serialize backend response\n";

			std::cout
				<< R"({"id":0,"ok":false,"result":"","error":"Response serialization failed"})"
				<< '\n'
				<< std::flush;

			return;
		}

		std::cout
			<< output
			<< '\n'
			<< std::flush;
	}

	// Write a Successful Response Containing Any Supported Result Type
	template <typename Result>
	void writeSuccess(std::uint64_t id, Result result) {

		writeResponse(Response<std::decay_t<Result>>{
			.id = id,
			.ok = true,
			.result = std::move(result),
			.error = {}
		});
	}

	// Write a Failed Response Containing an Error Message
	void writeError(std::uint64_t id, std::string error) {

		writeResponse(Response<std::string>{
			.id = id,
			.ok = false,
			.result = {},
			.error = std::move(error)
		});
	}

	/* ================================ Backend Request Dispatch ================================= */

	// Dispatch One Parsed Request to the Appropriate Backend Operation
	void handleRequest(const Request& request) {

		if (request.action == "glossary") {

			writeSuccess(
				request.id,
				Utils::joinString(
					Glossary::buildResult(request.payload.mnemonic),
					'\n'
				)
			);

			return;
		}

		if (request.action == "assemble") {

			writeSuccess(
				request.id,
				makeAssemblerResponse(
					Assembler::buildResult(
						Utils::splitString(request.payload.source, '\n'),
						request.payload.useUndocumented
					)
				)
			);

			return;
		}

		if (request.action == "convertPpu") {

			auto result = GeneratePPU::buildResult(
				request.payload.address,
				request.payload.text
			);

			if (!result) {
				writeSuccess(
					request.id,
					makePpuResponse(
						std::move(result).error()
					)
				);

				return;
			}

			writeSuccess(
				request.id,
				makePpuResponse(std::move(*result))
			);

			return;
		}

		if (request.action == "convertTas") {

			ConvertTAS::Emulator emulator;
			ConvertTAS::GameMode game_mode;

			if (request.payload.emulator == "fceux-2p") {
				emulator = ConvertTAS::Emulator::FCEUX;
				game_mode = ConvertTAS::GameMode::TwoPlayer;

			} else if (request.payload.emulator == "fceux-1p") {
				emulator = ConvertTAS::Emulator::FCEUX;
				game_mode = ConvertTAS::GameMode::OnePlayer;

			} else if (request.payload.emulator == "neshawk-2p") {
				emulator = ConvertTAS::Emulator::NESHawk;
				game_mode = ConvertTAS::GameMode::TwoPlayer;

			} else if (request.payload.emulator == "neshawk-1p") {
				emulator = ConvertTAS::Emulator::NESHawk;
				game_mode = ConvertTAS::GameMode::OnePlayer;

			} else {

				writeError(
					request.id,
					"Unknown TAS source emulator or player mode."
				);

				return;
			}

			writeSuccess(
				request.id,
				makeTasResponse(
					ConvertTAS::buildResult(
						Utils::splitString(request.payload.source, '\n'),
						emulator,
						game_mode
					)
				)
			);

			return;
		}

		writeError(
			request.id,
			"Unknown backend action: " + request.action
		);
	}
}

/* ================================= Persistent Backend Process ================================== */

// Read and Process JSON Requests Until Electron Closes the Input Pipe
int main() {

	std::ios::sync_with_stdio(false);
	std::cin.tie(nullptr);

	std::string input;

	while (std::getline(std::cin, input)) {

		if (input.empty()) {
			continue;
		}

		Request request;

		const auto error = glz::read_json(request, input);

		if (error) {

			std::cerr
				<< glz::format_error(error, input)
				<< '\n';

			writeError(0, "Invalid JSON request");

			continue;
		}

		try {

			handleRequest(request);

		} catch (const std::exception& exception) {

			std::cerr
				<< "Backend exception: "
				<< exception.what()
				<< '\n';

			writeError(
				request.id,
				"Backend operation failed: " + std::string(exception.what())
			);

		} catch (...) {

			std::cerr << "Unknown backend exception\n";

			writeError(
				request.id,
				"Unknown backend failure"
			);
		}
	}

	return 0;
}
