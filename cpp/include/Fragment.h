#ifndef __FRAGMENT_H__
# define __FRAGMENT_H__

# include <string>
# include <cstdint>

class Fragment {
 private:
  std::uint32_t length;
  std::string bits;
  // internal mutation functions incoming
 public:
  /*
   * Coplien's form
   */
  Fragment(std::uint32_t);
  Fragment(const Fragment &);
  ~Fragment();
  Fragment &operator=(const Fragment &);

  /*
   * Stuff
   */
  void mutate();
  std::string repr() const;

  /*
   * Setters and getters
   */
  std::uint32_t getLength() const;
  void setLength(std::uint32_t);
  std::string getBits() const;
  void setBits(std::string);
};

#endif /* !__FRAGMENT_H__ */
