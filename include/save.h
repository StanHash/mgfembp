#ifndef SAVE_H
#define SAVE_H

#include "common.h"

#include "save_data.h"
#include "save_fwd.h"

extern bool gIsSramWorking;

bool StringEquals(char const * str_a, char const * str_b);
void StringCopy(char * dst, char const * src);
u32 SramChecksum32(void const * sram_src, int size);
bool VerifySaveBlockChecksum(struct SaveBlockInfo const * block_info);
void PopulateSaveBlockChecksum(struct SaveBlockInfo * block_info);
char const * func_0201473C(u32 bcd_date);
void func_02014788(void);
void SramInit(void);
bool IsSramWorking(void);
void func_02014810(const void * src, void * dst, u32 size);
void WipeSram(void);
fu16 Checksum16(void const * data, int size);
bool ReadGlobalSaveInfo(struct GlobalSaveInfo * info);
void WriteGlobalSaveInfo(struct GlobalSaveInfo * info);
void WriteGlobalSaveInfoNoChecksum(struct GlobalSaveInfo * info);
void InitGlobalSaveInfo(void);
void * SramOffsetToAddr(fu16 off);
fu16 SramAddrToOffset(void * addr);
bool ReadSaveBlockInfo(struct SaveBlockInfo * block_info, int save_id);
void * GetSaveReadAddr(int save_id);
bool IsNotFirstPlaythrough(void);
bool func_02014AB4(void);
bool IsMultiArenaAvailable(void);
bool IsNotFirstPlaythrough_2(void);
bool CheckHasCompletedSave(void);
bool func_02014B0C(int save_id);
void ReadGameSavePlaySt(int save_id, struct PlaySt * dst);
struct GameSavePackedUnit const * ReadGameSaveUnits(int save_id);
void ReadGameSavePackedUnit(struct GameSavePackedUnit const * sram_src, struct Unit * unit);

extern char gSaveDateBuf[10];
extern bool gIsSramWorking;

extern char const gSaveDataMark[];

extern struct SramMain * SHOULD_BE_CONST gSramMain;

#endif // SAVE_H
