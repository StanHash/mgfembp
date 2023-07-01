#ifndef GAME_STRUCTS_H
#define GAME_STRUCTS_H

#include "common.h"

#define SUPPLY_ITEM_COUNT 100

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

#define ITEMSLOT_INV_COUNT 5
#define UNIT_WEAPON_EXP_COUNT 8
#define UNIT_SUPPORT_COUNT 10

enum
{
    UNIT_FLAG_HIDDEN = 1 << 0,
    UNIT_FLAG_TURN_ENDED = 1 << 1,
    UNIT_FLAG_DEAD = 1 << 2,
    UNIT_FLAG_NOT_DEPLOYED = 1 << 3,
    UNIT_FLAG_RESCUING = 1 << 4,
    UNIT_FLAG_RESCUED = 1 << 5,
    UNIT_FLAG_HAD_ACTION = 1 << 6,
    UNIT_FLAG_UNDER_ROOF = 1 << 7,
    UNIT_FLAG_SEEN = 1 << 8,
    UNIT_FLAG_CONCEALED = 1 << 9,
    UNIT_FLAG_AI_PROCESSED = 1 << 10,

    UNIT_FLAG_SOLOANIM_1 = 1 << 14,
    UNIT_FLAG_SOLOANIM_2 = 1 << 15,

    // Helpers

    UNIT_FLAG_UNAVAILABLE = UNIT_FLAG_DEAD | UNIT_FLAG_NOT_DEPLOYED,
    UNIT_FLAG_SOLOANIM = UNIT_FLAG_SOLOANIM_1 | UNIT_FLAG_SOLOANIM_2,
};

struct Unit
{
    /* 00 */ struct PInfo const * pinfo;
    /* 04 */ struct JInfo const * jinfo;
    /* 08 */ i8 level;
    /* 09 */ u8 exp;
    /* 0A */ u8 ai_flags;
    /* 0B */ i8 id;
    /* 0C */ u16 flags;
    /* 0E */ i8 x;
    /* 0F */ i8 y;
    /* 10 */ i8 max_hp;
    /* 11 */ i8 hp;
    /* 12 */ i8 pow;
    /* 13 */ i8 skl;
    /* 14 */ i8 spd;
    /* 15 */ i8 def;
    /* 16 */ i8 res;
    /* 17 */ i8 lck;
    /* 18 */ i8 bonus_con;
    /* 19 */ u8 rescue;
    /* 1A */ i8 bonus_mov;
    /* 1B */ // pad?
    /* 1C */ u16 items[ITEMSLOT_INV_COUNT];
    /* 26 */ u8 wexp[UNIT_WEAPON_EXP_COUNT];
    /* 2E */ u8 status : 4;
    /* 2E */ u8 status_duration : 4;
    /* 2F */ u8 torch : 4;
    /* 2F */ u8 barrier : 4;
    /* 30 */ u8 supports[UNIT_SUPPORT_COUNT];
    /* 3A */ // pad?
    /* 3C */ struct UnitSprite * map_sprite;
    /* 40 */ u16 ai_config;
    /* 42 */ u8 ai_a;
    /* 43 */ u8 ai_a_pc;
    /* 44 */ u8 ai_b;
    /* 45 */ u8 ai_b_pc;
    /* 46 */ u8 ai_counter;
    /* 47 */ // pad?
    /* 48 */ // end
};

#endif // GAME_STRUCTS_H
