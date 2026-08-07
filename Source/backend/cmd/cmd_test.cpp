/* Command Line Test Bed for NES ACE */

#include <algorithm>
#include <chrono>
#include <format>
#include <fstream>
#include <functional>
#include <iostream>
#include <numeric>
#include <print>
#include <string>
#include <string_view>
#include <vector>
#include <variant>
#include <ranges>
#include <utility>

#include "nes_ace.glossary.hpp"
#include "nes_ace.assembler.hpp"
#include "nes_ace.generate_ppu.hpp"
#include "nes_ace.convert_tas.hpp"

struct BenchmarkTimes {
	std::vector<double> glossary;
	std::vector<double> assembler;
	std::vector<double> ppu_generator;
	std::vector<double> tas_converter;
};

struct BenchmarkStats {
	double mean = 0.0;
	double median = 0.0;
	double minimum = 0.0;
	double maximum = 0.0;
};

// Calculate Benchmark Statistics
BenchmarkStats calculateStats(const std::vector<double>& times) {

	if (times.empty()) {
		return {};
	}

	std::vector<double> sorted_times = times;
	std::ranges::sort(sorted_times);

	const std::size_t midpoint = sorted_times.size() / 2;

	double median = sorted_times[midpoint];

	if (sorted_times.size() % 2 == 0) {
		median = (sorted_times[midpoint - 1] + sorted_times[midpoint]) / 2.0;
	}

	return {
		.mean = std::accumulate(times.begin(), times.end(), 0.0) / static_cast<double>(times.size()),
		.median = median,
		.minimum = sorted_times.front(),
		.maximum = sorted_times.back()
	};
}

// Display Benchmark Statistics for One Mode
void displayStats(std::string_view mode, const std::vector<double>& times) {

	const BenchmarkStats stats = calculateStats(times);

	std::println(
		"{:<24}{:>8}{:>16.6f}{:>16.6f}{:>16.6f}{:>16.6f}",
		mode,
		times.size(),
		stats.mean,
		stats.median,
		stats.minimum,
		stats.maximum
	);
}

// Display Complete Benchmark Summary
void displayBenchmarkSummary(const BenchmarkTimes& times) {

	std::println();
	std::println("Benchmark Summary (Milliseconds)");
	std::println();

	std::println(
		"{:<24}{:>8}{:>16}{:>16}{:>16}{:>16}",
		"Mode",
		"Runs",
		"Mean",
		"Median",
		"Minimum",
		"Maximum"
	);

	displayStats("Glossary", times.glossary);
	displayStats("Assembler", times.assembler);
	displayStats("PPU Payload Generator", times.ppu_generator);
	displayStats("TAS Converter", times.tas_converter);
}

// Time Execution of Any Non-Void Function
template <typename Func, typename... Args>
auto time_it(std::vector<double>& times, Func&& func, Args&&... args) {

	auto start = std::chrono::steady_clock::now();
	auto result = std::invoke(std::forward<Func>(func), std::forward<Args>(args)...);
	auto end = std::chrono::steady_clock::now();

	std::chrono::duration<double, std::milli> elapsed = end - start;
	times.push_back(elapsed.count());

	std::println("Execution Time: {} Milliseconds", elapsed.count());

	return result;
}

// Glossary Loop
void glossary(std::vector<double>* times = nullptr) {

	std::string mnemonic;

	std::print("Enter a 6502 Mnemonic: ");
	std::getline(std::cin, mnemonic);

	std::println();

	if (times != nullptr) {
		(void)time_it(*times, Glossary::buildResult, mnemonic);
		return;
	}

	std::vector<std::string> result = Glossary::buildResult(mnemonic);

	for (const auto& line : result) {
		std::println("{}", line);
	}
}

std::string errorToString(Assembler::ErrorType error) {

	switch (error) {

		case Assembler::ErrorType::None:
			return "";

		case Assembler::ErrorType::Syntax:
			return "Syntax Error";

		case Assembler::ErrorType::InvalidLabel:
			return "Invalid Label";

		case Assembler::ErrorType::InvalidInstruction:
			return "Invalid Instruction";

		case Assembler::ErrorType::UndocumentedInstruction:
			return "Undocumented Instruction";

		case Assembler::ErrorType::InvalidOperand:
			return "Invalid Operand";

		case Assembler::ErrorType::InvalidMode:
			return "Invalid Addressing Mode";

		case Assembler::ErrorType::InvalidOrg:
			return "Invalid Origin Directive";

		case Assembler::ErrorType::InvalidConst:
			return "Invalid Constant Directive";

		case Assembler::ErrorType::InvalidData:
			return "Invalid Data Directive";

		case Assembler::ErrorType::DuplicateSymbol:
			return "Duplicate Symbol";

		case Assembler::ErrorType::UndefinedSymbol:
			return "Undefined Symbol";

		case Assembler::ErrorType::BranchOutOfRange:
			return "Branch Out of Range";

		case Assembler::ErrorType::MissingOrg:
			return "Missing Origin Directive";
	}

	return "";
}

