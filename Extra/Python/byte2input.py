byte_list = ['AB', '9C', '81']
inputs = []

for byte in byte_list:

	first = ""
	second = ""

	if byte[0] == "0":
		second = "....|........|"
	elif byte[0] == "1":
		second = "S...|........|"
	elif byte[0] == "2":
		second = ".s..|........|"
	elif byte[0] == "3":
		second = "Ss..|........|"
	elif byte[0] == "4":
		second = "..B.|........|"
	elif byte[0] == "5":
		second = "S.B.|........|"
	elif byte[0] == "6":
		second = ".sB.|........|"
	elif byte[0] == "7":
		second = "SsB.|........|"
	elif byte[0] == "8":
		second = "...A|........|"
	elif byte[0] == "9":
		second = "S..A|........|"
	elif byte[0] == "A":
		second = ".s.A|........|"
	elif byte[0] == "B":
		second = "Ss.A|........|"
	elif byte[0] == "C":
		second = "..BA|........|"
	elif byte[0] == "D":
		second = "S.BA|........|"
	elif byte[0] == "E":
		second = ".sBA|........|"
	elif byte[0] == "F":
		second = "SsBA|........|"

	if byte[1] == "0":
		first = "|    0,...|...."
	elif byte[1] == "1":
		first = "|    0,...|...R"
	elif byte[1] == "2":
		first = "|    0,...|..L."
	elif byte[1] == "3":
		first = "|    0,...|..LR"
	elif byte[1] == "4":
		first = "|    0,...|.D.."
	elif byte[1] == "5":
		first = "|    0,...|.D.R"
	elif byte[1] == "6":
		first = "|    0,...|.DL."
	elif byte[1] == "7":
		first = "|    0,...|.DLR"
	elif byte[1] == "8":
		first = "|    0,...|U..."
	elif byte[1] == "9":
		first = "|    0,...|U..R"
	elif byte[1] == "A":
		first = "|    0,...|U.L."
	elif byte[1] == "B":
		first = "|    0,...|U.LR"
	elif byte[1] == "C":
		first = "|    0,...|UD.."
	elif byte[1] == "D":
		first = "|    0,...|UD.R"
	elif byte[1] == "E":
		first = "|    0,...|UDL."
	elif byte[1] == "F":
		first = "|    0,...|UDLR"

	inputs.append(first + second)

for i in inputs:
	print(i)