
CC         ?= gcc

COMMON_PATH = common
CFLAGS      = -I$(COMMON_PATH)

SOURCE      = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

C_HEADERS   = NTT_params.h \
		      ring.h
C_SOURCES   = ring.c

HEADERS     = $(ASM_HEADERS) $(C_HEADERS)
SOURCES     = $(ASM_SOURCES) $(C_SOURCES) $(SOURCE)

all: test gen

test: test.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCES)

gen: gen.c $(HEADERS) $(SOURCES)
	$(CC) $(CFLAGS) -o $@ $< $(SOURCES)

.PHONY: clean
clean:
	rm -f test
	rm -f gen




