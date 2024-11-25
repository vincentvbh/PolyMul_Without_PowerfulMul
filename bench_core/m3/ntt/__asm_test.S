
#include "macros.i"
#include "mulmod.i"

.cpu cortex-m3
.syntax unified

.align 4
.global __asm_mulhi_test
__asm_mulhi_test:

    push.w {r4-r12, lr}

    ldr.w r1, [r1]
    ldr.w r2, [r2]

    mulhi r14, r1, r2, r4, r5, r6

    str.w r14, [r0]

    pop.w {r4-r12, pc}

