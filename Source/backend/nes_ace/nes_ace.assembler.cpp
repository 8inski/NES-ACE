/* Assemble 6502 ASM Scripts into TASStudio Inputs */

#include "nes_ace.assembler.hpp"

#include <string>
#include <string_view>
#include <vector>
#include <inplace_vector>
#include <unordered_map>
#include <cstdint>
#include <cstddef>
#include <optional>
#include <variant>
#include <ranges>
#include <algorithm>
#include <cctype>
#include <iterator>
#include <utility>

#include "nes_ace.database.hpp"
#include "nes_ace.generate_tas.hpp"
#include "nes_ace.utils.hpp"

namespace Assembler {

	namespace {

		// Helper Function to Supress Warnings Regarding uint16_t Conversion Altering Int Values,
		// 6502 Wrap Around Behaviour is Intentional
		constexpr std::uint16_t advanceAddress(
			std::uint16_t address,
			std::size_t byte_count
		) noexcept {
			return static_cast<std::uint16_t>(
				static_cast<std::size_t>(address) +
				byte_count
			);
		}

		/* =========================== Building NormalizedLine Objects =========================== */

		// All Enums/Structs to Build NormalizedLine Objects
		// All Raw Lines Will Be Parsed into These Objects
		// Unique Payload Type for Each Type of Line
		// Value Expressions Parsed as ValueExpr (ie: 12345, <LABEL, >$7FF, %10101010)
		// Operands Define Shape
		// Instructions Point to Database for Single Source of Truth
		// All Lines Contain ErrorType to be Updated Through Assembly Process

		/* ======================================================================================= */

		enum class LineType {
			None,
			Instruction,
			Label,
			Org,
			Const,
			Byte,
			Word
		};

		enum class ValueSelect {
			None,
			Low,
			High
		};

		enum class ValueType {
			None,
			Literal,
			Symbol
		};

		enum class ValueWidth {
			None,
			Byte,
			Word
		};

		struct ValueExpr {
			ValueType type{ValueType::None};
			std::uint16_t value{};
			std::string symbol;
			ValueSelect byte_select{ValueSelect::None};
			ValueWidth width{ValueWidth::None};
		};

		enum class OperandType {
			None,
			Accumulator,
			Immediate,
			Address,
			Indirect
		};

		enum class IndexRegister {
			None,
			X,
			Y
		};

		struct Operand {
			OperandType type{OperandType::None};
			IndexRegister index{IndexRegister::None};
			ValueExpr value;
		};

		struct InstructionPayload {
			const CPU6502::InstructionInfo* inst_info{nullptr};
			const CPU6502::ModeInfo* mode_info{nullptr};
			Operand operand;
		};

		struct LabelPayload {
			std::string name;
		};

		struct OrgPayload {
			ValueExpr origin;
		};

		struct ConstPayload {
			std::string name;
			ValueExpr value;
		};

		struct DataPayload {
			std::vector<ValueExpr> values;
			std::size_t num_bytes{};
		};

		using ParsedPayload = std::variant<
			std::monostate,
			InstructionPayload,
			LabelPayload,
			OrgPayload,
			ConstPayload,
			DataPayload
		>;

		// Normalized Source Line
		struct NormalizedLine {
			std::size_t index{};
			std::string cleaned_line;
			LineType type{LineType::None};
			ErrorType error{ErrorType::None};
			std::string lead_text;
			std::string trail_text;
			ParsedPayload parsed;
		};

		/* =============================== Pass 1: Parse Raw Lines =============================== */

		// This Pass Takes Raw Line Data and Parses It into NormalizedLine Objects That Can Be Used
		// by the Rest of the Assembler

		// Errors Applied This Pass: InvalidLabel, InvalidOperand, InvalidConst, InvalidOrg,
		// InvalidData, Syntax

		/* ======================================================================================= */

		// Helpers to Determine if Char is Valid for Symbol
		constexpr auto isSymbolStart = [](char c) noexcept {
			return
				(c >= 'A' && c <= 'Z') ||
				(c >= 'a' && c <= 'z') ||
				c == '_';
		};

		constexpr auto isSymbolChar = [](char c) noexcept {
			return isSymbolStart(c) || (c >= '0' && c <= '9');
		};

		// Helper to Determine if Char is Part of Hex Number
		constexpr auto isHex = [](char c) noexcept {
			return
				(c >= '0' && c <= '9') ||
				(c >= 'A' && c <= 'F') ||
				(c >= 'a' && c <= 'f');
		};

		struct ParseValue {
			ValueExpr value;
			std::string wrapper;
		};

