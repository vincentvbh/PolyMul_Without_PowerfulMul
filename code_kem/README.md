
# Compilation

Quick start
```
make all -j12
```

Alternatively, one can compile as follows
```
make all -j [jobs] DEVICE=[device name]
```

The following binaries will be produced:
```
elf/crypto_kem_[scheme]_[testType].elf
```
where `[scheme]` is one of the following:
- `lightsaber`
- `saber`
- `firesaber`
and `[testType]` is one of the following:
- `test`
- `testvectors`
- `speed`
- `stack`
- `hashing`

# Flashing binaries

One can flash the binary file `[elf file]` as follows:

```
openocd -f nucleo-f2.cfg -c "program [elf file] reset exit"
```

Below gives all the commands relevant to this work
```
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_lightsaber_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_lightsaber_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_lightsaber_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_lightsaber_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_lightsaber_hashing reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_saber_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_saber_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_saber_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_saber_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_saber_hashing reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_firesaber_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_firesaber_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_firesaber_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_firesaber_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypto_kem_firesaber_hashing reset exit"
```

# Python script

We also program some Python scripts compiling, flashing, and parsing the outputs from the board
Type the following
```
python3 ./[script] --jobs=[number of jobs] --device=[device name] --serial_device=[serial port name] --baud_rate=[baud rate] --clean
```

where
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

Below gives all the commands relevant to this work
```
python3 ./test.py --jobs=12 --device=stm32f207zg --serial_device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./testvectors.py --jobs=12 --device=stm32f207zg --serial_device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./speed.py --jobs=12 --device=stm32f207zg --serial_device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./stack.py --jobs=12 --device=stm32f207zg --serial_device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./hashing.py --jobs=12 --device=stm32f207zg --serial_device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
```

# I don't have a board with Cortex-M3, but I have a machine with Linux, what should I do?

The idea is to cross-compile and run the binary with emulation.
- Figure out which tools are available for emulating any of `armv7-m`, `armv7-a`, or `armv7`.
- Cross-compile the program targeting any of `armv7-m`, `armv7-a`, `armv7` supported by the emulator.
- Run with the emulator.

## Requirement

Below we give an example.
- Host machine: x86.
- OS: Ubuntu.
- Emulator:
- Cross-compiler: `gcc-arm-linux-gnueabi` (`gcc-arm-linux-gnueabihf` should also work)

## Compilation

```
make all_armv7 ARMv7_CROSS_CC=[armv7 cross cc name]
```

where `[armv7 cross cc name]` is the name of the cross-compiler.

## Test for correctness

### Executing the binaries

Type
```
./obj_armv7/crypto_kem_[parameter set]_[implementation]_[test type] | grep "ERROR"
```

- `[parameter set]` is one of the following:
    - `lightsaber`
    - `saber`
    - `firesaber`
- `[implementation]` is one of the following:
    - `m3ref`
    - `m3old`
    - `m3speed`
- `[test type]` is one of the following:
    - `test`
    - `testvectors`
    - Other tests `speed`, `stack`, `hashing` can be made possible, but they are meaningless since we are emulating.

### Comparing testvectors with bash

Run
```
bash ./hosttest_cmp_testvectors.sh
```

# I don't have a board with Cortex-M3, but I have a machine with Windows/macOS, what should I do?

In theory, the above cross-compile-and-emulate should be doable while emulating a board with Cortex-M3. But we didn't succeed.
We installed `qemu` and tried below
```
qemu-system-arm -cpu cortex-m3 -machine lm3s6965evb -nographic \
                -semihosting-config enable=on,target=native \
                -kernel [elf file]
```

where `[elf file]` is compiled with the linker script `lm3s6965.ld` as follows
```
make all -j12 DEVICE=lm3s6965
```




