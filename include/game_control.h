#ifndef GAME_CONTROL_H
#define GAME_CONTROL_H

#include "prelude.h"

#include "proc.h"

struct ProgramProc
{
    /* 00 */ PROC_HEADER;

    /* 29 */ u8 unk_29;
    /* 2A */ u8 unk_2A;
    /* 2B */ u8 unk_2B;
};

void OnVBlank(void);
void OnMain(void);
void StartMainProc(void);

// the functions below are leftovers from the full game
// they don't do anything here and are unused

struct ProgramProc * GetMainProc(void);
void func_020145AC(int unk_29);
void func_020145DC(int unk_2A);
bool func_0201460C(void);
void func_02014634(void);
void func_02014664(void);

extern struct ProcScr SHOULD_BE_CONST ProcScr_Program[];

#endif // GAME_CONTROL_H
