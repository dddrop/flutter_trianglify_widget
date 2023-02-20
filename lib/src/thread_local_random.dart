class ThreadLocalRandom {
  ThreadLocalRandom([this.seed = 0x5DEECE66D]);

  int seed;

  int nextInt(int mod) {
    if (mod != 0) {
      seed = (seed * 0x5DEECE66D + 0xB) & ((1 << 48) - 1);
      return seed % mod;
    }

    return 0;
  }
}
