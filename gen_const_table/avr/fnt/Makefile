
CC         ?= gcc

COMMON_PATH = ./common
CFLAGS      = -I$(COMMON_PATH)

SOURCES     = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c

.PHONY: all
all: test_FNT257_modint16 test_FNT257_redint16 test_FNT257_modint32 test_FNT769_modint16 test_FNT769_montint16

test_FNT257_modint16: FNT257_modint16.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@ -DSPACE_INT16

test_FNT257_redint16: FNT257_redint16.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@ -DSPACE_INT16

test_FNT257_modint32: FNT257_modint32.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@ -DSPACE_INT32

test_FNT769_modint16: FNT769_modint16.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

test_FNT769_montint16: FNT769_montint16.c $(SOURCES)
	$(CC) $(CFLAGS) $(SOURCES) $< -o $@

.PHONY: clean

clean:
	rm -rf test*


