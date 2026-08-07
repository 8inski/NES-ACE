/* Generate Byte Stream to Create Text Payload Through ASM Program */

#include "nes_ace.generate_ppu.hpp"

#include <string>
#include <string_view>
#include <vector>
#include <array>
#include <flat_map>
#include <cstdint>
#include <cstddef>
#include <expected>
#include <ranges>
#include <algorithm>
#include <utility>

#include "nes_ace.generate_tas.hpp"
#include "nes_ace.utils.hpp"

namespace GeneratePPU {

	namespace {

		// Map Characters to SMB3 Pattern Table
		const std::flat_map<char, std::uint8_t> char_reference = {

			{'A', 0xB0}, {'B', 0xB1}, {'C', 0xB2}, {'D', 0xB3},
			{'E', 0xB4}, {'F', 0xB5}, {'G', 0xB6}, {'H', 0xB7},
			{'I', 0xB8}, {'J', 0xB9}, {'K', 0xBA}, {'L', 0xBB},
			{'M', 0xBC}, {'N', 0xBD}, {'O', 0xBE}, {'P', 0xBF},
			{'Q', 0xC0}, {'R', 0xC1}, {'S', 0xC2}, {'T', 0xC3},
			{'U', 0xC4}, {'V', 0xC5}, {'W', 0xC6}, {'X', 0xC7},
			{'Y', 0xC8}, {'Z', 0xC9},

			{'a', 0xD0}, {'b', 0xD1}, {'c', 0xD2}, {'d', 0xD3},
			{'e', 0xD4}, {'f', 0xD5}, {'g', 0xD6}, {'h', 0xD7},
			{'i', 0xD8}, {'j', 0xD9}, {'k', 0xDA}, {'l', 0xDB},
			{'m', 0xDC}, {'n', 0xDD}, {'o', 0xDE}, {'p', 0xDF},
			{'q', 0xCA}, {'r', 0xCB}, {'s', 0xCC}, {'t', 0xCD},
			{'u', 0xCE}, {'v', 0xCF}, {'w', 0x81}, {'x', 0x88},
			{'y', 0x8C}, {'z', 0x8F},

			{'0', 0xF0}, {'1', 0xF1}, {'2', 0xF2}, {'3', 0xF3},
			{'4', 0xF4}, {'5', 0xF5}, {'6', 0xF6}, {'7', 0xF7},
			{'8', 0xF8}, {'9', 0xF9},

			{' ', 0xFE}, {',', 0x9A}, {'.', 0xE9}, {'!', 0xEA},
			{'?', 0xEB}, {'-', 0x9C}, {'>', 0xEE}, {']', 0xEF},
			{'\'', 0xAB}
		};

		// Helper Lambda Function to Remove Characters if not in Pattern Table
		const auto notInPatternTable = [](char c) {
			return !char_reference.contains(c);
		};

		// Strip External Whitespace and Remove Invalid Characters
		std::string cleanPayload(std::string_view payload) {

			std::string cleaned_payload = Utils::stripWhitespace(payload);
			std::erase_if(cleaned_payload, notInPatternTable);

			return cleaned_payload;
		}

		// Reccomend String to User That Will Vertically Align First Word of Each Line Based on
		// Initial Address, If Word Longer Than Available Line Space, Return (payload, false)
		std::pair<std::string, bool> wrapPayload(std::uint16_t initial, std::string_view payload) {

			const std::size_t initial_column = static_cast<std::size_t>(initial & 0x1F);
			const std::size_t available_length = 32 - initial_column;

			const std::vector<std::string> tokens = Utils::splitString(payload, ' ');

			if (tokens.empty()) {
				return {{}, true};
			}

			std::string result;
			std::size_t line_length = 0;

			for (const auto& token : tokens) {

				const std::size_t token_length = token.size();

				if (token.empty()) {
					continue;
				}

				if (token_length > available_length) {
					return {std::string{payload}, false};
				}

				if (line_length == 0) {
					result.append(token);
					line_length = token_length;
					continue;
				}

				if (line_length + 1 + token_length <= available_length) {
					result.push_back(' ');
					result.append(token);

					line_length += 1 + token_length;
					continue;
				}

				result.append(32 - line_length, ' ');
				result.append(token);

				line_length = token_length;
			}

			if (result.size() > 77) {
				return {std::string{payload}, false};
			}

			return {result, true};
		}

		struct HeaderFooter {
			std::array<std::uint8_t, 6> header;
			std::array<std::uint8_t, 4> footer;
		};

		// Generate TAS Header/Footer for PPU Writing Program (Footer: Transition Byte, Write 1 Byte
		// at $00F8, Prevents Infinite Loop Due to NMI Handling)
		constexpr HeaderFooter genHeaderFooter(
			std::uint16_t initial,
			std::size_t length
		) noexcept {

			std::array<std::uint8_t, 6> header = {
				static_cast<std::uint8_t>(length + 3),
				Utils::highByte(PPU_ADDRESS),
				Utils::lowByte(PPU_ADDRESS),
				static_cast<std::uint8_t>(length),
				Utils::highByte(initial),
				Utils::lowByte(initial)
			};

			std::array<std::uint8_t, 4> footer {
				0x01,
				0x01,
				0x00,
				0xF8
			};

			return {header, footer};
		}
	}

	// Convert String to PPU TAS Input Payload, Public API for GUI
	std::expected<Result, Error> buildResult(std::string_view initial_str, std::string_view payload) {

		const auto initial = Utils::svToUint16(initial_str, 16);

		std::string cleaned_payload = cleanPayload(payload);
		const std::size_t length = cleaned_payload.length();

		if (!initial) {
			return std::unexpected(
				Error{
					ErrorType::InvalidInitial,
					std::move(cleaned_payload)
				}
			);
		}

		if (length > PPU_SIZE) {
			return std::unexpected(
				Error{
					ErrorType::PayloadLength,
					std::move(cleaned_payload),
					length - static_cast<std::size_t>(PPU_SIZE)
				}
			);
		}

		if (*initial < 0x2000 || *initial + static_cast<int>(length) > 0x23C0) {
			return std::unexpected(
				Error{
					ErrorType::PayloadOutsidePPU,
					std::move(cleaned_payload)
				}
			);
		}

		auto [wrapped_payload, can_wrap] = wrapPayload(*initial, cleaned_payload);

		const HeaderFooter hf = genHeaderFooter(*initial, length);

		std::vector<std::uint8_t> byte_code;
		byte_code.reserve(hf.header.size() + length + hf.footer.size());

		byte_code.append_range(hf.header);

		for (char c : cleaned_payload) {
			byte_code.push_back(char_reference.at(c));
		}

		byte_code.append_range(hf.footer);

		std::vector<std::string> inputs = GenerateTAS::p1Only(byte_code);

		return Result{
			std::move(cleaned_payload),
			std::move(wrapped_payload),
			can_wrap,
			length,
			std::move(byte_code),
			std::move(inputs)
		};
	}
}
