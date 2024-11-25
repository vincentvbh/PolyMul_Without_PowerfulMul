
.macro FNT_reduce_hi a, t
    ubfx.w \t, \a, #0, #16
    add.w \a, \t, \a, asr #16
.endm

.macro FNT_reduce_lo a, t
    ubfx.w \t, \a, #0, #8
    sub.w \a, \t, \a, asr #8
.endm

.macro FNT_reduce a, t
    FNT_reduce_hi \a, \t
    FNT_reduce_lo \a, \t
.endm

.macro FNT_freeze a, qinv, q, qtop
    mul \a, \a, \qinv
    add.w \a, \qtop, \a, asr #16
    mul \a, \a, \q
    asr.w \a, \a, #16
.endm

.macro FNT_neg_freeze a, qinv, q, qtop
    mul \a, \a, \qinv
    sub.w \a, \qtop, \a, asr #16
    mul \a, \a, \q
    asr.w \a, \a, #16
.endm

.macro FNT_CT_butterfly c0, c1, logW
    add.w \c0, \c0, \c1, lsl #\logW
    sub.w \c1, \c0, \c1, lsl #(\logW+1)
.endm

.macro shift_subAdd c0, c1, shlv
    sub.w \c0, \c0, \c1, lsl #(\shlv)
    add.w \c1, \c0, \c1, lsl #(\shlv+1)
.endm

.macro FNT_CT_ibutterfly c0, c1, shlv
    shift_subAdd \c0, \c1, \shlv
.endm

