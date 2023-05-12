#include "hardware.h"

#include "gbadma.h"
#include "gbaio.h"

#include "async_upload.h"
#include "interrupts.h"
#include "oam.h"

#include "unknowns.h"

static u8 s_bg_sync_bits;
static bool s_pal_sync;

static u32 s_game_time;

static u8 s_unk_03000008;
static u8 s_unk_03000009;

i8 EWRAM_DATA gFadeComponentStep[0x20] = { 0 };
i8 EWRAM_DATA gFadeComponents[3 * 0x200] = { 0 };
u16 EWRAM_DATA gPal[0x200] = { 0 };
u16 EWRAM_DATA gBg0Tm[0x400] = { 0 };
u16 EWRAM_DATA gBg1Tm[0x400] = { 0 };
u16 EWRAM_DATA gBg2Tm[0x400] = { 0 };
u16 EWRAM_DATA gBg3Tm[0x400] = { 0 };
void * EWRAM_DATA gBgMapVramTable[4] = { 0 };
void (*EWRAM_DATA MainFunc)(void) = NULL;
u32 EWRAM_DATA gPad_0202CA34 = 0; // this is to pad for matching
struct KeySt EWRAM_DATA gKeyStInstance = { 0 };

extern struct DispIo COMMON_DATA(gDispIo) gDispIo;
extern void (*COMMON_DATA(HBlankFuncA) HBlankFuncA)(void);
extern void (*COMMON_DATA(HBlankFuncB) HBlankFuncB)(void);

struct KeySt * SHOULD_BE_CONST gKeySt = &gKeyStInstance;

u32 GetGameTime(void)
{
    return s_game_time;
}

void SetGameTime(u32 time)
{
    s_game_time = time;
}

void IncGameTime(void)
{
    s_game_time++;

    if (s_game_time >= 1000 * FRAMES_PER_HOUR)
    {
        s_game_time = 990 * FRAMES_PER_HOUR;
        return;
    }
}

bool FormatTime(u32 time, u16 * out_hours, u16 * out_minutes, u16 * out_seconds)
{
    *out_seconds = (time / FRAMES_PER_SECOND) % 60;
    *out_minutes = (time / FRAMES_PER_MINUTE) % 60;
    *out_hours = (time / FRAMES_PER_HOUR);

    return (time / 30) & 1; // clock `:` on/off boolean
}

inline void EnableBgSync(int bits)
{
    s_bg_sync_bits |= bits;
}

inline void EnableBgSyncById(int bg_id)
{
    s_bg_sync_bits |= (1 << bg_id);
}

inline void DisableBgSync(int bits)
{
    s_bg_sync_bits &= ~bits;
}

inline void EnablePalSync(void)
{
    s_pal_sync = TRUE;
}

inline void DisablePalSync(void)
{
    s_pal_sync = FALSE;
}

void ApplyPaletteExt(void const * color_data, int offset, int size)
{
    if ((size & 0x1F) != 0)
    {
        // size is not a multiple of 32
        CpuCopy16(color_data, gPal + (offset >> 1), size);
    }
    else
    {
        CpuFastCopy(color_data, gPal + (offset >> 1), size);
    }

    EnablePalSync();
}

