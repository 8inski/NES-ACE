# Required to grab file name from command line
import sys

branch_locs = [] # RAM address of all branch instructions
program = [] # List of lines in intital program
byte_code = [] # List of assembled bytes
input_set = [] # List of button inputs corresponding to byte code

# Returns branch value based on location and destination
def calcBranchValue(start, finish):

	result = int(finish, 16) - int(start, 16)

	if result >= 2:
		result = str(hex(result - 2))[-2:]
	else:
		result = str(hex(254 + result))[-2:]

	if result[0] == 'x':
		result = result.replace('x', '0')
		return result.upper()
	else:
		return result.upper()

# Open file specified in command line
with open(sys.argv[1], "r") as f1:

	counter = 0

	for line in f1:
		# Append first line broken by white space to branch_locs
		if counter == 0:
			branch_locs = line.split()
			counter += 1
		# Append each subsequent line to program
		else:
			program.append(line)

# Single Byte Instruction : Associated Opcode
single_byte_ins = {
	'ASL':'0A',
	'BRK':'00',
	'CLC':'18',
	'SEC':'38',
	'CLI':'58',
	'SEI':'78',
	'CLV':'B8',
	'CLD':'D8',
	'SED':'F8',
	'NOP':'EA',
	'TAX':'AA',
	'TXA':'8A',
	'DEX':'CA',
	'INX':'E8',
	'TAY':'A8',
	'TYA':'98',
	'DEY':'88',
	'INY':'C8',
	'RTI':'40',
	'RTS':'60',
	'TXS':'9A',
	'TSX':'BA',
	'PHA':'48',
	'PLA':'68',
	'PHP':'08',
	'PLP':'28',
	'ROL A':'2A',
	'ROR A':'6A',
	'LSR A':'4A'
}

# Branch Instruction : Associated Opcode
branch_ins = {
	'BPL':'10',
	'BMI':'30',
	'BVC':'50',
	'BVS':'70',
	'BCC':'90',
	'BCS':'B0',
	'BNE':'D0',
	'BEQ':'F0'
}

# Jump Instruction : Associated Opcodes [Direct, Indirect]
jump_ins = {
	'JSR':['20', None],
	'JMP':['4C', '6C']
}

# Other Instruction : Associated Opcodes [Immediate, Zero Page, Zero Page X, Zero Page Y, Absolute, Absolute X, Absolute Y, Indirect X, Indirect Y]
other_ins = {
	'ADC':['69', '65', '75', None, '6D', '7D', '79', '61', '71'],
	'AND':['29', '25', '35', None, '2D', '3D', '39', '21', '31'],
	'ASL':[None, '06', '16', None, '0E', '1E', None, None, None],
	'BIT':[None, '24', None, None, '2C', None, None, None, None],
	'CMP':['C9', 'C5', 'D5', None, 'CD', 'DD', 'D9', 'C1', 'D1'],
	'CPX':['E0', 'E4', None, None, 'EC', None, None, None, None],
	'CPY':['C0', 'C4', None, None, 'CC', None, None, None, None],
	'DEC':[None, 'C6', 'D6', None, 'CE', 'DE', None, None, None],
	'EOR':['49', '45', '55', None, '4D', '5D', '59', '41', '51'],
	'INC':[None, 'E6', 'F6', None, 'EE', 'FE', None, None, None],
	'LDA':['A9', 'A5', 'B5', None, 'AD', 'BD', 'B9', 'A1', 'B1'],
	'LDX':['A2', 'A6', None, 'B6', 'AE', None, 'BE', None, None],
	'LDY':['A0', 'A4', 'B4', None, 'AC', 'BC', None, None, None],
	'LSR':[None, '46', '56', None, '4E', '5E', None, None, None],
	'ORA':['09', '05', '15', None, '0D', '1D', '19', '01', '11'],
	'ROL':[None, '26', '36', None, '2E', '3E', None, None, None],
	'ROR':[None, '66', '76', None, '6E', '7E', None, None, None],
	'SBC':['E9', 'E5', 'F5', None, 'ED', 'FD', 'F9', 'E1', 'F1'],
	'STA':[None, '85', '95', None, '8D', '9D', '99', '81', '91'],
	'STX':[None, '86', None, '96', '8E', None, None, None, None],
	'STY':[None, '84', '94', None, '8C', None, None, None, None]
}

