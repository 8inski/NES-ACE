/* Display All Information About 6502 Instruction Looked up by Mnemonic or Alias */

#include "nes_ace.glossary.hpp"

#include <string>
#include <string_view>
#include <format>
#include <vector>
#include <cstddef>
#include <algorithm>

#include "nes_ace.database.hpp"

namespace Glossary {

	namespace CPU = CPU6502;

	namespace {

		// Return Displayed Text for Each Mode Enum
		constexpr std::string_view modeToString(CPU::Mode mode) noexcept {

			switch (mode) {
				case CPU::Mode::ACC: return "Accumulator";
				case CPU::Mode::IMM: return "Immediate";
				case CPU::Mode::ZPG: return "Zero Page";
				case CPU::Mode::ZPX: return "Zero Page, X";
				case CPU::Mode::ZPY: return "Zero Page, Y";
				case CPU::Mode::ABS: return "Absolute";
				case CPU::Mode::ABX: return "Absolute, X";
				case CPU::Mode::ABY: return "Absolute, Y";
				case CPU::Mode::IDX: return "Indirect, X";
				case CPU::Mode::IDY: return "Indirect, Y";
				case CPU::Mode::IND: return "Indirect";
				case CPU::Mode::IMP: return "Implied";
				case CPU::Mode::REL: return "Relative";
			}

			return "";
		}

		// Return Displayed Text for Each Flag Enum
		constexpr std::string_view flagToString(CPU::Flag flag) noexcept {

			switch (flag) {
				case CPU::Flag::C: return "C";
				case CPU::Flag::Z: return "Z";
				case CPU::Flag::I: return "I";
				case CPU::Flag::D: return "D";
				case CPU::Flag::B: return "B";
				case CPU::Flag::V: return "V";
				case CPU::Flag::N: return "N";
			}

			return "";
		}
	}

	// Push All Displayed Lines to Return Vector
	std::vector<std::string> buildResult(std::string_view mnemonic) {

		std::vector<std::string> result;

		const CPU::InstructionInfo* instruction = CPU::findInstruction(mnemonic);

		if (instruction == nullptr) {
			result.push_back("Unknown Instruction");
			return result;
		}

		result.push_back(
			std::format(
				"{}: {}{}",
				instruction->mnemonic,
				instruction->description,
				(instruction->undocumented) ? " (Undocumented)" : ""
			)
		);

		result.push_back("");

		result.push_back("Aliases:");

		if (!instruction->aliases.front().empty()) {

			std::string aliases;

			for (const auto& alias : instruction->aliases) {

				if (alias.empty()) {
					break;
				}

				if (!aliases.empty()) {
					aliases += ' ';
				}

				aliases += alias;
			}

			result.push_back(std::move(aliases));

		} else {
			result.push_back("None");
		}

		result.push_back("");

		result.push_back("Flags Affected:");

		if (!instruction->flags.empty()) {

			std::string flags;

			for (auto flag : instruction->flags) {

				if (!flags.empty()) {
					flags += ' ';
				}

				flags += flagToString(flag);
			}

			result.push_back(std::move(flags));

		} else {
			result.push_back("None");
		}

		result.push_back("");

		result.push_back("Addressing Modes:");

		std::size_t longest_mode = 0;

		for (const auto& info : instruction->modes) {
			longest_mode = std::max(
				longest_mode,
				modeToString(info.mode).size()
			);
		}

		for (const auto& info : instruction->modes) {

			result.push_back(
				std::format(
					"{:<{}} : ${:02X}  ({} {}, {}{} Cycles){}",
					modeToString(info.mode),
					longest_mode,
					static_cast<int>(info.opcode),
					info.num_bytes,
					(info.num_bytes == 1) ? "Byte" : "Bytes",
					(info.num_bytes == 1) ? " " : "",
					info.num_cycles,
					(!instruction->undocumented && info.undocumented) ? " (Undocumented)" : ""
				)
			);
		}

		return result;
	}
}
