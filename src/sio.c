#include "common.h"

#include "async_upload.h"
#include "gbaio.h"
#include "gbasvc.h"
#include "hardware.h"
#include "interrupts.h"

#include "unknowns.h"

struct Unk_Sio_134
{
    /* 00 */ u8 unk_00;
    /* 01 */ STRUCT_PAD(0x01, 0x04);
    /* 04 */ u8 unk_04;
    /* 05 */ STRUCT_PAD(0x05, 0x0A);
    /* 0A */ u8 unk_0A[0x80];
    /* 8A */ STRUCT_PAD(0x8A, 0x8C);
    /* 8C */ // end
};

struct Unk_Sio
{
    /* 000 */ u8 unk_000;
    /* 001 */ u8 unk_001;
    /* 002 */ u16 unk_002;
    /* 004 */ u16 unk_004;
    /* 006 */ i8 unk_006;
    /* 007 */ u8 unk_007;
    /* 008 */ u8 unk_008;
    /* 009 */ u8 unk_009;
    /* 00A */ u8 unk_00A;
    /* 00B */ u8 unk_00B[4];
    /* 00F */ u8 unk_00F;
    /* 010 */ u8 unk_010;
    /* 011 */ u8 unk_011;
    /* 012 */ u16 unk_012[4];
    /* 01A */ u8 unk_01A[4];
    /* 01E */ u8 unk_01E;
    /* 01F */ u8 unk_01F;
    /* 020 */ u8 unk_020;
    /* 021 */ STRUCT_PAD(0x021, 0x022); // implicit
    /* 022 */ u16 unk_022;
    /* 024 */ u16 unk_024;
    /* 026 */ u16 unk_026[4];
    /* 02E */ u8 unk_02E;
    /* 02F */ STRUCT_PAD(0x02F, 0x030); // implicit
    /* 030 */ u16 unk_030;
    /* 032 */ u16 unk_032[0x80];
    /* 132 */ STRUCT_PAD(0x132, 0x134); // implicit
    /* 134 */ struct Unk_Sio_134 unk_134[8];
    /* 594 */ struct Unk_Sio_134 unk_594[4];
    /* 7C4 */ u8 unk_7C4;
    /* 7C5 */ u8 unk_7C5;
    /* 7C6 */ u8 unk_7C6;
    /* 7C7 */ u8 unk_7C7;
    /* 7C8 */ u16 unk_7C8;
    /* 7CA */ u16 unk_7CA;
    /* 7CC */ u16 unk_7CC;
    /* 7CE */ u16 unk_7CE;
};

struct Unk_Sio EWRAM_DATA gUnk_Sio_0202F8B0 = { 0 };
struct Unk_Sio * SHOULD_BE_CONST gUnk_Sio_02018648 = &gUnk_Sio_0202F8B0;

u16 EWRAM_DATA gUnk_Sio_02030080[0x200] = { 0 };
u16 EWRAM_DATA gUnk_Sio_02030480[0x200][4] = { 0 };

static u8 s_sio_cnt;
static int s_sio_id;

static u8 s_pad_03000040[4];

static u32 s_unk_03000044;
static u16 s_unk_03000048;
static u16 s_unk_0300004A;

static int s_pad_0300004C;

static u16 s_unk_03000050[4];
static u16 s_unk_03000058[4];

// COMMON
extern int gUnk_Sio_03001C34;
extern int gSioStateId;
extern u32 gUnk_Sio_03001C30;
extern u8 gUnk_Sio_03002E50[0x80];
extern u16 gUnk_Sio_06_03001C30[4];
extern u16 gUnk_Sio_06_03001CC8[4];
extern u16 gUnk_Sio_06_03002E58[4];

// TODO: what to do here? This is improvable
struct Sio
{
    u16 siocnt;
    u16 siodata;
};

#define SIO ((struct Sio *)(&REG_SIOCNT))

int func_02014C94(void)
{
    fu16 siocnt;

    switch (gSioStateId)
    {
        case 0:
            REG_RCNT = 0;
            REG_SIOCNT = s_sio_cnt | SIO_INTR_ENABLE | SIO_MULTI_MODE;

            siocnt = REG_SIOCNT;

            if ((siocnt & SIO_MULTI_SD) != 0)
            {
                s_sio_id = siocnt & SIO_MULTI_SI;

                if (s_sio_id != 0)
                    s_sio_id = -1;

                gUnk_Sio_03001C34 = 0;
                gSioStateId = 1;
            }

            return -1;

        case 1:
            siocnt = REG_SIOCNT;

            if (gUnk_Sio_03001C34 != 0 && (siocnt & SIO_ERROR) == 0 && gUnk_Sio_02018648->unk_012[1] != UINT16_MAX)
            {
                s_sio_id = (siocnt & SIO_ID) >> 4; // TODO: shift constant
                gSioStateId = 2;

                if (s_sio_id == 0)
                    REG_IE &= ~INTR_FLAG_SERIAL;

                return s_sio_id;
            }
            else
            {
                SIO->siodata = ~gUnk_Sio_02018648->unk_7C8;

                if (s_sio_id != 0)
                {
                    REG_SIOCNT = s_sio_cnt | SIO_INTR_ENABLE | SIO_MULTI_MODE;
                }
                else
                {
                    REG_SIOCNT = s_sio_cnt | SIO_INTR_ENABLE | SIO_MULTI_MODE | SIO_MULTI_BUSY;
                }

                return -1;
            }

        default:
            return s_sio_id;
    }
}

