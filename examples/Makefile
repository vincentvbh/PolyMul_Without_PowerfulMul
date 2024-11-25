
CC = gcc

CFLAGS += -march=native -O3
CFLAGS += -Wall -Wunused -Wno-format

COMMON_PATH = ../common

CFLAGS += -I$(COMMON_PATH)

COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

ASM_HEADERs =
ASM_SOURCEs =
C_HEADERs =
C_SOURCEs =

SOURCEs = $(ASM_SOURCEs) $(C_SOURCEs) $(COMMON_SOURCE)
HEADERs = $(ASM_HEADERs) $(C_HEADERs)

all: TC TC-striding TMVP Nussbaumer

TC: TC.c $(SOURCEs) $(HEADERs)
	$(CC) $(CFLAGS) $(SOURCEs) $< -o $@

TC-striding: TC-striding.c $(SOURCEs) $(HEADERs)
	$(CC) $(CFLAGS) $(SOURCEs) $< -o $@

TMVP: TMVP.c $(SOURCEs) $(HEADERs)
	$(CC) $(CFLAGS) $(SOURCEs) $< -o $@

Nussbaumer: Nussbaumer.c $(SOURCEs) $(HEADERs)
	$(CC) $(CFLAGS) $(SOURCEs) $< -o $@

.PHONY: clean
clean:
	rm -f TMVP
	rm -f Nussbaumer
	rm -f TC
	rm -f TC-striding








