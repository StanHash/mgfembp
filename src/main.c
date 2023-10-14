#include "prelude.h"

#include "gbadma.h"
#include "gbaio.h"

#include "armfunc.h"
#include "debug_text.h"
#include "game_control.h"
#include "hardware.h"
#include "interrupts.h"
#include "proc.h"
#include "save.h"

void Main(void)
{
    u16 keyinput;

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

void PutBuildInfo(u16 * tm)
{
    DebugPutStr(tm + 0x00, "2002/06/06(THU) 18:18:02");
    DebugPutStr(tm - 0x20, "kaneko");
}
