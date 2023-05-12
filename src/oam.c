#include "oam.h"

#include "gbadma.h"

#include "armfunc.h"

struct OamSection
{
    u16 * buf;
    void * oam;
    u16 offset;
    u16 count;
};

static struct OamSection s_oam_hi;
static struct OamSection s_oam_lo;

u16 COMMON_DATA(gOam) gOam[0x200] = { 0 };
u16 * COMMON_DATA(gOamHiPutIt) gOamHiPutIt = NULL;
u16 * COMMON_DATA(gOamLoPutIt) gOamLoPutIt = NULL;
struct OamView * COMMON_DATA(gOamAffinePutIt) gOamAffinePutIt = NULL;
u16 COMMON_DATA(gOamAffinePutId) gOamAffinePutId = 0;

void InitOam(int slice_point)
{
    s_oam_lo.buf = gOam;
    s_oam_lo.oam = OAM;
    s_oam_lo.offset = 0;
    s_oam_lo.count = slice_point;

    s_oam_hi.buf = gOam + slice_point * 4;
    s_oam_hi.oam = OAM + slice_point * 4 * sizeof(u16);
    s_oam_hi.offset = slice_point * 4 * sizeof(u16);
    s_oam_hi.count = 0x80 - slice_point;
}

inline int GetOamSlicePoint(void)
{
    return s_oam_lo.count;
}

void SyncHiOam(void)
{
    CpuFastCopy(s_oam_hi.buf, s_oam_hi.oam, s_oam_hi.count * 8);
    ClearOam(s_oam_hi.buf, s_oam_hi.count);

    gOamHiPutIt = s_oam_hi.buf;

    gOamAffinePutIt = (struct OamView *)gOam;
    gOamAffinePutId = 0;
}

void SyncLoOam(void)
{
    if (s_oam_lo.count == 0)
        return;

    CpuFastCopy(s_oam_lo.buf, s_oam_lo.oam, s_oam_lo.count * 8);
    ClearOam(s_oam_lo.buf, s_oam_lo.count);

    gOamLoPutIt = s_oam_lo.buf;
}

void SetObjAffine(int id, fi16 pa, fi16 pb, fi16 pc, fi16 pd)
{
    gOam[id * 0x10 + 3] = pa;
    gOam[id * 0x10 + 7] = pb;
    gOam[id * 0x10 + 11] = pc;
    gOam[id * 0x10 + 15] = pd;
}

void PutUnkSprite(struct UnkSprite const * sprites, int x, int y)
{
    int x_obj, y_obj;

    for (;;)
    {
        if (FALSE)
            return;

        if (sprites->oam01 == 1 || gOamHiPutIt >= gOam + 0x80)
            return;

        x_obj = OAM1_X(sprites->x + x);
        y_obj = OAM0_Y(sprites->y + y);

#if defined(MODERN) && MODERN
        *gOamHiPutIt++ = (sprites->oam01 >> 0) | y_obj;
        *gOamHiPutIt++ = (sprites->oam01 >> 16) | x_obj;
        *gOamHiPutIt++ = sprites->oam2;
        *gOamHiPutIt++ = 0;
#else
        *(u32 *)((u32 *)gOamHiPutIt)++ = sprites->oam01 | (x_obj << 16) | (y_obj);
        *(u16 *)((u32 *)gOamHiPutIt)++ = sprites->oam2;
#endif

        sprites++;
    }
}
