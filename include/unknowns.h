#ifndef UNKNOWNS_H
#define UNKNOWNS_H

#include "attributes.h"
#include "types.h"

void SramInit(void);
void func_common_020150C4(void);
bool func_common_0201592C(fu8 arg_0);
void func_common_02015CEC(u16 * arg_0, int arg_1);
void func_common_02016114(int arg_0);
void InitUnits(void);
void func_common_02016A74(void);
void * SramOffsetToAddr(u16 off);

#endif // UNKNOWNS_H
