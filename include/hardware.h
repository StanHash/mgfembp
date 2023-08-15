#ifndef HARDWARE_H
#define HARDWARE_H

#include "prelude.h"
#include "vec2.h"

// TODO: move to gbasomething
#define VRAM (void *)0x06000000

enum
{
    FRAMES_PER_SECOND = 60,
    FRAMES_PER_MINUTE = 60 * FRAMES_PER_SECOND,
    FRAMES_PER_HOUR = 60 * FRAMES_PER_MINUTE,
};

enum
{
    BG0_SYNC_BIT = 1 << 0,
    BG1_SYNC_BIT = 1 << 1,
    BG2_SYNC_BIT = 1 << 2,
    BG3_SYNC_BIT = 1 << 3,
};

#if defined(MODERN) && MODERN
#define IO_ALIGNED(n) ALIGNED(n)
#else
#define IO_ALIGNED(n) ALIGNED(4)
#endif

struct IO_ALIGNED(2) DispCnt
{
    /* bit  0 */ u16 mode : 3;
    /* bit  3 */ u16 : 1;
    /* bit  4 */ u16 bitmap_frame : 1;
    /* bit  5 */ u16 hblank_interval_free : 1;
    /* bit  6 */ u16 obj_mapping : 1;
    /* bit  7 */ u16 forced_blank : 1;
    /* bit  8 */ u16 bg0_enable : 1;
    /* bit  9 */ u16 bg1_enable : 1;
    /* bit 10 */ u16 bg2_enable : 1;
    /* bit 11 */ u16 bg3_enable : 1;
    /* bit 12 */ u16 obj_enable : 1;
    /* bit 13 */ u16 win0_enable : 1;
    /* bit 14 */ u16 win1_enable : 1;
    /* bit 15 */ u16 objwin_enable : 1;
};

struct IO_ALIGNED(2) DispStat
{
    /* bit  0 */ u16 vblank : 1;
    /* bit  1 */ u16 hblank : 1;
    /* bit  2 */ u16 vcount : 1;
    /* bit  3 */ u16 vblank_int_enable : 1;
    /* bit  4 */ u16 hblank_int_enable : 1;
    /* bit  5 */ u16 vcount_int_enable : 1;
    /* bit  6 */ u16 : 2;
    /* bit  8 */ u16 vcount_compare : 8;
};

struct IO_ALIGNED(2) BgCnt
{
    /* bit  0 */ u16 priority : 2;
    /* bit  2 */ u16 chr_block : 2;
    /* bit  4 */ u16 : 2;
    /* bit  6 */ u16 mosaic : 1;
    /* bit  7 */ u16 color_depth : 1;
    /* bit  8 */ u16 tm_block : 5;
    /* bit 13 */ u16 wrap : 1;
    /* bit 14 */ u16 size : 2;
};

struct IO_ALIGNED(4) WinCnt
{
    u8 win0_enable_bg0 : 1;
    u8 win0_enable_bg1 : 1;
    u8 win0_enable_bg2 : 1;
    u8 win0_enable_bg3 : 1;
    u8 win0_enable_obj : 1;
    u8 win0_enable_blend : 1;
    u8 : 2;

    u8 win1_enable_bg0 : 1;
    u8 win1_enable_bg1 : 1;
    u8 win1_enable_bg2 : 1;
    u8 win1_enable_bg3 : 1;
    u8 win1_enable_obj : 1;
    u8 win1_enable_blend : 1;
    u8 : 2;

    u8 wout_enable_bg0 : 1;
    u8 wout_enable_bg1 : 1;
    u8 wout_enable_bg2 : 1;
    u8 wout_enable_bg3 : 1;
    u8 wout_enable_obj : 1;
    u8 wout_enable_blend : 1;
    u8 : 2;

    u8 wobj_enable_bg0 : 1;
    u8 wobj_enable_bg1 : 1;
    u8 wobj_enable_bg2 : 1;
    u8 wobj_enable_bg3 : 1;
    u8 wobj_enable_obj : 1;
    u8 wobj_enable_blend : 1;
    u8 : 2;
};

