#ifndef SAVE_UTIL_H
#define SAVE_UTIL_H

#include "common.h"

#include "save_fwd.h"

bool StringEquals(char const * str_a, char const * str_b);
void StringCopy(char * dst, char const * src);
u32 SramChecksum32(void const * sram_src, int size);
bool VerifySaveBlockChecksum(struct SaveBlockInfo const * block_info);
void PopulateSaveBlockChecksum(struct SaveBlockInfo * block_info);
char const * func_0201473C(u32 bcd_date);
void func_02014788(void);

extern bool gIsSramWorking;

#endif // SAVE_UTIL_H
