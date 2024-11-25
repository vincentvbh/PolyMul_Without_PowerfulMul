
/*!
 * @details     int16_t fnt769_montgomery_mul_asm(int16_t a, int16 b) ;
 * @brief       montgomoery multiplicaiton for prime 769
 * @param[in]   signed two 16-bit integer 'a' and 'b'
 * @param[out]  return fnt769_montgomery_mul_asm(a,b)
 * @note        ..
 * @pre         ..
 */            
            NAME    fnt769_montgomery_reduce_asm      ;   module name
            PUBLIC  fnt769_montgomery_reduce_asm      ;   make the main label vissible outside this module
            RSEG    CODE                              ;   place program in 'CODE' segment


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
    

fnt769_montgomery_reduce_asm:
    ;prolog
    push    r0
    push    r1
    push    r2
    push    r10
    push    r11
    push    r12
    push    r13
    push    r14
    push    r15
    
#define zero    r2
#define tmp0    r10
#define tmp1    r11
#define tmp2    r12
#define tmp3    r13
#define hi0     r14
#define hi1     r15
#define a0      r16
#define a1      r17
#define b0      r18
#define b1      r19
#define lo0     r20
#define lo1     r21
#define cst_q   r22
#define one     r23    
    
    clr     zero
    
    ldi     cst_q,  0xFD
    mc_muls16x16_32 a0, a1, b0, b1, lo0, lo1, hi0, hi1, zero
    mulsu   cst_q,  lo0
    add     lo1,    r0
    
    ldi     cst_q,  0x03
    ldi     one,    0x01
    mc_muls16x16_32 lo0, lo1, one, cst_q, tmp0, tmp1, tmp2, tmp3, zero
    sub     hi0,    tmp2
    sbc     hi1,    tmp3
    
    
    movw    r16,    hi0
    
#undef	zero 
#undef	tmp0 
#undef	tmp1 
#undef	tmp2 
#undef	tmp3 
#undef	hi0  
#undef	hi1  
#undef	a0   
#undef	a1   
#undef	b0   
#undef	b1   
#undef	lo0  
#undef	lo1  
#undef	cst_q
#undef	one

    ;epilog
    pop    r15
    pop    r14
    pop    r13
    pop    r12
    pop    r11
    pop    r10
    pop    r2
    pop    r1
    pop    r0

    ret

    END
    

