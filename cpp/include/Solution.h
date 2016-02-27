#ifndef __SOLUTION_H__
# define __SOLUTION_H__

# include <list>
# include <cstdint>
# include <random>
# include "Fragment.h"

# define FRAGMENT_PER_SOLUTION (6)
# define UNIFORM_CROSSOVER_PROB (0.5)

extern std::default_random_engine generator;

class Solution {
 private:
  std::uint32_t size;
  std::list<Fragment *> fragments;
  std::uint32_t fitness;

  void uniformCrossover(Solution *);
 public:
  /*
   * Coplien's form
   */
  Solution(std::uint32_t, std::uint32_t);
  Solution(const Solution &);
  ~Solution();
  Solution &operator=(const Solution &);
  
  /*
   * Stuff
   */
  void evaluate(std::vector< std::pair<double, double> > *);
  void crossover(Solution *);
  void mutate();
  
  /*
   * Setters and getters
   */
  std::uint32_t getSize() const;
  void setSize(std::uint32_t);
  std::list<Fragment *> &getFragments() const;
  std::uint32_t getFitness() const;
  void setFitness(std::uint32_t);
};

#endif /* !__SOLUTION_H__ */
