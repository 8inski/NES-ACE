/* Generate Byte Stream to Create Text Payload Through ASM Program */

#pragma once

#include <string>
#include <string_view>
#include <vector>
#include <cstdint>
#include <cstddef>
#include <expected>
#include <utility>

namespace GeneratePPU {

	// Size and Location of RAM Buffer to Push Data to PPU
	constexpr std::uint16_t PPU_ADDRESS = 0x7BD0;
	constexpr std::uint8_t PPU_SIZE = 77;

	// PPU Errors
	enum class ErrorType {
		InvalidInitial,
		PayloadOutsidePPU,
		PayloadLength
	};

	struct Error {
		ErrorType error;
		std::string cleaned_payload;
		std::size_t overflow{};
	};

	// Return Struct for Public API
	struct Result {
		std::string cleaned_payload;
		std::string wrapped_payload;
		bool can_wrap;
		std::size_t length{};
		std::vector<std::uint8_t> byte_code;
		std::vector<std::string> inputs;
	};

	// Convert String to PPU TAS Input Payload, Public API for GUI
	std::expected<Result, Error> buildResult(std::string_view initial_str, std::string_view payload);
}
