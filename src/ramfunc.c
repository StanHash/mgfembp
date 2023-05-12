#include "armfunc.h"

#include "gbadma.h"

#undef DrawGlyph
#undef DecodeString
#undef PutOamHi
#undef PutOamLo
#undef MapFloodCoreStep
#undef MapFloodCore

extern u8 COMMON_DATA(RamFuncArea) RamFuncArea[];

extern void (*COMMON_DATA(PutOamHiRamFunc) PutOamHiRamFunc)(int x, int y, u16 const * oam_list, int oam2);
extern void (*COMMON_DATA(PutOamHiRamFunc) PutOamLoRamFunc)(int x, int y, u16 const * oam_list, int oam2);

void InitRamFuncs(void)
{
    int size = ArmCodeEnd - ArmCodeStart;

    CpuCopy16(ArmCodeStart, RamFuncArea, size);

    PutOamHiRamFunc = (void *)RamFuncArea + (((u8 *)(void *)PutOamHi) - ArmCodeStart);
    PutOamLoRamFunc = (void *)RamFuncArea + (((u8 *)(void *)PutOamLo) - ArmCodeStart);
}

void DrawGlyphRam(u16 const * cvt_lut, void * chr, u32 const * glyph, int offset)
{
}

void DecodeStringRam(char const * src, char * dst)
{
}

void PutOamHiRam(int x, int y, u16 const * oam_list, int oam2)
{
    PutOamHiRamFunc(x, y, oam_list, oam2);
}

void PutOamLoRam(int x, int y, u16 const * oam_list, int oam2)
{
    PutOamLoRamFunc(x, y, oam_list, oam2);
}

void MapFloodCoreStepRam(int connect, int x, int y)
{
}

void MapFloodCoreRam(void)
{
}
