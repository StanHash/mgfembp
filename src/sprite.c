#include "sprite.h"

#include "armfunc.h"
#include "oam.h"

struct SpriteEnt
{
    /* 00 */ struct SpriteEnt * next;
    /* 04 */ i16 oam1;
    /* 06 */ i16 oam0;
    /* 08 */ u16 oam2;
    /* 0A */ // pad
    /* 0C */ u16 const * sprite;
};

void SpriteRefresher_Loop(struct SpriteProc * proc);

u16 SHOULD_BE_CONST Sprite_8x8[] = {
    1,                                // count
    OAM0_SHAPE_8x8, OAM1_SIZE_8x8, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_16x16[] = {
    1,                                    // count
    OAM0_SHAPE_16x16, OAM1_SIZE_16x16, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_32x32[] = {
    1,                                    // count
    OAM0_SHAPE_32x32, OAM1_SIZE_32x32, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_64x64[] = {
    1,                                    // count
    OAM0_SHAPE_64x64, OAM1_SIZE_64x64, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x16[] = {
    1,                                  // count
    OAM0_SHAPE_8x16, OAM1_SIZE_8x16, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_16x32[] = {
    1,                                    // count
    OAM0_SHAPE_16x32, OAM1_SIZE_16x32, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_32x64[] = {
    1, OAM0_SHAPE_32x64, OAM1_SIZE_32x64, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_16x8[] = {
    1,                                  // count
    OAM0_SHAPE_16x8, OAM1_SIZE_16x8, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_32x16[] = {
    1,                                    // count
    OAM0_SHAPE_32x16, OAM1_SIZE_32x16, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_64x32[] = {
    1,                                    // count
    OAM0_SHAPE_64x32, OAM1_SIZE_64x32, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_32x8[] = {
    1,                                  // count
    OAM0_SHAPE_32x8, OAM1_SIZE_32x8, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x32[] = {
    1,                                  // count
    OAM0_SHAPE_8x32, OAM1_SIZE_8x32, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_32x8_VFlipped[] = {
    1,                                               // count
    OAM0_SHAPE_32x8, OAM1_SIZE_32x8 + OAM1_VFLIP, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x16_HFlipped[] = {
    1,                                               // count
    OAM0_SHAPE_8x16, OAM1_SIZE_8x16 + OAM1_HFLIP, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x8_HFlipped[] = {
    1,                                             // count
    OAM0_SHAPE_8x8, OAM1_SIZE_8x8 + OAM1_HFLIP, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x8_VFlipped[] = {
    1,                                             // count
    OAM0_SHAPE_8x8, OAM1_SIZE_8x8 + OAM1_VFLIP, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_8x8_HFlipped_VFlipped[] = {
    1,                                                          // count
    OAM0_SHAPE_8x8, OAM1_SIZE_8x8 + OAM1_HFLIP + OAM1_VFLIP, 0, // object 0
};

u16 SHOULD_BE_CONST Sprite_16x16_VFlipped[] = {
    1,                                                 // count
    OAM0_SHAPE_16x16, OAM1_SIZE_16x16 + OAM1_VFLIP, 0, // object 0
};

// clang-format off

struct ProcScr SHOULD_BE_CONST ProcSrc_SpriteRefresher[] =
{
    PROC_REPEAT(SpriteRefresher_Loop),
    PROC_END,
};

// clang-format on

struct SpriteEnt * COMMON_DATA(gSpriteAllocIt) gSpriteAllocIt = NULL;

struct SpriteEnt EWRAM_DATA gSpriteList[0x80] = { 0 };
struct SpriteEnt EWRAM_DATA gSpriteLayers[0x10] = { 0 };

void PutSpriteAffine(int id, fi16 pa, fi16 pb, fi16 pc, fi16 pd)
{
    gOam[id * 0x10 + 0x03] = pa;
    gOam[id * 0x10 + 0x07] = pb;
    gOam[id * 0x10 + 0x0B] = pc;
    gOam[id * 0x10 + 0x0F] = pd;
}

void ClearSprites(void)
{
    int i;

    for (i = 15; i >= 0; i--)
    {
        gSpriteLayers[i].next = &gSpriteLayers[i + 1];
        gSpriteLayers[i].sprite = NULL;
    }

    gSpriteLayers[15].next = NULL;
    gSpriteLayers[12].next = NULL;

    gSpriteAllocIt = gSpriteList;
}

void PutSprite(int layer, int x, int y, u16 const * sprite, int oam2)
{
    gSpriteAllocIt->next = gSpriteLayers[layer].next;
    gSpriteAllocIt->oam1 = OAM1_X(x);
    gSpriteAllocIt->oam0 = OAM0_Y(y);
    gSpriteAllocIt->oam2 = oam2;
    gSpriteAllocIt->sprite = sprite;

    gSpriteLayers[layer].next = gSpriteAllocIt;
    gSpriteAllocIt++;
}

void PutSpriteExt(int layer, int x_oam1, int y_oam0, u16 const * sprite, int oam2)
{
    gSpriteAllocIt->next = gSpriteLayers[layer].next;
    gSpriteAllocIt->oam1 = x_oam1;
    gSpriteAllocIt->oam0 = y_oam0;
    gSpriteAllocIt->oam2 = oam2;
    gSpriteAllocIt->sprite = sprite;

    gSpriteLayers[layer].next = gSpriteAllocIt;
    gSpriteAllocIt++;
}

void PutSpriteLayerOam(int layer)
{
    struct SpriteEnt * it = gSpriteLayers + layer;

    while (it)
    {
        if (!it->sprite)
        {
            it = it->next;
            continue;
        }

        PutOamHi(it->oam1, it->oam0, it->sprite, it->oam2);
        it = it->next;
    }
}

void SpriteRefresher_Loop(struct SpriteProc * proc)
{
    PutSprite(proc->layer, proc->x, proc->y, proc->sprite, proc->oam2);
}

struct SpriteProc * StartSpriteRefresher(AnyProc * parent, int layer, int x, int y, u16 const * sprite, int oam2)
{
    struct SpriteProc * proc;

    if (parent)
    {
        proc = SpawnProc(ProcSrc_SpriteRefresher, parent);
    }
    else
    {
        proc = SpawnProc(ProcSrc_SpriteRefresher, PROC_TREE_3);
    }

    proc->x = x;
    proc->y = y;
    proc->layer = layer;
    proc->sprite = sprite;
    proc->oam2 = oam2;

    return proc;
}

void MoveSpriteRefresher(struct SpriteProc * proc, int x, int y)
{
    if (proc == NULL)
    {
        proc = FindProc(ProcSrc_SpriteRefresher);
    }

    proc->x = x;
    proc->y = y;
}
