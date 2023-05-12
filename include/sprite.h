#ifndef SPRITE_H
#define SPRITE_H

#include "common.h"

#include "proc.h"

struct SpriteProc
{
    /* 00 */ PROC_HEADER;

    /* 2C */ i32 x;
    /* 30 */ i32 y;
    /* 34 */ STRUCT_PAD(0x34, 0x50);
    /* 50 */ i16 layer;
    /* 52 */ u16 tileref;
    /* 54 */ u16 const * sprite;
};

void PutSpriteAffine(int id, fi16 pa, fi16 pb, fi16 pc, fi16 pd);
void ClearSprites(void);
void PutSprite(int layer, int x, int y, u16 const * sprite, int oam2);
void PutSpriteExt(int layer, int xOam1, int yOam0, u16 const * sprite, int oam2);
void PushSpriteLayerObjects(int layer);
void PutSpriteLayerOam(int layer);

struct SpriteProc * StartSpriteRefresher(AnyProc * parent, int layer, int x, int y, u16 const * sprite, int tileref);
void MoveSpriteRefresher(struct SpriteProc * proc, int x, int y);

extern u16 SHOULD_BE_CONST Sprite_8x8[];
extern u16 SHOULD_BE_CONST Sprite_16x16[];
extern u16 SHOULD_BE_CONST Sprite_32x32[];
extern u16 SHOULD_BE_CONST Sprite_64x64[];
extern u16 SHOULD_BE_CONST Sprite_8x16[];
extern u16 SHOULD_BE_CONST Sprite_16x32[];
extern u16 SHOULD_BE_CONST Sprite_32x64[];
extern u16 SHOULD_BE_CONST Sprite_16x8[];
extern u16 SHOULD_BE_CONST Sprite_32x16[];
extern u16 SHOULD_BE_CONST Sprite_64x32[];
extern u16 SHOULD_BE_CONST Sprite_32x8[];
extern u16 SHOULD_BE_CONST Sprite_8x32[];
extern u16 SHOULD_BE_CONST Sprite_32x8_VFlipped[];
extern u16 SHOULD_BE_CONST Sprite_8x16_HFlipped[];
extern u16 SHOULD_BE_CONST Sprite_8x8_HFlipped[];
extern u16 SHOULD_BE_CONST Sprite_8x8_VFlipped[];
extern u16 SHOULD_BE_CONST Sprite_8x8_HFlipped_VFlipped[];
extern u16 SHOULD_BE_CONST Sprite_16x16_VFlipped[];

#endif // SPRITE_H