// Assembler Loop
void assembler(std::vector<double>* times = nullptr) {

	std::vector<std::string> raw_lines;

	bool valid_file = false;

	while (!valid_file) {

		std::string filename;

		std::print("Enter File Name: ");
		std::getline(std::cin, filename);

		std::println();

		std::ifstream asm_file(filename);

		if (!asm_file.is_open()) {
			std::print("File Failed to Open\n\n");
			continue;
		}

		std::string current_line;

		while (std::getline(asm_file, current_line)) {
			raw_lines.push_back(current_line);
		}

		asm_file.close();
		valid_file = true;
	}

	bool valid_undocumented = false;
	bool use_undocumented = false;

	while (!valid_undocumented) {

		std::string y_n;

		std::print("Use Undocumented Instructions? (Y/N): ");
		std::getline(std::cin, y_n);

		std::println();

		if (y_n == "Y" || y_n == "y") {
			use_undocumented = true;
			valid_undocumented = true;

		} else if (y_n == "N" || y_n == "n") {
			valid_undocumented = true;

		} else {
			std::print("Invalid Selection\n\n");
			continue;
		}
	}

	if (times != nullptr) {
		(void)time_it(*times, Assembler::buildResult, raw_lines, use_undocumented);
		return;
	}

	Assembler::Result result = Assembler::buildResult(raw_lines, use_undocumented);

	for (const auto& line : result.cleaned_program) {
		std::println("{}", line.cleaned_line);
	}

	std::println();

	if (!result.errors.empty()) {

		std::print(
			"{} {} Found:\n\n",
			result.errors.size(),
			(result.errors.size() == 1) ? "Error" : "Errors"
		);

		for (const auto& error : result.errors) {
			std::print(
				"Line {}: {}\n{}\n\n",
				error.index + 1,
				errorToString(error.error),
				error.cleaned_line
			);
		}

		return;
	}

	const std::size_t max_digits_segments = std::to_string(result.segments.size()).size();
	std::size_t max_digits_bytes = 0;

	for (const auto& segment : result.segments) {
		max_digits_bytes = std::max(
			max_digits_bytes,
			std::to_string(segment.length).size()
		);
	}

	std::print(
		"{} {} Generated:\n\n",
		result.segments.size(),
		(result.segments.size() == 1) ? "Segment" : "Segments"
	);

	for (const auto& segment : result.segments) {
		std::println(
			"Segment {:0>{}}: {:>{}} {} (${:04X} - ${:04X})",
			segment.index + 1,
			max_digits_segments,
			segment.length,
			max_digits_bytes,
			(segment.length == 1) ? "Byte " : "Bytes",
			segment.origin,
			segment.end
		);
	}

	std::println();

	for (const auto& [i, byte] : std::views::enumerate(result.byte_code)) {

		std::print("{:02X}", byte);

		if ((i + 1) % 16 == 0) {
			std::println();
			continue;
		}

		std::print(" ");
	}

	std::print("\n\n");

	for (const auto& input : result.inputs) {
		std::println("{}", input);
	}
}

// PPU Payload Generator Loop
void ppuGen(std::vector<double>* times = nullptr) {

	std::string payload;
	std::string initial;

	std::print("Enter Payload: ");
	std::getline(std::cin, payload);

	std::println();

	std::print("Enter Initial Address: ");
	std::getline(std::cin, initial);

	std::println();

	if (times != nullptr) {
		(void)time_it(*times, GeneratePPU::buildResult, initial, payload);
		return;
	}

	auto ppu = GeneratePPU::buildResult(initial, payload);

	if (!ppu) {

		GeneratePPU::Error error = std::move(ppu).error();

		if (error.error == GeneratePPU::ErrorType::InvalidInitial) {
			std::println("Invalid PPU Address");

		} else if (error.error == GeneratePPU::ErrorType::PayloadOutsidePPU) {
			std::println("Payload Extends Outside PPU Nametable Range ($2000 - $23BF)");

		} else if (error.error == GeneratePPU::ErrorType::PayloadLength) {
			std::println(
				"Payload Length Exceeds RAM Buffer Size by {} {}",
				error.overflow,
				(error.overflow == 1) ? "Character" : "Characters"
			);
		}

		return;
	}

	GeneratePPU::Result result = std::move(*ppu);

	std::print("{}\n\n", result.cleaned_payload);
	std::print("Payload Length: {}\n\n", result.length);

	if (!result.can_wrap) {
		std::print("**WARNING**\nUnable to Provide Correctly Wrapped Payload\n\n");

	} else if (result.cleaned_payload != result.wrapped_payload) {
		std::print("**WARNING**\nPayload Will Wrap Incorrectly\n\nRecommended Payload:\n{}\n\n", result.wrapped_payload);
	}

	for (const auto& [i, byte] : std::views::enumerate(result.byte_code)) {

		std::print("{:02X}", byte);

		if ((i + 1) % 16 == 0) {
			std::println();
			continue;
		}

		std::print(" ");
	}

	std::print("\n\n");

	for (const auto& line : result.inputs) {
		std::println("{}", line);
	}
}

