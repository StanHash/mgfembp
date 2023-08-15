#ifndef REPORT_H
#define REPORT_H

#include "prelude.h"

#include "game_structs.h"
#include "proc.h"

struct ReportProc
{
    /* 00 */ PROC_HEADER;
    /* 29 */ STRUCT_PAD(0x29, 0x54);
    /* 54 */ struct GameSavePackedUnit const * unk_54;
    /* 58 */ u32 unk_58;
    /* 5C */ u32 unk_5C;
    /* 60 */ u32 unk_60;
};

struct Unit * GetUnit(int unit_id);
void ClearUnit(struct Unit * unit);
void InitUnits(void);
int GetDataSize(void const * data);
void UnpackRaw(void const * src, void * dst);
void Decompress_Unused_Unknown(void const * src, void * dst);
void Decompress(void const * src, void * dst);

void func_common_020166F8(struct ReportProc * proc);
void func_common_02016784(struct ReportProc * proc);
void func_common_02016820(void);
void func_common_02016850(struct ReportProc * proc);
void func_common_020168B4(struct ReportProc * proc);
void func_common_02016958(struct ReportProc * proc);
void func_common_02016990(void);
void func_common_020169DC(struct ReportProc * proc);
void func_common_02016A20(struct ReportProc * proc);
void func_common_02016A68(struct ReportProc * proc);
void StartFe6Report(AnyProc * parent);

#if defined(VER_FINAL)
void func_common_02016A24(struct ReportProc * proc);
#endif

extern struct Unit gUnits[62];

extern struct Unit * SHOULD_BE_CONST UnitTable[0x40];

extern struct ProcScr SHOULD_BE_CONST ProcScr_Fe6Report[];

#endif // REPORT_H
