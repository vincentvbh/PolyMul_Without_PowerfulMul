
COMMON_PATH             = ./common

HASH_PATH               = $(COMMON_PATH)
HASH_HEADERS            = $(HASH_PATH)/fips202.h $(HASH_PATH)/keccakf1600.h
HASH_SOURCES            = $(HASH_PATH)/fips202.c $(HASH_PATH)/keccakf1600.S

RAND_PATH               = $(COMMON_PATH)
RAND_HEADERS            = $(RAND_PATH)/randombytes.h
RAND_SOURCES            = $(RAND_PATH)/randombytes.c

COMMON_HEADERS          = $(HASH_HEADERS) $(RAND_HEADERS)
COMMON_SOURCES          = $(HASH_SOURCES) $(RAND_SOURCES)
COMMON_OBJS             = $(patsubst %.c, %.o, $(COMMON_SOURCES))

# cross-compilation targeting Armv7 on linux
ARMv7_CROSS_CC         ?= arm-linux-gnueabi-gcc
ARMv7_CROSS_FLAGS       = -march=armv7 -z noexecstack -g -static
ARMv7_CROSS_CFLAGS      = $(CFLAGS) -O3 -Wall -DCROSS_ARMv7_HOSTTEST -I$(COMMON_PATH)

# cross-compilation targeting Armv7-M on linux/macOS
ARMv7-M_ARCH_FLAGS      = -mthumb -mcpu=cortex-m3
ARMv7-M_DEFINES         = -DSTM32F2 -DSTM32F207ZG

ARMv7-M_CROSS_PREFIX   ?= arm-none-eabi
ARMv7-M_CROSS_CC        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_LD        = $(ARMv7-M_CROSS_PREFIX)-gcc
ARMv7-M_CROSS_OBJCOPY   = $(ARMv7-M_CROSS_PREFIX)-objcopy
ARMv7-M_CROSS_OBJDUMP   = $(ARMv7-M_CROSS_PREFIX)-objdump
ARMv7-M_CROSS_GDB       = $(ARMv7-M_CROSS_PREFIX)-gdb

OPENCM3_DIR             = ./libopencm3
OPENCM3_OBJS            = $(COMMON_PATH)/hal-opencm3.o
OPENCM3_LIBNAME         = opencm3_stm32f2

PLATFORM               ?= nucleo-f207zg

ARMv7-M_LDSCRIPT        = $(COMMON_PATH)/$(PLATFORM).ld

ARMv7-M_CROSS_CFLAGS   += -O3 -Wall \
						  -I$(OPENCM3_DIR)/include -I$(COMMON_PATH) \
						  -fno-common $(ARMv7-M_ARCH_FLAGS) -MD $(ARMv7-M_DEFINES)

ARMv7-M_CROSS_LDFLAGS  += --static -Wl,--start-group -lc -lgcc -lnosys -Wl,--end-group \
		 				  -T$(ARMv7-M_LDSCRIPT) -nostartfiles \
		 				  $(ARMv7-M_ARCH_FLAGS) \
		 				  -L$(OPENCM3_DIR)/lib

opencm3_lib:
	@if [ ! "`ls -A $(OPENCM3_DIR)`" ] ; then \
		printf "######## ERROR ########\n"; \
		printf "\tlibopencm3 is not initialized.\n"; \
		printf "\tPlease run (in the root directory):\n"; \
		printf "\t$$ git submodule init\n"; \
		printf "\t$$ git submodule update\n"; \
		printf "\tbefore running make.\n"; \
		printf "######## ERROR ########\n"; \
		exit 1; \
		fi
	make -C $(OPENCM3_DIR)

PRIMITIVE_PREFIX     ?= crypto_kem
SOURCE_ROOT_PATH     ?= crypto_kem
TESTS_ROOT_PATH      ?= crypto_kem

ALL_ELF = \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_stack.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_hashing.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_speed.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_stack.elf

TEST_ELF = \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3ref_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3old_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_lightsaber_m3speed_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_saber_m3speed_testvectors.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_test.elf \
	elf/$(PRIMITIVE_PREFIX)_firesaber_m3speed_testvectors.elf

TEST_OBJ_ARMv7 = $(patsubst elf/%, obj_armv7/%, $(patsubst %.elf, %, $(TEST_ELF)))

.PHONY: all all_armv7 clean libclean

all: $(ALL_ELF)

all_armv7: $(TEST_OBJ_ARMv7)

include scheme.mk

# default rules

$(HASH_PATH)/fips202-profile.o: $(HASH_PATH)/fips202.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -DPROFILE_HASHING -o $@ -c $<

%.o: %.c opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

%.o: %.S opencm3_lib
	$(ARMv7-M_CROSS_CC) $(ARMv7-M_CROSS_CFLAGS) -o $@ -c $<

libclean:
	make -C $(OPENCM3_DIR) clean

clean: libclean
	find . -name '*.d' -delete
	find . -name '*.o' -delete
	rm -f elf/*
	rm -f obj/*
	rm -f obj_armv7/*



