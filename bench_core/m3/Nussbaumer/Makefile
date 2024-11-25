LDSCRIPT   = common/nucleo-f207zg.ld
LIBNAME    = opencm3_stm32f2
ARCH_FLAGS = -mthumb -mcpu=cortex-m3
DEFINES    = -DSTM32F2 -DSTM32F207ZG
OBJS       = common/hal-opencm3.o

COMMON_PATH = common

LDFLAGS += -I$(COMMON_PATH)

COMMON_HEADER = $(COMMON_PATH)/tools.h $(COMMON_PATH)/naive_mult.h $(COMMON_PATH)/gen_table.h $(COMMON_PATH)/ntt_c.h
COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

ASM_HEADERs = macros.i
ASM_SOURCEs = __asm_Nussbaumer.S __asm_iNussbaumer.S __asm_tmvp.S __asm_TMVP_mul.S
C_HEADERs = ring.h MV.h Hom.h
C_SOURCEs = ring.c MV.c Hom.c

HEADERs = $(ASM_HEADERs) $(C_HEADERs)
SOURCEs = $(ASM_SOURCEs) $(COMMON_SOURCE) $(C_SOURCEs)


all: test.elf bench.elf

test.elf: test.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)

bench.elf: bench.o $(HEADERs) $(OBJS) $(LDSCRIPT)
	$(LD) -o $@ $< $(SOURCEs) $(OBJS) $(LDFLAGS) -l$(LIBNAME)

include common/make.mk


