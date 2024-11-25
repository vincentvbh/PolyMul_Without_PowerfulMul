ifeq ($(AIO),1)
elf/boardtest.elf: common/test.c $(LINKDEPS) $(CONFIG)
	$(compiletest)

else
elf/boardtest.elf: $(call objs,common/test.c) $(LINKDEPS) $(CONFIG)

endif


tests: elf/boardtest.elf
tests-bin: bin/boardtest.bin
