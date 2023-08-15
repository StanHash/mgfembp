#include "report.h"

#include "game_structs.h"
#include "graphics_data.h"
#include "hardware.h"
#include "proc.h"
#include "save.h"
#include "sio.h"

#if defined(VER_20030206)
#include "debug_text.h"
#endif

#include "gbadma.h"

// COMMON
extern struct SioMessage gUnk_03001C40;
extern struct Unit gUnits[62];

static u8 s_unk_03000060[4];

struct PlayReport
{
    /* 00 */ u8 unk_00;
    /* 01 */ u8 complete[3];
    /* 04 */ u8 complete_count;
    /* 05 */ u8 chapter[3];
    /* 08 */ STRUCT_PAD(0x08, 0x09);
    /* 09 */ u8 hard_mode[3];
    /* 0C */ u32 time_played[3];
};

static struct PlayReport s_play_report;

struct PidReport
{
    u8 unk_00, unk_01;
    u32 flags[0x100 / 32];
};

static struct PidReport s_unk_03000080;

#define ROM_LOGO_FIXED (*(u8 const *)0x080000B2)
#define ROM_LOGO_FIXED_VALUE 0x96

#define ROM_GAMECODE (*(u32 const *)0x080000AC)
#define ROM_GAMECODE_FE6 0x4A454641u // 'AFEJ'

struct Unit * SHOULD_BE_CONST UnitTable[0x40] = {
    [0x00] = NULL,        [0x01] = gUnits + 0,  [0x02] = gUnits + 1,  [0x03] = gUnits + 2,  [0x04] = gUnits + 3,
    [0x05] = gUnits + 4,  [0x06] = gUnits + 5,  [0x07] = gUnits + 6,  [0x08] = gUnits + 7,  [0x09] = gUnits + 8,
    [0x0A] = gUnits + 9,  [0x0B] = gUnits + 10, [0x0C] = gUnits + 11, [0x0D] = gUnits + 12, [0x0E] = gUnits + 13,
    [0x0F] = gUnits + 14, [0x10] = gUnits + 15, [0x11] = gUnits + 16, [0x12] = gUnits + 17, [0x13] = gUnits + 18,
    [0x14] = gUnits + 19, [0x15] = gUnits + 20, [0x16] = gUnits + 21, [0x17] = gUnits + 22, [0x18] = gUnits + 23,
    [0x19] = gUnits + 24, [0x1A] = gUnits + 25, [0x1B] = gUnits + 26, [0x1C] = gUnits + 27, [0x1D] = gUnits + 28,
    [0x1E] = gUnits + 29, [0x1F] = gUnits + 30, [0x20] = gUnits + 31, [0x21] = gUnits + 32, [0x22] = gUnits + 33,
    [0x23] = gUnits + 34, [0x24] = gUnits + 35, [0x25] = gUnits + 36, [0x26] = gUnits + 37, [0x27] = gUnits + 38,
    [0x28] = gUnits + 39, [0x29] = gUnits + 40, [0x2A] = gUnits + 41, [0x2B] = gUnits + 42, [0x2C] = gUnits + 43,
    [0x2D] = gUnits + 44, [0x2E] = gUnits + 45, [0x2F] = gUnits + 46, [0x30] = gUnits + 47, [0x31] = gUnits + 48,
    [0x32] = gUnits + 49, [0x33] = gUnits + 50, [0x34] = gUnits + 51, [0x35] = gUnits + 52, [0x36] = gUnits + 53,
    [0x37] = gUnits + 54, [0x38] = gUnits + 55, [0x39] = gUnits + 56, [0x3A] = gUnits + 57, [0x3B] = gUnits + 58,
    [0x3C] = gUnits + 59, [0x3D] = gUnits + 60, [0x3E] = gUnits + 61,
};

inline struct Unit * GetUnit(int unit_id)
{
    return UnitTable[unit_id & 0xFF];
}

void ClearUnit(struct Unit * unit)
{
    fu8 id = unit->id;

    CpuFill16(0, unit, sizeof(struct Unit));

    unit->id = id;
}

void InitUnits(void)
{
    int i;

    for (i = 0; i < 0x3E; i++)
    {
        struct Unit * unit = GetUnit(i);

        if (!unit)
            continue;

        ClearUnit(unit);
        unit->id = i;
    }
}

int GetDataSize(void const * data)
{
    return *((u32 const *)data) >> 8;
}

