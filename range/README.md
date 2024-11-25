

# Output range of our Barrett multiplication in our experiement

## Requirement

- A `C` compiler.

## Range

We compute the output range after each layer of computation where the initial inputs are random elements in $[0, q)$ and $2^{23} - 2^{13} + 1$.
The current version requires some tweak on I/O to print the outputs correctly on microcontrollers.

## Compilation
Type
`make`. The following binaries will be produced:
- `test`
- `gen`


## Correctness of table generation

Type
```
./gen
```

Sample output:
```
============ gen started ============
gen finished!
```

## Experiemental range with random inputs

Type
```
./test
```

Sample output:
```
============ Table 5 numbers ============
NTT input: 8363648
After 0-th layer: 27234418
After 1-th layer: 41063339
After 2-th layer: 49941104
After 3-th layer: 61183326
After 4-th layer: 73057383
After 5-th layer: 75903955
After 6-th layer: 88663707
After 7-th layer: 93546600
Test finished!
```



