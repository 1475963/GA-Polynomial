## genetic algorithm objects

import cython
from libc.stdlib cimport malloc, free
from cython.parallel import parallel, prange
import random
import math
import os
import multiprocessing
import consts as Consts
import bitstring
from start import data, dataMatrix
from cpython cimport array
import array
from functools import partial
import copy
import sys
import struct

cdef double processing(i, myData, myDataMatrix, tmpList):
    cdef double ysolution
    cdef int k
    ysolution = 0
    k = 0
    for k in range(Consts.FRAGMENT_PER_SOLUTION):
        ysolution += (tmpList[k] * myDataMatrix[i][k])
    return abs(myData[i][1] - ysolution)

cdef class Fragment(object):
    """ fragment object """
    cdef public unsigned int length
    cdef public float bitsValue
    cdef public object bits

    def __init__(self, unsigned int length=0):
        self.length = length
        if length == 0:
            self.bits = None
        else:
            self.bits = bitstring.BitString(float=struct.unpack('>f', os.urandom(int(length / 8)))[0],
                                            length=length)
            """
            self.bits = bitstring.BitString(float=random.uniform(-999999999, 999999999),
                                            length=length)
            """
            self.setBitsValue()

    def __del__(self):
        # empty destructor
        pass

    def __repr__(self):
        return (("length = {} "
                 + "bits = {} "
                 + "value = {} ").format(self.length, self.bits, self.bitsValue))

    def copy(self):
        cdef Fragment fragmentCopy
        fragmentCopy = Fragment(0)
        fragmentCopy.length = self.length
        fragmentCopy.bits = bitstring.BitString(float=self.bitsValue,
                                                length=self.length)
        fragmentCopy.bitsValue = self.bitsValue
        return fragmentCopy

    cpdef void mutateBitOfFragment(Fragment self):
        cdef index = random.randint(0, self.length - 1)
        # XOR in order to invert bit
        self.bits[index] = self.bits[index] ^ 1

    cpdef void mutate(Fragment self):
        # apply any mutation type
        self.mutateBitOfFragment()
        self.setBitsValue()

    cpdef void setBitsValue(Fragment self):
        self.bitsValue = self.bits.float

cdef class Solution(object):
    """ solution object """
    cdef public unsigned int size
    cdef public double fitness
    cdef public object fragments

    def __init__(self, unsigned int size=0, unsigned int fragmentLength=0):
        self.size = size
        if size == 0 and fragmentLength == 0:
            self.fragments = None
        else:
            self.fragments = []
            for j in range(size):
                self.fragments.append(Fragment(fragmentLength))
        self.fitness = 0

    def __del__(self):
        # empty destructor
        pass

    def __repr__(self):
        return ("fitness : {:.2E}\n".format(float(self.fitness)))
        """
        return (("size = {} "
                 + "fragments = {} "
                 + "fitness = {:.2f}").format(self.size, self.fragments, float(self.fitness)))
        """

    def copy(self):
        cdef Solution solutionCopy
        solutionCopy = Solution(0, 0)
        solutionCopy.size = self.size
        solutionCopy.fragments = []
        for fragment in self.fragments:
            solutionCopy.fragments.append(fragment.copy())
        solutionCopy.fitness = self.fitness
        return solutionCopy

    def evaluate(self):
        tmpList = []
        for j in range(Consts.FRAGMENT_PER_SOLUTION):
            tmpList.append(self.fragments[j].bitsValue)
        cdef double ysolution
        cdef double fitnesses
        cdef int k
        fitnesses = 0
        """
        cdef array.array ctmpList = array.array('i', tmpList)
        cdef int[:] ctl = ctmpList
        cdef int fragmentPerSolution
        fragmentPerSolution = Consts.FRAGMENT_PER_SOLUTION
        """
        for i in range(len(data)):
            k = 0
            ysolution = 0
            """
            with nogil:
                for k in prange(fragmentPerSolution):
                    ysolution += (ctl[k] * dataMatrix[i][k])#(tmpList[k] * dataMatrix[i][k])
            """
            for k in range(Consts.FRAGMENT_PER_SOLUTION):
                ysolution += (tmpList[k] * dataMatrix[i][k])
            fitnesses += abs(data[i][1] - ysolution)
        self.fitness = fitnesses
#        self.fitness = 1 / fitnesses

    def processEvaluate(self):
        tmpList = []
        print("hi")
        for j in range(Consts.FRAGMENT_PER_SOLUTION):
            tmpList.append(self.fragments[j].bitsValue)
        cdef double fitnesses
        fitnesses = 0
        pool = multiprocessing.Pool(processes=4)
        gateawayProcessing = partial(processing, myData=data, myDataMatrix=dataMatrix, tmpList=tmpList)
        results = pool.map(gateawayProcessing, range(len(data)), 10)
        pool.close()
        pool.join()
        for result in results:
            fitnesses += result
        self.fitness = fitnesses / len(data)

    def crossover(self, Solution solution):
        def uniform(Solution firstParent, Solution secondParent):
            index = random.randint(0, Consts.FRAGMENT_PER_SOLUTION - 1)
            for j in range(len(firstParent.fragments[index].bits)):
                if random.uniform(0, 1) > Consts.UNIFORM_CROSSOVER_PROB:
                    save = firstParent.fragments[index].bits[j]
                    firstParent.fragments[index].bits.set(secondParent.fragments[index].bits[j], j)
                    secondParent.fragments[index].bits.set(save, j)
            firstParent.fragments[index].setBitsValue()
            secondParent.fragments[index].setBitsValue()

        # apply any crossover method
        uniform(self, solution)

    cpdef mutate(Solution self):
        random.choice(self.fragments).mutate()

cdef class Population(object):
    """ population object """
    cdef public unsigned int maxPop
    cdef public double fitness
    cdef public object solutions

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
                 + "fitness = {:.2E}").format(self.maxPop, self.solutions, float(self.fitness)))

    def evaluate(self):
        """
        cdef int i
        cdef int solutionsLength
        solutionsLength = len(self.solutions)
        with nogil:
            for i in prange(solutionsLength):
                solutions[i].evaluate()
        """
        cdef fitnesses
        fitnesses = 0
        cdef int i
        for i in range(len(self.solutions)):
            self.solutions[i].evaluate()
#            self.solutions[i].processEvaluate()
            fitnesses += self.solutions[i].fitness
        self.fitness = fitnesses / len(self.solutions)

    cpdef Solution best(Population self):
        return self.solutions[0]

    def sort(self):
        self.solutions = sorted(self.solutions, key=lambda t: t.fitness)

    cpdef object elite(Population self):
        elites = []
        for solution in self.solutions[:Consts.ELITES_NUMBER]:
            elites.append(solution.copy())
        return elites
