
import config
import random as rand

class Genetic:

	def __init__(self, popSize, mutRate):
		self.popSize = popSize
		self.pop     = []
		self.mutRate = mutRate


	def getGeneration(self, genNum):
		f = open("results.txt", 'w')
		self.initialize()
		for i in range(genNum):
			self.printGen(f, i)
			self.naturalSelection()

		f.close()


	def printGen(self, f, genNum):
		print("******** Generation: {} ********".format(genNum))
		f.write("******** Generation: {} ********\n".format(genNum))
		best = self.getBest()
		print("Best fitness: {}".format(1/best.fitness))
		f.write("Best fitness: {}\n".format(1/best.fitness))
		print("Best configuration: {}".format(best.config))
		f.write("Best configuration: {}\n\n".format(best.config))
		print("\n")

	def initialize(self):
		self.pop = []
		for _ in range(self.popSize):
			curr = config.ConfigObj(mutRate = self.mutRate)
			self.pop.append(curr)


	def naturalSelection(self):
		parents    = self.getParents()
		parentsLen = len(parents) - 1

		for i in range(self.popSize):
			one = parents[ rand.randint(0,parentsLen) ]
			two = parents[ rand.randint(0,parentsLen) ]
			self.pop[i] = one.crossOver(two)


	def getParents(self):
		maxFitness = float(self.getMaxFitness())
		parents    = []

		for i in range(self.popSize):
			weight = int((float(self.pop[i].fitness) / maxFitness) * 100)
			for _ in range(weight):
				parents.append(self.pop[i])

		return parents

	def getMaxFitness(self):
		best_fit = self.pop[0].fitness
		for obj in self.pop:
			if (obj.fitness > best_fit):
				best_fit = obj.fitness
		return best_fit

	def getBest(self):
		best = self.pop[0]
		best_fit = self.pop[0].fitness
		for obj in self.pop:
			if (obj.fitness > best_fit):
				best = obj
				best_fit = obj.fitness

		return best