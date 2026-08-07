/* Assemble 6502 ASM Scripts into TASStudio Inputs */

#pragma once

#include <string>
#include <vector>
#include <cstdint>
#include <cstddef>

namespace Assembler {

	// ASM Error Types
	enum class ErrorType {
		None,
		Syntax,
		InvalidLabel,
		InvalidInstruction,
		UndocumentedInstruction,
		InvalidOperand,
		InvalidMode,
		InvalidOrg,
		InvalidConst,
		InvalidData,
		DuplicateSymbol,
		UndefinedSymbol,
		BranchOutOfRange,
		MissingOrg
	};

	// Display Objects
	struct LineDisplay {
		std::string cleaned_line;
		bool has_error;
	};

	struct SegmentDisplay {
		std::size_t index{};
		std::size_t length{};
		std::uint16_t origin{};
		std::uint16_t end{};
	};

	struct ErrorDisplay {
		std::size_t index{};
		std::string cleaned_line;
		ErrorType error{ErrorType::None};
	};

	// Return Struct for Public API
	struct Result {
		std::vector<LineDisplay> cleaned_program;
		std::vector<ErrorDisplay> errors;
		std::vector<SegmentDisplay> segments;
		std::vector<std::uint8_t> byte_code;
		std::vector<std::string> inputs;
	};

	// Main Loop, Public API for GUI
	Result buildResult(const std::vector<std::string>& raw_lines, bool use_undocumented = false);
}
