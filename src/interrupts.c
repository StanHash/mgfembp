#include "interrupts.h"

#include "gbadma.h"
#include "gbaio.h"

// crt0 IntrMain
extern void IntrMain(void);

// TODO: make these objects
extern void (*gIrqFuncTable[INT_COUNT])(void);
extern u32 IntrMainRam[0x200];

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
