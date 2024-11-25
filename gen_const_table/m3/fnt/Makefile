
COMMON_PATH = common

SOURCES = $(COMMON_PATH)/tools.c $(COMMON_PATH)/naive_mult.c $(COMMON_PATH)/gen_table.c $(COMMON_PATH)/ntt_c.c
SOURCES += ring.c

all: gen_fnt

gen_fnt: gen_fnt.c $(SOURCES)
	gcc gen_fnt.c -o gen_fnt -I$(COMMON_PATH) $(SOURCES)

.PHONY: clean

clean:
	rm -f gen_fnt