		// Extract String Containing a Value Expression, Return ValueExpr and Wrapper, Pass 1 Finds
		// Value Expression, Pass 2 Parses It
		std::optional<ParseValue> parseValue(std::string_view trail_text) {

			if (trail_text == "A" || trail_text == "a") {
				return std::nullopt;
			}

			// Pass 1
			std::size_t match_start = std::string_view::npos;
			std::size_t match_end = std::string_view::npos;

			for (std::size_t i = 0; i < trail_text.size(); ++i) {

				std::size_t value_start = i;

				if (trail_text[value_start] == '<' || trail_text[value_start] == '>') {
					++value_start;
				}

				if (value_start >= trail_text.size()) {
					continue;
				}

				std::size_t value_end = value_start;
				const char first = trail_text[value_start];

				if (first == '$') {

					++value_end;
					const std::size_t digit_start = value_end;

					while (
						value_end < trail_text.size() &&
						value_end - digit_start < 4 &&
						isHex(trail_text[value_end])
					) {
						++value_end;
					}

					if (value_end == digit_start) {
						continue;
					}

				} else if (first == '%') {

					++value_end;
					const std::size_t digit_start = value_end;

					while (
						value_end < trail_text.size() &&
						value_end - digit_start < 16 &&
						(trail_text[value_end] == '0' || trail_text[value_end] == '1')
					) {
						++value_end;
					}

					if (value_end == digit_start) {
						continue;
					}

				} else if (first >= '0' && first <= '9') {

					while (
						value_end < trail_text.size() &&
						value_end - value_start < 5 &&
						trail_text[value_end] >= '0' &&
						trail_text[value_end] <= '9'
					) {
						++value_end;
					}

				} else if (isSymbolStart(first)) {

					while (
						value_end < trail_text.size() &&
						isSymbolChar(trail_text[value_end])
					) {
						++value_end;
					}

				} else {
					continue;
				}

				match_start = i;
				match_end = value_end;
				break;
			}

			if (match_start == std::string_view::npos) {
				return std::nullopt;
			}

			const std::string_view value_expr = trail_text.substr(
				match_start,
				match_end - match_start
			);

			std::string wrapper;
			wrapper.reserve(trail_text.size() - value_expr.size());
			wrapper.append(trail_text.substr(0, match_start));
			wrapper.append(trail_text.substr(match_end));
			Utils::toUpper(wrapper);

			// Pass 2
			ValueType type{ValueType::None};
			std::uint16_t value{};
			std::string symbol;
			ValueSelect byte_select{ValueSelect::None};
			ValueWidth width{ValueWidth::None};

			std::string_view value_stripped = value_expr;

			if (value_expr.starts_with('<')) {
				value_stripped.remove_prefix(1);
				byte_select = ValueSelect::Low;
				width = ValueWidth::Byte;

			} else if (value_expr.starts_with('>')) {
				value_stripped.remove_prefix(1);
				byte_select = ValueSelect::High;
				width = ValueWidth::Byte;
			}

			if (value_stripped.starts_with('$')) {

				value_stripped.remove_prefix(1);
				type = ValueType::Literal;

				const auto value_check = Utils::svToUint16(value_stripped, 16);

				if (!value_check) {
					return std::nullopt;
				}

				value = *value_check;

				if (width == ValueWidth::None) {
					width = (value_stripped.size() <= 2)
						? ValueWidth::Byte
						: ValueWidth::Word;
				}

			} else if (value_stripped.starts_with('%')) {

				value_stripped.remove_prefix(1);
				type = ValueType::Literal;

				const auto value_check = Utils::svToUint16(value_stripped, 2);

				if (!value_check) {
					return std::nullopt;
				}

				value = *value_check;

				if (width == ValueWidth::None) {
					width = (value_stripped.size() <= 8)
						? ValueWidth::Byte
						: ValueWidth::Word;
				}

			} else if (isSymbolStart(value_stripped.front())) {

				type = ValueType::Symbol;
				symbol = value_stripped;

				if (width == ValueWidth::None) {
					width = ValueWidth::Word;
				}

			} else {

				type = ValueType::Literal;

				const auto value_check = Utils::svToUint16(value_stripped, 10);

				if (!value_check) {
					return std::nullopt;
				}

				value = *value_check;

				if (width == ValueWidth::None) {
					width = (value < 256)
						? ValueWidth::Byte
						: ValueWidth::Word;
				}
			}

			return ParseValue{
				ValueExpr{
					type,
					value,
					std::move(symbol),
					byte_select,
					width
				},
				std::move(wrapper)
			};
		}

