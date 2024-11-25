
This file documents how to reproduce the numbers in our paper.
Inside the two folders `code_kem` and `code_sign`,
the environment setup and the usage of the scripts are the same.
The only different is the target cryptographic schemes and the benchmarking policies (KEMs vs signatures).

After going to each folders `code_kem` and `code_sign`, follow the instructions below.

# Requirements

- C compiler: This is for running the examples, the version doesn't matter as the performance numbers do not rely on the C compiler targeting the host machine.
- Board `nucleo-f207zg`: The target hardware.
- `openocd`: A tool for flashing the binary files to the board. Our version:
```
Open On-Chip Debugger 0.12.0
```
- `libopencm3`: For generating and compiling various platform-related files. Commit `9545471e4861090a77f79c4458eb19ec771e23d9` of [libopencm3](https://github.com/libopencm3/libopencm3.git). See the Section below for instructions
- `python3` with `argparse`, `pyserial`, `numpy`, `filecmp` for reading from the serial port and parsing the data. We use `Python 3.13.0`.
- Cross-compiler for Armv7-M. The name of the package depends on the host machine. We use `arm-none-eabi-gcc (GNU Arm Embedded Toolchain 10.3-2021.10) 10.3.1 20210824 (release)`. You can download it from [Arm GNU Toolchain Downloads](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads).

# Before you start

## Setup `libopencm3`.
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

Find a `nucleo-f207zg` board. If you cannot find one, it is possible to test the functionality and reproduce the benchmark with a board with a Cortex-M3. See instructions at the end.

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
Plug in the device and repeat above.
The name newly appeared is the name of the serial port.

# Compilation and testing

There are two ways for compiling the source files into binary files.

## Bash and Makefile

First of all, compile `libopencm3` with
```
sh ./makelib.sh
```

Then,
one can compile with the following:
```
make all -j [jobs] PLATFORM=[board name]
```
where `[jobs]` is defaulted to the number of cores on the host machine if omitted, `[board name]` is defaulted to `nucleo-f207zg` if omitted.
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
sh ./flash_bin [elf file]
```

## Reading from serial port
Type
```
python3 ./read_serial.py --device=[device name] --baud_rate=[baud]
```
to read the output of the serial port
where `[device]` is the device name recognized by the host machine and `[baud]` is the Baud rate.
`[device name]` and `[baud]` are defaulted to system/hardware-dependent values in the file `config.py` when omitted.

## Python script

We also provide some python scripts compiling the source, flashing the `.elf` files, reading from the serial port,
and parsing the outputs.

- `--jobs`: Number of threads during the compilation of the source files under `crypto_kem` or `crypto_sign`. The default value is the number of cores. This doesn't effect the compilation of `libopencm3`.
- `--platform`: The name of the board. This is passed to `PLATFORM` and defaulted to `nucleo-f207zg` in `config.mk`.
- `--device`: The name of the serial port identified by the host machine.
- `--baud_rate`: The baud rate while reading from the serial port and defaulted to `9600` in `config.py`.
- `--clean`: Passing `--clean` to the scripts will call `make clean` prior to compiling the source. By default, `clean` is set to false and `make clean` is not called.

# Testing and benchmarking the schemes

Follow the above instructions in `code_kem` and `code_sign`

# Testing and benchmarking NTT-related functions

Follow instructions in `bench_core/m3/README.md`




