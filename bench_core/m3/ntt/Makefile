LDSCRIPT   = common/nucleo-f207zg.ld
LIBNAME    = opencm3_stm32f2
ARCH_FLAGS = -mthumb -mcpu=cortex-m3
DEFINES    = -DSTM32F2 -DSTM32F207ZG
OBJS       = common/hal-opencm3.o

COMMON_PATH = common

LDFLAGS += -I$(COMMON_PATH)

COMMON_HEADER = $(COMMON_PATH)/tools.h $(COMMON_PATH)/naive_mult.h $(COMMON_PATH)/gen_table.h $(COMMON_PATH)/ntt_c.h
COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

ASM_HEADERs = macros.i mulmod.i butterflies.i
ASM_SOURCEs = __asm_test.S __asm_ntt.S __asm_intt.S __asm_mul.S
C_HEADERs = NTT_params.h \
		    ring.h
C_SOURCEs = ring.c

HEADERs = $(ASM_HEADERs) $(C_HEADERs)
SOURCEs = $(ASM_SOURCEs) $(COMMON_SOURCE) $(C_SOURCEs)

all: test.elf bench_dilithium2.elf bench_dilithium3.elf bench_dilithium5.elf

test.elf: test.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)

bench_dilithium2.o: bench.c lib
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=2 -o $@ -c $<

bench_dilithium3.o: bench.c lib
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=3 -o $@ -c $<

bench_dilithium5.o: bench.c lib
	$(CC) $(CFLAGS) -DDILITHIUM_MODE=5 -o $@ -c $<

bench_dilithium2.elf: bench_dilithium2.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)

bench_dilithium3.elf: bench_dilithium3.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)

bench_dilithium5.elf: bench_dilithium5.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)


include common/make.mk




