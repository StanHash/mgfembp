OUTPUT_ARCH(arm)

MEMORY
{
    EWRAM (w!x) : ORIGIN = 0x02000000, LENGTH = 256K
    IWRAM (w!x) : ORIGIN = 0x03000000, LENGTH = 32K
}

gIrqFuncTable = 0x030003C0;

SECTIONS
{
    . = 0x02010000;
    .text : ALIGN(4)
    {
        . = ALIGN(4); src/crt0.o(.text);
        . = ALIGN(4); src/armfunc.o(.text);
        . = ALIGN(4); src/main.o(.text);
        . = ALIGN(4); asm/mgfembp_20030206.o(.text);
        . = ALIGN(4); src/main.o(.rodata);
        . = ALIGN(4); asm/mgfembp_20030206.o(.rodata);
    }

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
