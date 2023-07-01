OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY
{
    LOADRAM (wx) : ORIGIN = 0x02010000, LENGTH = 0x18000
    EWRAM (w!x)  : ORIGIN = 0x02028000, LENGTH = 256K - 0x28000
    IWRAM (w!x)  : ORIGIN = 0x03000000, LENGTH = 32K
}

/* COMMON */
gOamLoPutIt = 0x03000340;
gDispIo = 0x03000350;
gIrqFuncTable = 0x030003C0;
gOamAffinePutId = 0x030003F4;
PutOamHiRamFunc = 0x030003F8;
HBlankFuncA = 0x030003FC;
gOam = 0x03000400;
gOamHiPutIt = 0x03000A00;
HBlankFuncB = 0x03000A04;
RamFuncArea = 0x03000A10;
PutOamLoRamFunc = 0x03001410;
gOamAffinePutIt = 0x03001414;
IntrMainRam = 0x03001420; /* size: 0800 */
gSpriteAllocIt = 0x03001C20;
gUnits = 0x03001CE0;
ReadSramFast = 0x03002EE0;
VerifySramFast = 0x03002EE4;

SECTIONS
{
    .text : ALIGN(4)
    {
        . = ALIGN(4); src/crt0.o(.text);
        . = ALIGN(4); src/armfunc.o(.text);
        . = ALIGN(4); src/main.o(.text);
        . = ALIGN(4); src/interrupts.o(.text);
        . = ALIGN(4); src/hardware.o(.text);
        . = ALIGN(4); src/async_upload.o(.text);
        . = ALIGN(4); src/oam.o(.text);
        . = ALIGN(4); src/ramfunc.o(.text);
        . = ALIGN(4); src/proc.o(.text);
        . = ALIGN(4); src/debug_text.o(.text);
        . = ALIGN(4); src/sprite.o(.text);
        . = ALIGN(4); src/game_control.o(.text);
        . = ALIGN(4); src/save.o(.text);
        . = ALIGN(4); asm/*.o(.text);
        . = ALIGN(4); src/gbasvc.o(.text);
        . = ALIGN(4); src/gbasram.o(.text);
        . = ALIGN(4); *libgcc.a:_call_via_rX.o(.text);
        . = ALIGN(4); *libgcc.a:_divsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_dvmd_tls.o(.text);
        . = ALIGN(4); *libgcc.a:_modsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_udivsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_umodsi3.o(.text);
        . = ALIGN(4); *libc.a:memcpy.o(.text);
        . = ALIGN(4); asm/*.o(.fake_glue);
    } > LOADRAM

    .rodata : ALIGN(4)
    {
        . = ALIGN(4); src/main.o(.rodata);
        . = ALIGN(4); src/interrupts.o(.rodata);
        . = ALIGN(4); src/hardware.o(.rodata);
        . = ALIGN(4); src/async_upload.o(.rodata);
        . = ALIGN(4); src/oam.o(.rodata);
        . = ALIGN(4); src/ramfunc.o(.rodata);
        . = ALIGN(4); src/proc.o(.rodata);
        . = ALIGN(4); src/debug_text.o(.rodata);
        . = ALIGN(4); src/sprite.o(.rodata);
        . = ALIGN(4); src/game_control.o(.rodata);
        . = ALIGN(4); src/save.o(.rodata);
        . = ALIGN(4); asm/*.o(.rodata);
        . = ALIGN(4); src/gbasram.o(.rodata);
    } > LOADRAM

    .data : ALIGN(4)
    {
        . = ALIGN(4); src/hardware.o(.data);
        . = ALIGN(4); src/proc.o(.data);
        . = ALIGN(4); src/debug_text.o(.data);
        . = ALIGN(4); src/sprite.o(.data);
        . = ALIGN(4); src/game_control.o(.data);
        . = ALIGN(4); src/save.o(.data);
        . = ALIGN(4); asm/*.o(.data);
    } > LOADRAM

    .bss (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4); src/hardware.o(.bss);
        . = ALIGN(4); src/oam.o(.bss);
        . = ALIGN(4); src/game_control.o(.bss);

        . = 0x000220;
        . = ALIGN(4); src/gbasram.o(.bss);
    } > IWRAM

    .ewram_data (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4); src/hardware.o(.ewram_data);
        . = ALIGN(4); src/async_upload.o(.ewram_data);
        . = ALIGN(4); src/proc.o(.ewram_data);
        . = ALIGN(4); src/debug_text.o(.ewram_data);
        . = ALIGN(4); src/sprite.o(.ewram_data);
        . = ALIGN(4); src/save.o(.ewram_data);
    } > EWRAM

    /* DWARF 2 sections */
    .debug_aranges  0 : { *(.debug_aranges) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    .debug_info     0 : { *(.debug_info) }
    .debug_abbrev   0 : { *(.debug_abbrev) }
    .debug_line     0 : { *(.debug_line) }
    .debug_frame    0 : { *(.debug_frame) }
    .debug_str      0 : { *(.debug_str) }
    .debug_loc      0 : { *(.debug_loc) }
    .debug_macinfo  0 : { *(.debug_macinfo) }

    /* Discard everything not specifically mentioned above. */
    /DISCARD/ :
    {
        *(*);
    }
}
