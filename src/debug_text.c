#include "debug_text.h"

#include "armfunc.h"
#include "async_upload.h"
#include "gbaio.h"
#include "hardware.h"
#include "oam.h"
#include "sprite.h"

#include <stdarg.h>

#define BGCHR_DEBUGTEXT_DEFAULT 0x2C0

#define OBCHR_DEBUGTEXT_DEFAULT 0x180

struct DebugTextSt
{
    /* 00 */ i32 vram_offset;
    /* 04 */ i16 bg;
    /* 06 */ u16 chr;
    /* 08 */ i32 hcur;
    /* 0C */ u32 vcur;
    /* 10 */ u32 vdisp;
    /* 14 */ char screen[256][32];
};

struct DebugTextSt EWRAM_DATA gDebugTextSt = { 0 };

char EWRAM_DATA gNumberStr[9] = { 0 };

int EWRAM_DATA gDebugOam2Chr = 0;
int EWRAM_DATA gDebugOam2Pal = 0;

void DebugInitBg(int bg, int vram_offset)
{
    if (vram_offset == 0)
        vram_offset = BGCHR_DEBUGTEXT_DEFAULT * CHR_SIZE;

    SetBgChrOffset(bg, 0);
    SetBgScreenSize(bg, BG_SIZE_256x256);

    AsyncDataUploadVram(Img_DebugFont, vram_offset, 0x40 * CHR_SIZE);

    gPal[PAL_OFFSET(0, 0)] = RGB5(0, 0, 0);
    gPal[PAL_OFFSET(0, 2)] = RGB5(31, 31, 31);

    EnablePalSync();

    TmFill(GetBgTm(bg), 0);

    gDebugTextSt.bg = bg;
    gDebugTextSt.vram_offset = vram_offset;
    gDebugTextSt.chr = GetBgChrId(bg, vram_offset);
}

void DebugPutStr(u16 * tm, char const * str)
{
    while (*str)
    {
        *tm = *str > '`' ? *str - '`' + (gDebugTextSt.chr + 0x20) : *str - ' ' + (gDebugTextSt.chr);

        tm++;
        str++;
    }

    EnableBgSyncById(gDebugTextSt.bg);
}

void DebugPutFmt(u16 * tm, char const * fmt, ...)
{
    char buffer[0x100];
    va_list args;

    va_start(args, fmt);
    // vsprintf(buffer, fmt, args);
    va_end(args);

    DebugPutStr(tm, buffer);
}

void DebugScreenInit(void)
{
    int i;

    for (i = 0; i < 0x100; i++)
        gDebugTextSt.screen[i & 0xFF][0] = '\0';

    gDebugTextSt.hcur = 0;
    gDebugTextSt.vcur = 0;

    TmFill(gBg2Tm, 0);
    EnableBgSync(BG2_SYNC_BIT);
}

void DebugPrintFmt(char const * fmt, ...)
{
    char buffer[0x100];
    va_list args;

    va_start(args, fmt);
    // vsprintf(buffer, fmt, args);
    va_end(args);

    DebugPrintStr(buffer);
}

static void ClearNumberStr(void)
{
    u32 * ptr = (u32 *)gNumberStr;

    *ptr++ = 0x20202020; // '    '
    *ptr = 0x20202020;   // '    '

    gNumberStr[8] = 0;
}

void GenNumberStr(int number)
{
    int i;

    ClearNumberStr();

    for (i = 7; i >= 0; i--)
    {
        gNumberStr[i] = '0' + number % 10;

        number /= 10;

        if (number == 0)
            break;
    }
}

void GenNumberOrBlankStr(int number)
{
    ClearNumberStr();

    if (number == 255 || number == -1)
    {
        gNumberStr[6] = gNumberStr[7] = ':';
    }
    else
    {
        GenNumberStr(number);
    }
}

void DebugPrintNumber(int number, int length)
{
    GenNumberStr(number);
    DebugPrintStr(gNumberStr + 8 - length);
}

void GenNumberHexStr(int number)
{
    static char const hex_digits[] = "0123456789ABCDEF";

    int i;

    ClearNumberStr();

    for (i = 7; i >= 0; i--)
    {
        gNumberStr[i] = hex_digits[number & 0xF];

        number >>= 4;

        if (number == 0)
            break;
    }
}