int func_02014DB0(void)
{
    return (REG_SIOCNT & SIO_ID) >> 4; // TODO: shift constant
}

void func_02014DC0(fu16 arg_0, fu16 arg_1, fu16 arg_2)
{
    gUnk_Sio_02018648->unk_7C8 = arg_0;
    gUnk_Sio_02018648->unk_7CA = arg_1;
    gUnk_Sio_02018648->unk_7CC = arg_2;
    s_sio_cnt = arg_1;
}

void func_02014DF4(void)
{
    int j, i;

    // TODO: constants

    gUnk_Sio_03001C30 = 0;

    gUnk_Sio_02018648->unk_022 = 0;
    gUnk_Sio_02018648->unk_024 = 0;
    gUnk_Sio_02018648->unk_7C4 = 0;
    gUnk_Sio_02018648->unk_7C5 = 0;
    gUnk_Sio_02018648->unk_7C6 = 0;
    gUnk_Sio_02018648->unk_7C7 = 0;
    gUnk_Sio_02018648->unk_01E = 0;
    gUnk_Sio_02018648->unk_01F = 0;
    gUnk_Sio_02018648->unk_020 = 0;
    gUnk_Sio_02018648->unk_030 = 0;

    for (i = 0; i < 4; i++)
    {
        gUnk_Sio_02018648->unk_00B[i] = 0;
        gUnk_Sio_02018648->unk_012[i] = UINT16_MAX;
        gUnk_Sio_02018648->unk_01A[i] = 0;
        gUnk_Sio_02018648->unk_026[i] = 0;
    }

    for (i = 0; i < 0x80; i++)
    {
        gUnk_Sio_03002E50[i] = 0;
        gUnk_Sio_02018648->unk_032[i] = 0;
    }

    for (j = 0; j < 8; j++)
    {
        struct Unk_Sio_134 * ent = &gUnk_Sio_02018648->unk_134[j];

        ent->unk_00 = 0;
        ent->unk_04 = 0;

        for (i = 0; i < (int)ARRAY_COUNT(ent->unk_0A); i++)
            ent->unk_0A[i] = 0;
    }

    for (j = 0; j < 4; j++)
    {
        struct Unk_Sio_134 * ent = &gUnk_Sio_02018648->unk_594[j];

        ent->unk_00 = 0;
        ent->unk_04 = 0;

        for (i = 0; i < (int)ARRAY_COUNT(ent->unk_0A); i++)
            ent->unk_0A[i] = 0;
    }

    s_unk_03000048 = s_unk_0300004A = 0;

    for (i = 0; i < 0x200; i++)
    {
        gUnk_Sio_02030080[i] = 0;
    }

    for (j = 0; j < 4; j++)
    {
        s_unk_03000050[j] = s_unk_03000058[j] = 0;

        for (i = 0; i < 0x200; i++)
        {
            gUnk_Sio_02030480[i][j] = 0;
        }
    }
}

void func_02014F80(void)
{
    int i;

    gUnk_Sio_02018648->unk_000 = 0;
    gUnk_Sio_02018648->unk_001 = 0;
    gUnk_Sio_02018648->unk_002 = 0;
    gUnk_Sio_02018648->unk_004 = 0;
    gUnk_Sio_02018648->unk_006 = UINT8_MAX;
    gUnk_Sio_02018648->unk_007 = 0;
    gUnk_Sio_02018648->unk_008 = 0;
    gUnk_Sio_02018648->unk_009 = 0;
    gUnk_Sio_02018648->unk_00F = 0;
    gUnk_Sio_02018648->unk_010 = 0;
    gUnk_Sio_02018648->unk_011 = 0;
    gUnk_Sio_02018648->unk_02E = 0;
    gUnk_Sio_02018648->unk_00A = 0;

    func_02014DC0(0x4321, 3, 0xF);
    func_common_02016114(0);
    func_02014DF4();

    s_unk_03000044 = 0;

#if defined(VER_20030206)
    for (i = 0; i < 4; i++)
    {
        gUnk_Sio_06_03002E58[i] = gUnk_Sio_06_03001C30[i] = gUnk_Sio_06_03001CC8[i] = 0;
    }
#endif
}

