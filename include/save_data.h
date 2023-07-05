#ifndef SAVE_DATA_H
#define SAVE_DATA_H

#include "common.h"

#include "game_structs.h"
#include "save_fwd.h"

struct GlobalSaveInfo
{
    /* 00 */ char name[8];
    /* 08 */ u32 magic32;
    /* 0C */ u16 magic16;
    /* 0E */ u16 completed : 1;
    /*    */ u16 completed_hard : 1;
    /*    */ u16 completed_true : 1;
    /*    */ u16 completed_true_hard : 1;
    /*    */ u16 unk_0E_4 : 12;
    /* 10 */ u8 cleared_playthroughs[12];
    /* 1C */ u16 checksum;
    /* 1E */ u8 last_game_save_id;
    /* 1F */ u8 last_suspend_slot;
};

// up to checksum offset, aligned to 2 (nearest down)
#define GLOBALSIZEINFO_SIZE_FOR_CHECKSUM (offsetof(struct GlobalSaveInfo, checksum) & ~1)

struct SaveBlockInfo
{
    /* 00 */ u32 magic32;
    /* 04 */ u16 magic16;
    /* 06 */ u8 kind;
    /* 08 */ u16 offset;
    /* 0A */ u16 size;
    /* 0C */ u32 checksum32;
};

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

#define UNIT_SAVE_AMOUNT_BLUE 52

struct GameSaveBlock
{
    struct PlaySt play_st;
    struct GameSavePackedUnit units[UNIT_SAVE_AMOUNT_BLUE];
    // ...
};

struct SramMain
{
    /* 0000 */ struct GlobalSaveInfo head;
    /* 0020 */ struct SaveBlockInfo block_info[SAVE_COUNT];
    /* 0090 */ STRUCT_PAD(0x0090, 0x70F4);
};

#endif // SAVE_DATA_H
