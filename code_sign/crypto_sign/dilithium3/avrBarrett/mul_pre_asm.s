/*!
 * @details     int32_t Barrett_mul_pre_asm(int32_t a, int32_t b, int32_t bp);
 * @brief       barrett-based multiplication return a X b mod^{+-} Q
 * @param[in]   signed 32-bit data : a, b q
 * @param[out]  return a X b mod^{+-} Q
 * @note        ..
 * @pre         ..
 */
            NAME    Barrett_mul_pre_asm         ;   module name
            PUBLIC  Barrett_mul_pre_asm         ;   make the main label vissible outside this module
            RSEG    CODE                        ;   place program in 'CODE' segment

//signed 16-bit X signed 16-bit mulciplication
mc_muls16x16_32    MACRO    m_a0, m_a1, m_b0, m_b1, m_c0, m_c1, m_c2, m_c3, m_zero

	muls    m_a1,   m_b1        ;   (signed)ah * (signed)
	movw	m_c2,   r0
	mul     m_a0,   m_b0        ;   al * bl
	movw	m_c0,   r0
	mulsu	m_a1,   m_b0        ;   (signed)ah * bl
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
	mulsu	m_b1,   m_a0        ;   (signed)bh * al
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero

    ENDM

//signed 16-bit X unsigned 16-bit mulciplication
mc_mulsu16x16_32    MACRO    m_a0, m_a1, m_b0, m_b1, m_c0, m_c1, m_c2, m_c3, m_zero

	mulsu   m_a1,   m_b1        ;   (signed)ah * (unsigned)bh
	movw	m_c2,   r0
	mul     m_a0,   m_b0        ;   al * bl
	movw	m_c0,   r0
	mulsu	m_a1,   m_b0        ;   (signed)ah * bl
	sbc     m_c3,   m_zero
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
	mul     m_b1,   m_a0        ;   (unsigned)bh * al
	add     m_c1,   r0
	adc     m_c2,   r1
	adc     m_c3,   m_zero
    
    ENDM
    
//signed 32-bit X 32-bit multiplication and return low 32-bit
mc_muls32x32_lo32   MACRO    m_a0, m_a1, m_a2, m_a3, m_b0, m_b1, m_b2, m_b3, m_c0, m_c1, m_c2, m_c3, m_zero

	mul     m_a0,   m_b0
    movw    m_c0,   r0    
    mul     m_a2,   m_b0
    movw    m_c2,   r0
    mul     m_a1,   m_b0
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   m_zero    
    mul     m_a0,   m_b1
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   m_zero    
    mul     m_a1,   m_b1
    add     m_c2,   r0
    adc     m_c3,   r1    
    mul     m_a0,   m_b2
    add     m_c2,   r0
    adc     m_c3,   r1    
    mulsu   m_a3,   m_b0
    add     m_c3,   r0    
    mul     m_a2,   m_b1
    add     m_c3,   r0    
    mul     m_a1,   m_b2
    add     m_c3,   r0    
    mulsu   m_b3,   m_a0
    add     m_c3,   r0
       
    ENDM

//signed 32-bit X Q multiplication and return low 32-bit
mc_muls32xq_lo32    MACRO    m_a0, m_a1, m_a2, m_a3, m_q, m_c0, m_c1, m_c2, m_c3, m_zero

	movw    m_c0,   m_a0
    movw    m_c2,   m_a2
    ldi     m_q,    0xE0
    mul     m_a0,   m_q
    add     m_c1,   r0
    adc     m_c2,   r1
    adc     m_c3,   zero
    mul     m_a2,   m_q
    add     m_c3,   r0
    mul     m_a1,   m_q
    add     m_c2,   r0
    adc     m_c3,   r1
    ldi     m_q,    0x7F
    mul     m_a0,   m_q
    add     m_c2,   r0
    adc     m_c3,   r1
    mul     m_a1,   m_q
    add     m_c3,   r0
    
    ENDM
    
#define b0      r12
#define b1      r13
#define b2      r14
#define b3      r15
#define a0      r16
#define a1      r17
#define a2      r18
#define a3      r19
#define bp0     r20
#define bp1     r21
#define bp2     r22
#define bp3     r23
#define ntt_q   r24
#define mulr0   r4
#define mulr1   r5
#define mulr2   r6
#define mulr3   r7
#define tmp0    r8
#define tmp1    r9
#define tmp2    r10
#define tmp3    r11
#define o_cnt   r2
#define i_cnt   r25
#define zero    r3
            
