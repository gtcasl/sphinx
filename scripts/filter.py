
def get_main(inst_file):
	main = []

	found = False
	for line in inst_file:

		if (found):
			main.append(line)
			if "ret" in line:
				found = False

		if ("<main>:" in line):
			found = True
	return main


def parse_inst(main_inst):
	instructions = []
	for inst in main_inst:
		inst = inst.replace(" ", "")
		inst = inst.replace("\n", "")
		inst = inst.replace(":", "")
		info = inst.split("\t")
		instructions.append((info[0], info[1]))
	return instructions

def main():
	inst_file = open("../Workspace/add.dump", "r")

	output    = open("../Workspace/add.hex", "w")

	main_inst   = get_main(inst_file)
	parsed_inst = parse_inst(main_inst)
	for address, instruction in parsed_inst:
		output.write("{} {}\n".format(int(address, 16),int(instruction, 16)))

	inst_file.close()
	output.close()

if __name__ == '__main__':
	main()