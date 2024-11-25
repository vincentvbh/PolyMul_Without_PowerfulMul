
CC = gcc

COMMON_PATH = common

CFLAGS += -I$(COMMON_PATH)


COMMON_SOURCE = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

ASM_HEADERs =
ASM_SOURCEs =
C_HEADERs = NTT_params.h \
		    ring.h
C_SOURCEs = ring.c

HEADERs = $(ASM_HEADERs) $(C_HEADERs)
SOURCEs = $(ASM_SOURCEs) $(COMMON_SOURCE) $(C_SOURCEs)

all: rand_test gen

rand_test: rand_test.c $(HEADERs) $(SOURCEs)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCEs)

gen: gen.c $(HEADERs) $(SOURCEs)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCEs)

.PHONY: clean
clean:
	rm -f rand_test
	rm -f gen