struct IO_ALIGNED(2) BlendCnt
{
    u16 target1_enable_bg0 : 1;
    u16 target1_enable_bg1 : 1;
    u16 target1_enable_bg2 : 1;
    u16 target1_enable_bg3 : 1;
    u16 target1_enable_obj : 1;
    u16 target1_enable_bd : 1;
    u16 effect : 2;
    u16 target2_enable_bg0 : 1;
    u16 target2_enable_bg1 : 1;
    u16 target2_enable_bg2 : 1;
    u16 target2_enable_bg3 : 1;
    u16 target2_enable_obj : 1;
    u16 target2_enable_bd : 1;
};

struct DispIo
{
    /* 00 */ struct DispCnt disp_ct;
    /* 04 */ struct DispStat disp_stat;
    /* 08 */ STRUCT_PAD(0x08, 0x0C);
    /* 0C */ struct BgCnt bg0_ct;
    /* 10 */ struct BgCnt bg1_ct;
    /* 14 */ struct BgCnt bg2_ct;
    /* 18 */ struct BgCnt bg3_ct;
    /* 1C */ struct Vec2u bg_off[4];
    /* 2C */ u8 win0_right, win0_left, win1_right, win1_left;
    /* 30 */ u8 win0_bottom, win0_top, win1_bottom, win1_top;
    /* 34 */ struct WinCnt win_ct;
    /* 38 */ u16 mosaic;
    /* 3A */ STRUCT_PAD(0x3A, 0x3C);
    /* 3C */ struct BlendCnt blend_ct;
    /* 40 */ STRUCT_PAD(0x40, 0x44);
    /* 44 */ u8 blend_coef_a;
    /* 45 */ u8 blend_coef_b;
    /* 46 */ u8 blend_y;
    /* 48 */ u16 bg2pa;
    /* 4A */ u16 bg2pb;
    /* 4C */ u16 bg2pc;
    /* 4E */ u16 bg2pd;
    /* 50 */ u32 bg2x;
    /* 54 */ u32 bg2y;
    /* 58 */ u16 bg3pa;
    /* 5A */ u16 bg3pb;
    /* 5C */ u16 bg3pc;
    /* 5E */ u16 bg3pd;
    /* 60 */ u32 bg3x;
    /* 64 */ u32 bg3y;
    /* 68 */ i8 color_addition;
};

struct KeySt
{
    /* 00 */ u8 repeat_delay;    // initial delay before generating auto-repeat presses
    /* 01 */ u8 repeat_interval; // time between auto-repeat presses
    /* 02 */ u8 repeat_clock;    // (decreased by one each frame, reset to repeat_delay when Presses change and
                                 // repeat_interval when reaches 0)
    /* 04 */ u16 held;           // keys that are currently held down
    /* 06 */ u16 repeated;       // auto-repeated keys
    /* 08 */ u16 pressed;        // keys that went down this frame
    /* 0A */ u16 previous;       // keys that were held down last frame
    /* 0C */ u16 last;
    /* 0E */ u16 ablr_pressed; // 1 for Release (A B L R Only), 0 Otherwise
    /* 10 */ u16 pressed2;
    /* 12 */ u16 time_since_start_select; // Time since last Non-Start Non-Select Button was pressed
};

/**
 * Gets current game time.
 * Under usual circumstances, game time is incremented on each VBlank interrupt (60 times a second).
 * @return the current game time
 */
u32 GetGameTime(void);

/**
 * Overrides current game time.
 * @param time the new game time
 */
void SetGameTime(u32 time);

/**
 * Increments game time by one unit.
 * If the incremented game time would be 1000 hours or more, it will wrap down to 990 hours.
 */
void IncGameTime(void);

/**
 * Formats time value into components suitable for user display.
 * @param time the game time to format
 * @param out_hours address where to output hour count
 * @param out_minutes address where to output minute count
 * @param out_seconds address where to output second count
 * @return TRUE if we are past halfway this second
 */
bool FormatTime(u32 time, u16 * out_hours, u16 * out_minutes, u16 * out_seconds);

/**
 * Enables uploading tilemaps to VRAM on next frame end for the corresponding bgs.
 * This function should be called for committing any changes made to tilemaps.
 * @param bits a bitwise combination BGx_SYNC_BIT flags that define which bgs to enable upload for.
 */
void EnableBgSync(int bits);

/**
 * Enables uploading tilemap to VRAM on next frame end for the corresponding bg.
 * @param bg_id the id of the which bg to enable upload for.
 */
void EnableBgSyncById(int bg_id);

