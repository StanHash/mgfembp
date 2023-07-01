#include "save_data.h"
#include "save_util.h"

#include "armfunc.h"
#include "game_structs.h"
#include "gbaio.h"
#include "gbasram.h"
#include "hardware.h"

#include "unknowns.h"

// start garb

#define UNIT_SAVE_AMOUNT_BLUE 52
#define UNIT_SAVE_AMOUNT_RED 50
#define UNIT_SAVE_AMOUNT_GREEN 10

enum
{
    // flags for GameSavePackedUnit::flags

    SAVEUNIT_FLAG_DEAD = 1 << 0,
    SAVEUNIT_FLAG_UNDEPLOYED = 1 << 1,
    SAVEUNIT_FLAG_SOLOANIM1 = 1 << 2,
    SAVEUNIT_FLAG_SOLOANIM2 = 1 << 3,
};

struct GameSavePackedUnit
{
    /* 00 */ u32 pid : 7;
    /*    */ u32 jid : 7;
    /*    */ u32 level : 5;
    /*    */ u32 flags : 6;
    /*    */ u32 exp : 7;
    /* 04 */ u32 x : 6;
    /*    */ u32 y : 6;
    /*    */ u32 max_hp : 6;
    /*    */ u32 pow : 5;
    /*    */ u32 skl : 5;
    /*    */ u32 spd : 5;
    /*    */ u32 def : 5;
    /*    */ u32 res : 5;
    /*    */ u32 lck : 5;
    /*    */ u32 con : 5;
    /*    */ u32 mov : 5;
    /*    */ u32 item_a : 14;
    /*    */ u32 item_b : 14;
    /*    */ u32 item_c : 14;
    /*    */ u32 item_d : 14;
    /*    */ u32 item_e : 14;
    /* 14 */ u8 unused_14[2];
    /* 16 */ u8 wexp[UNIT_WEAPON_EXP_COUNT];
    /* 1E */ u8 supports[UNIT_SUPPORT_COUNT];
};

struct GameSaveBlock
{
    struct PlaySt play_st;
    struct GameSavePackedUnit units[UNIT_SAVE_AMOUNT_BLUE];
    u16 supply_items[SUPPLY_ITEM_COUNT];
    // struct PidStats pid_stats[PID_STATS_COUNT];
    // struct ChapterStats chapter_stats[CHAPTER_STATS_COUNT];
    // u8 permanent_flags[sizeof(gPermanentFlagBits)];
};

extern struct Unit gUnits[];
extern void ReadGameSavePackedUnit(struct GameSavePackedUnit const * src, struct Unit * dst);

// end garb

struct SramMain
{
    /* 0000 */ struct GlobalSaveInfo head;
    /* 0020 */ struct SaveBlockInfo block_info[SAVE_COUNT];
    /* 0090 */ STRUCT_PAD(0x0090, 0x70F4);
};

char EWRAM_DATA gUnk_0202F8A4[10] = { 0 };

bool EWRAM_DATA gIsSramWorking = FALSE;

char const gSaveDataMark[] = "AGB-FE6";

struct SramMain * SHOULD_BE_CONST gSramMain = CART_SRAM;

bool StringEquals(char const * str_a, char const * str_b)
{
    while (*str_a | *str_b)
    {
        if (*str_a++ != *str_b++)
            return FALSE;
    }

    return TRUE;
}

void StringCopy(char * dst, char const * src)
{
    while (*src)
    {
        *dst++ = *src++;
    }

    *dst = *src;
}

u32 SramChecksum32(void const * sram_src, int size)
{
    ReadSramFast(sram_src, gBuf, size);
    return Checksum32(gBuf, size);
}

bool VerifySaveBlockChecksum(struct SaveBlockInfo const * block_info)
{
    int size = block_info->size;
    void * sram_src = SramOffsetToAddr(block_info->offset);

    u32 checksum32 = SramChecksum32(sram_src, size);

    if (block_info->checksum32 != checksum32)
        return FALSE;
    else
        return TRUE;
}

void PopulateSaveBlockChecksum(struct SaveBlockInfo * block_info)
{
    int size = block_info->size;
    void * sram_src = SramOffsetToAddr(block_info->offset);

    block_info->checksum32 = SramChecksum32(sram_src, size);
}