# Increase each time we hit a branch to reference branch_locs correctly
branch_number = 0

# Loop through all program lines and append bytes to byte_code
for line in program:

	# Append opcode directly if single byte instruction
	if line[0:3] in single_byte_ins:
		byte_code.append(single_byte_ins[line[0:3]])

	# Calculate branch value and append that with opcode
	elif line[0:3] in branch_ins:
		byte_code.append(branch_ins[line[0:3]])
		byte_code.append(calcBranchValue(branch_locs[branch_number], line[5:9]))
		branch_number += 1

	# Append opcode and ram address bytes for jump
	elif line[0:3] in jump_ins:
		# Direct
		if len(line) == 10:
			byte_code.append(jump_ins[line[0:3]][0])
			byte_code.append(line[7:9])
			byte_code.append(line[5:7])
		# Indirect
		elif len(line) == 12:
			byte_code.append(jump_ins[line[0:3]][1])
			byte_code.append(line[8:10])
			byte_code.append(line[6:8])

	# Append opcode and ram address bytes depending on mode
	elif line[0:3] in other_ins:
		# Immediate
		if line[4] == '#':
			byte_code.append(other_ins[line[0:3]][0])
			byte_code.append(line[6:8])
		# Zero Page
		elif len(line) == 8:
			byte_code.append(other_ins[line[0:3]][1])
			byte_code.append(line[5:7])
		# Zero Page, X
		elif len(line) == 10 and line[8] == 'X':
			byte_code.append(other_ins[line[0:3]][2])
			byte_code.append(line[5:7])
		# Zero Page, Y
		elif len(line) == 10 and line[8] == 'Y':
			byte_code.append(other_ins[line[0:3]][3])
			byte_code.append(line[5:7])
		# Absolute
		elif len(line) == 10 and line[8] not in ['X', 'Y']:
			byte_code.append(other_ins[line[0:3]][4])
			byte_code.append(line[7:9])
			byte_code.append(line[5:7])
		# Absolute, X
		elif len(line) == 12 and line[10] == 'X':
			byte_code.append(other_ins[line[0:3]][5])
			byte_code.append(line[7:9])
			byte_code.append(line[5:7])
		# Absolute, Y
		elif len(line) == 12 and line[10] == 'Y' and line[8] != ')':
			byte_code.append(other_ins[line[0:3]][6])
			byte_code.append(line[7:9])
			byte_code.append(line[5:7])
		# Indirect, X
		elif len(line) == 12 and line[9] == 'X':
			byte_code.append(other_ins[line[0:3]][7])
			byte_code.append(line[6:8])
		# Indirect, Y
		elif len(line) == 12 and line[8] == ')':
			byte_code.append(other_ins[line[0:3]][8])
			byte_code.append(line[6:8])
			
	# Ignore lines that don't have instructions
	else:
		continue

# Remove 00 from end of byte_code (empty line at end)
byte_code.pop()

# See if even amount of bytes, if not, append NOP instruction
if len(byte_code) % 2 != 0:
	byte_code.append('EA')

# Loop through byte code and create input strings
for byte in byte_code:

	pressed = ''

	# Append each button if the corresponding bit is included
	pressed += 'U' if int(byte, 16) & 8 != 0 else '.'
	pressed += 'D' if int(byte, 16) & 4 != 0 else '.'
	pressed += 'L' if int(byte, 16) & 2 != 0 else '.'
	pressed += 'R' if int(byte, 16) & 1 != 0 else '.'
	pressed += 'S' if int(byte, 16) & 16 != 0 else '.'
	pressed += 's' if int(byte, 16) & 32 != 0 else '.'
	pressed += 'B' if int(byte, 16) & 64 != 0 else '.'
	pressed += 'A' if int(byte, 16) & 128 != 0 else '.'

	# Add in what SubNESHawk requires for TAS Studio
	input_set.append('|    0,..|%s|........|' % pressed)

# Write the output file to be copied directly into TAS Studio
with open('%s_inputs.txt' % sys.argv[1], 'w') as f2:
	for buttonspressed in input_set:
		f2.write('%s\n' % buttonspressed)