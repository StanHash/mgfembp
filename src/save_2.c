#include "save_data.h"

#include "armfunc.h"
#include "gbaio.h"
#include "gbasram.h"
#include "hardware.h"
#include "save_util.h"

char const gSaveDataMark[] = "AGB-FE6";

struct SramMain
{
    /* 0000 */ struct GlobalSaveInfo head;
    /* 0020 */ struct SaveBlockInfo block_info[SAVE_COUNT];
    /* 0090 */ STRUCT_PAD(0x0090, 0x70F4);
};

struct SramMain * SHOULD_BE_CONST gSramMain = CART_SRAM;

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
