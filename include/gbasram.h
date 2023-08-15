#ifndef GBASRAM_H
#define GBASRAM_H

#include "prelude.h"

void SetSramFastFunc(void);
void WriteSramFast(u8 const * src, u8 * dst, u32 size);
u32 WriteAndVerifySramFast(void const * src, void * dst, u32 size);
extern u32 (*VerifySramFast)(void const * src, void * dst, u32 size);
extern void (*ReadSramFast)(void const * src, void * dst, u32 size);

#define CART_SRAM_ADDR 0x0E000000
#define CART_SRAM_SIZE 0x00008000
#define CART_SRAM ((void *)CART_SRAM_ADDR)

#endif // GBASRAM_H
