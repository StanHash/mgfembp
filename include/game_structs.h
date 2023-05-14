#ifndef GAME_STRUCTS_H
#define GAME_STRUCTS_H

#include "common.h"

enum
{
    PLAY_FLAG_STATSCREENPAGE0 = 1 << 0,
    PLAY_FLAG_STATSCREENPAGE1 = 1 << 1,
    PLAY_FLAG_2 = 1 << 2,
    PLAY_FLAG_TUTORIAL = 1 << 3,
    PLAY_FLAG_4 = 1 << 4,
    PLAY_FLAG_COMPLETE = 1 << 5,
    PLAY_FLAG_HARD = 1 << 6,
    PLAY_FLAG_7 = 1 << 7,

    PLAY_FLAG_STATSCREENPAGE_SHIFT = 0,
    PLAY_FLAG_STATSCREENPAGE_MASK = PLAY_FLAG_STATSCREENPAGE0 | PLAY_FLAG_STATSCREENPAGE1,
};

struct PlaySt
{
    /* 00 */ u32 time_saved;
    /* 04 */ u32 time_chapter_started;
    /* 08 */ int gold; // TODO: is this u32 or i32?
    /* 0C */ u8 save_id;
    /* 0D */ u8 vision;
    /* 0E */ i8 chapter;
    /* 0F */ u8 faction;
    /* 10 */ u16 turn;
    /* 12 */ u8 x_cursor, y_cursor;
    /* 14 */ u8 flags;
    /* 15 */ u8 weather;
    /* 16 */ u16 support_gain;
    /* 18 */ u8 playthrough_id;
    /* 19 */ u8 ending_id : 4;
    /* 19 */ u8 unk_19_4 : 4;
    /* 1A */ u8 last_sort_id;
    /* 1B */ u8 unk_1B;

    /* 1C */ // option bits
    /* bit  0 */ u32 unk_1C_1 : 1;
    /* bit  1 */ u32 config_terrain_mapui : 1; // TODO: constants
    /* bit  2 */ u32 config_unit_mapui : 2;    // TODO: constants
    /* bit  4 */ u32 config_no_auto_cursor : 1;
    /* bit  5 */ u32 config_talk_speed : 2;
    /* bit  7 */ u32 config_walk_speed : 1;
    /* bit  8 */ u32 config_bgm_disable : 1;
    /* bit  9 */ u32 config_se_disable : 1;
    /* bit 10 */ u32 config_window_theme : 2;
    /* bit 12 */ u32 unk_1D_5 : 1;
    /* bit 13 */ u32 unk_1D_6 : 1;
    /* bit 14 */ u32 config_no_auto_end_turn : 1;
    /* bit 15 */ u32 config_no_subtitle_help : 1;
    /* bit 16 */ u32 config_battle_anim : 2;
    /* bit 18 */ u32 config_battle_preview_kind : 2;
    /* bit 20 */ u32 unk_1E_5 : 1;
    /* bit 21 */ u32 unk_1E_6 : 1;
    /* bit 22 */ u32 debug_control_red : 2;
    /* bit 24 */ u32 debug_control_green : 2;
    /* bit 26 */ u32 unk_1F_3 : 6;
};

#endif // GAME_STRUCTS_H
