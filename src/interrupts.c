#include "interrupts.h"

#include "gbadma.h"
#include "gbaio.h"

// crt0 IntrMain
extern void IntrMain(void);

void (*COMMON_DATA(gIrqFuncTable) gIrqFuncTable[INT_COUNT])(void) = { 0 };
u32 COMMON_DATA(IntrMainRam) IntrMainRam[0x200] = { 0 };

static void DummyIntrFunc(void);

void InitIntrs(void)
{
    int i;

    for (i = 0; i < INT_COUNT; ++i)
        gIrqFuncTable[i] = DummyIntrFunc;

    CpuFastCopy(IntrMain, IntrMainRam, sizeof IntrMainRam);
    INTR_VECTOR = IntrMainRam;
}

static void DummyIntrFunc(void)
{
}

void SetIntrFunc(int num, void (*func)(void))
{
    gIrqFuncTable[num] = func;
}
