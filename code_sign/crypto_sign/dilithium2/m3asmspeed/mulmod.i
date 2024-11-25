
#ifndef SCHOOLBOOKS_I
#define SCHOOLBOOKS_I

#include "macros.i"



// all must not be the same
.macro mulhi_split acchi, ahi, bhi, alo, blo, accmid

    mul     \acchi,    \ahi,    \bhi
    mul    \accmid,    \alo,    \bhi
    add.w   \acchi,  \acchi, \accmid, asr #16
    mul    \accmid,    \ahi,    \blo
    add.w   \acchi,  \acchi, \accmid, asr #16

.endm

.macro mulhi acchi, ahi, bhi, alo, blo, accmid

    ubfx.w \alo, \ahi, #0, #16
    ubfx.w \blo, \bhi, #0, #16
    asr.w  \ahi, \ahi, #16
    asr.w  \bhi, \bhi, #16

    mulhi_split \acchi, \ahi, \bhi, \alo, \blo, \accmid

.endm

.macro mulmod a, b, blo, bhi, q, t0, t1, t2, t3

    mul \t3, \a, \b

    ubfx.w \t0, \a, #0, #16
    asr.w \a, \a, #16

    mulhi_split \t1, \a, \bhi, \t0, \blo, \t2

    mls \t3, \t1, \q, \t3

.endm

.macro mulmod_fast c, a, b, bprime, q, lo, hi

    smull \lo, \hi, \a, \bprime
    mul \c, \a, \b
    mls \c, \hi, \q, \c

.endm

//Schoolbook multiplication (smull) -- slightly reordered to be able to use c0=a0
.macro const_smull c0, c1, a0, a1, b0, b1, tmp
    mul        \tmp,   \a1, \b0
    mla        \tmp,   \a0, \b1, \tmp
    mul         \c0,   \a0, \b0
    mul         \c1,   \a1, \b1
    adds.w      \c0,   \c0, \tmp, lsl #16
    adc.w       \c1,   \c1, \tmp, asr #16
.endm

//Schoolbook multiplication (smlal)
.macro const_smlal acc0, acc1, a0, a1, b0, b1, tmp
    mul        \tmp,   \a0, \b0
    adds.w    \acc0, \acc0, \tmp
    mul        \tmp,   \a1, \b1
    adc.w     \acc1, \acc1, \tmp
    mul        \tmp,   \a1, \b0
    mla        \tmp,   \a0, \b1, \tmp
    adds.w    \acc0, \acc0, \tmp, lsl #16
    adc.w     \acc1, \acc1, \tmp, asr #16
.endm

// pah = res is possible
.macro const_montmul res, al, ah, bl, bh, tmp0, qinv, ql, qh
    const_smull \al, \res, \al, \ah, \bl, \bh, \tmp0
    mul         \bh, \al, \qinv
    ubfx        \bl, \bh, #0, #16
    asr.w       \bh, \bh, #16
    const_smlal \al, \res, \bl, \bh, \ql, \qh, \tmp0
.endm

.macro montmul_fast res, a, b, qinv, q, t0, t1

    smull \t0, \res, \a, \b
    mul   \t1, \t0, \qinv
    smlal \t0, \res, \t1, \q

.endm


#endif