Barrett_mul_pre_asm:
    push    r0
    push    r1
    push    r2
    push    r3
    push    r4
    push    r5
    push    r6
    push    r7
    push    r8
    push    r9
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    push    r20
    push    r21
    push    r22
    push    r23
    push    r24
    push    r25
    push    r26
    push    r27
    push    r28
    push    r29
    push    r30
    push    r31
    
    ;   param setting
    movw    a0,     r16
    movw    a2,     r18
    movw    b0,     r20
    movw    b2,     r22
    movw    bp0,    r24
    movw    bp2,    r26
    
    //  [Barrett_asm] //////////////////////////////////////////////////////
    //  int32_t lo, hi, bp_lo, bp_hi, a_lo, a_hi;
    //  bp_lo = (int32_t)(uint16_t)bp;  bp_hi = (int32_t)(int16_t)(bp >> 16);
    //  a_lo = (int32_t)(uint16_t)a;    a_hi = (int32_t)(int16_t)(a >> 16);

    //  hi = a_hi * bp_hi;
    mc_muls16x16_32     a2, a3, bp2, bp3, mulr0, mulr1, mulr2, mulr3, zero
    
    //  hi += ((a_lo * bp_hi) >> 16);
    mc_mulsu16x16_32    bp2, bp3, a0, a1, tmp0, tmp1, tmp2, tmp3, zero
    mov     r0,     tmp3
    lsl     r0
    sbc     r0,     r0
    add     mulr0,  tmp2
    adc     mulr1,  tmp3
    adc     mulr2,  r0
    adc     mulr3,  r0

    //  hi += ((a_hi * bp_lo) >> 16);
    mc_mulsu16x16_32    a2, a3, bp0, bp1, tmp0, tmp1, tmp2, tmp3, zero
    mov     r0,     tmp3
    lsl     r0
    sbc     r0,     r0
    add     mulr0,  tmp2
    adc     mulr1,  tmp3
    adc     mulr2,  r0
    adc     mulr3,  r0
    
    //  hi * q
    ;   tmp = hi * q
    mc_muls32xq_lo32    mulr0, mulr1, mulr2, mulr3, ntt_q, tmp0, tmp1, tmp2, tmp3, zero
   
    //  lo = a * b; 
    ;   [bp <- b] [mulr <- lo = a * b]
    movw    bp0,    b0
    movw    bp2,    b2
    mc_muls32x32_lo32   a0, a1, a2, a3, bp0, bp1, bp2, bp3, mulr0, mulr1, mulr2, mulr3, zero  
    sub     mulr0,  tmp0
    sbc     mulr1,  tmp1
    sbc     mulr2,  tmp2
    sbc     mulr3,  tmp3
    
    //  return lo - hi * q;
    
    //  int32_t freeze_32_asm(int32_t a);
    ;   a = [mulr3 | mulr2 | mulr1 | mulr0] = a3 || a2 || a1 || a0
    
    //  int32_t t = (a + (1ULL << 22)) >> 23;
    ;   (a + (1ULL << 22))
    ldi     ntt_q,  0x40
    mov     bp2,    mulr2
    mov     bp3,    mulr3
    add     bp2,    ntt_q
    adc     bp3,    zero
    
    ;   (a + (1ULL << 22)) >> 23
    rol     bp2
    rol     bp3
    sbc     bp2,    bp2
    
    mov     bp0,    bp3
    mov     bp1,    bp2
    mov     bp3,    bp2
    
    //  a -= t * Q; 
    ;   tmp3 || tmp2 || tmp1 || tmp0 = t(bp) * Q
    mc_muls32xq_lo32    bp0, bp1, bp2, bp3, ntt_q, tmp0, tmp1, tmp2, tmp3, zero
    
    ;   a-= t* Q
    sub     mulr0,  tmp0
    sbc     mulr1,  tmp1
    sbc     mulr2,  tmp2
    sbc     mulr3,  tmp3
    
    //  if (a > Q / 2)     a -= Q;
    movw    bp0,    mulr0
    movw    bp2,    mulr2
    subi    bp1,    0xf0
    sbci    bp2,    0x3f
    sbci    bp3,    0x00
    lsl     bp3
    sbc     r0,     r0
    com     r0
    mov     r1,     r0
    movw    tmp0,   r0
    movw    tmp2,   r0
    ldi     ntt_q,  0x01
    and     tmp0,   ntt_q
    ldi     ntt_q,  0xE0
    and     tmp1,   ntt_q
    ldi     ntt_q,  0x7F
    and     tmp2,   ntt_q
    movw    bp0,    mulr0
    movw    bp2,    mulr2
    sub     bp0,    tmp0
    sbc     bp1,    tmp1
    sbc     bp2,    tmp2
    sbc     bp3,    zero
    
    //  if (a < -Q / 2)    a += Q;
    movw    mulr0,  bp0
    movw    mulr2,  bp2
    ldi     i_cnt,  0xF0
    ldi     ntt_q,  0x3F
    add     bp1,    i_cnt
    adc     bp2,    ntt_q
    adc     bp3,    zero
    lsl     bp3
    sbc     r0,     r0
    mov     r1,     r0
    movw    tmp0,   r0
    movw    tmp2,   r0
    ldi     ntt_q,  0x01
    and     tmp0,   ntt_q
    ldi     ntt_q,  0xE0
    and     tmp1,   ntt_q
    ldi     ntt_q,  0x7F
    and     tmp2,   ntt_q
    movw    bp0,    mulr0
    movw    bp2,    mulr2
    add     bp0,    tmp0
    adc     bp1,    tmp1
    adc     bp2,    tmp2
    adc     bp3,    zero
        
    movw    r16,    mulr0
    movw    r18,    mulr2
    
    ;epilog
    pop     r31
    pop     r30
    pop     r29
    pop     r28
    pop     r27
    pop     r26
    pop     r25
    pop     r24
    pop     r23
    pop     r22
    pop     r21
    pop     r20
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     r11
    pop     r10
    pop     r9
    pop     r8
    pop     r7
    pop     r6
    pop     r5
    pop     r4
    pop     r3
    pop     r2
    pop     r1
    pop     r0

#undef b0      
#undef b1      
#undef b2      
#undef b3      
#undef a0      
#undef a1      
#undef a2      
#undef a3      
#undef bp0     
#undef bp1     
#undef bp2     
#undef bp3     
#undef ntt_q   
#undef mulr0   
#undef mulr1   
#undef mulr2   
#undef mulr3   
#undef tmp0    
#undef tmp1    
#undef tmp2    
#undef tmp3    
#undef o_cnt   
#undef i_cnt   
#undef zero    
    ret

    END
    

