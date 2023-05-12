#include "common.h"

#include "gbadma.h"
#include "gbaio.h"

#include "armfunc.h"
#include "debug_text.h"
#include "hardware.h"
#include "interrupts.h"
#include "proc.h"

#include "unknowns.h"

char const g_build_date[] = "2002/06/06(THU) 18:18:02";
char const g_build_name[] = "kaneko";

NAKEDFUNC
void Main(void)
{
    u16 keyinput;

    // this (and the naked attr) wouldn't be needed if agbcc hadn't gotten rid of the -mtpcs-frame flag
    asm("\
        sub sp, #0x10\n\
        push {r4, lr}\n\
        add r4, sp, #0x18\n\
        str r4, [sp, #0xc]\n\
        mov r4, pc\n\
        str r4, [sp, #0x14]\n\
        mov r4, fp\n\
        str r4, [sp, #8]\n\
        mov r4, lr\n\
        str r4, [sp, #0x10]\n\
        add r4, sp, #0x14\n\
        mov fp, r4\n\
        sub sp, #4\n\
    ");

    DmaFill32(3, 0, (void *)0x03000000, 0x8000);

    REG_WAITCNT = WAITCNT_SRAM_4 | WAITCNT_WS0_N_3 | WAITCNT_WS0_S_1 | WAITCNT_WS1_N_3 | WAITCNT_WS1_S_1 |
        WAITCNT_WS2_N_3 | WAITCNT_WS2_S_1 | WAITCNT_PHI_OUT_NONE | WAITCNT_PREFETCH_ENABLE;

    InitIntrs();
    SetOnVBlank(NULL);

    REG_DISPSTAT = 8;
    REG_IME = 1;

    InitKeySt(gKeySt);
    RefreshKeySt(gKeySt);

    InitRamFuncs();

    // wait for any key press before continuing
    // ... using a goto loop?
lop:
    keyinput = ~REG_KEYINPUT;

    if (keyinput == 0)
        goto lop;

    SramInit();
    InitProcs();

    SetOnVBlank(OnVBlank);
    StartMainProc();

    for (;;)
    {
        RunMainFunc();
    }
}

NAKEDFUNC
void PutBuildInfo(u16 * tm)
{
    // DebugPutStr(tm + 0x00, g_build_date);
    // DebugPutStr(tm - 0x20, g_build_name);

    // all of this (and the naked attr) wouldn't be needed if agbcc hadn't gotten rid of the -mtpcs-frame flag

    asm("\
        sub sp, #0x10\n\
        push {r4, lr}\n\
        add r4, sp, #0x18\n\
        str r4, [sp, #0xc]\n\
        mov r4, pc\n\
        str r4, [sp, #0x14]\n\
        mov r4, fp\n\
        str r4, [sp, #8]\n\
        mov r4, lr\n\
        str r4, [sp, #0x10]\n\
        add r4, sp, #0x14\n\
        mov fp, r4\n\
        add r4, r0, #0\n\
        ldr r1, =g_build_date\n\
        bl DebugPutStr\n\
        sub r4, #0x40\n\
        ldr r1, =g_build_name\n\
        add r0, r4, #0\n\
        bl DebugPutStr\n\
        pop {r4}\n\
        pop {r0, r1, r2}\n\
        mov fp, r1\n\
        mov sp, r2\n\
        bx r0\n\
        .align 2, 0\n\
        .pool\n\
    ");
}
