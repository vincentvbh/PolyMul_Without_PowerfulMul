
CC         ?= gcc

COMMON_PATH = common
CFLAGS      = -I$(COMMON_PATH)

SOURCES     = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c
SOURCES    += ring.c

all: gen

gen: gen.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

.PHONY: clean

clean:
	rm -f gen



