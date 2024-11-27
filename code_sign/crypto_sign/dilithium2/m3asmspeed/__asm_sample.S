
#include "params.h"


.syntax unified

// asm_rej_uniform(int32_t *a,unsigned int len,const unsigned char *buf, unsigned int buflen);
.align 4
.global __asm_rej_uniform
.type __asm_rej_uniform, %function
__asm_rej_uniform:
    push.w {r4-r6}
    push.w {r1}
    // Store Q-1 in r12.
    movw r12, #:lower16:Q
    movt r12, #:upper16:Q

    add.w r6, r0, r1, lsl #2
    add.w r3, r2, r3
    sub.w r3, r3, #2

    _rej_uniform_loop:
    // If there are less than 3 bytes available, return.
    cmp.w r3, r2
    ble.w end

    ldr r5, [r2], #3
    ubfx r5, r5, #0, #23

    cmp.n r5, r12
    it le
    strle r5, [r0], #4

    cmp.n r0, r6
    bne.n _rej_uniform_loop

end:
    pop.w {r5}

    sub.w r0, r6, r0
    sub.w r0, r5, r0, lsr #2
    pop.w {r4-r6}
    bx lr

