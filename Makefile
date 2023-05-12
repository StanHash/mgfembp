.SUFFIXES:

# ==================
# = PROJECT CONFIG =
# ==================

BUILD_NAMES := mgfembp mgfembp_20030206 mgfembp_20030219

SRC_DIR = src
ASM_DIR = asm
BUILD_DIR = build

# ====================
# = TOOL DEFINITIONS =
# ====================

ifeq ($(OS),Windows_NT)
  EXE := .exe
else
  EXE :=
  UNAME := $(shell uname -s)
endif

TOOLCHAIN ?= $(DEVKITARM)
AGBCC_HOME ?= tools/agbcc

ifneq (,$(TOOLCHAIN))
  export PATH := $(TOOLCHAIN)/bin:$(PATH)
endif

PREFIX := arm-none-eabi-

ifeq ($(UNAME),Darwin)
  ifneq (,$(TOOLCHAIN))
    PREFIX := $(TOOLCHAIN)/bin/$(PREFIX)
  endif
  SHASUM ?= shasum
endif

export OBJCOPY := $(PREFIX)objcopy
export AS := $(PREFIX)as
export CPP := $(PREFIX)cpp
export LD := $(PREFIX)ld
export STRIP := $(PREFIX)strip

CC1 := $(AGBCC_HOME)/bin/old_agbcc$(EXE)
CC1_NEW := $(AGBCC_HOME)/bin/agbcc$(EXE)

SHASUM ?= sha1sum

# ================
# = BUILD CONFIG =
# ================

CPPFLAGS := -I $(AGBCC_HOME)/include -iquote include -iquote . -nostdinc -undef
CFLAGS := -g -mthumb-interwork -Wimplicit -Wparentheses -Werror -fhex-asm -ffix-debug-line -O2
ASFLAGS := -mcpu=arm7tdmi -I asm/include -I include

BINS := $(BUILD_NAMES:%=%.bin)
ELFS := $(BINS:%.bin=%.elf)
MAPS := $(BINS:%.bin=%.map)

C_SRCS := $(wildcard $(SRC_DIR)/*.c)
C_OBJS := $(C_SRCS:%.c=%.o)

ASM_SRCS := $(wildcard $(SRC_DIR)/*.s) $(wildcard $(ASM_DIR)/*.s)
ASM_OBJS := $(ASM_SRCS:%.s=%.o)

BASE_OBJS := $(C_OBJS) $(ASM_OBJS)

define vars

$1_OBJS := $$(filter-out $$(filter-out asm/$1.o,$$(BUILD_NAMES:%=asm/%.o)),$$(BASE_OBJS))
$1_OBJS := $$($1_OBJS:%=$$(BUILD_DIR)/$1/%)

ALL_OBJS += $$($1_OBJS)
ALL_DEPS += $$($1_OBJS:%.o=%.d)

endef

$(foreach build, $(BUILD_NAMES), $(eval $(call vars,$(build))))

SUBDIRS := $(sort $(dir $(ALL_OBJS) $(ALL_DEPS)))
$(shell mkdir -p $(SUBDIRS))

# ===========
# = RECIPES =
# ===========

compare: $(BINS)
	$(SHASUM) -c mgfembp_all.sha1

clean:
	@echo "RM $(BINS) $(ELFS) $(MAPS) $(BUILD_DIR)/"
	@rm -f $(BINS) $(ELFS) $(MAPS)
	@rm -fr $(BUILD_DIR)/

one: mgfembp.bin
	$(SHASUM) -c mgfembp.sha1

.PHONY: compare clean one

%.bin: %.elf
	$(OBJCOPY) --strip-debug -O binary $< $@

define rules

$1.elf: $1.lds $$($1_OBJS)
	@echo "LD $1.lds $$($1_OBJS:$(BUILD_DIR)/%=%)"
	@cd $(BUILD_DIR)/$1 && $(LD) -T ../../$1.lds -Map ../../$1.map -L../../tools/agbcc/lib $$($1_OBJS:$(BUILD_DIR)/$1/%=%) -lc -lgcc -o ../../$$@

# C dependency file
$(BUILD_DIR)/$1/%.d: %.c
	@$(CPP) $$(CPPFLAGS) $$< -o $$@ -MM -MG -MT $$@ -MT $(BUILD_DIR)/$1/$$*.o

# C object
$(BUILD_DIR)/$1/%.o: %.c
	@echo "CC $$<"
	@$(CPP) $$(CPPFLAGS) $$< | iconv -f UTF-8 -t CP932 | $(CC1) $$(CFLAGS) -o $(BUILD_DIR)/$1/$$*.s
	@echo ".text\n\t.align\t2, 0\n" >> $(BUILD_DIR)/$1/$$*.s
	@$(AS) $$(ASFLAGS) $(BUILD_DIR)/$1/$$*.s -o $$@
	@$(STRIP) -N .gcc2_compiled. $$@

# ASM dependency file (dummy, generated with the object)
$(BUILD_DIR)/$1/%.d: $(BUILD_DIR)/$1/%.o
	@touch $$@

# ASM object
$(BUILD_DIR)/$1/%.o: %.s
	@echo "AS $$<"
	@$(AS) $(ASFLAGS) $$< -o $$@ --MD $(BUILD_DIR)/$1/$$*.d

endef

$(foreach build, $(BUILD_NAMES), $(eval $(call rules,$(build))))

#$(ELF): $(ALL_OBJS) $(LDS)
#	@echo "LD $(LDS) $(ALL_OBJS:$(BUILD_DIR)/%=%)"
#	@cd $(BUILD_DIR) && $(LD) -T ../$(LDS) -Map ../$(MAP) -L../tools/agbcc/lib $(ALL_OBJS:$(BUILD_DIR)/%=%) -lc -lgcc -o ../$@

# C dependency file
#$(BUILD_DIR)/%.d: %.c
#	@$(CPP) $(CPPFLAGS) $< -o $@ -MM -MG -MT $@ -MT $(BUILD_DIR)/$*.o

# C object
#$(BUILD_DIR)/%.o: %.c
#	@echo "CC $<"
#	@$(CPP) $(CPPFLAGS) $< | iconv -f UTF-8 -t CP932 | $(CC1) $(CFLAGS) -o $(BUILD_DIR)/$*.s
#	@echo ".text\n\t.align\t2, 0\n" >> $(BUILD_DIR)/$*.s
#	@$(AS) $(ASFLAGS) $(BUILD_DIR)/$*.s -o $@
#	@$(STRIP) -N .gcc2_compiled. $@

# ASM dependency file (dummy, generated with the object)
#$(BUILD_DIR)/%.d: $(BUILD_DIR)/%.o
#	@touch $@

# ASM object
#$(BUILD_DIR)/%.o: %.s
#	@echo "AS $<"
#	@$(AS) $(ASFLAGS) $< -o $@ --MD $(BUILD_DIR)/$*.d

ifneq (clean,$(MAKECMDGOALS))
  -include $(ALL_DEPS)
  .PRECIOUS: $(BUILD_DIR)/%.d
endif

# ===============================
# = CFLAGS & CPPFLAGS overrides =
# ===============================

# not yet supported by agbcc :/
# %/main.o:            CFLAGS += -mtpcs-frame

$(BUILD_DIR)/mgfembp_20030206/%.o: CPPFLAGS += -DVER_20030206
$(BUILD_DIR)/mgfembp_20030219/%.o: CPPFLAGS += -DVER_20030219
$(BUILD_DIR)/mgfembp/%.o:          CPPFLAGS += -DVER_FINAL
