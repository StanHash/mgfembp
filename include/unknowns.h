#ifndef UNKNOWNS_H
#define UNKNOWNS_H

#include "attributes.h"
#include "types.h"

void SramInit(void);
void OnVBlank(void);
void StartMainProc(void);

extern u16 SHOULD_BE_CONST Sprite_8x8[];

#endif // UNKNOWNS_H
