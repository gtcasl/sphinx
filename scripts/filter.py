
def get_main(inst_file):
	main = []
	output = open("../Workspace/tags.hex", "w")
	found  = False
	for line in inst_file:
		if found:
			if len(line.split(" ")) > 2:
				main.append(line)
			elif len(line.split(" ")) == 2:
				addr = line.replace(":", "")
				addr = addr.replace("\n", "")
				addr = addr.split(" ")
				if (addr[1] == "<main>"):
					output.write("{}\n".format(int(addr[0], 16)))
		else:
			if "Disassembly of section .text:" in line:
				found = True


	return main


def parse_inst(main_inst):
	instructions = []
	instructions.append(("10360","0f000113"))
	for inst in main_inst:
		inst = inst.replace(" ", "")
		inst = inst.replace("\n", "")
		inst = inst.replace(":", "")
		info = inst.split("\t")
		instructions.append((info[0], info[1]))

	# instructions.append(("10360", "0f000113"))
	# instructions.append(("10364", "fe010113"))
	# instructions.append(("10368", "00812e23"))
	# instructions.append(("1036c", "02010413"))
	# instructions.append(("10370", "01000793"))
	# instructions.append(("10374", "fef42623")) # 10374:	fef42623          	sw	a5,-20(s0)
	# instructions.append(("10378", "00700793")) # 10378:	00700793          	li	a5,7
	# instructions.append(("1037c", "fef42423")) # 1037c:	fef42423          	sw	a5,-24(s0)
	# instructions.append(("10380", "fec42703")) # 10380:	fec42703          	lw	a4,-20(s0)
	# instructions.append(("10384", "fe842783")) # 10384:	fe842783          	lw	a5,-24(s0)
	# instructions.append(("10388", "00f707b3")) # 10388:	00f707b3          	add	a5,a4,a5
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