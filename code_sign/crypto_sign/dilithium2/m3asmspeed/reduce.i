
#ifndef REDUCE_I
#define REDUCE_I

#include "reduce.i"

// specialized for Dilithium modulus 2^23 - 2^13 + 1
.macro reduce_32 a, q, t

    add.w \t, \a, #(1<<22)
    asr.w \t, \t, #23
    mls.w \a, \t, \q, \a

.endm

.macro freeze_32 a, q, qhalf t

    reduce_32 \a, \q, \t
    cmp   \a, \qhalf
    it    gt
    subgt \a, \a, \q
    cmn   \a, \qhalf
    it    lt
    addlt  \a, \a, \q

.endm

#endif

