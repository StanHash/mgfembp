#ifndef DEBUG_TEXT_H
#define DEBUG_TEXT_H

#include "common.h"

void DebugInitBg(int bg, int vram_offset);
void DebugPutStr(u16 * tm, char const * str);
void DebugPutFmt(u16 * tm, char const * fmt, ...);

void GenNumberStr(int number);
void GenNumberOrBlankStr(int number);
void GenNumberHexStr(int number);

void DebugScreenInit(void);
void DebugPrintFmt(char const * fmt, ...);
void DebugPrintNumber(int number, int length);
void DebugPrintNumberHex(int number, int length);
void DebugPrintStr(char const * str);
void DebugPutScreen(void);
bool DebugUpdateScreen(fu16 held, fu16 pressed);

void DebugInitObj(int obvram_offset, int pal_id);
void DebugPutObjStr(int x, int y, char const * str);
void DebugPutObjNumber(int x, int y, int number, int length);
void DebugPutObjNumberHex(int x, int y, int number, int length);

extern u8 SHOULD_BE_CONST Img_DebugFont[];

// 8 characters + '\0'. least significant digit always at + 7
extern char EWRAM_DATA gNumberStr[9];

#endif // DEBUG_TEXT_H
