
import config

class Genetic:

	def __init__(self, pop_size):
		self.pop_size = pop_size
		self.pop      = []


	def initialize_and_test(self, num_generations):
		self.pop = []
		for _ in range(self.pop_size):
			self.pop.append(config.ConfigObj())

	def print_best(self):
		best = self.pop[0].config
		best_fit = self.pop[0].fitness
		for obj in self.pop:
			if (obj.fitness < best_fit):
				best = obj.config
				best_fit = obj.fitness

		print("BEST CONFIG: ")
		print(best)
		print("FITNESS: {}".format(best_fit))