
# Compilation

Compile `libopencm3` with
```
bash ./makelib.sh
```
and then compile the binary files with
```
make all
```
The following files will be produced:
- `test.elf`
- `bench.elf`

# Test for correctness

Type
```
sh ./flash_bin.sh test.elf
```

Sample output:
```
============ IGNORE OUTPUT BEFORE THIS LINE ============

Test finished!
```

# Benchmark

Type
```
sh ./flash_bin.sh bench.elf
```

Sample output:
```
============ IGNORE OUTPUT BEFORE THIS LINE ============


============ Nussbaumer + TMVP-TC benchmark ============


============ Assembly benchmark ============

__asm_TMVP_mul_4x4_full cycles: 10413
__asm_TMVP_mla_4x4_full cycles: 13100
__asm_TC4_16_full cycles: 3403
__asm_TC4_T_16_full cycles: 4171
__asm_iTC4_T_7x7_full cycles: 11125
__asm_Nussbaumer_neg256_0_1_2_3_4 cycles: 4483
__asm_iNussbaumer_neg256_0_1_2_3 cycles: 4493
__asm_iNussbaumer_neg256_4_last cycles: 2220

============ Table 11 numbers ============

Hom_M cycles: 15594
Hom_V cycles: 7875
BiHom cycles: 10412
Hom_I cycles: 10830

============ Table 14 numbers ============

Dilithium 2 c t0 cycles: 87971

============ Table 19 numbers ============

lightsaber matrix-vector product: 131785
saber matrix-vector product: 261011
firesaber matrix-vector product: 431292
lightsaber inner product (Enc): 50347
saber inner product (Enc): 71540
firesaber inner product (Enc): 92720
lightsaber inner product (Dec): 81447
saber inner product (Dec): 118185
firesaber inner product (Dec): 154911
bench finished!
```


