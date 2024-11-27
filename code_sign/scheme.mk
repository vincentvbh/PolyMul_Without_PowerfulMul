
define schemelib_armv7-m
$(1)_$(2)_PATH        = $$(SOURCE_ROOT_PATH)/$(3)/$(4)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S)
$(1)_$(2)_OBJS        = $$(patsubst %.c, %.o, $$($(1)_$(2)_SOURCES))
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH) $(5)

obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_test.o: $$(TESTS_ROOT_PATH)/test.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_test.elf: obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_test.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_testvectors.o: $$(TESTS_ROOT_PATH)/testvectors.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_testvectors.elf: obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_testvectors.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_hashing.o: $$(TESTS_ROOT_PATH)/hashing.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_hashing.elf: obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_hashing.o $$(filter-out $$(HASH_PATH)/fips202.o, $$(COMMON_OBJS)) $$(HASH_PATH)/fips202-profile.o $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(filter-out $$(HASH_PATH)/fips202.o, $$(COMMON_OBJS)) $$(HASH_PATH)/fips202-profile.o $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_speed.o: $$(TESTS_ROOT_PATH)/speed.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_speed.elf: obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_speed.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)

obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_stack.o: $$(TESTS_ROOT_PATH)/stack.c opencm3_lib
	$$(ARMv7-M_CROSS_CC) $$($(1)_$(2)_CFLAGS) $$(ARMv7-M_CROSS_CFLAGS) -o $$@ -c $$<

elf/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_stack.elf: obj/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_stack.o $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_OBJS) $$(ARMv7-M_CROSS_LDSCRIPT)
	$$(ARMv7-M_CROSS_LD) $$(COMMON_OBJS) $$(OPENCM3_OBJS) $$($(1)_$(2)_OBJS) $$< -o $$@ $$(ARMv7-M_CROSS_LDFLAGS) -l$$(OPENCM3_LIBNAME)
endef

define schemelib_armv7
$(1)_$(2)_PATH        = $$(SOURCE_ROOT_PATH)/$(3)/$(4)
$(1)_$(2)_HEADERS     = $$(wildcard $$($(1)_$(2)_PATH)/*.h) $$(wildcard $$($(1)_$(2)_PATH)/*.i)
$(1)_$(2)_SOURCES     = $$(wildcard $$($(1)_$(2)_PATH)/*.c) $$(wildcard $$($(1)_$(2)_PATH)/*.s) $$(wildcard $$($(1)_$(2)_PATH)/*.S)
$(1)_$(2)_CFLAGS      = -I$$($(1)_$(2)_PATH) $(5)

obj_armv7/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_test: $$(TESTS_ROOT_PATH)/test.c $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	$$(ARMv7_CROSS_CC) $$(ARMv7_CROSS_FLAGS) $$(ARMv7_CROSS_CFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(COMMON_PATH)/hal-opencm3.c $$($(1)_$(2)_SOURCES) $$< -o $$@

obj_armv7/$$(PRIMITIVE_PREFIX)_$(1)_$(2)_testvectors: $$(TESTS_ROOT_PATH)/testvectors.c $$($(1)_$(2)_HEADERS) $$($(1)_$(2)_SOURCES)
	$$(ARMv7_CROSS_CC) $$(ARMv7_CROSS_FLAGS) $$(ARMv7_CROSS_CFLAGS) $$($(1)_$(2)_CFLAGS) $$(COMMON_SOURCES) $$(COMMON_PATH)/hal-opencm3.c $$($(1)_$(2)_SOURCES) $$< -o $$@
endef

$(eval $(call schemelib_armv7-m,dilithium2,m3ref,dilithium2,m3ref,))
$(eval $(call schemelib_armv7-m,dilithium3,m3ref,dilithium3,m3ref,))

$(eval $(call schemelib_armv7-m,dilithium2,m3plant,dilithium2,m3plant,))
$(eval $(call schemelib_armv7-m,dilithium3,m3plant,dilithium3,m3plant,))
$(eval $(call schemelib_armv7-m,dilithium5,m3plant,dilithium5,m3plant,))

$(eval $(call schemelib_armv7-m,dilithium2,m3asmspeed,dilithium2,m3asmspeed,))
$(eval $(call schemelib_armv7-m,dilithium3,m3asmspeed,dilithium3,m3asmspeed,))
$(eval $(call schemelib_armv7-m,dilithium5,m3asmspeed,dilithium5,m3asmspeed,))


$(eval $(call schemelib_armv7,dilithium2,m3ref,dilithium2,m3ref,))
$(eval $(call schemelib_armv7,dilithium3,m3ref,dilithium3,m3ref,))

$(eval $(call schemelib_armv7,dilithium2,m3plant,dilithium2,m3plant,))
$(eval $(call schemelib_armv7,dilithium3,m3plant,dilithium3,m3plant,))
$(eval $(call schemelib_armv7,dilithium5,m3plant,dilithium5,m3plant,))

$(eval $(call schemelib_armv7,dilithium2,m3asmspeed,dilithium2,m3asmspeed,))
$(eval $(call schemelib_armv7,dilithium3,m3asmspeed,dilithium3,m3asmspeed,))
$(eval $(call schemelib_armv7,dilithium5,m3asmspeed,dilithium5,m3asmspeed,))