		// Utilize parseValue on Strings That Should Have an Empty Wrapper
		std::optional<ValueExpr> parseStandaloneValue(std::string_view trail_text) {

			auto parsed = parseValue(trail_text);

			if (!parsed || !parsed->wrapper.empty()) {
				return std::nullopt;
			}

			return std::move(parsed->value);
		}

		// Check Symbol is Valid and Not Accumulator Instruction
		bool isValidSymbol(std::string_view symbol) {

			if (
				symbol.empty() ||
				symbol == "A" ||
				symbol == "a" ||
				!isSymbolStart(symbol.front())
			) {
				return false;
			}

			for (const char c : symbol.substr(1)) {

				if (!isSymbolChar(c)) {
					return false;
				}
			}

			return true;
		}

		// Parse Label Payload
		void parseLabel(NormalizedLine& line) {

			LabelPayload payload{};

			const std::string_view label_name =
				std::string_view{line.lead_text}.substr(
					0,
					line.lead_text.size() - 1
				);

			if (!isValidSymbol(label_name)) {
				line.error = ErrorType::InvalidLabel;
				return;
			}

			payload.name = label_name;
			line.parsed = std::move(payload);
		}

		// Parse Instruction Payload
		void parseInstruction(NormalizedLine& line) {

			InstructionPayload payload{};
			Operand operand{};

			if (line.trail_text.empty()) {
				line.parsed = std::move(payload);
				return;
			}

			if (line.trail_text == "A" || line.trail_text == "a") {

				operand.type = OperandType::Accumulator;
				payload.operand = std::move(operand);
				line.parsed = std::move(payload);

				return;
			}

			const auto parsed_value = parseValue(line.trail_text);

			if (!parsed_value) {
				line.error = ErrorType::InvalidOperand;
				return;
			}

			operand.value = std::move(parsed_value->value);
			const std::string_view wrapper = parsed_value->wrapper;

			if (wrapper == "#") {
				operand.type = OperandType::Immediate;

			} else if (wrapper.empty()) {
				operand.type = OperandType::Address;

			} else if (wrapper == ",X") {
				operand.type = OperandType::Address;
				operand.index = IndexRegister::X;

			} else if (wrapper == ",Y") {
				operand.type = OperandType::Address;
				operand.index = IndexRegister::Y;

			} else if (wrapper == "()") {
				operand.type = OperandType::Indirect;

			} else if (wrapper == "(,X)") {
				operand.type = OperandType::Indirect;
				operand.index = IndexRegister::X;

			} else if (wrapper == "(),Y") {
				operand.type = OperandType::Indirect;
				operand.index = IndexRegister::Y;

			} else {
				line.error = ErrorType::InvalidOperand;
				return;
			}

			payload.operand = std::move(operand);
			line.parsed = std::move(payload);
		}

		// Parse Const Payload
		void parseConst(NormalizedLine& line) {

			ConstPayload payload{};

			std::vector<std::string> tokens = Utils::splitString(line.trail_text, '=');

			if (tokens.size() != 2) {
				line.error = ErrorType::InvalidConst;
				return;
			}

			const std::string_view lead_const = tokens.at(0);
			const std::string_view trail_const = tokens.at(1);

			if (!isValidSymbol(lead_const)) {
				line.error = ErrorType::InvalidConst;
				return;
			}

			auto valid_value = parseStandaloneValue(trail_const);

			if (!valid_value) {
				line.error = ErrorType::InvalidConst;
				return;
			}

			payload.name = lead_const;
			payload.value = std::move(*valid_value);
			line.parsed = std::move(payload);
		}

		// Parse Org Payload
		void parseOrg(NormalizedLine& line) {

			OrgPayload payload{};

			auto valid_value = parseStandaloneValue(line.trail_text);

			if (valid_value) {
				payload.origin = std::move(*valid_value);
				line.parsed = std::move(payload);

			} else {
				line.error = ErrorType::InvalidOrg;
			}
		}

		// Parse Data Payload
		void parseData(NormalizedLine& line) {

			DataPayload payload{};

			std::vector<std::string> values = Utils::splitString(line.trail_text, ',');
			payload.values.reserve(values.size());

			for (const auto& value : values) {

				auto valid_value = parseStandaloneValue(value);

				if (valid_value) {
					payload.values.push_back(std::move(*valid_value));

				} else {
					line.error = ErrorType::InvalidData;
					return;
				}
			}

			payload.num_bytes =
				(line.type == LineType::Byte)
					? payload.values.size()
					: 2 * payload.values.size();

			line.parsed = std::move(payload);
		}

