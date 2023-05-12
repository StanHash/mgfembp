#ifndef INTERRUPTS_H
#define INTERRUPTS_H

enum
{
    // Note: those do NOT map directly to IE/IF bits, but rather to the order in which IntrMain processes them

    INT_SERIAL = 0,
    INT_VBLANK = 1,
    INT_HBLANK = 2,
    INT_VCOUNT = 3,
    // ...

    INT_COUNT = 13,
};

void InitIntrs(void);
void SetIntrFunc(int num, void (*func)(void));

#endif // INTERRUPTS_H
