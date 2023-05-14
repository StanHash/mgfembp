#ifndef SAVE_DATA_H
#define SAVE_DATA_H

#include "common.h"

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

#endif // SAVE_DATA_H
