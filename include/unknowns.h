#ifndef UNKNOWNS_H
#define UNKNOWNS_H

#include "attributes.h"
#include "types.h"

void Decompress(void const * src, void * dst);
void SramInit(void);
void func_common_020150C4(void);
bool func_common_0201592C(fu8 arg_0);
void func_common_02015CEC(u16 * arg_0, int arg_1);
void func_common_02016114(int arg_0);
bool func_common_0201596C(void);
void * func_common_02015E28(u32 * out);
fi16 func_common_02015A3C(void * arg_0, fu16 arg_1);
void InitUnits(void);
void func_common_02016A74(void);
void * SramOffsetToAddr(u16 off);
fi16 func_common_02015B34(fi8 arg_0, u16 * arg_1);
void func_common_02015DB4(void * arg_0);

#if defined(VER_20030206)
int func_06_02016424(int arg_0);
#endif

extern u16 const Pal_Unk_02017C74[]; // pal
extern u8 const Img_Unk_02017374[];  // lz
extern u8 const Tm_Unk_02017AA8[];   // lz

#endif // UNKNOWNS_H