/**
 * Disables uploading tilemaps to VRAM on next frame end for the corresponding bgs.
 * Note that tilemap uploading is disabled automatically at the end of each frame.
 * @param bits a bitwise combination BGx_SYNC_BIT flags that define which bgs to disable upload for.
 */
void DisableBgSync(int bits);

/**
 * Enables uploading palettes to PLTT on next frame end.
 * This function should be called for committing any changes made to palettes.
 */
void EnablePalSync(void);

/**
 * Disables uploading palettes to PLTT on next frame end.
 * Note that palette uploading is disabled automatically at the end of each frame.
 */
void DisablePalSync(void);

/**
 * Applies palette data to the palette buffer.
 * Note that this doesn't upload to palette to PLTT (this is to prevent visual artifacts when done mid-frame).
 * @param color_data address of data to copy
 * @param offset raw offset within the palette buffer to copy to
 * @param size size of data
 */
void ApplyPaletteExt(void const * color_data, int offset, int size);

/**
 * Uploads gDispIo members to the corresponding IO ports.
 * This is usually not called from outside the VBlank handler.
 */
void SyncDispIo(void);

/**
 * Gets the address of the BgCnt for given bg.
 * This will be the address one of the members of gDispIo.
 * @param bg_id the id of the which bg to get the BgCnt for.
 * @return address to the BgCnt object.
 */
struct BgCnt * GetBgCt(fu16 bg_id);

// TODO: doc (it's trivial but tedious)
int GetBgChrOffset(int bg);
int GetBgChrId(int bg, int offset);
int GetBgTilemapOffset(int bg);
void SetBgChrOffset(int bg, int offset);
void SetBgTilemapOffset(int bg, int offset);
void SetBgScreenSize(int bg, int size);
void SetBgBpp(int bg, int bpp);

/**
 * Uploads any bg tilemaps or palettes (whicher were enabled for upload).
 * This is usually not called from outside the VBlank handler.
 */
void SyncBgsAndPal(void);

/**
 * Fills tilemap with given tile value.
 * @param tm address of tilemap. This must be an array of 32 * 32 u16 tiles.
 * @param tile the tile value to fill the tilemap with (usually 0).
 */
void TmFill(u16 * tm, int tile);

/**
 * Clears graphics of given 4bpp chr in VRAM with zeroes.
 * This is done asynchroneously (on next frame end).
 * @param chr index of which chr to clear.
 */
void SetBlankChr(int chr);

/**
 * Sets VBlank handler.
 * This is an utility function that wraps SetIntrFunc while also enabling/disabling the necessary IO settings.
 * @param opt_func address of new VBlank handler (can be NULL).
 */
void SetOnVBlank(void (*opt_func)(void));

/**
 * Sets VMatch handler.
 * This is an utility function that wraps SetIntrFunc while also enabling/disabling the necessary IO settings.
 * @param opt_func address of new VMatch handler (can be NULL).
 */
void SetOnVMatch(void (*opt_func)(void));

void SetNextVCount(int vcount);
void SetVCount(int vcount);
void SetMainFunc(void (*opt_func)(void));
void RunMainFunc(void);
void RefreshKeyStFromKeys(struct KeySt * key_st, short keys);
void RefreshKeySt(struct KeySt * key_st);
void ClearKeySt(struct KeySt * key_st);
void InitKeySt(struct KeySt * key_st);
void SetBgOffset(fu16 bgid, fu16 x_offset, fu16 y_offset);
void func_020111D8(void);
void func_0201120C(fu8 a, fu8 b);
void func_02011240(u16 * a, u16 * b);
void func_02011280(void * tm, void const * in_data, fu8 base, fu8 linebits);
void func_0201135C(u16 * tm, i16 const * in_data, int unused);
void ColorFadeClear(void);
void ColorFadeSetupFromToPaletteAuto(u16 const * in_pal, int pal_num, int pal_count, int component_step);
void ColorFadeSetupRange(int pal_num, int pal_count, int add, int component_step);
void ColorFadeSetRangeStep(int pal_num, int pal_count, int component_step);
void ColorFadeSetupFromColorToBlack(fi8 component_step);
void ColorFadeSetupFromBlack(fi8 component_step);
void ColorFadeSetupFromColorToWhite(fi8 component_step);
void ColorFadeSetupFromWhite(fi8 component_step);
void ColorFadeTick2(void);