char const * func_0201473C(u32 bcd_date)
{
    gUnk_0202F8A4[0] = '0' + ((bcd_date >> 20) & 0xF);
    gUnk_0202F8A4[1] = '0' + ((bcd_date >> 16) & 0xF);
    gUnk_0202F8A4[2] = '/';
    gUnk_0202F8A4[3] = '0' + ((bcd_date >> 12) & 0xF);
    gUnk_0202F8A4[4] = '0' + ((bcd_date >> 8) & 0xF);
    gUnk_0202F8A4[5] = '/';
    gUnk_0202F8A4[6] = '0' + ((bcd_date >> 4) & 0xF);
    gUnk_0202F8A4[7] = '0' + ((bcd_date >> 0) & 0xF);
    gUnk_0202F8A4[8] = '\0';

    return gUnk_0202F8A4;
}

void func_02014788(void)
{
}

void SramInit(void)
{
    u32 buf[2];

    buf[0] = 0x12345678;
    buf[1] = 0x87654321;

    SetSramFastFunc();

    REG_IE |= INTR_FLAG_GAMEPAK;

    WriteSramFast((u8 const *)&buf[0], ((void *)gSramMain) + sizeof(*gSramMain), sizeof(u32));
    ReadSramFast(((void *)gSramMain) + sizeof(*gSramMain), &buf[1], sizeof(u32));

    gIsSramWorking = (buf[1] == buf[0]) ? TRUE : FALSE;
}

bool IsSramWorking(void)
{
    return gIsSramWorking;
}

void func_02014810(const void * src, void * dst, u32 size)
{
    WriteAndVerifySramFast(src, dst, size);
}

#define WriteAndVerifySramFast func_02014810

void WipeSram(void)
{
    u32 buf[0x10];
    int i;

    for (i = 0; i < (int)ARRAY_COUNT(buf); i++)
        buf[i] = 0xFFFFFFFF;

    for (i = 0; i < CART_SRAM_SIZE / (int)sizeof(buf); i++)
        WriteAndVerifySramFast(buf, ((void *)gSramMain) + i * sizeof(buf), sizeof(buf));

    STATIC_ASSERT(CART_SRAM_SIZE % sizeof(buf) == 0);
}

fu16 Checksum16(void const * data, int size)
{
    u16 const * data_u16 = data;

    int i;

    u32 add_acc = 0;
    u32 xor_acc = 0;

    for (i = 0; i < size / 2; ++i)
    {
        add_acc += data_u16[i];
        xor_acc ^= data_u16[i];
    }

    return (u16)(add_acc + xor_acc);
}

bool ReadGlobalSaveInfo(struct GlobalSaveInfo * info)
{
    struct GlobalSaveInfo local_info;

    if (!IsSramWorking())
        return FALSE;

    if (info == NULL)
        info = &local_info;

    ReadSramFast(&gSramMain->head, info, sizeof(struct GlobalSaveInfo));

    if (!StringEquals(info->name, gSaveDataMark))
        return FALSE;

    if (info->magic32 == SAVE_MAGIC32 && info->magic16 == SAVE_MAGIC16 &&
        info->checksum == Checksum16(info, GLOBALSIZEINFO_SIZE_FOR_CHECKSUM))
    {
        return TRUE;
    }

    return FALSE;
}

void WriteGlobalSaveInfo(struct GlobalSaveInfo * info)
{
    info->checksum = Checksum16(info, GLOBALSIZEINFO_SIZE_FOR_CHECKSUM);
    WriteAndVerifySramFast(info, &gSramMain->head, sizeof(struct GlobalSaveInfo));
}

void WriteGlobalSaveInfoNoChecksum(struct GlobalSaveInfo * info)
{
    WriteAndVerifySramFast(info, &gSramMain->head, sizeof(struct GlobalSaveInfo));
}

void InitGlobalSaveInfo(void)
{
    struct GlobalSaveInfo info;

    int i;

    WipeSram();

    StringCopy(info.name, gSaveDataMark);
    info.magic32 = SAVE_MAGIC32;
    info.magic16 = SAVE_MAGIC16;
    info.completed = FALSE;
    info.completed_true = FALSE;
    info.completed_hard = FALSE;
    info.completed_true_hard = FALSE;
    info.unk_0E_4 = 0;
    info.last_suspend_slot = 0;
    info.last_game_save_id = 0;

    for (i = 0; i < (int)ARRAY_COUNT(info.cleared_playthroughs); i++)
        info.cleared_playthroughs[i] = 0;

    WriteGlobalSaveInfo(&info);
}

void * SramOffsetToAddr(fu16 off)
{
    return ((void *)gSramMain) + off;
}

fu16 SramAddrToOffset(void * addr)
{
    return ((u8 *)addr) - ((u8 *)(void *)gSramMain);
}