void UnpackRaw(void const * src, void * dst)
{
    int size = GetDataSize(src) - 4;

    if (size % 0x20 != 0)
        CpuCopy16(src + 4, dst, size);
    else
        CpuFastCopy(src + 4, dst, size);
}

void Decompress_Unused_Unknown(void const * src, void * dst)
{
    SwiLZ77UnCompReadNormalWrite8bit(src, gBuf);
    CpuFastCopy(gBuf, dst, GetDataSize(src));
}

void Decompress(void const * src, void * dst)
{
    typedef void (*DecompressFunc)(void const *, void *);

    static DecompressFunc SHOULD_BE_CONST func_lut[] = {
        UnpackRaw,                         // 00, vram
        UnpackRaw,                         // 00, wram
        SwiLZ77UnCompReadNormalWrite16bit, // 10, vram
        SwiLZ77UnCompReadNormalWrite8bit,  // 10, wram
        SwiHuffUnCompReadNormal,           // 20, vram
        SwiHuffUnCompReadNormal,           // 20, wram
        SwiRLUnCompReadNormalWrite16bit,   // 30, vram
        SwiRLUnCompReadNormalWrite8bit,    // 30, wram
    };

    int is_wram;

    if ((((u32)dst) - ((u32)VRAM)) < 0x18000)
        is_wram = FALSE; // is vram
    else
        is_wram = TRUE;

    func_lut[is_wram + ((((u8 const *)src)[0] & 0xF0) >> 3)](src, dst);
}

void func_common_020166F8(struct ReportProc * proc)
{
    u16 var = 0x2586;

    InitBgs(NULL);

    ApplyPalette(Pal_Unk_02017C74, 0);
    Decompress(Img_Unk_02017374, VRAM + GetBgChrOffset(1));
    Decompress(Tm_Unk_02017908, gBg1Tm);
    EnableBgSync(BG1_SYNC_BIT);

    SpawnProc(ProcScr_SioVSync, PROC_TREE_VSYNC);
    SpawnProc(ProcScr_SioMain, proc);
    SpawnProc(ProcScr_SioCon, proc);

    SioSend16(&var, -1);

#if defined(VER_20030206)
    DebugInitObj(-1, 9);
#endif
}

void func_common_02016784(struct ReportProc * proc)
{
    int i, timeout_count = 0;

    if (FindProc(ProcScr_SioCon) != NULL)
    {
#if defined(VER_20030206)
        DebugPutObjStr(8, 0x10, "WAIT");
#endif

        return;
    }

    for (i = 0; i < 4; i++)
    {
        if (gSioSt->timeout_clock[i] > 60)
            timeout_count++;
    }

    if (!func_common_0201596C() || gSioSt->unk_01E > 60 || timeout_count != 0)
    {
        Proc_Goto(proc, 10);
        return;
    }

    gUnk_03001C40.kind = SIO_MSG_CC;
    gUnk_03001C40.sender = gSioSt->self_id;
    gUnk_03001C40.param = gSioSt->unk_000;

    SioSend(&gUnk_03001C40, 0xA);

    if ((gSioSt->unk_009 & 3) == 3)
    {
        gSioSt->unk_009 = 3;
        func_common_02016288();

        gSioSt->unk_004 = 6;
        gSioSt->unk_01E = 0;

        func_common_02016114(3);

        Proc_Break(proc);
    }

#if defined(VER_20030206)
    DebugPutObjStr(8, 0x10, "WAIT");
#endif
}

void func_common_02016820(void)
{
    Proc_EndEach(ProcScr_SioVSync);
    Proc_EndEach(ProcScr_SioMain);
    Proc_EndEach(ProcScr_SioCon);

    func_common_02015064();
    func_02014F80();
}

void func_common_0201684C(void)
{
#if defined(VER_20030206)
    DebugPutObjStr(8, 0x10, "END");
#endif
}

void func_common_02016850(struct ReportProc * proc)
{
    // dummy unused
    int unused_fixed_value = ROM_LOGO_FIXED;

    s_unk_03000060[0] = 0;
    proc->unk_58 = 0;

    if (ROM_LOGO_FIXED != ROM_LOGO_FIXED_VALUE)
    {
        proc->unk_5C = ROM_LOGO_FIXED;
        s_unk_03000060[0] = proc->unk_58 = 1;

        Proc_Goto(proc, 11);
    }
    else if (ROM_GAMECODE != ROM_GAMECODE_FE6)
    {
        proc->unk_5C = ROM_GAMECODE;
        s_unk_03000060[0] = proc->unk_58 = 2;

        Proc_Goto(proc, 11);
    }

    SioEmitData(s_unk_03000060, sizeof(s_unk_03000060));
}