// TAS Converter Loop
void tasConvert(std::vector<double>* times = nullptr) {

	std::vector<std::string> raw_lines;

	bool valid_file = false;

	while (!valid_file) {

		std::string filename;

		std::print("Enter File Name: ");
		std::getline(std::cin, filename);

		std::println();

		std::ifstream tas_file(filename);

		if (!tas_file.is_open()) {
			std::print("File Failed to Open\n\n");
			continue;
		}

		std::string current_line;

		while (std::getline(tas_file, current_line)) {
			raw_lines.push_back(current_line);
		}

		tas_file.close();
		valid_file = true;
	}

	ConvertTAS::Emulator emulator;
	ConvertTAS::GameMode mode;

	bool valid_emu = false;

	while (!valid_emu) {

		std::string emu;

		std::print("Choose Emulator (F: FCEUX or N: NESHawk): ");
		std::getline(std::cin, emu);

		std::println();

		if (emu == "F" || emu == "f") {
			emulator = ConvertTAS::Emulator::FCEUX;
			valid_emu = true;

		} else if (emu == "N" || emu == "n") {
			emulator = ConvertTAS::Emulator::NESHawk;
			valid_emu = true;

		} else {
			std::print("Invalid Emulator\n\n");
			continue;
		}
	}

	bool valid_players = false;

	while (!valid_players) {

		std::string players;

		std::print("Choose Game Mode (1: 1 Player or 2: 2 Players): ");
		std::getline(std::cin, players);

		std::println();

		if (players == "1") {
			mode = ConvertTAS::GameMode::OnePlayer;
			valid_players = true;

		} else if (players == "2") {
			mode = ConvertTAS::GameMode::TwoPlayer;
			valid_players = true;

		} else {
			std::print("Invalid Game Mode\n\n");
			continue;
		}
	}

	if (times != nullptr) {
		(void)time_it(*times, ConvertTAS::buildResult, raw_lines, emulator, mode);
		return;
	}

	ConvertTAS::Result result = ConvertTAS::buildResult(raw_lines, emulator, mode);

	std::print("Lag Frames: {}\n\n", result.lag_frames);

	for (const auto& line : result.valid_inputs) {
		std::println("{}", line);
	}

	std::println();

	for (const auto& line : result.converted_inputs) {
		std::println("{}", line);
	}
}

// Everything Runs Normally
void normalMode() {

	bool running = true;

	while (running) {

		std::println();

		std::println(
			"Enter a Mode (Q to Quit)\n\n"
			"0: Glossary\n"
			"1: Assembler\n"
			"2: PPU Payload Generator\n"
			"3: TAS Converter\n"
		);

		std::string mode;
		std::getline(std::cin, mode);

		std::println();

		if (mode == "Q" || mode == "q") {
			running = false;

		} else if (mode == "0") {
			glossary();
			std::println();

		} else if (mode == "1") {
			assembler();
			std::println();

		} else if (mode == "2") {
			ppuGen();
			std::println();

		} else if (mode == "3") {
			tasConvert();
			std::println();

		} else {
			std::print("Invalid Selection\n\n");
		}
	}
}

// All Loops Run in Benchmark Mode with Timing Summary
void benchmarkMode() {

	BenchmarkTimes times;
	bool running = true;

	while (running) {

		std::println();

		std::println(
			"Enter a Mode (Q to Quit)\n\n"
			"0: Glossary\n"
			"1: Assembler\n"
			"2: PPU Payload Generator\n"
			"3: TAS Converter\n"
		);

		std::string mode;
		std::getline(std::cin, mode);

		std::println();

		if (mode == "Q" || mode == "q") {
			running = false;

		} else if (mode == "0") {
			glossary(&times.glossary);
			std::println();

		} else if (mode == "1") {
			assembler(&times.assembler);
			std::println();

		} else if (mode == "2") {
			ppuGen(&times.ppu_generator);
			std::println();

		} else if (mode == "3") {
			tasConvert(&times.tas_converter);
			std::println();

		} else {
			std::print("Invalid Selection\n\n");
		}
	}

	displayBenchmarkSummary(times);
}

// -b Flag Runs in Benchmark Mode
int main(int argc, char* argv[]) {

	bool benchmark = false;

	for (int i = 1; i < argc; ++i) {

		if (std::string_view(argv[i]) == "-b") {
			benchmark = true;
			break;
		}
	}

	if (benchmark) {
		std::println();
		std::println("Running in Benchmark Mode");
		benchmarkMode();

	} else {
		normalMode();
	}

	return 0;
}