bool ReadSaveBlockInfo(struct SaveBlockInfo * block_info, int save_id)
{
    struct SaveBlockInfo local_block_info;
    u32 magic32;

    if (block_info == NULL)
        block_info = &local_block_info;

    ReadSramFast(&gSramMain->block_info[save_id], block_info, sizeof(struct SaveBlockInfo));

    if (block_info->magic16 != SAVE_MAGIC16)
        return FALSE;

    switch (save_id)
    {
        case SAVE_GAME0:
        case SAVE_GAME1:
        case SAVE_GAME2:
            magic32 = SAVE_MAGIC32;
            break;

        case SAVE_SUSPEND:
        case SAVE_SUSPEND_ALT:
            magic32 = SAVE_MAGIC32;
            break;

        case SAVE_MULTIARENA:
            magic32 = SAVE_MAGIC32_MULTIARENA;
            break;

        case SAVE_XMAP:
            magic32 = SAVE_MAGIC32_XMAP;
            break;

        default:
            return FALSE;
    }

    if (block_info->magic32 != magic32)
        return FALSE;

    return VerifySaveBlockChecksum(block_info);
}

void * GetSaveReadAddr(int save_id)
{
    struct SaveBlockInfo block_info;
    ReadSaveBlockInfo(&block_info, save_id);
    return SramOffsetToAddr(block_info.offset);
}

bool IsNotFirstPlaythrough(void)
{
    struct GlobalSaveInfo info;

    if (ReadGlobalSaveInfo(&info))
        return info.completed;

    return FALSE;
}

bool func_02014AB4(void)
{
    return TRUE;
}

bool IsMultiArenaAvailable(void)
{
    int i;

    if (!IsSramWorking())
        return FALSE;

    for (i = 0; i < 3; i++)
    {
        // dummied
    }

#if BUGFIX
    return FALSE;
#endif
}

bool IsNotFirstPlaythrough_2(void)
{
    return IsNotFirstPlaythrough();
}

bool CheckHasCompletedSave(void)
{
    int i;
    struct PlaySt play_st;

    for (i = 0; i < 3; i++)
    {
        // reads were dummied

        if ((play_st.flags & PLAY_FLAG_COMPLETE) != 0)
            return TRUE;
    }

    return FALSE;
}

bool func_02014B0C(int save_id)
{
    if (!IsSramWorking())
        return FALSE;

    return ReadSaveBlockInfo(NULL, save_id);
}

void ReadGameSavePlaySt(int save_id, struct PlaySt * dst)
{
    struct GameSaveBlock const * src = GetSaveReadAddr(save_id);

    ReadSramFast(&src->play_st, dst, sizeof(struct PlaySt));
}

struct GameSavePackedUnit const * ReadGameSaveUnits(int save_id)
{
    int i;
    struct GameSaveBlock const * src = GetSaveReadAddr(save_id);

    InitUnits();

    for (i = 0; i < UNIT_SAVE_AMOUNT_BLUE; i++)
        ReadGameSavePackedUnit(&src->units[i], &gUnits[i]);

    return src->units;
}

void ReadGameSavePackedUnit(struct GameSavePackedUnit const * sram_src, struct Unit * unit)
{
    int i;
    struct GameSavePackedUnit save_unit;

    ReadSramFast(sram_src, &save_unit, sizeof(struct GameSavePackedUnit));

    unit->level = save_unit.level;
    unit->exp = save_unit.exp;
    unit->x = save_unit.pid;
    unit->y = save_unit.jid;
    unit->max_hp = save_unit.max_hp;
    unit->pow = save_unit.pow;
    unit->skl = save_unit.skl;
    unit->spd = save_unit.spd;
    unit->def = save_unit.def;
    unit->res = save_unit.res;
    unit->lck = save_unit.lck;
    unit->bonus_con = save_unit.con;
    unit->bonus_mov = save_unit.mov;

    unit->items[0] = save_unit.item_a;
    unit->items[1] = save_unit.item_b;
    unit->items[2] = save_unit.item_c;
    unit->items[3] = save_unit.item_d;
    unit->items[4] = save_unit.item_e;

    if (unit->exp > 99)
        unit->exp = -1;

    unit->flags = 0;

    if ((save_unit.flags & SAVEUNIT_FLAG_DEAD) != 0)
        unit->flags |= UNIT_FLAG_DEAD | UNIT_FLAG_HIDDEN;

    for (i = 0; i < UNIT_SUPPORT_COUNT; i++)
        unit->supports[i] = save_unit.supports[i];
}
