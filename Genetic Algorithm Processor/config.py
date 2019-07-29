import export_config
import subprocess as sp
import options_list

import random as rand

from pprint import pprint
	


class ConfigObj:

	def __init__(self, config = None, mutRate = 0):
		if (config == None):
			self.config  = self.genRandomConfig()
		else:
			self.config  = config

		self.fitness = 1.0 / float(self.fitTest())
		self.mutRate = mutRate


	def fitTest(self):
		export_config.export(self.config)

		# cmd = ["export", "CASH_DEBUG_LEVEL=0"]
		# p = sp.Popen(cmd, stdout=sp.PIPE)
		# p.wait()

		# print("******************************* CONFIG {}".format(self.config))
		cmd = ["make", "-C", "../src"]
		p = sp.Popen(cmd, stdout=sp.PIPE)
		for line in p.stdout:
			if "error" in line:
				print("EROORRRR")
				exit()
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

	def genRandomConfig(self):
		final = []

		for config_name, config_options in options_list.options.items():
			chose = rand.randint(0,100)


			if (chose < 50):
				details = config_options["no"]
			else:
				details = config_options["yes"]

			curr = []

			if (details["val"] != ""):
				curr.append("#define {} {}".format(details["label"], details["val"]))
			else:
				curr.append("#define {}".format(details["label"]))


			for opt, rang in details["dependancies"].items():
				num = rand.randint(rang[0], rang[1])
				curr.append("#define {} {}".format(opt, num))

			final.append(curr)

		return final


	def crossOver(self, other):
		curr = []
		mid = len(self.config) / 2
		for i in range(len(self.config)):
			if i < mid:
				use = self.config[i]
			else:
				use = other.config[i]
			curr.append(use)

		curr = self.mutate(curr)

		return ConfigObj(curr, self.mutRate)


	def mutate(self, conf):
		if rand.randint(0, 100) < self.mutRate:
			i = rand.randint(0, len(conf) - 1)
			toMutate = conf[i]
			if "CACHE" in toMutate[0]:
				if "ENABLED" in toMutate[0]:
					m = rand.randint(0,100)
					if m < 50:
						j = rand.randint(1,2)
						rang = options_list.opposite[toMutate[j]]

						num = rand.randint(rang[0], rang[1])
						replace = append("#define {} {}".format(opt, num))

						toMutate[j] = replace
						conf[i] = toMutate
					else:
						conf[i] = options_list.opposite[toMutate[0]]
				else:
					add = []
					add.extend(options_list.opposite[toMutate[0]])
					if "DCACHE" in add[0]:
						rang = options_list.opposite["#define DLINE_BITS"]
						add.append("#define {} {}".format("DLINE_BITS", rand.randint(rang[0], rang[1])))

						rang = options_list.opposite["#define DCACHE_BITS"]
						add.append("#define {} {}".format("DCACHE_BITS", rand.randint(rang[0], rang[1])))
					else:
						rang = options_list.opposite["#define ILINE_BITS"]
						add.append("#define {} {}".format("ILINE_BITS", rand.randint(rang[0], rang[1])))
						
						rang = options_list.opposite["#define ICACHE_BITS"]
						add.append("#define {} {}".format("ICACHE_BITS", rand.randint(rang[0], rang[1])))

					conf[i] = add
			else:
				conf[i] = options_list.opposite[toMutate[0]]

		return conf




if __name__ == '__main__':
	for _ in range(100):
		one = ConfigObj(mutRate=100)
		two = ConfigObj(mutRate=100)
		three = one.crossOver(two)
		print(three.config)
		print("--------------------")




