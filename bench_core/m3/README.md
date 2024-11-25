
# Cortex-M3 polynomial arithmetic benchmark

This folder test and benchmark the performance of our Barrett-based NTT, FNT, and Nussbaumer+TMVP-TC-4 on Cortex-M3.
Before you start, set up `libopencm3` in the same way indicated in `cortex-m3.md` in the root of this artifact.
For testing and benchmarking, follow the instructions in the following folders:
- ntt: Constant/variable-time Barrett-based NTT/iNTT/base multiplication, and the resulting matrix-vector multiplications.
- fnt: Fermat number transform and the resulting c s_1, c s_2.
- Nussbaumer: Nussbaumer+TMVP-TC-4 over Z_{2^k} for k = 0, ..., 24 and the resulting c t_0.

