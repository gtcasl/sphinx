
import options_list
import fit

import random as rand
def genRandomConfig():
	final = {}

	for opt, details in options_list.options.items():
		chose = rand.randint(0,100)

		if (chose < 50):
			continue
		else:
			final[opt] = details["val"]
			for opt, rang in details["dependancies"].items():
				final[opt] = rand.randint(rang[0], rang[1])
	return final


class ConfigObj:

	def __init__(self):
		self.config  = genRandomConfig()
		self.fitness = fit.calculateFitness(self.config)






if __name__ == '__main__':
	one = ConfigObj()