void SyncDispIo(void)
{
    // TODO: rewrite this function for MODERN
    // this is a bit of a mess

#define SET_REG(type, reg, src) *((type *)&REG_##reg) = *((type *)&(src))

    SET_REG(u16, DISPCNT, gDispIo.disp_ct);
    SET_REG(u16, DISPSTAT, gDispIo.disp_stat);

    SET_REG(u16, BG0CNT, gDispIo.bg0_ct);
    SET_REG(u16, BG1CNT, gDispIo.bg1_ct);
    SET_REG(u16, BG2CNT, gDispIo.bg2_ct);
    SET_REG(u16, BG3CNT, gDispIo.bg3_ct);

    // set both HOFS and VOFS with a single 32-bit copy
    SET_REG(u32, BG0HOFS, gDispIo.bg_off[0]);
    SET_REG(u32, BG1HOFS, gDispIo.bg_off[1]);
    SET_REG(u32, BG2HOFS, gDispIo.bg_off[2]);
    SET_REG(u32, BG3HOFS, gDispIo.bg_off[3]);

    // set both WIN0H and WIN1H with a single 32-bit copy
    SET_REG(u32, WIN0H, gDispIo.win0_right);
    // set both WIN0V and WIN1V with a single 32-bit copy
    SET_REG(u32, WIN0V, gDispIo.win0_bottom);

    // set both WININ and WINOUT with a single 32-bit copy
    SET_REG(u32, WININ, gDispIo.win_ct);

    SET_REG(u16, MOSAIC, gDispIo.mosaic);
    SET_REG(u16, BLDCNT, gDispIo.blend_ct);
    SET_REG(u16, BLDALPHA, gDispIo.blend_coef_a);
    SET_REG(u8, BLDY, gDispIo.blend_y);

    // set both BG2PA and BG2PB with a single 32-bit copy
    SET_REG(u32, BG2PA, gDispIo.bg2pa);
    // set both BG2PC and BG2PD with a single 32-bit copy
    SET_REG(u32, BG2PC, gDispIo.bg2pc);

    SET_REG(u32, BG2X, gDispIo.bg2x);
    SET_REG(u32, BG2Y, gDispIo.bg2y);

    // set both BG3PA and BG3PB with a single 32-bit copy
    SET_REG(u32, BG3PA, gDispIo.bg3pa);
    // set both BG3PC and BG3PD with a single 32-bit copy
    SET_REG(u32, BG3PC, gDispIo.bg3pc);

    SET_REG(u32, BG3X, gDispIo.bg3x);
    SET_REG(u32, BG3Y, gDispIo.bg3y);

#undef SET_REG
}

struct BgCnt * GetBgCt(fu16 bg_id)
{
    switch (bg_id)
    {
        case 0:
            return &gDispIo.bg0_ct;
        case 1:
            return &gDispIo.bg1_ct;
        case 2:
            return &gDispIo.bg2_ct;
        case 3:
            return &gDispIo.bg3_ct;
    }

#if BUGFIX
    return NULL;
#endif
}

int GetBgChrOffset(int bg)
{
    struct BgCnt * bg_ct = GetBgCt(bg);
    return bg_ct->chr_block * 0x4000;
}

int GetBgChrId(int bg, int offset)
{
    offset &= 0xFFFF;

    return (offset - GetBgChrOffset(bg)) / 0x20;
}

int GetBgTilemapOffset(int bg)
{
    struct BgCnt * bg_ct = GetBgCt(bg);
    return bg_ct->tm_block * 0x800;
}

void SetBgChrOffset(int bg, int offset)
{
    struct BgCnt * bg_ct = GetBgCt(bg);
    bg_ct->chr_block = offset >> 14;
}

void SetBgTilemapOffset(int bg, int offset)
{
    struct BgCnt * bg_ct = GetBgCt(bg);

    if ((offset & 0x7FF) != 0) // must be aligned
        return;

    bg_ct->tm_block = offset >> 11;
    gBgMapVramTable[bg] = (void *)(0x06000000 | offset);
}

void SetBgScreenSize(int bg, int size)
{
    struct BgCnt * bg_ct = GetBgCt(bg);
    bg_ct->size = size;
}

void SetBgBpp(int bg, int bpp)
{
    struct BgCnt * bg_ct = GetBgCt(bg);
    bg_ct->color_depth = (bpp == 8) ? BG_COLORDEPTH_8BPP : BG_COLORDEPTH_4BPP;
}

void SyncBgsAndPal(void)
{
    if ((s_bg_sync_bits & BG0_SYNC_BIT) != 0)
        CpuFastCopy(gBg0Tm, gBgMapVramTable[0], sizeof gBg0Tm);

    if ((s_bg_sync_bits & BG1_SYNC_BIT) != 0)
        CpuFastCopy(gBg1Tm, gBgMapVramTable[1], sizeof gBg1Tm);

    if ((s_bg_sync_bits & BG2_SYNC_BIT) != 0)
        CpuFastCopy(gBg2Tm, gBgMapVramTable[2], sizeof gBg2Tm);

    if ((s_bg_sync_bits & BG3_SYNC_BIT) != 0)
        CpuFastCopy(gBg3Tm, gBgMapVramTable[3], sizeof gBg3Tm);

    s_bg_sync_bits = 0;

    if (s_pal_sync == TRUE)
    {
        CpuFastCopy(gPal, (void *)0x05000000, sizeof gPal);
        s_pal_sync = FALSE;
    }
}

