/* Convert Frame Time into Subframe Time in 2 FCEUX or NESHawk */

#pragma once

#include <string>
#include <vector>
#include <cstddef>

namespace ConvertTAS {

	enum class Emulator {
		FCEUX,
		NESHawk
	};

	enum class GameMode {
		OnePlayer,
		TwoPlayer
	};

	struct Result {
		std::vector<std::string> valid_inputs;
		std::vector<std::string> converted_inputs;
		std::size_t lag_frames{};
	};

	// Main Function, Public API for GUI
	Result buildResult(const std::vector<std::string>& inputs, Emulator emulator, GameMode mode);
}
