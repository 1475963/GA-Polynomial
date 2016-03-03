#!/usr/bin/python

from __future__ import print_function
import pprint as pp
import random
import sys
import os
import cProfile, pstats
from ga_entities import Fragment, Solution, Population
import consts as Consts
from start import data, dataMatrix

def getData(filename):
    dataFile = open(filename, 'r')
    """
    data = <float **> malloc(len(dataFile) * cython.sizeof(float *))
    if data is NULL:
        raise MemoryError()
    for i, line in enumerate(dataFile):
        # store 2 floats in each row
        data[i] = <float *> malloc(2 * cython.sizeof(float))
        for j, word in enumerate(line.split()):
            data[i][j] = float(word)
    """
    for line in dataFile:
        data.append(tuple(float(word) for word in line.split()))
    return data

def getDataMatrix(data):
    """
    dataMatrix = <float **> malloc(len(data) * cython.sizeof(float *))
    if dataMatrix is NULL:
        raise MemoryError()
    for i in range(len(data)):
        data[i] = <float *> malloc(Consts.FRAGMENT_PER_SOLUTION * cython.sizeof(float))
        for j in range(Consts.FRAGMENT_PER_SOLUTION):
            data[i][j] = data[i][0] ** j
    """
    for i in range(len(data)):
        dataMatrix.append([])
        for j in range(Consts.FRAGMENT_PER_SOLUTION):
            dataMatrix[i].append(data[i][0] ** j)
    return dataMatrix

def dumpHistory(history, lastPopulation):
    historyFile = open(Consts.HISTORY_FILE, 'w+')
    print("============== HISTORY OF POPULATIONS FOR {} RUNS ==============".format(Consts.TRIES), file=historyFile)
    print(history, file=historyFile)
    print("============== BEST OF LAST POPULATION DETAILS ==============", file=historyFile)
    print(lastPopulation.best().fragments, file=historyFile)
    print(lastPopulation.best().fitness, file=historyFile)

def dropGnpConf(lastPopulation):
    confFile = open(Consts.GNP_CONF_FILE, 'w+')
    bestFragments = lastPopulation.best().fragments
    print(Consts.CONF.format(Consts.DATA_FILE,
                      bestFragments[0].bitsValue,
                      bestFragments[1].bitsValue,
                      bestFragments[2].bitsValue,
                      bestFragments[3].bitsValue,
                      bestFragments[4].bitsValue,
                      bestFragments[5].bitsValue), file=confFile)

def dropImageSave():
    os.system(Consts.GNP_EXEC)

def generate(warmongers=[]):
    population = Population(Consts.MAX_POPULATION,
                            Consts.FRAGMENT_PER_SOLUTION,
                            Consts.FRAGMENT_LENGTH)
    population.solutions.extend(warmongers)
    return population

def selection(population):
    def tournament(selected):
        for j in range(Consts.SAMPLE_SIZE):
            sample = random.sample(population.solutions, Consts.SAMPLE_SIZE)
            bestFitness = float("inf")
            index = 0
            for i, solution in enumerate(sample):
                if solution.fitness < bestFitness:
                    bestFitness = solution.fitness
                    index = i
            selected.append(sample[index].copy())

    selected = []
    for i in range(int(Consts.MAX_POPULATION / Consts.SAMPLE_SIZE)):
        # any selection method
        tournament(selected)
    return selected

def crossover(population):
    for solution in population.solutions:
        if random.uniform(0, 1) <= Consts.CROSSOVER_RATE:
            solution.crossover(random.choice(population.solutions))

def mutation(population):
    for solution in population.solutions:
        if random.uniform(0, 1) <= Consts.SOLUTION_MUTATION_RATE:
            solution.mutate()

def ga_polynomial():
    print("## START")
    step = int(Consts.TRIES / 100)
    history = []
    population = generate()
    history.append(population.best())
    # static end loop with number of simulation tries
    for t in range(Consts.TRIES):
# end loop with fitness threshold
#   while (currentFitness > Consts.FITNESS_THRESHOLD):
# should try end loop with celerity change sensibility
        appliedStep = t % step
        population.evaluate()
        population.sort()
#        print(population.solutions)
        elites = population.elite()
        if appliedStep == 0:
            bestSolution = population.best()
            print("actual try: {}, actual population size: {}, actual population overall fitness: {:.2E}".format(t, len(population.solutions), population.fitness))
            print("best solution in population : {}\nfitness : {:.2E}".format(str(bestSolution.fragments), bestSolution.fitness))
        population.solutions = selection(population)[:Consts.MAX_POPULATION - Consts.ELITES_NUMBER]
        crossover(population)
        mutation(population)
        population.solutions = elites + population.solutions
        if appliedStep == 0:
            history.append(population.best())
    dumpHistory(history, population)
    dropGnpConf(population)
    dropImageSave()
    print("## END")
