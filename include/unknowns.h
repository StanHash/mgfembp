#ifndef UNKNOWNS_H
#define UNKNOWNS_H

#include "attributes.h"
#include "types.h"

void SramInit(void);
void InitUnits(void);
void func_common_02016A74(void);
void * SramOffsetToAddr(u16 off);

#endif // UNKNOWNS_H
