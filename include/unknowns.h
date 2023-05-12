#ifndef UNKNOWNS_H
#define UNKNOWNS_H

#include "attributes.h"
#include "types.h"

struct KeySt;

void IrqInit(void);
void SetOnVBlank(void (*func)(void));
void InitKeySt(struct KeySt * key_st);
void RefreshKeySt(struct KeySt * key_st);
void InitRamFuncs(void);
void SramInit(void);
void InitProcs(void);
void OnVBlank(void);
void StartMainProc(void);
void RunMainFunc(void);

extern struct KeySt * SHOULD_BE_CONST gKeySt;

#endif // UNKNOWNS_H
