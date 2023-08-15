OUTPUT_ARCH(arm)
ENTRY(_start)

MEMORY
{
    LOADRAM (wx) : ORIGIN = 0x02010000, LENGTH = 0x18000
    EWRAM (w!x)  : ORIGIN = 0x02028000, LENGTH = 256K - 0x28000
    IWRAM (w!x)  : ORIGIN = 0x03000000, LENGTH = 32K
}

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
        . = ALIGN(4); src/sio.o(.text);
        . = ALIGN(4); src/report.o(.text);
        . = ALIGN(4); src/gbasvc.o(.text);
        . = ALIGN(4); src/gbasram.o(.text);
        . = ALIGN(4); *libgcc.a:_call_via_rX.o(.text);
        . = ALIGN(4); *libgcc.a:_divsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_dvmd_tls.o(.text);
        . = ALIGN(4); *libgcc.a:_modsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_udivsi3.o(.text);
        . = ALIGN(4); *libgcc.a:_umodsi3.o(.text);
        . = ALIGN(4); *libc.a:memcpy.o(.text);
        . = ALIGN(4); src/*.o(fake_glue);
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
        . = ALIGN(4); src/graphics_data.o(.rodata);
        . = ALIGN(4); src/sio.o(.rodata);
        . = ALIGN(4); src/report.o(.rodata);
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
        . = ALIGN(4); src/sio.o(.data);
        . = ALIGN(4); src/report.o(.data);
    } > LOADRAM

    .bss (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4); src/hardware.o(.bss);
        . = ALIGN(4); src/oam.o(.bss);
        . = ALIGN(4); src/game_control.o(.bss);
        . = ALIGN(4); src/sio.o(.bss);
        . = ALIGN(4); src/report.o(.bss);
        . = ALIGN(4); . = . + 0x17C; /* empty? */
        . = ALIGN(4); src/gbasram.o(.bss);
    } > IWRAM

    COMMON (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4); *(COMMON.gOamLoPutIt);
        . = ALIGN(4); . = . + 12; /* empty? */
        . = ALIGN(4); *(COMMON.gDispIo);
        . = ALIGN(4); . = . + 4; /* empty? */
        . = ALIGN(4); *(COMMON.gIrqFuncTable);
        . = ALIGN(4); *(COMMON.gOamAffinePutId);
        . = ALIGN(4); *(COMMON.PutOamHiRamFunc);
        . = ALIGN(4); *(COMMON.HBlankFuncA);
        . = ALIGN(4); *(COMMON.gOam);
        . = ALIGN(4); . = . + 0x200; /* empty? */
        . = ALIGN(4); *(COMMON.gOamHiPutIt);
        . = ALIGN(4); *(COMMON.HBlankFuncB);
        . = ALIGN(4); . = . + 8; /* empty? */
        . = ALIGN(4); *(COMMON.RamFuncArea);
        . = ALIGN(4); *(COMMON.PutOamLoRamFunc);
        . = ALIGN(4); *(COMMON.gOamAffinePutIt);
        . = ALIGN(4); . = . + 8; /* empty? */
        . = ALIGN(4); *(COMMON.IntrMainRam);
        . = ALIGN(4); *(COMMON.gSpriteAllocIt);
        . = ALIGN(4); . = . + 12; /* empty? */
        . = ALIGN(4); *(COMMON.gUnk_Sio_06_03001C30);
        . = ALIGN(4); *(COMMON.gUnk_Sio_03001C30);
        . = ALIGN(4); *(COMMON.gUnk_Sio_03001C34);
        . = ALIGN(0x10); /* align? */
        . = ALIGN(4); *(COMMON.gUnk_03001C40);
        . = ALIGN(4); *(COMMON.gUnk_Sio_06_03001CC8);
        . = ALIGN(4); *(COMMON.gSioStateId);
        . = ALIGN(0x10); /* align? */
        . = ALIGN(4); *(COMMON.gUnits);
        . = ALIGN(4); *(COMMON.gSioMsgBuf);
        . = ALIGN(4); . = . + 4; /* empty? */
        . = ALIGN(4); *(COMMON.gUnk_Sio_06_03002E58);
        . = ALIGN(0x10); /* align? */
        . = ALIGN(4); *(COMMON.gUnk_Sio_03002E50);
        . = ALIGN(4); *(COMMON.ReadSramFast);
        . = ALIGN(4); *(COMMON.VerifySramFast);
    } > IWRAM

    ewram_data (NOLOAD) : ALIGN(4)
    {
        . = ALIGN(4); src/hardware.o(ewram_data);
        . = ALIGN(4); src/async_upload.o(ewram_data);
        . = ALIGN(4); src/proc.o(ewram_data);
        . = ALIGN(4); src/debug_text.o(ewram_data);
        . = ALIGN(4); src/sprite.o(ewram_data);
        . = ALIGN(4); src/save.o(ewram_data);
        . = ALIGN(4); src/sio.o(ewram_data);
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