void func_common_020168B4(struct ReportProc * proc)
{
    int i;
    struct PlaySt play_st;

    s_play_report.unk_00 = 0x55;
    s_play_report.complete_count = 0;

    for (i = 0; i < 3; i++)
    {
        s_play_report.complete[i] = 0;
        s_play_report.chapter[i] = 0;
        s_play_report.hard_mode[i] = 0;
        s_play_report.time_played[i] = 0;
    }

    for (i = 0; i < 3; i++)
    {
        if (func_02014B0C(i))
        {
            ReadGameSavePlaySt(i, &play_st);

            s_play_report.chapter[i] = play_st.chapter;

            if ((play_st.flags & PLAY_FLAG_COMPLETE) != 0)
            {
                s_play_report.complete[i]++;
                s_play_report.complete_count++;
            }

            if ((play_st.flags & PLAY_FLAG_HARD) != 0)
            {
                s_play_report.hard_mode[i]++;
            }

            s_play_report.time_played[i] = play_st.time_saved;
        }
    }

    SioEmitData((void *)&s_play_report, 0x28);
}

void func_common_02016958(struct ReportProc * proc)
{
    u8 from_id;
    fu16 len = SioReceiveData(s_unk_03000060, &from_id, NULL);

    if (len != 0)
    {
        proc->unk_58 = s_unk_03000060[0];
        proc->unk_54 = ReadGameSaveUnits(proc->unk_58);
        proc->unk_58 = 1;

        Proc_Break(proc);
    }
}

void func_common_02016990(void)
{
    int i;

    for (i = 0; i < 0x3E; i++)
    {
        struct Unit * unit = GetUnit(i);

        if (unit->pid == 0)
            continue;

        if ((unit->flags & UNIT_FLAG_DEAD) != 0)
            continue;

        s_unk_03000080.flags[unit->pid >> 5] |= 1 << (unit->pid & 0x1F);
    }
}

void func_common_020169DC(struct ReportProc * proc)
{
    CpuFill16(0, &s_unk_03000080, sizeof(s_unk_03000080));

    s_unk_03000080.unk_00 = 0x66;
    s_unk_03000080.unk_01 = 1;

    func_common_02016990();

#if defined(VER_FINAL)
    proc->unk_60 = SioEmitData((void const *)&s_unk_03000080, 0x28);
#else
    SioEmitData((void const *)&s_unk_03000080, 0x28);
#endif

    proc->unk_58 = 0;
}

void func_common_02016A20(struct ReportProc * proc)
{
#if !defined(VER_FINAL)
    func_common_02016114(0);

#if defined(VER_20030206)
    DebugPutObjStr(8, 0x10, "HALT");
#endif
#endif
}

#if defined(VER_FINAL)

void func_common_02016A24(struct ReportProc * proc)
{
    if (gSioSt->pending_send[proc->unk_60].unk_00 == gSioSt->unk_009)
    {
        Decompress(Tm_Unk_020179D8, gBg1Tm);
        EnableBgSync(BG1_SYNC_BIT);
        Proc_Break(proc);
    }
}

#endif

void func_common_02016A68(struct ReportProc * proc)
{
    func_common_02016114(0);

#if defined(VER_20030206)
    DebugPutObjStr(8, 0x10, "HALT");
#endif
}

// clang-format off

struct ProcScr SHOULD_BE_CONST ProcScr_Fe6Report[] =
{
    PROC_CALL(func_common_020166F8),
    PROC_REPEAT(func_common_02016784),
    PROC_CALL(func_common_02016850),
    PROC_CALL(func_common_020168B4),
    PROC_REPEAT(func_common_02016958),
    PROC_CALL(func_common_020169DC),

#if defined(VER_FINAL)
    PROC_REPEAT(func_common_02016A24),
#endif

    PROC_REPEAT(func_common_02016A68),

PROC_LABEL(10),
    PROC_CALL(func_common_02016820),
    PROC_REPEAT(func_common_0201684C),

PROC_LABEL(11),
    PROC_REPEAT(func_common_02016A20),
};

// clang-format on

void StartFe6Report(AnyProc * parent)
{
    SpawnProcLocking(ProcScr_Fe6Report, parent);
}
