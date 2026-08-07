/* Generate SubNESHawk TASStudio Inputs for Player 1 from Byte Stream */

#pragma once

#include <string>
#include <vector>
#include <cstdint>

#include "nes_ace.tas_input.hpp"

namespace GenerateTAS {

	// Convert Vector of Bytes to Vector of SubNESHawk Input Strings (Empty Player 2)
	inline std::vector<std::string> p1Only(const std::vector<std::uint8_t>& byte_code) {

		std::vector<std::string> input_set;
		input_set.reserve(byte_code.size());

		for (NES::Controller byte : byte_code) {
			input_set.push_back(SubNESHawk::genFrame(byte));
		}

		return input_set;
	}
}