void TmFill(u16 * tm, int tile)
{
    tile = tile + (tile << 16);
    CpuFastFill(tile, tm, sizeof gBg0Tm);
}

void SetBlankChr(int chr)
{
    AsyncDataFill(0x00000000, VRAM + 0x20 * chr, 0x20);
}

void SetOnVBlank(void (*opt_func)(void))
{
    if (opt_func != NULL)
    {
        gDispIo.disp_stat.vblank_int_enable = TRUE;

        SetIntrFunc(INT_VBLANK, opt_func);
        REG_IE |= INTR_FLAG_VBLANK;
    }
    else
    {
        gDispIo.disp_stat.vblank_int_enable = FALSE;
        REG_IE &= ~INTR_FLAG_VBLANK;
    }
}

void SetOnVMatch(void (*opt_func)(void))
{
    if (opt_func != NULL)
    {
        gDispIo.disp_stat.vcount_int_enable = TRUE;

        SetIntrFunc(INT_VCOUNT, opt_func);
        REG_IE |= INTR_FLAG_VCOUNT;
    }
    else
    {
        gDispIo.disp_stat.vcount_int_enable = FALSE;
        REG_IE &= ~INTR_FLAG_VCOUNT;

        gDispIo.disp_stat.vcount_compare = 0;
    }
}

void SetNextVCount(int vcount)
{
    u16 disp_stat;

    disp_stat = REG_DISPSTAT;
    disp_stat = disp_stat & 0xFF;
    disp_stat = disp_stat | (vcount << 8);

    REG_DISPSTAT = disp_stat;
}

void SetVCount(int vcount)
{
    gDispIo.disp_stat.vcount_compare = vcount;
}

void SetMainFunc(void (*opt_func)(void))
{
    MainFunc = opt_func;
}

void RunMainFunc(void)
{
    if (MainFunc != NULL)
        MainFunc();
}

void RefreshKeyStFromKeys(struct KeySt * key_st, short keys)
{
    key_st->previous = key_st->held;
    key_st->held = keys;

    // keys that are pressed now, but weren't pressed before
    key_st->pressed = (key_st->repeated = (key_st->held ^ key_st->previous) & key_st->held) & ~0;

    if (key_st->pressed)
    {
        key_st->last = key_st->held;
    }

    key_st->ablr_pressed = 0;

    if (key_st->held == 0)
    {
        if (key_st->last &&
            key_st->last == (key_st->previous & (KEY_BUTTON_L | KEY_BUTTON_R | KEY_BUTTON_B | KEY_BUTTON_A)))
            key_st->ablr_pressed = key_st->previous;
    }

    // keys are being held
    if (key_st->held && key_st->held == key_st->previous)
    {
        key_st->repeat_clock--;

        if (key_st->repeat_clock == 0)
        {
            key_st->repeated = key_st->held;
            key_st->repeat_clock = key_st->repeat_interval; // reset repeat timer
        }
    }
    else
    {
        // held key combination has changed. reset timer
        key_st->repeat_clock = key_st->repeat_delay;
    }

    key_st->pressed2 = (key_st->held ^ key_st->pressed2) & key_st->held;

    // any button other than start and select
    if (keys & (KEY_BUTTON_A | KEY_BUTTON_B | KEY_DPAD_ANY | KEY_BUTTON_R | KEY_BUTTON_L))
    {
        key_st->time_since_start_select = 0;
    }
    else if (key_st->time_since_start_select < UINT16_MAX)
    {
        key_st->time_since_start_select++;
    }
}

void RefreshKeySt(struct KeySt * key_st)
{
    RefreshKeyStFromKeys(key_st, (~REG_KEYINPUT) & KEY_ANY);
}

void ClearKeySt(struct KeySt * key_st)
{
    key_st->pressed = 0;
    key_st->repeated = 0;
    key_st->held = 0;
}

