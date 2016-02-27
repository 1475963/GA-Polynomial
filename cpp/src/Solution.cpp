#include "Solution.h"

Solution::Solution(std::uint32_t pSize, std::uint32_t pLength) {

  this->size = pSize;
  this->fragments = new std::list();
  for (i = 0; i < this->size; ++i) {
    this->fragments.push_back(new Fragment(pLength));
  }
  this->fitness = 0;
}

Solution::Solution(const Solution &other) {
  if (this != &other) {
    this->size = other.size;
    this->fragments = other.fragments;
    this->fitness = other.fitness;
  }
}

Solution::~Solution() {
  // destroy
}

Solution &Solution::operator=(const Solution &other) {
  if (this != &other) {
    this->size = other.size;
    this->fragments = other.fragments;
    this->fitness = other.fitness;
  }
}

void Solution::evaluate(std::vector< std::pair<double, double> > *pData) {
  for (unsigned int i = 0; i < pData->size(); ++i) {
    
  }
  // iterate over data
  // compute y
  // assign fitness to absolute value of expectedY and computedY
  // divide fitness by data length ?
}

void Solution::uniformCrossover(Solution *pSolution) {
  std::uniform_real_distribution<double> distribution(0, FRAGMENT_PER_SOLUTION - 1);
  Fragment *tmp = null;
  for (int i = 0; i < this->fragments.size(); ++i) {
    if (distribution(generator) > UNIFORM_CROSSOVER_PROB) {
      tmp = this->fragments[i];
      this->fragments[i] = pSolution->fragments[i];
      pSolution->fragments[i] = tmp;
    }
  }
}

void Solution::crossover(Solution *pSolution) {
  // Apply any crossover method
  this->uniformCrossover(pSolution);
}

void Solution::mutate() {
  std::uniform_int_distribution<int> distribution(0, FRAGMENT_PER_SOLUTION - 1);
  this->fragments[distribution(generator)]->mutate();
}

std::uint32_t Solution::getSize() const {
  return (this->size);
}

void Solution::setSize(std::uint32_t pSize) {
  this->size = pSize;
}

std::list<Fragment *> &Solution::getFragment() const {
  return (this->fragments);
}

std::uint32_t Solution::getFitness() const {
  return (this->fitness);
}

void Solution::setFitness(std::uint32_t pFitness) {
  this->fitness = pFitness;
}