/* Display All Information About 6502 Instruction Looked up by Mnemonic or Alias */

#pragma once

#include <string>
#include <string_view>
#include <vector>

namespace Glossary {

	// Push All Displayed Lines to Return Vector
	std::vector<std::string> buildResult(std::string_view mnemonic);
}