		// Strip Text from Semicolon Forward
		void removeComment(std::string& str) {

			const std::size_t comment_pos = str.find(';');

			if (comment_pos != std::string::npos) {
				str.erase(comment_pos);
			}
		}

		// Remove Whitespace Around Commas and Equals Signs, Replace Any Instance of Other Whitespace
		// with Single Space
		void normalizeWhitespace(std::string& str) {

			std::size_t write = 0;
			bool pending_space = false;

			for (std::size_t read = 0; read < str.size(); ++read) {

				const char c = str[read];

				if (std::isspace(static_cast<unsigned char>(c))) {
					pending_space = true;
					continue;
				}

				if (c == ',' || c == '=') {
					str[write++] = c;
					pending_space = false;
					continue;
				}

				if (
					pending_space &&
					write != 0 &&
					str[write - 1] != ',' &&
					str[write - 1] != '='
				) {
					str[write++] = ' ';
				}

				str[write++] = c;
				pending_space = false;
			}

			str.resize(write);
		}

		using Program = std::vector<NormalizedLine>;

		// Clean Lines, Tokenize, Categorize, Call Appropriate Parser and Add NormalizedLine Object
		// to Return Vector
		Program normalizeProgram(const std::vector<std::string>& raw_lines) {

			std::vector<NormalizedLine> program;
			program.reserve(raw_lines.size());

			for (const auto& [i, line] : std::views::enumerate(raw_lines)) {

				NormalizedLine norm{};
				norm.index = static_cast<std::size_t>(i);
				norm.cleaned_line = line;

				removeComment(norm.cleaned_line);
				normalizeWhitespace(norm.cleaned_line);

				std::vector<std::string> tokens = Utils::splitString(norm.cleaned_line, ' ', 1);

				norm.lead_text = tokens.at(0);
				norm.trail_text = (tokens.size() == 2) ? tokens.at(1) : "";

				if (norm.lead_text.size() == 3 && !norm.lead_text.contains(':')) {

					norm.type = LineType::Instruction;
					parseInstruction(norm);
					program.push_back(std::move(norm));

					continue;
				}

				if (tokens.size() == 1) {

					if (norm.lead_text.ends_with(":")) {
						norm.type = LineType::Label;
						parseLabel(norm);
						program.push_back(std::move(norm));

					} else if (norm.lead_text == "") {
						norm.type = LineType::None;
						program.push_back(std::move(norm));

					} else {
						norm.type = LineType::None;
						norm.error = ErrorType::Syntax;
						program.push_back(std::move(norm));
					}

					continue;
				}

				Utils::toUpper(norm.lead_text);

				if (norm.lead_text == ".CONST") {
					norm.type = LineType::Const;
					parseConst(norm);
					program.push_back(std::move(norm));

				} else if (norm.lead_text == ".ORG") {
					norm.type = LineType::Org;
					parseOrg(norm);
					program.push_back(std::move(norm));

				} else if (norm.lead_text == ".BYTE") {
					norm.type = LineType::Byte;
					parseData(norm);
					program.push_back(std::move(norm));

				} else if (norm.lead_text == ".WORD" || norm.lead_text == ".ADDR") {
					norm.type = LineType::Word;
					parseData(norm);
					program.push_back(std::move(norm));

				} else {
					norm.type = LineType::None;
					norm.error = ErrorType::Syntax;
					program.push_back(std::move(norm));
				}
			}

			return program;
		}

		/* ============================= Pass 2: Validation of Lines ============================= */

		// Catch Majority of Errors Not Caught in Parsing Process Such as Confirming Correct Value
		// Expressions Are Being Used and Making Sure Instructions/Modes Both Exist and Are
		// Documented

		// Errors Applied This Pass: InvalidOrg, InvalidConst, InvalidData, InvalidInstruction,
		// InvalidOperand, InvalidMode, UndocumentedInstruction

		/* ======================================================================================= */