void InitKeySt(struct KeySt * key_st)
{
    key_st->repeat_delay = 12;
    key_st->repeat_interval = 4;

    key_st->previous = 0;
    key_st->held = 0;
    key_st->pressed = 0;

    key_st->repeat_clock = 0;
    key_st->time_since_start_select = 0;
}

void SetBgOffset(fu16 bgid, fu16 x_offset, fu16 y_offset)
{
    switch (bgid)
    {
        case 0:
            gDispIo.bg_off[0].x = x_offset;
            gDispIo.bg_off[0].y = y_offset;
            break;

        case 1:
            gDispIo.bg_off[1].x = x_offset;
            gDispIo.bg_off[1].y = y_offset;
            break;

        case 2:
            gDispIo.bg_off[2].x = x_offset;
            gDispIo.bg_off[2].y = y_offset;
            break;

        case 3:
            gDispIo.bg_off[3].x = x_offset;
            gDispIo.bg_off[3].y = y_offset;
            break;
    }
}

void func_020111D8(void)
{
    s_unk_03000008 = s_unk_03000009 = 0;

    TmFill(gBg0Tm, 0);
    EnableBgSync(BG0_SYNC_BIT);
}

void func_0201120C(fu8 a, fu8 b)
{
    s_unk_03000008 = a;
    s_unk_03000009 = b;
}

void func_02011240(u16 * a, u16 * b)
{
    int i;

    for (i = 0x27F; i >= 0; i--)
        *a++ = *b++;
}

void func_02011280(void * tm, void const * in_data, fu8 base, fu8 linebits)
{
    u8 const * it = (u8 const *)in_data + 2;
    u8 * out;

    u8 x_size = (*(u32 const *)in_data);
    u8 y_size = (*(u32 const *)in_data) >> 8;

    i8 ix, iy;

    for (iy = y_size; iy >= 0; iy--)
    {
        out = (u8 *)tm + (iy << linebits);

        for (ix = x_size; ix >= 0; ix--)
            *out++ = *it++ + base;
    }
}

void func_0201135C(u16 * tm, i16 const * in_data, int unused)
{
    int x_size = (in_data[0]) & 0xFF;
    int y_size = (in_data[0] >> 8) & 0xFF;

    int ix, iy;

    int acc = 0;

    in_data = in_data + 1;

    for (iy = 0; iy < y_size; ++iy)
    {
        u16 * out = tm + (iy << 5);

        for (ix = 0; ix < x_size; ++ix)
        {
            acc += *in_data++;
            *out++ = acc;
        }
    }
}

void ColorFadeClear(void)
{
    int i;

    for (i = 31; i >= 0; i--)
        gFadeComponentStep[i] = 0;
}

void ColorFadeSetupFromToPaletteAuto(u16 const * in_pal, int pal_num, int pal_count, int component_step)
{
    int pal_idx, color_idx;

    int add = (component_step < 0) ? 0x20 : 0;
    int component_idx = pal_num * 0x30;

    for (pal_idx = 0; pal_idx < pal_count; pal_idx++)
    {
        gFadeComponentStep[pal_num + pal_idx] = component_step;

        for (color_idx = 0; color_idx < 0x10; color_idx++)
        {
            gFadeComponents[component_idx++] = RGB5_R(*in_pal) + add;
            gFadeComponents[component_idx++] = RGB5_G(*in_pal) + add;
            gFadeComponents[component_idx++] = RGB5_B(*in_pal) + add;

            in_pal++;
        }
    }
}

void ColorFadeSetupRange(int pal_num, int pal_count, int add, int component_step)
{
    int pal_idx;
    int color_idx;
    int dst_offset = pal_num * 0x10;

    u16 const * src = gPal + dst_offset;

    for (pal_idx = 0; pal_idx < pal_count; ++pal_idx)
    {
        gFadeComponentStep[pal_num + pal_idx] = component_step;

        for (color_idx = 0; color_idx < 0x10; color_idx++)
        {
            gFadeComponents[dst_offset++] = RGB5_R(*src) + add;
            gFadeComponents[dst_offset++] = RGB5_G(*src) + add;
            gFadeComponents[dst_offset++] = RGB5_B(*src) + add;

            src++;
        }
    }
}

