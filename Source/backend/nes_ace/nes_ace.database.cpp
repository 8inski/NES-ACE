/* Full 6502 Instruction Database */

#include "nes_ace.database.hpp"

#include <string_view>
#include <vector>
#include <inplace_vector>
#include <array>
#include <optional>
#include <cstddef>

#include "nes_ace.utils.hpp"

namespace CPU6502 {

	namespace {

		/* ============================== 6502 Instruction Database ============================== */

		// All Information for Every 6502 Opcode
		// Includes Undocumented Instructions/Modes
		// Includes All Aliases
		// Single Source of Truth for Entire Codebase

		/* ======================================================================================= */

		constexpr std::array<InstructionInfo, 75> instructions = {{

			// Single-Byte Instructions
			{
				"BRK",
				{},
				"Force Interrupt",
				InstructionType::SingleByte,
				{Flag::B, Flag::I},
				{
					{Mode::IMP, 0x00, 1, 7, false}
				},
				false
			},

			{
				"CLC",
				{},
				"Clear Carry Flag",
				InstructionType::SingleByte,
				{Flag::C},
				{
					{Mode::IMP, 0x18, 1, 2, false}
				},
				false
			},

			{
				"CLD",
				{},
				"Clear Decimal Mode",
				InstructionType::SingleByte,
				{Flag::D},
				{
					{Mode::IMP, 0xD8, 1, 2, false}
				},
				false
			},

			{
				"CLI",
				{},
				"Clear Interrupt Disable",
				InstructionType::SingleByte,
				{Flag::I},
				{
					{Mode::IMP, 0x58, 1, 2, false}
				},
				false
			},

			{
				"CLV",
				{},
				"Clear Overflow Flag",
				InstructionType::SingleByte,
				{Flag::V},
				{
					{Mode::IMP, 0xB8, 1, 2, false}
				},
				false
			},

			{
				"DEX",
				{},
				"Decrement X Register",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xCA, 1, 2, false}
				},
				false
			},

