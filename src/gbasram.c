#include "gbasram.h"
#include "gbaio.h"

char const gSramIdentifier[] = "SRAM_F_V102";

static u16 VerifySramFastRamArea[80];
static u16 ReadSramFastRamArea[64];

extern u32 (*COMMON_DATA(VerifySramFast) VerifySramFast)(void const * src, void * dst, u32 size);
extern void (*COMMON_DATA(ReadSramFast) ReadSramFast)(void const * src, void * dst, u32 size);

void ReadSramFast_Core(u8 const * src, u8 * dst, u32 size)
{
    REG_WAITCNT = (REG_WAITCNT & ~3) | 3;

    while (--size != -1)
        *dst++ = *src++;
}

void WriteSramFast(u8 const * src, u8 * dst, u32 size)
{
    REG_WAITCNT = (REG_WAITCNT & ~3) | 3;

    while (--size != -1)
        *dst++ = *src++;
}

u32 VerifySramFast_Core(u8 const * src, u8 * dst, u32 size)
{
    REG_WAITCNT = (REG_WAITCNT & ~3) | 3;

    while (--size != -1)
    {
        if (*dst++ != *src++)
            return (u32)(dst - 1);
    }

    return 0;
}

void SetSramFastFunc(void)
{
    u16 * src;
    u16 * dst;
    fu16 size;

    src = (u16 *)ReadSramFast_Core;
    // clear the least significant bit so that we get the actual start address of the function
    src = (u16 *)((uptr)src ^ 1);
    dst = ReadSramFastRamArea;
    // get the size of the function by subtracting the address of the next function
    size = ((uptr)WriteSramFast - (uptr)ReadSramFast_Core) / 2;
    // copy the function into the WRAM buffer
    while (size != 0)
    {
        *dst++ = *src++;
        size--;
    }
    // add 1 to the address of the buffer so that we stay in THUMB mode when bx-ing to the address
    ReadSramFast = (void *)((uptr)ReadSramFastRamArea + 1);

    src = (u16 *)VerifySramFast_Core;
    // clear the least significant bit so that we get the actual start address of the function
    src = (u16 *)((uptr)src ^ 1);
    dst = VerifySramFastRamArea;
    // get the size of the function by subtracting the address of the next function
    size = ((uptr)SetSramFastFunc - (uptr)VerifySramFast_Core) / 2;
    // copy the function into the WRAM buffer
    while (size != 0)
    {
        *dst++ = *src++;
        size--;
    }
    // add 1 to the address of the buffer so that we stay in THUMB mode when bx-ing to the address
    VerifySramFast = (void *)((uptr)VerifySramFastRamArea + 1);

    REG_WAITCNT = (REG_WAITCNT & ~3) | 3;
}

u32 WriteAndVerifySramFast(void const * src, void * dst, u32 size)
{
    fu8 i;
    u32 error_addr;

#if defined(BUGFIX) && BUGFIX
    error_addr = 0;
#endif

    // try writing and verifying the data 3 times
    for (i = 0; i < 3; i++)
    {
        WriteSramFast(src, dst, size);
        error_addr = VerifySramFast(src, dst, size);
        if (error_addr == 0)
            break;
    }

    return error_addr;
}
