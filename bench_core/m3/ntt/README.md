
# Compilation

Compile `libopencm3` with
```
sh ./makelib.sh
```
and then compile the binary files with
```
make all
```
The following files will be produced:
- `test.elf`
- `bench_dilithium2.elf`
- `bench_dilithium3.elf`
- `bench_dilithium5.elf`

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
sh ./flash_bin.sh [bench file]
```
for `[bench file]` one of the following:
- `bench_dilithium2.elf`
- `bench_dilithium3.elf`
- `bench_dilithium5.elf`

## Dilithium2

Sample output of `sh ./flash bench_dilithium2.elf`:
```
============ IGNORE OUTPUT BEFORE THIS LINE ============


============ Dilithium 2 benchmark ============


============ Assembly benchmark ============

__asm_NTT cycles: 21876
__asm_point_montmul cycles: 8537
__asm_extend cycles: 10335
__asm_point_mul_pre cycles: 6742
__asm_iNTT cycles: 19782
__asm_iNTT_negacyclic (unused) cycles: 23920
__asm_NTT_fast cycles: 13935
__asm_point_montmul_fast cycles: 5462
__asm_point_mul_pre_fast cycles: 4949
__asm_iNTT_fast cycles: 14122

============ Dilithium operation benchmark ============


======== Table 9 numbers ========

Constant-time Dilithium NTT cycles: 21871
Constant-time Dilithium iNTT cycles: 26475
Variable-time Dilithium NTT cycles: 15983
Variable-time Dilithium iNTT cycles: 19024

======== Table 13 numbers ========

Dilitihum 2 matrix-vector mul cycles: 269007
Dilitihum 2 matrix-vector mul fast cycles: 195114
bench finished!
```

## Dilithium3

Sample output of `sh ./flash bench_dilithium3.elf`:
```
============ IGNORE OUTPUT BEFORE THIS LINE ============


============ Dilithium 3 benchmark ============


============ Assembly benchmark ============

__asm_NTT cycles: 20256
__asm_point_montmul cycles: 7762
__asm_extend cycles: 9816
__asm_point_mul_pre cycles: 6223
__asm_iNTT cycles: 18007
__asm_iNTT_negacyclic (unused) cycles: 21611
__asm_NTT_fast cycles: 13076
__asm_point_montmul_fast cycles: 4943
__asm_point_mul_pre_fast cycles: 4429
__asm_iNTT_fast cycles: 13327

============ Dilithium operation benchmark ============


======== Table 9 numbers ========

Constant-time Dilithium NTT cycles: 20251
Constant-time Dilithium iNTT cycles: 24185
Variable-time Dilithium NTT cycles: 15122
Variable-time Dilithium iNTT cycles: 17713

======== Table 13 numbers ========

Dilitihum 3 matrix-vector mul cycles: 381597
Dilitihum 3 matrix-vector mul fast cycles: 276752
bench finished!
```

## Dilithium5

Sample output of `sh ./flash bench_dilithium5.elf`:
```
============ IGNORE OUTPUT BEFORE THIS LINE ============


============ Dilithium 5 benchmark ============


============ Assembly benchmark ============

__asm_NTT cycles: 20256
__asm_point_montmul cycles: 7762
__asm_extend cycles: 9816
__asm_point_mul_pre cycles: 6223
__asm_iNTT cycles: 18007
__asm_iNTT_negacyclic (unused) cycles: 21611
__asm_NTT_fast cycles: 13076
__asm_point_montmul_fast cycles: 4943
__asm_point_mul_pre_fast cycles: 4429
__asm_iNTT_fast cycles: 13326

============ Dilithium operation benchmark ============


======== Table 9 numbers ========

Constant-time Dilithium NTT cycles: 20251
Constant-time Dilithium iNTT cycles: 24185
Variable-time Dilithium NTT cycles: 15122
Variable-time Dilithium iNTT cycles: 17710

======== Table 13 numbers ========

Dilitihum 5 matrix-vector mul cycles: 514539
Dilitihum 5 matrix-vector mul fast cycles: 377313
bench finished!
```

