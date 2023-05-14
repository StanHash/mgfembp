#include "common.h"

#include "armfunc.h"
#include "gbasram.h"
#include "hardware.h"
#include "save_data.h"

#include "unknowns.h"

// this needs to be separate from save_core because each file is compiled using a different compiler somehow

char EWRAM_DATA gUnk_0202F8A4[10] = { 0 };

// I am annoyed because this needs to be here to match
bool EWRAM_DATA gIsSramWorking = FALSE;

bool StringEquals(char const * str_a, char const * str_b)
{
    while (*str_a | *str_b)
    {
        if (*str_a++ != *str_b++)
            return FALSE;
    }

    return TRUE;
}

void StringCopy(char * dst, char const * src)
{
    while (*src)
    {
        *dst++ = *src++;
    }

    *dst = *src;
}

u32 SramChecksum32(void const * sram_src, int size)
{
    ReadSramFast(sram_src, gBuf, size);
    return Checksum32(gBuf, size);
}

bool VerifySaveBlockChecksum(struct SaveBlockInfo const * block_info)
{
    int size = block_info->size;
    void * sram_src = SramOffsetToAddr(block_info->offset);

    u32 checksum32 = SramChecksum32(sram_src, size);

    if (block_info->checksum32 != checksum32)
        return FALSE;
    else
        return TRUE;
}

void PopulateSaveBlockChecksum(struct SaveBlockInfo * block_info)
{
    int size = block_info->size;
    void * sram_src = SramOffsetToAddr(block_info->offset);

    block_info->checksum32 = SramChecksum32(sram_src, size);
}

char const * func_0201473C(u32 bcd_date)
{
    gUnk_0202F8A4[0] = '0' + ((bcd_date >> 20) & 0xF);
    gUnk_0202F8A4[1] = '0' + ((bcd_date >> 16) & 0xF);
    gUnk_0202F8A4[2] = '/';
    gUnk_0202F8A4[3] = '0' + ((bcd_date >> 12) & 0xF);
    gUnk_0202F8A4[4] = '0' + ((bcd_date >> 8) & 0xF);
    gUnk_0202F8A4[5] = '/';
    gUnk_0202F8A4[6] = '0' + ((bcd_date >> 4) & 0xF);
    gUnk_0202F8A4[7] = '0' + ((bcd_date >> 0) & 0xF);
    gUnk_0202F8A4[8] = '\0';

    return gUnk_0202F8A4;
}

void func_02014788(void)
{
}
