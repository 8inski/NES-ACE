/* Utility Functions Used Across All Scripts */

#pragma once

#include <string>
#include <string_view>
#include <vector>
#include <cstdint>
#include <cstddef>
#include <optional>
#include <cctype>
#include <charconv>
#include <system_error>

namespace Utils {

	// Capitalize Every Character in a String
	inline void toUpper(std::string& str) {

		for (auto& c : str) {
			c = static_cast<char>(
				std::toupper(static_cast<unsigned char>(c))
			);
		}
	}

	// Strip Whitespace from Either End of String
	inline std::string stripWhitespace(std::string_view str) {

		constexpr std::string_view whitespace = " \t\n\r\f\v";

		std::size_t start = str.find_first_not_of(whitespace);

		if (start == std::string::npos) {
			return "";
		}

		std::size_t end = str.find_last_not_of(whitespace);

		std::string str_result{str.substr(start, end - start + 1)};

		return str_result;
	}

	// Split String into Segments on Any Delimiter
	inline std::vector<std::string> splitString(
		std::string_view str,
		char delimiter,
		std::size_t max_splits = std::string_view::npos
	) {

		std::vector<std::string> tokens;

		std::size_t start = 0;
		std::size_t splits = 0;

		while (splits < max_splits) {

			const std::size_t end = str.find(delimiter, start);

			if (end == std::string_view::npos) {
				break;
			}

			tokens.emplace_back(
				str.substr(start, end - start)
			);

			start = end + 1;
			++splits;
		}

		tokens.emplace_back(str.substr(start));

		return tokens;
	}

	// Join Strings Using Any Delimiter
	inline std::string joinString(
		const std::vector<std::string>& tokens,
		char delimiter = ' '
	) {

		if (tokens.empty()) {
			return {};
		}

		std::size_t result_size = tokens.size() - 1u;

		for (const std::string& token : tokens) {
			result_size += token.size();
		}

		std::string result;
		result.reserve(result_size);
		result.append(tokens.front());

		for (std::size_t i = 1; i < tokens.size(); ++i) {
			result.push_back(delimiter);
			result.append(tokens[i]);
		}

		return result;
	}

	// Convert String View of Decimal, Hex or Binary Number into Integer
	inline constexpr std::optional<std::uint16_t> svToUint16(
		std::string_view str,
		int base
	) noexcept {

		if (str.empty()) {
			return std::nullopt;
		}

		std::uint16_t value{};

		const char* first = str.data();
		const char* last = first + str.size();

		const auto [ptr, error] = std::from_chars(first, last, value, base);

		if (error != std::errc{} || ptr != last) {
			return std::nullopt;
		}

		return value;
	}

	// Extract Low Byte from uint16_t
	inline constexpr std::uint8_t lowByte(std::uint16_t value) noexcept {
		return static_cast<std::uint8_t>(value);
	}

	// Extract High Byte from uint16_t
	inline constexpr std::uint8_t highByte(std::uint16_t value) noexcept {
		return static_cast<std::uint8_t>(value >> 8);
	}
}
