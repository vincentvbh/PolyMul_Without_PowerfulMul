
COMMON_PATH = common

SOURCES = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c
SOURCES += ring.c

all: gen

gen: gen.c $(SOURCES)
	gcc gen.c -o gen -I$(COMMON_PATH) $(SOURCES)

.PHONY: clean

clean:
	rm -f gen


