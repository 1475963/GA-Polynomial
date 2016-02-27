#include "Fragment.h"

Fragment::Fragment(unsigned int pLength) {
  this->length = pLength;
  this->bits = std::string("");
}

Fragment::Fragment(const Fragment &other) {
  if (this != &other) {
    this->length = other.length;
    this->bits = other.bits;
  }
}

Fragment::~Fragment() {
  // destroy everything that have to be destroyed
}

Fragment &Fragment::operator=(const Fragment &other) {
  if (this != &other) {
    this->length = other.length;
    this->bits = other.bits;
  }
}

void Fragment::mutate() {
  // do a kind of mutation (uniform mutation first)
}

std::string Fragment::repr() const {
  // concat length, bits string and bits string value
  return (std::string("I'm a fragment"));
}

unsigned int Fragment::getLength() const {
  return (this->length);
}

void Fragment::setLength(unsigned int pLength) {
  this->length = pLength;
}

std::string Fragment::getBits() const {
  return (this->bits);
}

void Fragment::setBits(std::string pBits) {
  this->bits = pBits;
}
