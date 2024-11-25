
#ifndef BUTTERFLIES_I
#deifne BUTTERFLIES_I

#include "macros.i"
#include "mulmod.i"

.macro butterfly a0, a1, w, wlo, whi, q, t0, t1, t2, t3

    mulmod \a1, \w, \wlo, \whi, \q, \t0, \t1, \t2, \t3

    sub.w \a1, \a0, \t3
    add.w \a0, \a0, \t3

.endm

.macro GS_butterfly a0, a1, w, wlo, whi, q, t0, t1, t2, t3

    sub.w \t3, \a0, \a1
    add.w \a0, \a0, \a1

    mulmod \t3, \w, \wlo, \whi, \q, \t0, \t1, \t2, \a1

.endm


#endif







