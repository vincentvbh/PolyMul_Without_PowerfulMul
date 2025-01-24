
CC         ?= gcc

COMMON_PATH = ./common
CFLAGS      = -I$(COMMON_PATH)

SOURCES     = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

.PHONY: all
all: test_fnt257 test_ntt769

test_fnt257: fnt257.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@ -DSPACE_INT16

test_ntt769: ntt769.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@ -DSPACE_INT16

.PHONY: clean

clean:
	rm -rf test_*


