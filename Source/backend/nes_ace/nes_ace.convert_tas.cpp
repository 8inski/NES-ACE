/* Convert Frame Time into Subframe Time in 2 FCEUX or NESHawk */

#include "nes_ace.convert_tas.hpp"

#include <string>
#include <string_view>
#include <vector>
#include <cstddef>

#include "nes_ace.tas_input.hpp"

namespace ConvertTAS {

	namespace {

		using NES::Controller;

		constexpr std::string_view EMPTY_BUTTONS = "........";

		// Frame Object Holding 2 Bytes (Player 1, Player 2)
		struct Frame {
			Controller p1{};
			Controller p2{};
		};

		/* ==================================== Decode Inputs ==================================== */

		// Decode Inputs by Extracting Bit Field of Pressed Buttons, Decoding the Bit Field Based on
		// the Emulator Selected and Calculating the Frame Values for Player 1 and Player 2

		// Inputs Converted Here Are Coming Directly from Emulator, Therefore Minimal Error Catching,
		// Invalid Characters Are Ignored and Invalid Lines Are Discarded

		/* ======================================================================================= */

		// Extract Between '|', buttonField(line, 2) Returns P1, buttonField(line, 3) Returns P2
		std::string_view buttonField(std::string_view line, int index) {

			int pipe_count = 0;
			std::size_t start = 0;

			for (std::size_t i = 0; i < line.size(); ++i) {

				if (line[i] != '|')
					continue;

				++pipe_count;

				if (pipe_count == index) {
					start = i + 1;

				} else if (pipe_count == index + 1) {
					return line.substr(start, i - start);
				}
			}

			return {};
		}

		// Check That Both Button Fields Contain Exactly 8 Characters
		bool validButtonFields(std::string_view p1, std::string_view p2) noexcept {
			return p1.size() == 8 && p2.size() == 8;
		}

		// Decode FCEUX Button Field
		Controller decodeFCEUXButtons(std::string_view buttons) {

			using namespace NES;

			Controller pressed = 0;

			if (buttons[0] == 'R') pressed |= RIGHT;
			if (buttons[1] == 'L') pressed |= LEFT;
			if (buttons[2] == 'D') pressed |= DOWN;
			if (buttons[3] == 'U') pressed |= UP;
			if (buttons[4] == 'T') pressed |= START;
			if (buttons[5] == 'S') pressed |= SELECT;
			if (buttons[6] == 'B') pressed |= B;
			if (buttons[7] == 'A') pressed |= A;

			return pressed;
		}

		// Decode NESHawk Button Field
		Controller decodeNESHawkButtons(std::string_view buttons) {

			using namespace NES;

			Controller pressed = 0;

			if (buttons[0] == 'U') pressed |= UP;
			if (buttons[1] == 'D') pressed |= DOWN;
			if (buttons[2] == 'L') pressed |= LEFT;
			if (buttons[3] == 'R') pressed |= RIGHT;
			if (buttons[4] == 'S') pressed |= START;
			if (buttons[5] == 's') pressed |= SELECT;
			if (buttons[6] == 'B') pressed |= B;
			if (buttons[7] == 'A') pressed |= A;

			return pressed;
		}

		// Decode One FCEUX Frame from 2 Valid Button Fields
		Frame decodeFCEUXFrame(std::string_view p1, std::string_view p2) {
			return {
				decodeFCEUXButtons(p1),
				decodeFCEUXButtons(p2)
			};
		}

		// Decode One NESHawk Frame from 2 Valid Button Fields
		Frame decodeNESHawkFrame(std::string_view p1, std::string_view p2) {
			return {
				decodeNESHawkButtons(p1),
				decodeNESHawkButtons(p2)
			};
		}
	}

	/* ==================================== Encode Inputs ==================================== */

	// Use Pre-Compiled LUT to Generate SubNESHawk Input Strings, Convert to
	// Sub-Frame Time by Generating 4 Frames for Each Parsed Frame (Except for
	// Empty Frames, Interpreted as Lag Therefore 1:1)

	/* ======================================================================================= */

	// Main Function, Public API for GUI
	Result buildResult(
		const std::vector<std::string>& inputs,
		Emulator emulator,
		GameMode mode
	) {

		std::vector<std::string> valid_inputs;
		valid_inputs.reserve(inputs.size());

		std::vector<std::string> converted_inputs;
		converted_inputs.reserve(inputs.size() * 5);

		std::size_t lag_frames{};

		for (const auto& line : inputs) {

			const std::string_view p1 = buttonField(line, 2);

			const std::string_view p2 =
				(mode == GameMode::TwoPlayer)
					? buttonField(line, 3)
					: EMPTY_BUTTONS;

			if (!validButtonFields(p1, p2)) {
				continue;
			}

			valid_inputs.push_back(line);

			Frame frame;

			switch (emulator) {

				case Emulator::FCEUX:
					frame = decodeFCEUXFrame(p1, p2);
					break;

				case Emulator::NESHawk:
					frame = decodeNESHawkFrame(p1, p2);
					break;
			}

			if (frame.p1 == 0 && frame.p2 == 0) {
				converted_inputs.emplace_back(SubNESHawk::EMPTY_FRAME);
				lag_frames += 1;

			} else {

				const std::string converted = SubNESHawk::genFrame(
					frame.p1,
					frame.p2
				);

				converted_inputs.insert(converted_inputs.end(), 4, converted);
				converted_inputs.emplace_back(SubNESHawk::EMPTY_FRAME);
			}
		}

		return {
			std::move(valid_inputs),
			std::move(converted_inputs),
			lag_frames
		};
	}
}