/**
 * Initializes/resets bg related objects (tilemap, BgCnt, ...).
 * The opt_config parameter can be used to override the default VRAM allocation for bgs.
 *
 * It should be an array of 4 * 3 items, 3 entries for each background:
 * - opt_config[3 * bg + 0] holds the VRAM offset for the bg's chr data (eg. 0x0000).
 * - opt_config[3 * bg + 1] holds the VRAM offset for the bg's tilemap (eg. 0x6000).
 * - opt_config[3 * bg + 2] holds the identifier for the bg's tilemap size (usually 256x256).
 *
 * @param opt_config address of bg config (can be NULL).
 */
void InitBgs(u16 const * opt_config);

u16 * GetBgTm(int bg_id);
void SoftResetIfKeyCombo(void);
void func_02011F4C(int unk_keys);
void OnHBlankBoth(void);
void RefreshOnHBlank(void);
void SetOnHBlankA(void (*opt_func)(void));
void SetOnHBlankB(void (*opt_func)(void));

extern u8 gBuf[0x2000];

extern struct DispIo gDispIo;

extern u16 gPal[0x200];
extern u16 gBg0Tm[0x400];
extern u16 gBg1Tm[0x400];
extern u16 gBg2Tm[0x400];
extern u16 gBg3Tm[0x400];

extern struct KeySt * SHOULD_BE_CONST gKeySt;

#define CHR_SIZE 0x20

#define RGB5(r, g, b) (((b) << 10) + ((g) << 5) + (r))

#define RGB5_R(color) (0x1F & (color))
#define RGB5_G(color) (0x1F & ((color) >> 5))
#define RGB5_B(color) (0x1F & ((color) >> 10))

#define TM_OFFSET(x, y) (((y) << 5) + (x))
#define PAL_OFFSET(pal_id, color_num) (0x10 * (pal_id) + (color_num))

#define ApplyPalettes(src, num, count) ApplyPaletteExt((src), 0x20 * (num), 0x20 * (count))
#define ApplyPalette(src, num) ApplyPalettes((src), (num), 1)

#define SetDispEnable(bg0, bg1, bg2, bg3, obj)                                                                         \
    gDispIo.disp_ct.bg0_enable = (bg0);                                                                                \
    gDispIo.disp_ct.bg1_enable = (bg1);                                                                                \
    gDispIo.disp_ct.bg2_enable = (bg2);                                                                                \
    gDispIo.disp_ct.bg3_enable = (bg3);                                                                                \
    gDispIo.disp_ct.obj_enable = (obj)

#define SetWinEnable(win0, win1, objwin)                                                                               \
    gDispIo.disp_ct.win0_enable = (win0);                                                                              \
    gDispIo.disp_ct.win1_enable = (win1);                                                                              \
    gDispIo.disp_ct.objwin_enable = (objwin)

#define SetWin0Box(left, top, right, bottom)                                                                           \
    gDispIo.win0_left = (left);                                                                                        \
    gDispIo.win0_top = (top);                                                                                          \
    gDispIo.win0_right = (right);                                                                                      \
    gDispIo.win0_bottom = (bottom)

#define SetWin1Box(left, top, right, bottom)                                                                           \
    gDispIo.win1_left = (left);                                                                                        \
    gDispIo.win1_top = (top);                                                                                          \
    gDispIo.win1_right = (right);                                                                                      \
    gDispIo.win1_bottom = (bottom)

#define SetWin0Layers(bg0, bg1, bg2, bg3, obj)                                                                         \
    gDispIo.win_ct.win0_enable_bg0 = (bg0);                                                                            \
    gDispIo.win_ct.win0_enable_bg1 = (bg1);                                                                            \
    gDispIo.win_ct.win0_enable_bg2 = (bg2);                                                                            \
    gDispIo.win_ct.win0_enable_bg3 = (bg3);                                                                            \
    gDispIo.win_ct.win0_enable_obj = (obj)

#define SetWin1Layers(bg0, bg1, bg2, bg3, obj)                                                                         \
    gDispIo.win_ct.win1_enable_bg0 = (bg0);                                                                            \
    gDispIo.win_ct.win1_enable_bg1 = (bg1);                                                                            \
    gDispIo.win_ct.win1_enable_bg2 = (bg2);                                                                            \
    gDispIo.win_ct.win1_enable_bg3 = (bg3);                                                                            \
    gDispIo.win_ct.win1_enable_obj = (obj)