void ColorFadeSetRangeStep(int pal_num, int pal_count, int component_step)
{
    int i;

    for (i = pal_num; i < pal_num + pal_count; i++)
        gFadeComponentStep[i] = component_step;
}

void ColorFadeSetupFromColorToBlack(fi8 component_step)
{
    int i, j;

    for (i = 0x1F; i >= 0; i--)
    {
        gFadeComponentStep[i] = component_step;

        for (j = 0; j < 0x10; j++)
        {
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 0] = RGB5_R(gPal[PAL_OFFSET(i, j)]) + 0x20;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 1] = RGB5_G(gPal[PAL_OFFSET(i, j)]) + 0x20;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 2] = RGB5_B(gPal[PAL_OFFSET(i, j)]) + 0x20;
        }
    }
}

void ColorFadeSetupFromBlack(fi8 component_step)
{
    int i, j;

    for (i = 0x1F; i >= 0; i--)
    {
        gFadeComponentStep[i] = component_step;

        for (j = 0; j < 0x10; j++)
        {
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 0] = RGB5_R(gPal[PAL_OFFSET(i, j)]);
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 1] = RGB5_G(gPal[PAL_OFFSET(i, j)]);
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 2] = RGB5_B(gPal[PAL_OFFSET(i, j)]);
        }
    }
}

void ColorFadeSetupFromColorToWhite(fi8 component_step)
{
    int i, j;

    for (i = 0x1F; i >= 0; i--)
    {
        gFadeComponentStep[i] = component_step;

        for (j = 0; j < 0x10; j++)
        {
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 0] = RGB5_R(gPal[PAL_OFFSET(i, j)]) + 0x20;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 1] = RGB5_G(gPal[PAL_OFFSET(i, j)]) + 0x20;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 2] = RGB5_B(gPal[PAL_OFFSET(i, j)]) + 0x20;
        }
    }
}

void ColorFadeSetupFromWhite(fi8 component_step)
{
    int i, j;

    for (i = 0x1F; i >= 0; i--)
    {
        gFadeComponentStep[i] = component_step;

        for (j = 0; j < 0x10; j++)
        {
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 0] = RGB5_R(gPal[PAL_OFFSET(i, j)]) + 0x40;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 1] = RGB5_G(gPal[PAL_OFFSET(i, j)]) + 0x40;
            gFadeComponents[PAL_OFFSET(i, j) * 3 + 2] = RGB5_B(gPal[PAL_OFFSET(i, j)]) + 0x40;
        }
    }
}

void ColorFadeTick2(void)
{
    // This is a C implementation of the handwritten ARM function ColorFadeTick
    // with the addition of EnablePalSync at the end

    int i, j;
    fi16 red, green, blue;

    for (i = 0x1F; i >= 0; i--)
    {
        if (gFadeComponentStep[i] == 0)
            continue;

        for (j = 0x0F; j >= 0; j--)
        {
            int num = PAL_OFFSET(i, j);

            gFadeComponents[num * 3 + 0] += gFadeComponentStep[i];
            gFadeComponents[num * 3 + 1] += gFadeComponentStep[i];
            gFadeComponents[num * 3 + 2] += gFadeComponentStep[i];

            red = gFadeComponents[num * 3 + 0] - 0x20;

            if (red > 31)
                red = 31;

            if (red < 0)
                red = 0;

            green = gFadeComponents[num * 3 + 1] - 0x20;

            if (green > 31)
                green = 31;

            if (green < 0)
                green = 0;

            blue = gFadeComponents[num * 3 + 2] - 0x20;

            if (blue > 31)
                blue = 31;

            if (blue < 0)
                blue = 0;

            gPal[num] = RGB5(red, green, blue);
        }
    }

    EnablePalSync();
}

