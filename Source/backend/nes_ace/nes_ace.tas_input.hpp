/* Generate SubNESHawk TASStudio Inputs from Controller Bytes for Player 1 and Player 2 */

#pragma once

#include <string>
#include <string_view>
#include <cstdint>

namespace NES {

	// NES Controller Status Byte Defined by Following Bits 0-7
	using Controller = std::uint8_t;

	inline constexpr Controller A = 1 << 7;
	inline constexpr Controller B = 1 << 6;
	inline constexpr Controller SELECT = 1 << 5;
	inline constexpr Controller START = 1 << 4;
	inline constexpr Controller UP = 1 << 3;
	inline constexpr Controller DOWN = 1 << 2;
	inline constexpr Controller LEFT = 1 << 1;
	inline constexpr Controller RIGHT = 1 << 0;
}

namespace SubNESHawk {

	// Empty SubNESHawk TASStudio Frame
	inline constexpr std::string_view EMPTY_FRAME = "|    0,..|........|........|";

	// Generate Complete SubNESHawk TASStudio Frame
	std::string genFrame(NES::Controller p1, NES::Controller p2 = 0);
}
