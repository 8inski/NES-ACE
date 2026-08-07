/* Full 6502 Instruction Database */

#pragma once

#include <string_view>
#include <inplace_vector>
#include <array>
#include <cstdint>

namespace CPU6502 {

	enum class InstructionType {
		SingleByte,
		Branch,
		Other
	};

	enum class Mode {
		ACC,
		IMM,
		ZPG,
		ZPX,
		ZPY,
		ABS,
		ABX,
		ABY,
		IDX,
		IDY,
		IND,
		IMP,
		REL
	};

	enum class Flag {
		C,
		Z,
		I,
		D,
		B,
		V,
		N
	};

	struct ModeInfo {
		Mode mode;
		std::uint8_t opcode;
		std::uint8_t num_bytes;
		std::uint8_t num_cycles;
		bool undocumented;
	};

	// Object for Each 6502 Instruction
	struct InstructionInfo {
		std::string_view mnemonic;
		std::array<std::string_view, 3> aliases;
		std::string_view description;
		InstructionType type;
		std::inplace_vector<Flag, 7> flags;
		std::inplace_vector<ModeInfo, 8> modes;
		bool undocumented;
	};

	// Public API, Find Instruction (by Mnemonic or Alias) if in Database
	const InstructionInfo* findInstruction(std::string_view mnemonic);

	// Public API, Find Mode if it Exists for Instruction
	const ModeInfo* findMode(const InstructionInfo& instruction, Mode mode);
}
