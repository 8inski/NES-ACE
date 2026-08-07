/* Generate SubNESHawk TASStudio Inputs from Controller Bytes for Player 1 and Player 2 */

#include "nes_ace.tas_input.hpp"

#include <string>
#include <array>
#include <cstddef>
#include <algorithm>

namespace SubNESHawk {

	namespace {

		using ButtonField = std::array<char, 8>;
		using ButtonLUT = std::array<ButtonField, 256>;

		// Index Where P1/P2 Buttons Begin in EMPTY_FRAME
		constexpr std::size_t P1_OFFSET = 10;
		constexpr std::size_t P2_OFFSET = 19;

		// Convert Controller Byte to UDLRSsBA Button Field
		consteval ButtonField genButtonField(NES::Controller pressed) noexcept {

			return {
				(pressed & NES::UP)     ? 'U' : '.',
				(pressed & NES::DOWN)   ? 'D' : '.',
				(pressed & NES::LEFT)   ? 'L' : '.',
				(pressed & NES::RIGHT)  ? 'R' : '.',
				(pressed & NES::START)  ? 'S' : '.',
				(pressed & NES::SELECT) ? 's' : '.',
				(pressed & NES::B)      ? 'B' : '.',
				(pressed & NES::A)      ? 'A' : '.'
			};
		}

		// Build Lookup Table for Controller Bytes 0x00-0xFF
		consteval ButtonLUT buildLUT() noexcept {

			ButtonLUT lut{};

			for (std::size_t i = 0; i < lut.size(); ++i) {
				lut[i] = genButtonField(
					static_cast<NES::Controller>(i)
				);
			}

			return lut;
		}

		constexpr ButtonLUT LUT = buildLUT();
	}

	// Generate Complete SubNESHawk TASStudio Frame
	std::string genFrame(NES::Controller p1, NES::Controller p2) {

		std::string frame{EMPTY_FRAME};

		std::copy(
			LUT[p1].begin(),
			LUT[p1].end(),
			frame.begin() + P1_OFFSET
		);

		std::copy(
			LUT[p2].begin(),
			LUT[p2].end(),
			frame.begin() + P2_OFFSET
		);

		return frame;
	}
}
