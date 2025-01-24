
This folder demonstrates the generation of tables of constants involved in our implementation.

In each of the following folders:
- `m3/ntt_barrett`
- `m3/fnt`
- `avr/ntt_barrett`
- `avr/fnt`

typing
`make` will produce the binary `gen`
Typing `./gen` to generate tables of constants and compare them to the ones used in our implementations.
(`avr/fnt` provides `test_fnt257`, `test_fnt769` binary instead of `gen`. )

# Scripts

We also provide scripts compiling, generating the twiddle factors, testing if the twiddle factors implement the NTTs, and removing executable files.

- `bash make_all.sh`: This executes `make all` whenever a `Makefile` is found under this folder. Make sure to run this before others.
- `bash gen_all.sh`: This executes all the binary files named `gen` under this folder, generates the twiddle factors, and tests if the resulting tables are the ones used in our implementations.
- `bash test_all.sh`: This executes the tests testing if the the twiddle factors are compatible with the NTTs.
- `bash clean_all.sh`: This executes `make clean` whenever a `Makefile` is found under this folder.