void DebugPrintNumberHex(int number, int length)
{
    GenNumberHexStr(number);
    DebugPrintStr(gNumberStr + 8 - length);
}

void DebugPrintStr(char const * str)
{
    while (*str)
    {
        char chr = *str;

        if (gDebugTextSt.hcur == 0x30)
            chr = 0;
        else
            str++;

        if (chr == '\n')
            chr = 0;

        gDebugTextSt.screen[gDebugTextSt.vcur & 0xFF][gDebugTextSt.hcur] = chr;
        gDebugTextSt.hcur++;

        if (chr == 0)
        {
            gDebugTextSt.hcur = 0;
            gDebugTextSt.vcur++;
        }
    }

    if (gDebugTextSt.vcur > gDebugTextSt.vdisp + 20)
        gDebugTextSt.vdisp = gDebugTextSt.vcur - 20;
}

void DebugPutScreen(void)
{
    u16 * tm;
    u16 chr;
    int ih, iv;

    TmFill(gBg2Tm, 0);

    for (iv = 0; iv < 20; iv++)
    {
        tm = gBg2Tm + TM_OFFSET(0, iv);

        for (ih = 0; gDebugTextSt.screen[(iv + gDebugTextSt.vdisp) & 0xFF][ih]; ++tm, ++ih)
        {
            chr = gDebugTextSt.screen[(iv + gDebugTextSt.vdisp) & 0xFF][ih];

            if (chr > '`')
                chr = chr - 0x40;
            else
                chr = chr - 0x20;

            *tm = chr + gDebugTextSt.chr;
        }
    }

    EnableBgSync(BG2_SYNC_BIT);
}

bool DebugUpdateScreen(fu16 held, fu16 pressed)
{
    int top, bottom;

    if (pressed & KEY_BUTTON_B)
        return FALSE;

    DebugPutScreen();

    top = gDebugTextSt.vcur - 256;

    if (top < 0)
        top = 0;

    bottom = gDebugTextSt.vcur - 20;

    if (bottom < 0)
        bottom = 0;

    if ((held & KEY_DPAD_UP) && top < gDebugTextSt.vdisp)
        gDebugTextSt.vdisp--;

    if ((held & KEY_DPAD_DOWN) && bottom > gDebugTextSt.vdisp)
        gDebugTextSt.vdisp++;

    return TRUE;
}

void DebugInitObj(int obvram_offset, int pal_id)
{
    if (obvram_offset < 0)
        obvram_offset = OBCHR_DEBUGTEXT_DEFAULT * CHR_SIZE;

    obvram_offset &= 0xFFFF;

    gDebugOam2Chr = obvram_offset / CHR_SIZE;
    gDebugOam2Pal = OAM2_PAL(pal_id);

    AsyncDataUploadVram(Img_DebugFont, 0x10000 + obvram_offset, 0x40 * CHR_SIZE);

    gPal[PAL_OFFSET(0x10 + pal_id, 0)] = RGB5(0, 0, 0);
    gPal[PAL_OFFSET(0x10 + pal_id, 1)] = RGB5(0, 0, 31);
    gPal[PAL_OFFSET(0x10 + pal_id, 2)] = RGB5(31, 31, 31);

    EnablePalSync();
}

void DebugPutObjStr(int x, int y, char const * str)
{
    while (*str)
    {
        char chr = *str > 0x60 ? *str - 0x40 : *str - 0x20;

        PutOamHi(x, y, Sprite_8x8, chr + gDebugOam2Chr + gDebugOam2Pal);

        x += 8;
        str++;
    }
}

void DebugPutObjNumber(int x, int y, int number, int length)
{
    GenNumberStr(number);
    DebugPutObjStr(x, y, gNumberStr + 8 - length);
}

void DebugPutObjNumberHex(int x, int y, int number, int length)
{
    GenNumberHexStr(number);
    DebugPutObjStr(x, y, gNumberStr + 8 - length);
}

u32 SHOULD_BE_CONST Img_DebugFont[] = {
#include "embed/debug_font.4bpp.u32"
};
