
# stm32f207zg
# lm3s811

DEVICES_DATA         = devices.data

CROSS_PREFIX        ?= arm-none-eabi
CPP                 := $(CROSS_PREFIX)-cpp

define gen_link
genlink_family      :=$$(shell ./genlink.py $$(DEVICES_DATA) $(1) FAMILY)
genlink_subfamily   :=$$(shell ./genlink.py $$(DEVICES_DATA) $(1) SUBFAMILY)
genlink_cpu         :=$$(shell ./genlink.py $$(DEVICES_DATA) $(1) CPU)
genlink_fpu         :=$$(shell ./genlink.py $$(DEVICES_DATA) $(1) FPU)
genlink_cppflags    :=$$(shell ./genlink.py $$(DEVICES_DATA) $(1) CPPFLAGS)

ifeq ($$(genlink_family),)
$$(warning $$(DEVICE) not found in $$(DEVICES_DATA))
endif

$(1)_ARCH_FLAGS     := -mcpu=$$(genlink_cpu)
ifeq ($$(genlink_cpu),$$(filter $$(genlink_cpu),cortex-m0 cortex-m0plus cortex-m3 cortex-m4 cortex-m7))
$(1)_ARCH_FLAGS     += -mthumb
endif

ifeq ($$(genlink_fpu),soft)
$(1)_ARCH_FLAGS     += -msoft-float
else ifeq ($$(genlink_fpu),hard-fpv4-sp-d16)
$(1)_ARCH_FLAGS     += -mfloat-abi=hard -mfpu=fpv4-sp-d16
else ifeq ($$(genlink_fpu),hard-fpv5-sp-d16)
$(1)_ARCH_FLAGS     += -mfloat-abi=hard -mfpu=fpv5-sp-d16
else
$$(warning No match for the FPU flags)
endif

obj/$(1).ld: linker.ld.S $$(DEVICES_DATA)
	@printf "  GENLNK  $(1)\n"
	mkdir -p $$(@D)
	$$(CPP) $$($(1)_ARCH_FLAGS) $$(shell ./genlink.py $$(DEVICES_DATA) $(1) DEFS) -P -E $$< -o $$@
endef

all: \
    obj/stm32f207zg.ld \
    obj/lm3s6965.ld

$(eval $(call gen_link,stm32f207zg))
$(eval $(call gen_link,lm3s6965))



.PHONY: clean

clean:
	rm -f obj/*