void func_common_02014FE8(void)
{
    // Multi-Player mode SIO
    REG_RCNT = 0;
    REG_SIOCNT = s_sio_cnt | SIO_MULTI_MODE;

    REG_TM3CNT_H = 0;

    gUnk_Sio_03001C34 = gUnk_Sio_03001C30 = 0;
    gSioStateId = 0;
    s_sio_id = -1;

    SetIntrFunc(INT_SERIAL, func_common_020150C4);
    SetIntrFunc(INT_SERIAL, func_common_020150C4);

    REG_IE |= INTR_FLAG_TIMER3 | INTR_FLAG_SERIAL;
}

void func_common_02015064(void)
{
    // general purpose SIO
    REG_RCNT = 0x8000;
    REG_SIOCNT = 0;

    gUnk_Sio_03001C34 = gUnk_Sio_03001C30 = 0;
    gSioStateId = 0;
    s_sio_id = -1;

    SetIntrFunc(INT_SERIAL, NULL);
    SetIntrFunc(INT_SERIAL, NULL);

    REG_IE &= ~(INTR_FLAG_TIMER3 | INTR_FLAG_SERIAL);
}

void func_common_020150C4(void)
{
    int i;
    u16 recv[4];
    u16 var_08;
    fu16 siocnt;

    fu16 sb = 0;

    // TODO: constants

    gUnk_Sio_03001C34 = 1;
    gUnk_Sio_02018648->unk_01E = 0;
    gUnk_Sio_03001C30 = 1;
    gUnk_Sio_02018648->unk_008 = 0;

    REG_TM3CNT_H = 0;

    gUnk_Sio_02018648->unk_002 = siocnt = REG_SIOCNT;

    if (gUnk_Sio_02018648->unk_004 != 6)
    {
        gUnk_Sio_02018648->unk_006 = (siocnt >> 4) & 3;
    }

    // ew
    *(u64 *)(recv) = REG_SIOMLT_RECV;

    REG_SIOCNT = s_sio_cnt | SIO_MULTI_MODE | SIO_INTR_ENABLE;
    SIO->siodata = 0x7FFF;

    for (i = 0; i < 4; i++)
    {
        if (recv[i] != 0 && recv[i] != 0xFFFF)
        {
            if (gUnk_Sio_02018648->unk_00B[i] == 0)
                gUnk_Sio_02018648->unk_00B[i] = 1;

            gUnk_Sio_02018648->unk_008 |= 1 << i;
        }
        else
        {
            if (func_common_0201592C(i) == TRUE)
            {
                if (gUnk_Sio_02018648->unk_012[i] == 0xFFFF)
                {
                    gUnk_Sio_02018648->unk_01A[i]++;
                }
                else
                {
                    gUnk_Sio_02018648->unk_01A[i] = 0;
                }
            }
        }

        gUnk_Sio_02018648->unk_012[i] = gUnk_Sio_02030480[s_unk_03000058[i]][i] = recv[i];

        s_unk_03000058[i] = (s_unk_03000058[i] + 1) & 0x1FF;
    }

    if (gUnk_Sio_02018648->unk_004 > 4)
    {
        switch (gUnk_Sio_02018648->unk_001)
        {
            case 1:
                if (s_unk_0300004A != s_unk_03000048)
                {
                    var_08 = gUnk_Sio_02030080[s_unk_03000048];
                    s_unk_03000048 = (s_unk_03000048 + 1) & 0x1FF;
                    func_common_02015CEC(&var_08, 1);
                }

                if (gUnk_Sio_02018648->unk_006 == 0 && gUnk_Sio_02018648->unk_7CC != 0)
                {
                    REG_SIOCNT |= 0x80;
                    REG_TM3CNT = -gUnk_Sio_02018648->unk_7CC;
                    REG_TM3CNT_H = 0xC3;
                }

                break;

            case 3:
                if (gUnk_Sio_02018648->unk_006 != 0)
                {
                    func_common_02015CEC(&gUnk_Sio_02018648->unk_030, 1);
                    gUnk_Sio_02018648->unk_030 = 0x5FFF;
                }

                for (i = 0; i < 4; i++)
                {
                    if (func_common_0201592C(i) && recv[i] != 0x9ABC)
                        sb++;
                }

                if (sb == 0)
                    gUnk_Sio_02018648->unk_7CE = 1;

                break;
        }
    }

    gUnk_Sio_03001C30 = 0;
}

void func_common_02015314(void)
{
    INTR_CHECK = INTR_FLAG_VBLANK;

    SyncDispIo();
    SyncBgsAndPal();
    ApplyAsyncUploads();
}

void func_common_02015330(void)
{
    SwiVBlankIntrWait();
}
