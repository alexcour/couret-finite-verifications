// Independent segmented sieve for the F-001 mod-30 empirical correction.
// Build: g++ -std=c++17 -O2 -Wall -Wextra verify_mod30_prime_proportion.cpp -o verify_mod30
// Run: ./verify_mod30 1000000000
// Counts primes p <= x in the residue classes 1, 11, 29 (mod 30),
// divided by all primes p <= x. No scientific inference is made from a finite ratio.
#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <vector>

int main(int argc, char **argv) {
  try {
    uint64_t limit = argc >= 2 ? std::stoull(argv[1]) : 1000000ULL;
    if (limit < 2 || limit > 10000000000ULL)
      throw std::invalid_argument("x must be in [2, 10000000000]");
    const uint64_t root = static_cast<uint64_t>(std::sqrt((long double)limit));
    std::vector<uint8_t> base(root + 1, 1);
    base[0] = base[1] = 0;
    for (uint64_t p = 2; p * p <= root; ++p)
      if (base[p])
        for (uint64_t j = p * p; j <= root; j += p) base[j] = 0;
    std::vector<uint32_t> small;
    for (uint64_t i = 2; i <= root; ++i)
      if (base[i]) small.push_back(static_cast<uint32_t>(i));
    const uint64_t block = 1ULL << 20;
    std::vector<uint8_t> flags(block);
    uint64_t primes = 0, in_triplet = 0, by_1 = 0, by_11 = 0, by_29 = 0;
    for (uint64_t low = 2; low <= limit; low += block) {
      const uint64_t high = std::min(low + block - 1, limit);
      std::fill(flags.begin(), flags.begin() + (high - low + 1), 1);
      for (uint32_t p : small) {
        const uint64_t pp = static_cast<uint64_t>(p) * p;
        if (pp > high) break;
        uint64_t start = std::max(pp, ((low + p - 1) / p) * static_cast<uint64_t>(p));
        for (uint64_t j = start; j <= high; j += p) flags[j - low] = 0;
      }
      for (uint64_t i = low; i <= high; ++i) {
        if (!flags[i-low]) continue;
        ++primes;
        switch (i % 30) {
          case 1: ++by_1; ++in_triplet; break;
          case 11: ++by_11; ++in_triplet; break;
          case 29: ++by_29; ++in_triplet; break;
          default: break;
        }
      }
    }
    std::cout << "x=" << limit << "\n";
    std::cout << "pi(x)=" << primes << "\n";
    std::cout << "count_mod30_1=" << by_1 << "\n";
    std::cout << "count_mod30_11=" << by_11 << "\n";
    std::cout << "count_mod30_29=" << by_29 << "\n";
    std::cout << "count_triplet=" << in_triplet << "\n";
    std::cout << std::fixed << std::setprecision(12)
              << "ratio=" << static_cast<long double>(in_triplet) / primes << "\n";
    return 0;
  } catch (const std::exception &e) {
    std::cerr << "error: " << e.what() << "\n";
    return 1;
  }
}
