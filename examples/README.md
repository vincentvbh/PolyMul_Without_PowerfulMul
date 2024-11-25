
# Examples

This folder contains C programs for referential purposes.
We initially implemented the ideas straight in assembly, and later developed C programs in this folder for future extensions.

- `TC.c`: Toom-4. The approach is used for deriving other approaches like `TC-striding.c` and `TMVP.c`.
- `TC-striding.c`: Striding Toom-4. The approach is involved in the memory optimization layout but not used in the final implementations.
- `TMVP.c`: Toeplitz matrix-vector product based on Toom-4. The approach is used in `Nussbaumer.c`.
- `Nussbaumer.c`: Nussbaumer and Toeplitz matrix-vector product based on Toom-4 over $Z_{1, 2, 4, ..., 2^{24}}$. This is the transformation we eventually implemented in assembly. For the ease of development, there are two versions distinguished by if `INPLACE` is defined or not. If `INPLACE` is defined, the function calls allow overlapped source and destination at the cost of internal memory copying. In the assembly, the memory layout is closer to the case when `INPLACE` is undefined. There are also other memory optimizations that exist only in assembly, but those are heavily platform dependent and we didn't translate them into C.

# Compilation

Type
```
make
```
The following binaries will be produced.
- `Nussbaumer`
- `TC`
- `TC-striding`
- `TMVP`

After executing them,
the following will be shown on success.
```
Test finished!
```
