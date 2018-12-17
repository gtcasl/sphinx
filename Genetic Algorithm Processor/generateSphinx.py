
import Genetic


def main():
	ga = Genetic.Genetic(100)
	ga.initialize_and_test(10)
	ga.print_best()
	

if __name__ == '__main__':
	main()