void InitBgs(u16 const * opt_config)
{
    SHOULD_BE_STATIC u16 SHOULD_BE_CONST default_config[] = {
        // tile offset, map offset, size id
        0x0000, 0x6000, BG_SIZE_256x256, // BG 0
        0x0000, 0x6800, BG_SIZE_256x256, // BG 1
        0x0000, 0x7000, BG_SIZE_256x256, // BG 2
        0x8000, 0x7800, BG_SIZE_256x256, // BG 3
    };

    int i;

    if (opt_config == NULL)
        opt_config = default_config;

#if MODERN
    gDispIo.bg0_ct = (struct BgCnt) { 0 };
    gDispIo.bg1_ct = (struct BgCnt) { 0 };
    gDispIo.bg2_ct = (struct BgCnt) { 0 };
    gDispIo.bg3_ct = (struct BgCnt) { 0 };
#else
    *(u16 *)&gDispIo.bg0_ct = 0;
    *(u16 *)&gDispIo.bg1_ct = 0;
    *(u16 *)&gDispIo.bg2_ct = 0;
    *(u16 *)&gDispIo.bg3_ct = 0;
#endif

    gDispIo.disp_ct.forced_blank = FALSE;
    gDispIo.disp_ct.mode = 0;

    SetDispEnable(1, 1, 1, 1, 1);
    SetWinEnable(0, 0, 0);

    for (i = 0; i < 4; i++)
    {
        SetBgChrOffset(i, *opt_config++);
        SetBgTilemapOffset(i, *opt_config++);
        SetBgScreenSize(i, *opt_config++);

        SetBgOffset(i, 0, 0);
        TmFill(GetBgTm(i), 0);
    }

    EnableBgSync(BG0_SYNC_BIT | BG1_SYNC_BIT | BG2_SYNC_BIT | BG3_SYNC_BIT);

    InitOam(0);

    gPal[0] = 0;
    EnablePalSync();
}

u16 * GetBgTm(int bg_id)
{
    static u16 * SHOULD_BE_CONST tm_table[] = {
        gBg0Tm,
        gBg1Tm,
        gBg2Tm,
        gBg3Tm,
    };

    return tm_table[bg_id];
}

void SoftResetIfKeyCombo(void)
{
    if (gKeySt->held == (KEY_BUTTON_A + KEY_BUTTON_B + KEY_BUTTON_SELECT + KEY_BUTTON_START))
        SwiSoftReset(GBA_RESET_ALL);
}

void func_02011F4C(int unk_keys)
{
    u16 ie = REG_IE;

    REG_KEYCNT = unk_keys - 0x4000;
    REG_IE &= ~(INTR_FLAG_SERIAL | INTR_FLAG_GAMEPAK);
    REG_IE |= INTR_FLAG_KEYPAD;
    REG_DISPCNT |= DISPCNT_FORCE_BLANK;

    SwiSoundBiasReset();
    asm("swi 3"); // enter sleep mode
    SwiSoundBiasSet();

    REG_IE = ie;
}

void OnHBlankBoth(void)
{
    if (HBlankFuncA)
        HBlankFuncA();

    if (HBlankFuncB)
        HBlankFuncB();
}

void RefreshOnHBlank(void)
{
    int st = 0;

    if (HBlankFuncA != NULL)
        st += 1;

    if (HBlankFuncB != NULL)
        st += 2;

    switch (st)
    {
        case 0:
            // no funcs

            gDispIo.disp_stat.hblank_int_enable = 0;
            REG_IE &= ~INTR_FLAG_HBLANK;

            break;

        case 1:
            // only func A

            gDispIo.disp_stat.hblank_int_enable = 1;

            SetIntrFunc(INT_HBLANK, HBlankFuncA);
            REG_IE |= INTR_FLAG_HBLANK;

            break;

        case 2:
            // only func B

            gDispIo.disp_stat.hblank_int_enable = 1;

            SetIntrFunc(INT_HBLANK, HBlankFuncB);
            REG_IE |= INTR_FLAG_HBLANK;

            break;

        case 3:
            // both funcs

            gDispIo.disp_stat.hblank_int_enable = 1;

            SetIntrFunc(INT_HBLANK, OnHBlankBoth);
            REG_IE |= INTR_FLAG_HBLANK;

            break;
    }
}

void SetOnHBlankA(void (*opt_func)(void))
{
    HBlankFuncA = opt_func;
    RefreshOnHBlank();
}

void SetOnHBlankB(void (*opt_func)(void))
{
    HBlankFuncB = opt_func;
    RefreshOnHBlank();
}
