
rmln (){
    rm -f $2
    ln -s $1 $2
}

for x in api.h __asm_intt.S __asm_ntt.S __asm_mul.S __asm_sample.S butterflies.i macros.i mulmod.i ntt.c ntt.h NTT_params.h packing.c \
                    packing.h params.h poly.c poly.h poly.S polyvec.c polyvec.h reduce.c reduce.h reduce.i rounding.c \
                    rounding.h sign.h symmetric-shake.c symmetric.h
do
rmln ../m3asm/$x $x
done

