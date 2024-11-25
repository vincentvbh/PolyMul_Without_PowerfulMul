#ifndef NTT_PARAMS_H
#define NTT_PARAMS_H

#define ARRAY_N 256
#define NTT_N 128
#define LOGNTT_N 7
#define BASE_N (ARRAY_N / NTT_N)

// 2^8 + 1 = 0
#define Q (257)

// #define OMEGA (4)
// #define OMEGA_INV (-64)
// #define ZETA (2)
// #define ZETA_INV (-128)

#define OMEGA (-42)
#define OMEGA_INV (104)
#define ZETA (-27)
#define ZETA_INV (19)


// -60, -35, -42, -27

#endif

