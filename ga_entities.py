## genetic algorithm objects

import random
import bitstring
import math
import os
from threading import Thread
import consts as Consts
from start import data, dataMatrix

class Fragment(object):
    """ fragment object """

    def __init__(self, length):
        self.length = length
        self.bits = bitstring.BitString(int=int.from_bytes(os.urandom(int(length / 8)), byteorder='big', signed=True),
                                        length=length)
        self.bitsValue = self.bits.int

    def __del__(self):
        # empty destructor
        pass

    def __repr__(self):
        return (("length = {} "
                 + "bits = {} "
                 + "value = {} ").format(self.length, self.bits, self.bitsValue))

    def mutate(self):
        def newFragment(fragment):
            self.bits = bitstring.BitString(int=int.from_bytes(os.urandom(self.length / 8), byteorder='big', signed=True),
                                            length=self.length)
        def mutateBitOfFragment(fragment):
            index = random.randint(0, fragment.length - 1)
            # XOR in order to invert bit
            self.bits[index] = self.bits[index] ^ 1

        # apply any mutation type
        #newFragment(self)
        mutateBitOfFragment(self)
        self.bitsValue = self.bits.int

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

    @property
    def bitsValue(self):
        return self.__bitsValue

    @bitsValue.setter
    def bitsValue(self, value):
        self.__bitsValue = value

class Solution(object):
    """ solution object """

    def __init__(self, size, fragmentLength):
        self.size = size
        self.fragments = []
        for j in range(size):
            self.fragments.append(Fragment(fragmentLength))
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

    def evaluate(self):
        for i in range(len(data)):
            ysolution = 0
            for j in range(Consts.FRAGMENT_PER_SOLUTION):
                ysolution += (self.fragments[j].bitsValue * dataMatrix[i][j])
#            print("mine : %f, real %f" % (ysolution, data[i][1]))
            # fitness with scale (slower)
#           self.fitness += math.sqrt(((data[i][1] / scale) - (ysolution / scale)) ** 2)
            # fitness without scale (faster)
#            self.fitness += math.sqrt((data[i][1] - ysolution) ** 2)
            # absolute value (even faster ?)
            self.fitness += abs(data[i][1] - ysolution)
        self.fitness /= len(data)

    def crossover(self, solution):
        def uniform(firstParent, secondParent):
            for i, fragment in enumerate(firstParent.fragments):
                if random.uniform(0, 1) > Consts.UNIFORM_CROSSOVER_PROB:
                    save = fragment
                    fragment = secondParent.fragments[i]
                    secondParent.fragments[i] = save

        # apply any crossover method
        uniform(self, solution)

    def mutate(self):
        self.fragments[random.randint(0, Consts.FRAGMENT_PER_SOLUTION - 1)].mutate()

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

    def __init__(self, maxPop, size, fragmentLength):
        self.maxPop = maxPop
        self.solutions = []
        for i in range(maxPop):
            self.solutions.append(Solution(size, fragmentLength))
        self.fitness = 0

    def __del__(self):
        # empty destructor
        pass

    def __repr__(self):
        return (("maxPop = {} "
                 + "solutions = {} "
                 + "fitness = {:.2f}").format(self.maxPop, self.solutions, float(self.fitness)))

    def evaluate(self):
#        self.threadEvaluate()
        fitnesses = 0
        for solution in self.solutions:
            solution.evaluate()
            fitnesses += solution.fitness
        self.fitness = fitnesses / len(self.solutions)

    def threadEvaluate(self):
        threads = []
        for solution in self.solutions:
            # Thread solution evaluate
            t = Thread(target=solution.evaluate, args=())
            threads.append(t)
            t.start()
        # Wait for all threads
        for thread in threads:
            thread.join()
        fitnesses = 0
        for solution in self.solutions:
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
