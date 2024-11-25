
# Compilation

Quick start
```
sh ./makelib.sh
make all -j12
```

Alternatively, one can compile as follows
```
make all -j [jobs] PLATFORM=[board name]
```

The following binaries will be produced:
```
elf/crypto_sign_[scheme]_[testType].elf
```
where `[scheme]` is one of the following:
- `dilithium2`
- `dilithium3`
- `dilithium5`
and `[testType]` is one of the following:
- `test`
- `testvectors`
- `speed`
- `stack`
- `hashing`

# Flashing binaries

One flash the binaries as follows:

```
openocd -f nucleo-f2.cfg -c "program [elf file] reset exit"
```

Below gives all the commands relevant to this work
```
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium2_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium2_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium2_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium2_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium2_hashing reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium3_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium3_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium3_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium3_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium3_hashing reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium5_test.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium5_testvectors.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium5_speed.elf reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium5_stack reset exit"
openocd -f nucleo-f2.cfg -c "program elf/crypt_sign_dilithium5_hashing reset exit"
```

# Python script

We also program some Python scripts compiling, flashing, and parsing the outputs from the board
Type the following
```
python3 ./[script] --jobs=[number of jobs] --platform=[platform name] --device=[device name] --baud_rate=[baud rate] --clean
```
where
- `[script]` is one of the following
    - `test.py`: Test the correctness of the scheme.
    - `testvectors.py`: Generate testvectors for the implementations. Testvectors of implementations targeting the same scheme are compared if they are the same.
    - `speed.py`: Benchmark the overall cycle count of the scheme.
    - `stack.py`: Benchmark the stack usage of the scheme.
    - `hashing.py`: Benchmark the cycles spent on hashing in the scheme.
- `[jobs]`: This is the number of jobs. When omitted, it is defaulted to the number of cores on the host machine.
- `[platform name]`: This is the name of the platform. When omitted, it is defaulted to `nucleo-f207zg`.
- `[device name]`: This is the name of the serial port. Please check the name before running the script.
- `[baud rate]`: This is the baud rate. When omitted, it is defaulted to `9600`.
- `--clean`: This indicates if we call `make clean` prior to `make all`. When omitted, `make clean` won't be called.

Below gives all the commands relevant to this work
```
python3 ./test.py --jobs=12 --platform=nucleo-f207zg --device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./testvectors.py --jobs=12 --platform=nucleo-f207zg --device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./speed.py --jobs=12 --platform=nucleo-f207zg --device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./stack.py --jobs=12 --platform=nucleo-f207zg --device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
python3 ./hashing.py --jobs=12 --platform=nucleo-f207zg --device=/dev/tty.usbmodem11103 --baud_rate=9600 --clean
```


