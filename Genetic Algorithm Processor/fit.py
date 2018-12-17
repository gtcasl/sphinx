
import export_config
import subprocess as sp

def calculateFitness(config):
	export_config.export(config)

	# cmd = ["export", "CASH_DEBUG_LEVEL=0"]
	# p = sp.Popen(cmd, stdout=sp.PIPE)
	# p.wait()

	cmd = ["make", "-C", "../src"]
	p = sp.Popen(cmd, stdout=sp.PIPE)
	p.wait()

	cmd = ["../src/Sphinx.out", "--test", "../tests/rv32ui-p-addi.hex"]
	p = sp.Popen(cmd, stdout=sp.PIPE)
	p.wait()


	f = open("../results/results.txt", "r")

	time = 0
	cycles = 0

	for line in f:
		if "time to simulate:" in line:
			new_line = line.replace("time to simulate:", "")
			new_line = new_line.replace(" ", "")
			new_line = new_line.replace("#", "")
			new_line = new_line.replace("milliseconds", "")
			new_line = new_line.replace("\n", "")
			# print("***{}***".format(new_line))
			time = int(new_line)

		if "of total cycles:" in line:
			new_line = line.replace("of total cycles:", "")
			new_line = new_line.replace(" ", "")
			new_line = new_line.replace("#", "")
			new_line = new_line.replace("\n", "")
			# print("***{}***".format(new_line))
			cycles = int(new_line)

	f.close()

	return (cycles * time)

