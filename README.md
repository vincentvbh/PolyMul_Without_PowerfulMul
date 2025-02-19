
# About this artifact

This artifact accompanies our paper [Multiplying Polynomials without Powerful Multiplication Instructions (Long Paper)](https://eprint.iacr.org/2024/1649) accepted at [TCHES 2025, Issue 1](https://ches.iacr.org/2025/).
Our paper aims at the following lattice-based schemes
- Dilithium
- Saber

on the following platforms:
- ARM Cortex-M3
- AVR

For Dilithium, the artifact targets a certain Round 3 version.
There are several modifications after the publication of [FIPS 204](https://csrc.nist.gov/pubs/fips/204/final).
This artifact doesn't apply those changes as they were not available at the time of the submission.
We explicitly include the target Dilithium Round 3 implementation in this artifact for the functionality tests and will modify the implementations in compliance with FIPS 204 in the future.

# Introduction

We outline the following contributions of our paper:
- Dilithium:
    - Dilithium NTT/iNTT on Cortex-M3 and AVR: We generalize Barrett multiplication that is suitable for multi-limb arithmetic. The resulting modular multiplication is used in Dilithium NTT/iNTT modulo the Dilithium prime $2^{23} - 2^{13} + 1$.
    - Fermat number transform for challenge polynomial multiplication $c \boldsymbol{s}_1, c \boldsymbol{s}_2$ on Cortex-M3: We follow [AHKS22](https://link.springer.com/chapter/10.1007/978-3-031-09234-3_42) and apply Fermat number transform for `dilithium2` and `dilithium5`.
    - Nussbaumer + TMVP for challenge polynomial multiplication $c \boldsymbol{t}_0$ on Cortex-M3.
- Saber:
    - Nussbaumer + TMVP for matrix-vector multiplication and inner product on Cortex-M4.
    - Striding Toom--Cook for matrix-vector multiplication and inner product on AVR.

# Requirements

- C compiler: This is for running the examples, the version doesn't matter as the performance numbers do not rely on the C compiler targeting the host machine.

## Cortex-M3

### Reproducing benchmark


- Board `nucleo-f207zg`: The target hardware.
- `openocd`: A tool for flashing the binary files to the board. Our version:
```
Open On-Chip Debugger 0.12.0
```
- `libopencm3`: For generating and compiling various platform-related files. Commit `9545471e4861090a77f79c4458eb19ec771e23d9` of [libopencm3](https://github.com/libopencm3/libopencm3.git).
- `python3` with `argparse`, `pyserial`, `numpy`, `filecmp` for reading from the serial port and parsing the data. We use `Python 3.13.0`.
- `arm-none-eabi-gcc`. Cross-compiler We use `arm-none-eabi-gcc (GNU Arm Embedded Toolchain 10.3-2021.10) 10.3.1 20210824 (release)`. You can download it from [Arm GNU Toolchain Downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

### Testing correctness with emulation

This part varies between host machines.
- A cross-compiler targeting `armv7-m`, `armv7-a`, or `armv7`.
- A host machine with a `qemu`.

We tested with below:
- Ubuntu LTS 22.04.1, `x86_64 GNU/Linux`
- `gcc-arm-linux-gnueabi` or `gcc-arm-linux-gnueabihf`.
    - `arm-linux-gnueabi-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0`
    - `arm-linux-gnueabi-gcc-12 (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0`
    - `arm-linux-gnueabihf-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0`
- `qemu-user`. We use `1:6.2+dfsg-2ubuntu6.24`.

See `cortex-m3.md` for detailed instructions.

## AVR

- [IAR Embedded Workbench for AVR](https://www.iar.com/ko/products/architectures/microchip/iar-embedded-workbench-for-avr/) :
We developed our AVR code in IAR Embedded Workbench AVR.
  - One can get a one week trial to run the artifact at the link.
  - [IAR Embedded Workbench for AVR] is a Windows-only software (544.5MB).

See `avr.md` for detailed instructions.

# Examples of Toom--Cook, TMVP, and Nussbaumer

In the folder `examples`, we give the C programs implementing our Nussbaumer + TMVP over $Z_{1, 2, 4, ..., 2^{24}}$ used in Dilithium and Saber.
One only needs a C compiler for running the examples.
Please follow the instructions in `examples/README.md`

# Generating the tables of constants

In the folder `gen_constant_table`, we include the C programs generating the tables of constants in our Dilithium NTT/iNTT and FNT for Dilithium.
One only needs a C compiler for generating the constants.
Please follow the instructions in `gen_constant_table/README.md`

# Experimental range analysis

In the folder `range`, we include the C programs reporting the range of Dilithium NTT with random inputs as requested by reviewers. The numbers might differ for different randomness.
One only needs a C compiler for deriving the experimental range.
Please follow the instructions in `range/README.md`

# Licenses

The following files are third-party materials licensed under GPL-3.0 / LGPL-3.0
- `[every folder in this directory]/libopencm3`
- `m3_util/devices.data`
- `m3_util/genlink.py`
- `m3_util/linker.ld.S`
Other files are licensed under CC0 1.0 Universal.






