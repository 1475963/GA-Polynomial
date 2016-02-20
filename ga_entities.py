## genetic algorithm objects

import random
import bitstring
import math
import consts as Consts

class Fragment(object):
	""" fragment object """

	def __init__(self, minRange, maxRange, length):
		self.length = length
		self.bits = bitstring.BitString(int=random.randint(minRange, maxRange),
										length=length)

	def __del__(self):
		# empty destructor
		pass

	def __repr__(self):
		return (("length = {} "
				 + "bits = {} "
				 + "value = {} ").format(self.length, self.bits, self.bits.int))

	def mutate(self):
		# mutation function
		pass

	@property
	def length(self):
	    return self.__length

	@length.setter
	def length(self, value):
		self.__length = value

	@property
	def bits(self):
	    return self.__bits

	@bits.setter
	def bits(self, value):
		self.__bits = value

class Solution(object):
	""" solution object """

	def __init__(self, size, fragmentLength, minRange, maxRange):
		self.size = size
		self.fragments = []
		for j in range(size):
			self.fragments.append(Fragment(minRange,
										   maxRange,
										   fragmentLength))
		self.fitness = 0

	def __del__(self):
		# empty destructor
		pass

	def __repr__(self):
		return ("fitness : {:.2f}\n".format(float(self.fitness)))
		"""
		return (("size = {} "
				 + "fragments = {} "
				 + "fitness = {:.2f}").format(self.size, self.fragments, float(self.fitness)))
		"""

	def evaluate(self, data, scale):
		for i in range(len(data)):
			ysolution = 0
			for j in range(Consts.FRAGMENT_PER_SOLUTION):
				ysolution += (self.fragments[j].bits.int * (data[i][0] ** j))
#			print("mine : %f, real %f" % (ysolution, data[i][1]))
			self.fitness += math.sqrt(((data[i][1] / scale) - (ysolution / scale)) ** 2)
		self.fitness /= len(data)

	def crossover(self, solution):
		# crossover function
		# TO DO WORK IN PROGRESS
		pass

	def mutate(self):
		# mutation function
		# randomly choose a fragment and modify it
		pass

	@property
	def size(self):
	    return self.__size

	@size.setter
	def size(self, value):
		self.__size = value

	@property
	def fragments(self):
	    return self.__fragments

	@fragments.setter
	def fragments(self, value):
		self.__fragments = value

	@property
	def fitness(self):
		return self.__fitness

	@fitness.setter
	def fitness(self, value):
		self.__fitness = value

class Population(object):
	""" population object """

	def __init__(self, maxPop, size, fragmentLength, minRange, maxRange):
		self.maxPop = maxPop
		self.solutions = []
		for i in range(maxPop):
			self.solutions.append(Solution(size,
										   fragmentLength,
										   minRange,
										   maxRange))
		self.fitness = 0

	def __del__(self):
		# empty destructor
		pass

	def __repr__(self):
		return (("maxPop = {} "
				 + "solutions = {} "
				 + "fitness = {:.2f}").format(self.maxPop, self.solutions, float(self.fitness)))

	def evaluate(self, data, scale):
		fitnesses = 0
		for i, solution in enumerate(self.solutions):
			solution.evaluate(data, scale)
			fitnesses += solution.fitness
		self.fitness = fitnesses / len(self.solutions)

	def best(self):
		best = float("inf")
		index = 0
		for i, solution in enumerate(self.solutions):
			if solution.fitness < best:
				best = solution.fitness
				index = i
		return self.solutions[index]

	@property
	def maxPop(self):
	    return self.__maxPop

	@maxPop.setter
	def maxPop(self, value):
		self.__maxPop = value

	@property
	def solutions(self):
	    return self.__solutions

	@solutions.setter
	def solutions(self, value):
		self.__solutions = value

	@property
	def fitness(self):
		return self.__fitness

	@fitness.setter
	def fitness(self, value):
		self.__fitness = value
