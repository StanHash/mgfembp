.SUFFIXES:

# ==================
# = PROJECT CONFIG =
# ==================

BUILD_NAMES := mgfembp mgfembp_20030206 mgfembp_20030219

SRC_DIR = src
ASM_DIR = asm
BUILD_DIR = build
EMBED_DIR = embed

LDS = mgfembp.lds

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

# this should be 010110-ThumbPatch
CC1 := $(AGBCC_HOME)/bin/agbcc$(EXE)

SHASUM ?= sha1sum

# ================
# = BUILD CONFIG =
# ================

CPPFLAGS := -I $(AGBCC_HOME)/include -iquote include -iquote . -nostdinc -undef
CFLAGS := -g -mthumb-interwork -Wimplicit -Wparentheses -Werror -fhex-asm -ffix-debug-line -fprologue-bugfix -O2
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
	$(SHASUM) -c mgfembp.sha1

clean:
	@echo "RM $(BINS) $(ELFS) $(MAPS) $(BUILD_DIR)/"
	@rm -f $(BINS) $(ELFS) $(MAPS)
	@rm -fr $(BUILD_DIR)/ $(EMBED_DIR)/

tools:
	$(MAKE) -C tools/embed
	$(MAKE) -C tools/gbagfx

.PHONY: compare clean tools

%.bin: %.elf
	$(OBJCOPY) --strip-debug -O binary $< $@

define rules

$1.elf: $(LDS) $$($1_OBJS)
	@echo "LD $(LDS) $$($1_OBJS:$(BUILD_DIR)/%=%)"
	@cd $(BUILD_DIR)/$1 && $(LD) -T ../../$(LDS) -Map ../../$1.map -L../../tools/agbcc/lib $$($1_OBJS:$(BUILD_DIR)/$1/%=%) -lc -lgcc -o ../../$$@

# C dependency file
$(BUILD_DIR)/$1/%.d: %.c
	@$(CPP) $$(CPPFLAGS) $$< -o $$@ -MM -MG -MT $$@ -MT $(BUILD_DIR)/$1/$$*.o

# C object
$(BUILD_DIR)/$1/%.o: %.c
	@echo "CC $$<"
	$(CPP) $$(CPPFLAGS) $$< | iconv -f UTF-8 -t CP932 | $$(CC1) $$(CFLAGS) -o $(BUILD_DIR)/$1/$$*.s
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

# embed data

$(EMBED_DIR)/%.u8: $(EMBED_DIR)/%
	@mkdir -p $(dir $@)
	tools/embed/embed u8 $< > $@

$(EMBED_DIR)/%.u16: $(EMBED_DIR)/%
	@mkdir -p $(dir $@)
	tools/embed/embed u16 $< > $@

$(EMBED_DIR)/%.u32: $(EMBED_DIR)/%
	@mkdir -p $(dir $@)
	tools/embed/embed u32 $< > $@

# copy
$(EMBED_DIR)/%: data/%
	@mkdir -p $(dir $@)
	cp $< $@

# compress
$(EMBED_DIR)/%.lz: $(EMBED_DIR)/%
	@mkdir -p $(dir $@)
	tools/gbagfx/gbagfx $< $@

# png -> 4bpp
$(EMBED_DIR)/%.4bpp: data/%.png
	@mkdir -p $(dir $@)
	tools/gbagfx/gbagfx $< $@

# png -> gbapal
$(EMBED_DIR)/%.gbapal: data/%.png
	@mkdir -p $(dir $@)
	tools/gbagfx/gbagfx $< $@

ifneq (clean,$(MAKECMDGOALS))
  -include $(ALL_DEPS)
  .PRECIOUS: $(BUILD_DIR)/%.d
endif

# ===============================
# = CFLAGS & CPPFLAGS overrides =
# ===============================

$(BUILD_DIR)/mgfembp_20030206/%.o: CPPFLAGS += -DVER_20030206
$(BUILD_DIR)/mgfembp_20030219/%.o: CPPFLAGS += -DVER_20030219
$(BUILD_DIR)/mgfembp/%.o:          CPPFLAGS += -DVER_FINAL

$(BUILD_DIR)/mgfembp_20030206/%.d: CPPFLAGS += -DVER_20030206
$(BUILD_DIR)/mgfembp_20030219/%.d: CPPFLAGS += -DVER_20030219
$(BUILD_DIR)/mgfembp/%.d:          CPPFLAGS += -DVER_FINAL

%/main.o:         CFLAGS += -mtpcs-frame

%/interrupts.o:   CFLAGS += -O0
%/hardware.o:     CFLAGS += -O0
%/async_upload.o: CFLAGS += -O0
%/oam.o:          CFLAGS += -O0
%/ramfunc.o:      CFLAGS += -O0
%/proc.o:         CFLAGS += -O0
%/debug_text.o:   CFLAGS += -O0
%/sprite.o:       CFLAGS += -O0
%/game_control.o: CFLAGS += -O0

%/gbasram.o:      CFLAGS += -O1
