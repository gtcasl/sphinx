
import Genetic


def main():
	ga = Genetic.Genetic(popSize=1000, mutRate=5)
	ga.getGeneration(10)
	

if __name__ == '__main__':
	main()