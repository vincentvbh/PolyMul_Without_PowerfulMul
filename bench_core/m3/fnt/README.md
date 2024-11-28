
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


============ FNT benchmark ============


============ Assembly benchmark ============

__asm_FNT257 cycles: 6885
__asm_basemul257 cycles: 2509
__asm_iFNT257 cycles: 7302

============ Table 14 numbers ============

Dilithium II c s2 FNT rejection loop cycles: 41672
Dilithium II c s2 FNT rejection loop cycles: 41669
Dilithium V c s2 FNT rejection loop cycles: 72891
Dilithium V c s2 FNT rejection loop cycles: 83296
```


