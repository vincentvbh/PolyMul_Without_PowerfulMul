
This file documents how to reproduce the numbers of the Cortex-M3 implementations in our paper.
Inside the two folders `code_kem` and `code_sign`,
the environment setup and the scripts usage are the same.
The only difference is the target cryptographic schemes and the benchmarking policies (KEMs vs signatures).

After going to each folder `code_kem` and `code_sign`, follow the instructions below.

# Requirements

- C compiler: This is for running the examples, the version doesn't matter as the performance numbers do not rely on the C compiler targeting the host machine.

## Reproducing benchmarks

- Board `nucleo-f207zg`: The target hardware.
- `openocd`: A tool for flashing the binary files to the board. Our version:
```
Open On-Chip Debugger 0.12.0
```
- `libopencm3`: For generating and compiling various platform-related files. Commit `9545471e4861090a77f79c4458eb19ec771e23d9` of [libopencm3](https://github.com/libopencm3/libopencm3.git).
- `python3` with `argparse`, `pyserial`, `numpy`, `filecmp` for reading from the serial port and parsing the data. We use `Python 3.13.0`.
- `arm-none-eabi-gcc`. Cross-compiler We use `arm-none-eabi-gcc (GNU Arm Embedded Toolchain 10.3-2021.10) 10.3.1 20210824 (release)`. You can download it from [Arm GNU Toolchain Downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

## Reproducing benchmarks on a different board with Cortex-M3

- Your favorite board.
- A toolchain flashing the binary files to your favorite borad (`openocd` might work).
- Others should be the same as above.

## Testing correctness only (without accessing to Cortex-M3)

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

# Before you start

## Setup `libopencm3`

There are two options.
- Execute `setup_libopencm3_all.sh`
- Exectue each `setup_libopencm3.sh`.

### `setup_libopencm3_all.sh`

Type
```
sh ./setup_libopencm3_all.sh
```

This executes all `sh ./setup_libopencm3.sh` cloning and checking out `libopencm3` to the target commit.

### `setup_libopencm3.sh`

- If `libopencm3` does not exist and you want to clone it, type the following:
```
sh ./setup_libopencm3.sh
```

or
```
sh ./setup_libopencm3.sh 1
```
- If `libopencm3` does not exist and you want to add it as a submodule, type the following:
```
sh ./setup_libopencm3.sh 2
```
- If `libopencm3` already exists as a repository, checkout to `9545471e4861090a77f79c4458eb19ec771e23d9` as follows:
```
sh ./setup_libopencm3.sh [x]
```

for any `[x]` that is not 1 or 2.

## Find a `nucleo-f207zg` board

Find a `nucleo-f207zg` board.

## Pick an approach flashing binaries to the board

We use [openocd](https://openocd.org/pages/about.html) with the following version:
```
Open On-Chip Debugger 0.12.0
```

For installation, follow [getting-openocd](https://openocd.org/pages/getting-openocd.html) or below.

On macOS, type
```
brew install openocd
```

On a Linux, type
```
apt-get install openocd
```

## Identify the name of the serial port

Once connected to the serial port, find its name on the host machine.
The name is platform-dependent. We illustrate below how to find it.
End the following with a tab to list all possible names:
```
ls /dev/tty.usb
```

Plug in the device and repeat the above.
The name that newly appeared is the name of the serial port.

# Compilation and testing

There are two ways to compile the source files into binary files.

## Makefile

Compile with the following:
```
make all -j [jobs] DEVICE=[device name]
```

where `[jobs]` is defaulted to the number of cores on the host machine if omitted, `[device name]` is defaulted to `stm32f207zg` if omitted.
The binary files located at each folders listed in `IMPLEMENTATION_PATH` of `./mk/schemes.mk` will be compiled into `.elf` files and put into the folder `./elf`

## Flashing binary files
This step depends on the board.
For our board `nucleo-f207zg`, we flash the `.elf` file `[elf file]` with `opencod` as follows:
```
openocd -f nucleo-f2.cfg -c "program [elf file] reset exit"
```

The above command is also supplied in the script `flash_bin.sh`.
One can alternatively flash the file `[elf file]` as follows:
```
sh ./flash_bin.sh [elf file]
```

## Reading from serial port
Type
```
python3 ./read_serial.py --serial_device=[serial port name] --baud_rate=[baud]
```

to read the output of the serial port
where `[serial port name]` is the name recognized by the host machine and `[baud]` is the Baud rate.
`[serial port name]` and `[baud]` are defaulted to system/hardware-dependent values in the file `config.py` when omitted.

## Python script

We also provide some python scripts compiling the source, flashing the `.elf` files, reading from the serial port,
and parsing the outputs.
Type the following
```
python3 ./[script] --jobs=[number of jobs] --device=[device name] --serial_device=[serial port name] --baud_rate=[baud rate] --clean
```

- `[script]` is one of the following
    - `test.py`: Test the correctness of the scheme.
    - `testvectors.py`: Generate testvectors for the implementations. Testvectors of implementations targeting the same scheme are compared if they are the same.
    - `speed.py`: Benchmark the overall cycle count of the scheme.
    - `stack.py`: Benchmark the stack usage of the scheme.
    - `hashing.py`: Benchmark the cycles spent on hashing in the scheme.
- `[jobs]`: This is the number of jobs. When omitted, it is defaulted to the number of cores on the host machine.
- `[device name]`: This is the name of the device. When omitted, it is defaulted to `stm32f207zg`.
- `[serial port name]`: This is the name of the serial port. Please check the name before running the script.
- `[baud rate]`: This is the baud rate. When omitted, it is defaulted to `9600`.
- `--clean`: This indicates if we call `make clean` prior to `make all`. When omitted, `make clean` won't be called.

# Testing and benchmarking the schemes

Follow the above instructions in `code_kem` and `code_sign`

# Testing and benchmarking NTT-related functions

Follow instructions in `bench_core/m3/README.md`

# I have a different board with Cortex-M3, what should I do?

- Generate the linker script in the folder `m3_util` at the root of this artifact.
- Compile with
```
make all DEVICE=[device name]
```

where `[device name].ld` is the target linker.

# I don't have a board with Cortex-M3, but I have a machine with Linux, what should I do?

The idea is to cross-compile and run the binary with emulation.
- Figure out which tools are available for emulating any of `armv7-m`, `armv7-a`, or `armv7`.
- Cross-compile the program targeting any of `armv7-m`, `armv7-a`, `armv7` supported by the emulator.
- Run with the emulator.

## Requirement

Below we illustrate what work on our side.
- Ubuntu LTS 22.04.1, `x86_64 GNU/Linux`
- `gcc-arm-linux-gnueabi` or `gcc-arm-linux-gnueabihf`. 
    - `arm-linux-gnueabi-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0`
    - `arm-linux-gnueabi-gcc-12 (Ubuntu 12.3.0-1ubuntu1~22.04) 12.3.0` 
    - `arm-linux-gnueabihf-gcc (Ubuntu 11.4.0-1ubuntu1~22.04) 11.4.0`
- `qemu-user`. We use `1:6.2+dfsg-2ubuntu6.24`.

## Compilation

```
make all_armv7 ARMv7_CROSS_CC=[armv7 cross cc name]
```

where `[armv7 cross cc name]` is the name of the cross-compiler.

## Test for correctness

### Executing the binaries

Type
```
./obj_armv7/crypto_[kem|sign]_[parameter set]_[implementation]_[test type] | grep "ERROR"
```

- `[parameter set]` is the parameter set of the scheme.
- `[implementation]` is the implementation of the parameter set.
- `[test type]` is one of the following:
    - `test`
    - `testvectors`
    - Other tests `speed`, `stack`, `hashing` can be made possible, but they are meaningless while emulating.

### Comparing testvectors with bash

Run
```
bash ./hosttest_cmp_testvectors.sh
```

Notice that `sh` results in a syntax error since this invokes process substitution.

# I don't have a board with Cortex-M3, but I have a machine with Windows/macOS, what should I do?

In theory, the above cross-compile-and-emulate should be doable while emulating a board with Cortex-M3. But we didn't succeed.
We installed `qemu` and tried below.
```
qemu-system-arm -cpu cortex-m3 -machine lm3s6965evb -nographic \
                -semihosting-config enable=on,target=native \
                -kernel [elf file]
```

where `[elf file]` is compiled with the linker script `lm3s6965.ld` as follows
```
make all -j12 DEVICE=lm3s6965
```