#define SetWObjLayers(bg0, bg1, bg2, bg3, obj)                                                                         \
    gDispIo.win_ct.wobj_enable_bg0 = (bg0);                                                                            \
    gDispIo.win_ct.wobj_enable_bg1 = (bg1);                                                                            \
    gDispIo.win_ct.wobj_enable_bg2 = (bg2);                                                                            \
    gDispIo.win_ct.wobj_enable_bg3 = (bg3);                                                                            \
    gDispIo.win_ct.wobj_enable_obj = (obj)

#define SetWOutLayers(bg0, bg1, bg2, bg3, obj)                                                                         \
    gDispIo.win_ct.wout_enable_bg0 = (bg0);                                                                            \
    gDispIo.win_ct.wout_enable_bg1 = (bg1);                                                                            \
    gDispIo.win_ct.wout_enable_bg2 = (bg2);                                                                            \
    gDispIo.win_ct.wout_enable_bg3 = (bg3);                                                                            \
    gDispIo.win_ct.wout_enable_obj = (obj)

#define SetBlendConfig(eff, ca, cb, cy)                                                                                \
    gDispIo.blend_ct.effect = (eff);                                                                                   \
    gDispIo.blend_coef_a = (ca);                                                                                       \
    gDispIo.blend_coef_b = (cb);                                                                                       \
    gDispIo.blend_y = (cy)

#define SetBlendAlpha(ca, cb) SetBlendConfig(BLEND_EFFECT_ALPHA, (ca), (cb), 0)

#define SetBlendBrighten(cy) SetBlendConfig(BLEND_EFFECT_BRIGHTEN, 0, 0, (cy))

#define SetBlendDarken(cy) SetBlendConfig(BLEND_EFFECT_DARKEN, 0, 0, (cy))

#define SetBlendNone() SetBlendConfig(BLEND_EFFECT_NONE, 0x10, 0, 0)

#if BUGFIX

// fixes violation of strict aliasing rules

#define SetBlendTargetA(bg0, bg1, bg2, bg3, obj)                                                                       \
    gDispIo.blend_ct.target1_enable_bg0 = (bg0);                                                                       \
    gDispIo.blend_ct.target1_enable_bg1 = (bg1);                                                                       \
    gDispIo.blend_ct.target1_enable_bg2 = (bg2);                                                                       \
    gDispIo.blend_ct.target1_enable_bg3 = (bg3);                                                                       \
    gDispIo.blend_ct.target1_enable_obj = (obj)

#define SetBlendTargetB(bg0, bg1, bg2, bg3, obj)                                                                       \
    gDispIo.blend_ct.target2_enable_bg0 = (bg0);                                                                       \
    gDispIo.blend_ct.target2_enable_bg1 = (bg1);                                                                       \
    gDispIo.blend_ct.target2_enable_bg2 = (bg2);                                                                       \
    gDispIo.blend_ct.target2_enable_bg3 = (bg3);                                                                       \
    gDispIo.blend_ct.target2_enable_obj = (obj)

#else

#define SetBlendTargetA(bg0, bg1, bg2, bg3, obj)                                                                       \
    *((u16 *)&gDispIo.blend_ct) &= ~BLDCNT_TARGETA(1, 1, 1, 1, 1);                                                     \
    *((u16 *)&gDispIo.blend_ct) |= BLDCNT_TARGETA((bg0), (bg1), (bg2), (bg3), (obj))

#define SetBlendTargetB(bg0, bg1, bg2, bg3, obj)                                                                       \
    *((u16 *)&gDispIo.blend_ct) &= ~BLDCNT_TARGETB(1, 1, 1, 1, 1);                                                     \
    *((u16 *)&gDispIo.blend_ct) |= BLDCNT_TARGETB((bg0), (bg1), (bg2), (bg3), (obj))

#endif

#define SetBlendBackdropA(enable) gDispIo.blend_ct.target1_enable_bd = (enable)

#define SetBlendBackdropB(enable) gDispIo.blend_ct.target2_enable_bd = (enable)

#define SetBackdropColor(color)                                                                                        \
    gPal[0] = (color);                                                                                                 \
    EnablePalSync()

#endif // HARDWARE_H