			{
				"DEY",
				{},
				"Decrement Y Register",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0x88, 1, 2, false}
				},
				false
			},

			{
				"INX",
				{},
				"Increment X Register",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xE8, 1, 2, false}
				},
				false
			},

			{
				"INY",
				{},
				"Increment Y Register",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xC8, 1, 2, false}
				},
				false
			},

			{
				"PHA",
				{},
				"Push Accumulator",
				InstructionType::SingleByte,
				{},
				{
					{Mode::IMP, 0x48, 1, 3, false}
				},
				false
			},

			{
				"PHP",
				{},
				"Push Processor Status",
				InstructionType::SingleByte,
				{},
				{
					{Mode::IMP, 0x08, 1, 3, false}
				},
				false
			},

			{
				"PLA",
				{},
				"Pull Accumulator",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0x68, 1, 4, false}
				},
				false
			},

			{
				"PLP",
				{},
				"Pull Processor Status",
				InstructionType::SingleByte,
				{Flag::N, Flag::V, Flag::B, Flag::D, Flag::I, Flag::Z, Flag::C},
				{
					{Mode::IMP, 0x28, 1, 4, false}
				},
				false
			},

			{
				"RTI",
				{},
				"Return from Interrupt",
				InstructionType::SingleByte,
				{Flag::N, Flag::V, Flag::B, Flag::D, Flag::I, Flag::Z, Flag::C},
				{
					{Mode::IMP, 0x40, 1, 6, false}
				},
				false
			},

			{
				"RTS",
				{},
				"Return from Subroutine",
				InstructionType::SingleByte,
				{},
				{
					{Mode::IMP, 0x60, 1, 6, false}
				},
				false
			},

			{
				"SEC",
				{},
				"Set Carry Flag",
				InstructionType::SingleByte,
				{Flag::C},
				{
					{Mode::IMP, 0x38, 1, 2, false}
				},
				false
			},

			{
				"SED",
				{},
				"Set Decimal Mode",
				InstructionType::SingleByte,
				{Flag::D},
				{
					{Mode::IMP, 0xF8, 1, 2, false}
				},
				false
			},

			{
				"SEI",
				{},
				"Set Interrupt Disable",
				InstructionType::SingleByte,
				{Flag::I},
				{
					{Mode::IMP, 0x78, 1, 2, false}
				},
				false
			},

			{
				"STP",
				{"JAM", "KIL", "HLT"},
				"Stop Processor Until Reset",
				InstructionType::SingleByte,
				{},
				{
					{Mode::IMP, 0x02, 1, 0, true}
				},
				true
			},

			{
				"TAX",
				{},
				"Transfer Accumulator to X",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xAA, 1, 2, false}
				},
				false
			},

			{
				"TAY",
				{},
				"Transfer Accumulator to Y",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xA8, 1, 2, false}
				},
				false
			},

			{
				"TSX",
				{},
				"Transfer Stack Pointer to X",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0xBA, 1, 2, false}
				},
				false
			},

			{
				"TXA",
				{},
				"Transfer X to Accumulator",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0x8A, 1, 2, false}
				},
				false
			},

			{
				"TXS",
				{},
				"Transfer X to Stack Pointer",
				InstructionType::SingleByte,
				{},
				{
					{Mode::IMP, 0x9A, 1, 2, false}
				},
				false
			},

			{
				"TYA",
				{},
				"Transfer Y to Accumulator",
				InstructionType::SingleByte,
				{Flag::N, Flag::Z},
				{
					{Mode::IMP, 0x98, 1, 2, false}
				},
				false
			},


			// Branch Instructions
			{
				"BCC",
				{"BLT"},
				"Branch if Carry Clear",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0x90, 2, 2, false}
				},
				false
			},

			{
				"BCS",
				{"BGE"},
				"Branch if Carry Set",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0xB0, 2, 2, false}
				},
				false
			},

			{
				"BEQ",
				{},
				"Branch if Equal",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0xF0, 2, 2, false}
				},
				false
			},

			{
				"BMI",
				{},
				"Branch if Minus",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0x30, 2, 2, false}
				},
				false
			},

			{
				"BNE",
				{},
				"Branch if Not Equal",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0xD0, 2, 2, false}
				},
				false
			},

			{
				"BPL",
				{},
				"Branch if Positive",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0x10, 2, 2, false}
				},
				false
			},

			{
				"BVC",
				{},
				"Branch if Overflow Clear",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0x50, 2, 2, false}
				},
				false
			},

			{
				"BVS",
				{},
				"Branch if Overflow Set",
				InstructionType::Branch,
				{},
				{
					{Mode::REL, 0x70, 2, 2, false}
				},
				false
			},


			// Other Instructions
			{
				"ADC",
				{},
				"Add with Carry",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0x69, 2, 2, false},
					{Mode::ZPG, 0x65, 2, 3, false},
					{Mode::ZPX, 0x75, 2, 4, false},
					{Mode::ABS, 0x6D, 3, 4, false},
					{Mode::ABX, 0x7D, 3, 4, false},
					{Mode::ABY, 0x79, 3, 4, false},
					{Mode::IDX, 0x61, 2, 6, false},
					{Mode::IDY, 0x71, 2, 5, false}
				},
				false
			},

			{
				"AHX",
				{"SHA", "AXA"},
				"Store A AND X AND High Address Byte Plus One",
				InstructionType::Other,
				{},
				{
					{Mode::ABY, 0x9F, 3, 5, true},
					{Mode::IDY, 0x93, 2, 6, true}
				},
				true
			},

			{
				"ALR",
				{"ASR"},
				"AND Then Logical Shift Right",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0x4B, 2, 2, true}
				},
				true
			},

			{
				"ANC",
				{"AAC"},
				"AND Then Copy Negative Flag to Carry",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0x0B, 2, 2, true}
				},
				true
			},

			{
				"AND",
				{},
				"Bitwise AND with Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0x29, 2, 2, false},
					{Mode::ZPG, 0x25, 2, 3, false},
					{Mode::ZPX, 0x35, 2, 4, false},
					{Mode::ABS, 0x2D, 3, 4, false},
					{Mode::ABX, 0x3D, 3, 4, false},
					{Mode::ABY, 0x39, 3, 4, false},
					{Mode::IDX, 0x21, 2, 6, false},
					{Mode::IDY, 0x31, 2, 5, false}
				},
				false
			},

			{
				"ARR",
				{},
				"AND Then Rotate Right with Special Flag Behavior",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0x6B, 2, 2, true}
				},
				true
			},

			{
				"ASL",
				{"SHL"},
				"Arithmetic Shift Left",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ACC, 0x0A, 1, 2, false},
					{Mode::ZPG, 0x06, 2, 5, false},
					{Mode::ZPX, 0x16, 2, 6, false},
					{Mode::ABS, 0x0E, 3, 6, false},
					{Mode::ABX, 0x1E, 3, 7, false}
				},
				false
			},

			{
				"AXS",
				{"SBX"},
				"Store A AND X Minus Immediate in X",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0xCB, 2, 2, true}
				},
				true
			},

			{
				"BIT",
				{},
				"Bit Test",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z},
				{
					{Mode::ZPG, 0x24, 2, 3, false},
					{Mode::ABS, 0x2C, 3, 4, false}
				},
				false
			},

			{
				"CMP",
				{},
				"Compare Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0xC9, 2, 2, false},
					{Mode::ZPG, 0xC5, 2, 3, false},
					{Mode::ZPX, 0xD5, 2, 4, false},
					{Mode::ABS, 0xCD, 3, 4, false},
					{Mode::ABX, 0xDD, 3, 4, false},
					{Mode::ABY, 0xD9, 3, 4, false},
					{Mode::IDX, 0xC1, 2, 6, false},
					{Mode::IDY, 0xD1, 2, 5, false}
				},
				false
			},

			{
				"CPX",
				{},
				"Compare X Register",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0xE0, 2, 2, false},
					{Mode::ZPG, 0xE4, 2, 3, false},
					{Mode::ABS, 0xEC, 3, 4, false}
				},
				false
			},

			{
				"CPY",
				{},
				"Compare Y Register",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0xC0, 2, 2, false},
					{Mode::ZPG, 0xC4, 2, 3, false},
					{Mode::ABS, 0xCC, 3, 4, false}
				},
				false
			},

			{
				"DCP",
				{"DCM"},
				"Decrement Memory Then Compare",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0xC7, 2, 5, true},
					{Mode::ZPX, 0xD7, 2, 6, true},
					{Mode::ABS, 0xCF, 3, 6, true},
					{Mode::ABX, 0xDF, 3, 7, true},
					{Mode::ABY, 0xDB, 3, 7, true},
					{Mode::IDX, 0xC3, 2, 8, true},
					{Mode::IDY, 0xD3, 2, 8, true}
				},
				true
			},

			{
				"DEC",
				{},
				"Decrement Memory",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::ZPG, 0xC6, 2, 5, false},
					{Mode::ZPX, 0xD6, 2, 6, false},
					{Mode::ABS, 0xCE, 3, 6, false},
					{Mode::ABX, 0xDE, 3, 7, false}
				},
				false
			},

			{
				"EOR",
				{},
				"Bitwise Exclusive OR with Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0x49, 2, 2, false},
					{Mode::ZPG, 0x45, 2, 3, false},
					{Mode::ZPX, 0x55, 2, 4, false},
					{Mode::ABS, 0x4D, 3, 4, false},
					{Mode::ABX, 0x5D, 3, 4, false},
					{Mode::ABY, 0x59, 3, 4, false},
					{Mode::IDX, 0x41, 2, 6, false},
					{Mode::IDY, 0x51, 2, 5, false}
				},
				false
			},

			{
				"INC",
				{},
				"Increment Memory",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::ZPG, 0xE6, 2, 5, false},
					{Mode::ZPX, 0xF6, 2, 6, false},
					{Mode::ABS, 0xEE, 3, 6, false},
					{Mode::ABX, 0xFE, 3, 7, false}
				},
				false
			},

			{
				"ISC",
				{"ISB", "INS"},
				"Increment Memory Then Subtract with Carry",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0xE7, 2, 5, true},
					{Mode::ZPX, 0xF7, 2, 6, true},
					{Mode::ABS, 0xEF, 3, 6, true},
					{Mode::ABX, 0xFF, 3, 7, true},
					{Mode::ABY, 0xFB, 3, 7, true},
					{Mode::IDX, 0xE3, 2, 8, true},
					{Mode::IDY, 0xF3, 2, 8, true}
				},
				true
			},

			{
				"JMP",
				{},
				"Jump",
				InstructionType::Other,
				{},
				{
					{Mode::ABS, 0x4C, 3, 3, false},
					{Mode::IND, 0x6C, 3, 5, false}
				},
				false
			},

			{
				"JSR",
				{},
				"Jump to Subroutine",
				InstructionType::Other,
				{},
				{
					{Mode::ABS, 0x20, 3, 6, false}
				},
				false
			},

			{
				"LAS",
				{"LAR", "LAE", "LDS"},
				"Load A, X, and Stack Pointer from Memory AND Stack Pointer",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::ABY, 0xBB, 3, 4, true}
				},
				true
			},

			{
				"LAX",
				{},
				"Load Accumulator and X Register",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0xAB, 2, 2, true},
					{Mode::ZPG, 0xA7, 2, 3, true},
					{Mode::ZPY, 0xB7, 2, 4, true},
					{Mode::ABS, 0xAF, 3, 4, true},
					{Mode::ABY, 0xBF, 3, 4, true},
					{Mode::IDX, 0xA3, 2, 6, true},
					{Mode::IDY, 0xB3, 2, 5, true}
				},
				true
			},

			{
				"LDA",
				{},
				"Load Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0xA9, 2, 2, false},
					{Mode::ZPG, 0xA5, 2, 3, false},
					{Mode::ZPX, 0xB5, 2, 4, false},
					{Mode::ABS, 0xAD, 3, 4, false},
					{Mode::ABX, 0xBD, 3, 4, false},
					{Mode::ABY, 0xB9, 3, 4, false},
					{Mode::IDX, 0xA1, 2, 6, false},
					{Mode::IDY, 0xB1, 2, 5, false}
				},
				false
			},

			{
				"LDX",
				{},
				"Load X Register",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0xA2, 2, 2, false},
					{Mode::ZPG, 0xA6, 2, 3, false},
					{Mode::ZPY, 0xB6, 2, 4, false},
					{Mode::ABS, 0xAE, 3, 4, false},
					{Mode::ABY, 0xBE, 3, 4, false}
				},
				false
			},

			{
				"LDY",
				{},
				"Load Y Register",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0xA0, 2, 2, false},
					{Mode::ZPG, 0xA4, 2, 3, false},
					{Mode::ZPX, 0xB4, 2, 4, false},
					{Mode::ABS, 0xAC, 3, 4, false},
					{Mode::ABX, 0xBC, 3, 4, false}
				},
				false
			},

			{
				"LSR",
				{"SHR"},
				"Logical Shift Right",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ACC, 0x4A, 1, 2, false},
					{Mode::ZPG, 0x46, 2, 5, false},
					{Mode::ZPX, 0x56, 2, 6, false},
					{Mode::ABS, 0x4E, 3, 6, false},
					{Mode::ABX, 0x5E, 3, 7, false}
				},
				false
			},

			{
				"NOP",
				{},
				"No Operation",
				InstructionType::Other,
				{},
				{
					{Mode::IMP, 0xEA, 1, 2, false},
					{Mode::IMM, 0x80, 2, 2, true},
					{Mode::ZPG, 0x04, 2, 3, true},
					{Mode::ZPX, 0x14, 2, 4, true},
					{Mode::ABS, 0x0C, 3, 4, true},
					{Mode::ABX, 0x1C, 3, 4, true}
				},
				false
			},

			{
				"ORA",
				{},
				"Bitwise OR with Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0x09, 2, 2, false},
					{Mode::ZPG, 0x05, 2, 3, false},
					{Mode::ZPX, 0x15, 2, 4, false},
					{Mode::ABS, 0x0D, 3, 4, false},
					{Mode::ABX, 0x1D, 3, 4, false},
					{Mode::ABY, 0x19, 3, 4, false},
					{Mode::IDX, 0x01, 2, 6, false},
					{Mode::IDY, 0x11, 2, 5, false}
				},
				false
			},

			{
				"RLA",
				{},
				"Rotate Left Memory Then AND",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0x27, 2, 5, true},
					{Mode::ZPX, 0x37, 2, 6, true},
					{Mode::ABS, 0x2F, 3, 6, true},
					{Mode::ABX, 0x3F, 3, 7, true},
					{Mode::ABY, 0x3B, 3, 7, true},
					{Mode::IDX, 0x23, 2, 8, true},
					{Mode::IDY, 0x33, 2, 8, true}
				},
				true
			},

			{
				"ROL",
				{},
				"Rotate Left",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ACC, 0x2A, 1, 2, false},
					{Mode::ZPG, 0x26, 2, 5, false},
					{Mode::ZPX, 0x36, 2, 6, false},
					{Mode::ABS, 0x2E, 3, 6, false},
					{Mode::ABX, 0x3E, 3, 7, false}
				},
				false
			},

			{
				"ROR",
				{},
				"Rotate Right",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ACC, 0x6A, 1, 2, false},
					{Mode::ZPG, 0x66, 2, 5, false},
					{Mode::ZPX, 0x76, 2, 6, false},
					{Mode::ABS, 0x6E, 3, 6, false},
					{Mode::ABX, 0x7E, 3, 7, false}
				},
				false
			},

			{
				"RRA",
				{},
				"Rotate Right Memory Then Add with Carry",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0x67, 2, 5, true},
					{Mode::ZPX, 0x77, 2, 6, true},
					{Mode::ABS, 0x6F, 3, 6, true},
					{Mode::ABX, 0x7F, 3, 7, true},
					{Mode::ABY, 0x7B, 3, 7, true},
					{Mode::IDX, 0x63, 2, 8, true},
					{Mode::IDY, 0x73, 2, 8, true}
				},
				true
			},

			{
				"SAX",
				{"AAX"},
				"Store A AND X",
				InstructionType::Other,
				{},
				{
					{Mode::ZPG, 0x87, 2, 3, true},
					{Mode::ZPY, 0x97, 2, 4, true},
					{Mode::ABS, 0x8F, 3, 4, true},
					{Mode::IDX, 0x83, 2, 6, true}
				},
				true
			},

			{
				"SBC",
				{},
				"Subtract with Carry",
				InstructionType::Other,
				{Flag::N, Flag::V, Flag::Z, Flag::C},
				{
					{Mode::IMM, 0xE9, 2, 2, false},
					{Mode::ZPG, 0xE5, 2, 3, false},
					{Mode::ZPX, 0xF5, 2, 4, false},
					{Mode::ABS, 0xED, 3, 4, false},
					{Mode::ABX, 0xFD, 3, 4, false},
					{Mode::ABY, 0xF9, 3, 4, false},
					{Mode::IDX, 0xE1, 2, 6, false},
					{Mode::IDY, 0xF1, 2, 5, false}
				},
				false
			},

			{
				"SHX",
				{"SXA"},
				"Store X AND High Address Byte Plus One",
				InstructionType::Other,
				{},
				{
					{Mode::ABY, 0x9E, 3, 5, true}
				},
				true
			},

			{
				"SHY",
				{"SYA"},
				"Store Y AND High Address Byte Plus One",
				InstructionType::Other,
				{},
				{
					{Mode::ABX, 0x9C, 3, 5, true}
				},
				true
			},

			{
				"SLO",
				{"ASO"},
				"Arithmetic Shift Left Memory Then OR",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0x07, 2, 5, true},
					{Mode::ZPX, 0x17, 2, 6, true},
					{Mode::ABS, 0x0F, 3, 6, true},
					{Mode::ABX, 0x1F, 3, 7, true},
					{Mode::ABY, 0x1B, 3, 7, true},
					{Mode::IDX, 0x03, 2, 8, true},
					{Mode::IDY, 0x13, 2, 8, true}
				},
				true
			},

			{
				"SRE",
				{"LSE"},
				"Logical Shift Right Memory Then Exclusive OR",
				InstructionType::Other,
				{Flag::N, Flag::Z, Flag::C},
				{
					{Mode::ZPG, 0x47, 2, 5, true},
					{Mode::ZPX, 0x57, 2, 6, true},
					{Mode::ABS, 0x4F, 3, 6, true},
					{Mode::ABX, 0x5F, 3, 7, true},
					{Mode::ABY, 0x5B, 3, 7, true},
					{Mode::IDX, 0x43, 2, 8, true},
					{Mode::IDY, 0x53, 2, 8, true}
				},
				true
			},

			{
				"STA",
				{},
				"Store Accumulator",
				InstructionType::Other,
				{},
				{
					{Mode::ZPG, 0x85, 2, 3, false},
					{Mode::ZPX, 0x95, 2, 4, false},
					{Mode::ABS, 0x8D, 3, 4, false},
					{Mode::ABX, 0x9D, 3, 5, false},
					{Mode::ABY, 0x99, 3, 5, false},
					{Mode::IDX, 0x81, 2, 6, false},
					{Mode::IDY, 0x91, 2, 6, false}
				},
				false
			},

			{
				"STX",
				{},
				"Store X Register",
				InstructionType::Other,
				{},
				{
					{Mode::ZPG, 0x86, 2, 3, false},
					{Mode::ZPY, 0x96, 2, 4, false},
					{Mode::ABS, 0x8E, 3, 4, false}
				},
				false
			},

			{
				"STY",
				{},
				"Store Y Register",
				InstructionType::Other,
				{},
				{
					{Mode::ZPG, 0x84, 2, 3, false},
					{Mode::ZPX, 0x94, 2, 4, false},
					{Mode::ABS, 0x8C, 3, 4, false}
				},
				false
			},

			{
				"TAS",
				{"SHS"},
				"Transfer A AND X to Stack Pointer and Memory",
				InstructionType::Other,
				{},
				{
					{Mode::ABY, 0x9B, 3, 5, true}
				},
				true
			},

			{
				"XAA",
				{"ANE"},
				"Transfer X AND Immediate to Accumulator",
				InstructionType::Other,
				{Flag::N, Flag::Z},
				{
					{Mode::IMM, 0x8B, 2, 2, true}
				},
				true
			}
		}};

		/* ================================ Build LUT, Public API ================================ */

		// Convert Every Combination of 3 Capital Letters into an Integer
		// Index of a - Z = 0 - 25
		// Formula: Start at 0, for Each Letter, Multiply by 26 and Add Index
		// LUT is 17576 Pointer Array, nullptr for All Indexes Accept Ones Matching to a Mnemonic
		// Public API Takes Mnemonic and Returns InstructionInfo* and ModeInfo*

		/* ======================================================================================= */

		using MnemonicIndex = std::optional<std::size_t>;
		using MnemonicLUT = std::array<const InstructionInfo*, 26 * 26 * 26>;

		// Convert Three Letter String to an Index
		constexpr MnemonicIndex genMnemonicIndex(std::string_view mnemonic) noexcept {

			if (mnemonic.size() != 3) {
				return std::nullopt;
			}

			std::size_t index = 0;

			for (char c : mnemonic) {

				if (c >= 'a' && c <= 'z') {
					c = static_cast<char>(c - ('a' - 'A'));
				}

				if (c < 'A' || c > 'Z') {
					return std::nullopt;
				}

				index = index * 26 + static_cast<std::size_t>(c - 'A');
			}

			return index;
		}

		// Build LUT, Pointer to InstructionInfo or nullptr
		consteval MnemonicLUT buildLUT() noexcept {

			MnemonicLUT lut{};

			for (const auto& instruction : instructions) {

				if (const auto index = genMnemonicIndex(instruction.mnemonic)) {
					lut[*index] = &instruction;
				}

				for (const auto alias : instruction.aliases) {

					if (alias.empty()) {
						break;
					}

					if (const auto index = genMnemonicIndex(alias)) {
						lut[*index] = &instruction;
					}
				}
			}

			return lut;
		}

		constexpr MnemonicLUT LUT = buildLUT();
	}

	// Public API, Find Instruction (by Mnemonic or Alias) if in Database
	const InstructionInfo* findInstruction(std::string_view mnemonic) {

		const auto valid_index = genMnemonicIndex(mnemonic);

		if (!valid_index) {
			return nullptr;
		}

		return LUT[*valid_index];
	}

	// Public API, Find Mode if it Exists for Instruction
	const ModeInfo* findMode(const InstructionInfo& instruction, Mode mode) {

		for (const auto& info : instruction.modes) {

			if (info.mode == mode) {
				return &info;
			}
		}

		return nullptr;
	}
}