		// Confirm Org and Const Are Word Width Literals, Confirm All Values in Word/Addr or Byte Are
		// Appropriate Width
		void validateDirectives(Program& program) {

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type == LineType::Org) {

					const auto& payload = std::get<OrgPayload>(line.parsed);

					if (
						payload.origin.width != ValueWidth::Word ||
						payload.origin.type != ValueType::Literal
					) {
						line.error = ErrorType::InvalidOrg;
					}

				} else if (line.type == LineType::Const) {

					const auto& payload = std::get<ConstPayload>(line.parsed);

					if (
						payload.value.width != ValueWidth::Word ||
						payload.value.type != ValueType::Literal
					) {
						line.error = ErrorType::InvalidConst;
					}

				} else if (line.type == LineType::Word) {

					const auto& payload = std::get<DataPayload>(line.parsed);

					for (const auto& value : payload.values) {

						if (value.width != ValueWidth::Word) {
							line.error = ErrorType::InvalidData;
							break;
						}
					}

				} else if (line.type == LineType::Byte) {

					const auto& payload = std::get<DataPayload>(line.parsed);

					for (const auto& value : payload.values) {

						if (value.width != ValueWidth::Byte) {
							line.error = ErrorType::InvalidData;
							break;
						}
					}
				}
			}
		}

		// Attach InstructionInfo Pointer to Instruction Based on Mnemonic or Alias, Apply Error if
		// it Does Not Exist
		void validateInstructions(Program& program) {

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type == LineType::Instruction) {

					auto& payload = std::get<InstructionPayload>(line.parsed);
					payload.inst_info = CPU6502::findInstruction(line.lead_text);

					if (!payload.inst_info) {
						line.error = ErrorType::InvalidInstruction;
					}
				}
			}
		}

		// Use Operand Information from Initial Parse to Infer an Instruction Mode, Attach ModeInfo
		// Pointer to Instruction, Apply Error if it Does Not Exist
		void validateModes(Program& program) {

			using CPU6502::Mode;
			using CPU6502::InstructionType;

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type != LineType::Instruction) {
					continue;
				}

				auto& payload = std::get<InstructionPayload>(line.parsed);
				std::optional<Mode> mode;

				if (payload.inst_info->type == InstructionType::Branch) {

					if (payload.operand.type == OperandType::Address &&
						payload.operand.index == IndexRegister::None &&
						payload.operand.value.width == ValueWidth::Word)
					{
						mode = Mode::REL;
					}

				} else if (payload.inst_info->type == InstructionType::SingleByte) {

					if (payload.operand.type == OperandType::None) {
						mode = Mode::IMP;
					}

				} else {

					if (payload.operand.type == OperandType::None) {
						mode = Mode::IMP;

					} else if (payload.operand.type == OperandType::Accumulator) {
						mode = Mode::ACC;

					} else if (payload.operand.type == OperandType::Immediate) {

						if (payload.operand.value.width == ValueWidth::Byte) {
							mode = Mode::IMM;
						}

					} else if (payload.operand.type == OperandType::Indirect) {

						if (payload.operand.index == IndexRegister::X &&
							payload.operand.value.width == ValueWidth::Byte
						) {
							mode = Mode::IDX;

						} else if (payload.operand.index == IndexRegister::Y &&
							payload.operand.value.width == ValueWidth::Byte
						) {
							mode = Mode::IDY;

						} else if (payload.operand.index == IndexRegister::None &&
							payload.operand.value.width == ValueWidth::Word
						) {
							mode = Mode::IND;
						}

					} else if (payload.operand.type == OperandType::Address) {

						if (payload.operand.value.width == ValueWidth::Byte) {

							if (payload.operand.index == IndexRegister::X) {
								mode = Mode::ZPX;

							} else if (payload.operand.index == IndexRegister::Y) {
								mode = Mode::ZPY;

							} else {
								mode = Mode::ZPG;
							}

						} else if (payload.operand.value.width == ValueWidth::Word) {

							if (payload.operand.index == IndexRegister::X) {
								mode = Mode::ABX;

							} else if (payload.operand.index == IndexRegister::Y) {
								mode = Mode::ABY;

							} else {
								mode = Mode::ABS;
							}
						}
					}
				}

				if (!mode) {
					line.error = ErrorType::InvalidOperand;
					continue;
				}

				payload.mode_info = CPU6502::findMode(*payload.inst_info, *mode);

				if (!payload.mode_info) {
					line.error = ErrorType::InvalidMode;
				}
			}
		}

		// Apply Errors to Instructions Using Undocumented Instructions/Modes
		void invalidateUndocumented(Program& program) {

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type != LineType::Instruction) {
					continue;
				}

				const auto& payload = std::get<InstructionPayload>(line.parsed);

				if (
					payload.inst_info->undocumented ||
					payload.mode_info->undocumented
				) {
					line.error = ErrorType::UndocumentedInstruction;
				}
			}
		}

		/* ============================== Pass 3: Symbol Resolution ============================== */

		// Generate SymbolTable Containing all Labels/Constants and Their Associated Values, Use That
		// to Resolve Value Expressions

		// Errors Applied This Pass: DuplicateSymbol, UndefinedSymbol, MissingOrg

		/* ======================================================================================= */

		using SymbolTable = std::unordered_map<std::string, std::uint16_t>;

		// Generate Map of Symbols and Values, Track Current Address to Build Labels
		SymbolTable genSymbolTable(Program& program) {

			SymbolTable symbols;
			symbols.reserve(program.size());

			std::uint16_t current_address{};
			bool has_origin = false;

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type == LineType::None) {
					continue;
				}

				if (line.type == LineType::Org) {

					const auto& payload = std::get<OrgPayload>(line.parsed);

					current_address = payload.origin.value;
					has_origin = true;

				} else if (line.type == LineType::Const) {

					const auto& payload = std::get<ConstPayload>(line.parsed);

					if (
						auto [_, unique] = symbols.emplace(
							payload.name,
							payload.value.value
						);
						!unique
					) {
						line.error = ErrorType::DuplicateSymbol;
					}

				} else if (line.type == LineType::Label) {

					if (!has_origin) {
						line.error = ErrorType::MissingOrg;
						continue;
					}

					const auto& payload = std::get<LabelPayload>(line.parsed);

					if (
						auto [_, unique] = symbols.emplace(
							payload.name,
							current_address
						);
						!unique
					) {
						line.error = ErrorType::DuplicateSymbol;
					}

				} else if (line.type == LineType::Byte || line.type == LineType::Word) {

					if (!has_origin) {
						line.error = ErrorType::MissingOrg;
						continue;
					}

					const auto& payload = std::get<DataPayload>(line.parsed);

					current_address = advanceAddress(current_address, payload.num_bytes);

				} else if (line.type == LineType::Instruction) {

					if (!has_origin) {
						line.error = ErrorType::MissingOrg;
						continue;
					}

					const auto& payload = std::get<InstructionPayload>(line.parsed);

					current_address = advanceAddress(current_address, payload.mode_info->num_bytes);
				}
			}

			return symbols;
		}

		// Attach Value from Symbol Table to ValueExpr
		void resolveSymbols(Program& program, const SymbolTable& symbols) {

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type == LineType::Instruction) {

					auto& payload = std::get<InstructionPayload>(line.parsed);

					if (payload.operand.value.type == ValueType::Symbol) {

						if (
							auto it = symbols.find(payload.operand.value.symbol);
							it != symbols.end()
						) {
							payload.operand.value.value = it->second;

						} else {
							line.error = ErrorType::UndefinedSymbol;
						}
					}

				} else if (line.type == LineType::Byte || line.type == LineType::Word) {

					auto& payload = std::get<DataPayload>(line.parsed);

					for (auto& value : payload.values) {

						if (value.type == ValueType::Symbol) {

							if (
								auto it = symbols.find(value.symbol);
								it != symbols.end()
							) {
								value.value = it->second;

							} else {
								line.error = ErrorType::UndefinedSymbol;
								break;
							}
						}
					}
				}
			}
		}

		/* =============================== Pass 4: Create Segments =============================== */

		// Assemble Lines into Bytes and Generate Segments of Code Splitting on .org, Split into 255
		// Byte Chunks, and Generate Headers Used by ASM Total Control Program

		// Errors Applied This Pass: BranchOutOfRange

		/* ======================================================================================= */

		// Calculate Branch Offset, 0x007F = 127 Bytes Ahead, 0xFF80 = 128 Bytes Back
		constexpr std::optional<std::uint8_t> calcBranchValue(
			std::uint16_t current_address,
			std::uint16_t branch_to
		) noexcept {

			const std::uint16_t branch_from = advanceAddress(current_address, 2);

			const std::uint16_t offset = static_cast<std::uint16_t>(branch_to - branch_from);

			if (offset <= 0x007F || offset >=  0xFF80) {
				return static_cast<std::uint8_t>(offset);
			}

			return std::nullopt;
		}

		// Assemble Word/Byte Directive into Vector of Bytes
		std::vector<std::uint8_t> emitDataBytes(const NormalizedLine& line) {

			const auto& payload = std::get<DataPayload>(line.parsed);

			std::vector<std::uint8_t> bytes;
			bytes.reserve(payload.num_bytes);

			if (line.type == LineType::Byte) {

				for (const auto& value : payload.values) {

					if (value.byte_select == ValueSelect::High) {
						bytes.push_back(Utils::highByte(value.value));

					} else {
						bytes.push_back(Utils::lowByte(value.value));
					}
				}

			} else if (line.type == LineType::Word) {

				for (const auto& value : payload.values) {
					bytes.push_back(Utils::lowByte(value.value));
					bytes.push_back(Utils::highByte(value.value));
				}
			}

			return bytes;
		}

		// Assemble 6502 Instruction Line into Inplace Vector of Bytes (Length Will Never Be > 3)
		std::inplace_vector<std::uint8_t, 3> emitInstructionBytes(
			NormalizedLine& line,
			std::uint16_t current_address
		) {

			using CPU6502::InstructionType;

			std::inplace_vector<std::uint8_t, 3> bytes;

			const auto& payload = std::get<InstructionPayload>(line.parsed);

			if (payload.inst_info->type == InstructionType::SingleByte) {
				bytes.push_back(payload.mode_info->opcode);

			} else if (payload.inst_info->type == InstructionType::Branch) {

				const auto offset = calcBranchValue(current_address, payload.operand.value.value);

				if (!offset) {
					line.error = ErrorType::BranchOutOfRange;
					return bytes;
				}

				bytes.push_back(payload.mode_info->opcode);
				bytes.push_back(*offset);

			} else {

				bytes.push_back(payload.mode_info->opcode);

				if (payload.operand.value.width == ValueWidth::Byte) {

					if (payload.operand.value.byte_select == ValueSelect::High) {
						bytes.push_back(Utils::highByte(payload.operand.value.value));

					} else {
						bytes.push_back(Utils::lowByte(payload.operand.value.value));
					}

				} else if (payload.operand.value.width == ValueWidth::Word) {
					bytes.push_back(Utils::lowByte(payload.operand.value.value));
					bytes.push_back(Utils::highByte(payload.operand.value.value));
				}
			}

			return bytes;
		}

		// Helper Template to Push Bytes in a Vector or an Inplace Vector to Current Segment, Returns
		// Size of Container
		template <typename Container>
		std::size_t appendBytes(
			std::vector<std::uint8_t>& segment,
			const Container& bytes
		) {
			segment.append_range(bytes);
			return bytes.size();
		}

		struct Segment {
			std::uint16_t origin;
			std::vector<std::uint8_t> bytes;
			std::inplace_vector<std::uint8_t, 4> header;
		};

		// Generate Segments of Byte Code, Switching Out Current Segment on .org
		std::vector<Segment> genSegments(Program& program) {

			std::vector<Segment> segments;
			std::uint16_t current_address{};
			Segment current_segment{current_address, {}, {}};

			for (auto& line : program) {

				if (line.error != ErrorType::None) {
					continue;
				}

				if (line.type == LineType::None ||
					line.type == LineType::Const ||
					line.type == LineType::Label)
				{
					continue;
				}

				if (line.type == LineType::Org) {

					const auto& payload = std::get<OrgPayload>(line.parsed);

					if (!current_segment.bytes.empty()) {
						segments.push_back(std::move(current_segment));
					}

					current_address = payload.origin.value;
					current_segment = {current_address, {}, {}};

					continue;
				}

				if (line.type == LineType::Word || line.type == LineType::Byte) {

					const auto bytes = emitDataBytes(line);

					current_address = advanceAddress(
						current_address,
						appendBytes(current_segment.bytes, bytes)
					);

				} else if (line.type == LineType::Instruction) {

					const auto bytes = emitInstructionBytes(line, current_address);

					if (line.error != ErrorType::None) {
						continue;
					}

					current_address = advanceAddress(
						current_address,
						appendBytes(current_segment.bytes, bytes)
					);
				}
			}

			if (!current_segment.bytes.empty()) {
				segments.push_back(std::move(current_segment));
			}

			return segments;
		}

		// Split Segments into 255 Byte Chunks, Update Origins Accordingly
		void splitSegments(std::vector<Segment>& segments) {

			std::size_t total_chunks = 0;

			for (const auto& segment : segments) {

				if (!segment.bytes.empty()) {
					total_chunks += (segment.bytes.size() + 254) / 255;
				}
			}

			std::vector<Segment> split_segments;
			split_segments.reserve(total_chunks);

			for (auto& segment : segments) {

				const std::size_t total_bytes = segment.bytes.size();

				for (std::size_t i = 0; i < total_bytes; i += 255) {

					const std::uint16_t chunk_origin = advanceAddress(segment.origin, i);
					const std::size_t current_chunk_size = std::min(
						static_cast<std::size_t>(255),
						total_bytes - i
					);

					std::vector<std::uint8_t> chunk_bytes;
					chunk_bytes.reserve(current_chunk_size);

					using ByteDifference = std::vector<std::uint8_t>::difference_type;

					const auto start = segment.bytes.begin() + static_cast<ByteDifference>(i);
					const auto end = start + static_cast<ByteDifference>(current_chunk_size);

					std::move(start, end, std::back_inserter(chunk_bytes));

					split_segments.push_back(
						Segment{
							chunk_origin,
							std::move(chunk_bytes),
							{}
						}
					);
				}
			}

			segments = std::move(split_segments);
		}

		// Generate TAS Headers for Each Segment (0x01 Marks Start of New Segment)
		void applyHeaders(std::vector<Segment>& segments) {

			for (bool first = true; auto& segment : segments) {

				const std::uint8_t length = static_cast<std::uint8_t>(segment.bytes.size());

				if (first) {

					segment.header.push_back(length);
					segment.header.push_back(Utils::highByte(segment.origin));
					segment.header.push_back(Utils::lowByte(segment.origin));

					first = false;

				} else {
					segment.header.push_back(0x01);
					segment.header.push_back(length);
					segment.header.push_back(Utils::highByte(segment.origin));
					segment.header.push_back(Utils::lowByte(segment.origin));
				}
			}
		}

		// Generate Byte Code from Segments
		std::vector<std::uint8_t> genByteCode(const std::vector<Segment>& segments) {

			std::size_t total_size{};

			for (const auto& segment : segments) {
				total_size += segment.header.size() + segment.bytes.size();
			}

			std::vector<std::uint8_t> byte_code;
			byte_code.reserve(total_size);

			for (const auto& segment : segments) {
				byte_code.append_range(segment.header);
				byte_code.append_range(segment.bytes);
			}

			return byte_code;
		}

		/* ================================ Generate GUI Objects ================================= */

		// Build All Objects Getting Passed to the GUI, Keep Bare Minimum Visible to Public API

		// Errors Applied This Pass: None

		/* ======================================================================================= */

		// Generate Output Lines for GUI
		std::vector<LineDisplay> genLineDisplay(const Program& program) {

			std::vector<LineDisplay> output;
			output.reserve(program.size());

			for (const auto& line : program) {

				bool has_error{};

				if (line.error != ErrorType::None) {
					has_error = true;
				}

				output.emplace_back(
					line.cleaned_line,
					has_error
				);
			}

			return output;
		}

		// Generate Errors for GUI
		std::vector<ErrorDisplay> genErrorDisplay(const Program& program) {

			std::vector<ErrorDisplay> errors;
			errors.reserve(program.size());

			for (const auto& line : program) {

				if (line.error != ErrorType::None) {
					errors.emplace_back(
						line.index,
						line.cleaned_line,
						line.error
					);
				}
			}

			return errors;
		}

		// Generate Segment Display Data for GUI
		std::vector<SegmentDisplay> genSegmentDisplay(const std::vector<Segment>& segments) {

			std::vector<SegmentDisplay> segment_data;
			segment_data.reserve(segments.size());

			for (const auto& [i, segment] : std::views::enumerate(segments)) {

				std::size_t segment_index = static_cast<std::size_t>(i);
				std::uint16_t segment_end = advanceAddress(
					segment.origin,
					segment.bytes.size() - 1
				);

				segment_data.emplace_back(
					segment_index,
					segment.bytes.size(),
					segment.origin,
					segment_end
				);
			}

			return segment_data;
		}
	}

	// Main Loop, Public API for GUI
	Result buildResult(const std::vector<std::string>& raw_lines, bool use_undocumented) {

		Program program = normalizeProgram(raw_lines);

		validateDirectives(program);
		validateInstructions(program);
		validateModes(program);

		if (!use_undocumented) {
			invalidateUndocumented(program);
		}

		const SymbolTable symbols = genSymbolTable(program);
		resolveSymbols(program, symbols);

		std::vector<Segment> segments = genSegments(program);
		splitSegments(segments);
		applyHeaders(segments);

		std::vector<LineDisplay> cleaned_program = genLineDisplay(program);
		std::vector<ErrorDisplay> errors = genErrorDisplay(program);
		std::vector<SegmentDisplay> segment_data = genSegmentDisplay(segments);

		if (!errors.empty()) {
			return {
				std::move(cleaned_program),
				std::move(errors),
				std::move(segment_data),
				{},
				{}
			};
		}

		std::vector<std::uint8_t> byte_code = genByteCode(segments);
		std::vector<std::string> inputs = GenerateTAS::p1Only(byte_code);

		return {
			std::move(cleaned_program),
			std::move(errors),
			std::move(segment_data),
			std::move(byte_code),
			std::move(inputs)
		};
	}
}
