#include "common.h"

#include "async_upload.h"
#include "gbaio.h"
#include "gbasvc.h"
#include "hardware.h"
#include "interrupts.h"
#include "proc.h"

#if defined(VER_20030206)
#include "debug_text.h"
#endif

#include "unknowns.h"

enum
{
#if !defined(VER_FINAL)
    SIO_UNK_C4 = 0x14,
#else
    SIO_UNK_C4 = 0xC4,
#endif
    SIO_UNK_C5,
    SIO_UNK_C6,
    SIO_UNK_C7,
    SIO_UNK_C8,
    SIO_UNK_C9,
    SIO_UNK_CA,
    SIO_UNK_CB,
    SIO_UNK_CC,
    SIO_UNK_CD,
    SIO_UNK_CE,
    SIO_UNK_CF,
};

// TODO: clean up structs

struct Sio_Unk_03002E40
{
    /* 00 */ u8 unk_00;
    /* 01 */ u8 unk_01;
    /* 02 */ u16 unk_02;
};

struct DatBody
{
    u16 unk_04;
    u8 unk_06[0x80];
};

struct Unk_Sio_134
{
    /* 00 */ u8 unk_00;
    /* 01 */ STRUCT_PAD(0x01, 0x04);
    /* 04 */ u8 unk_04;
    /* 05 */ u8 unk_05;
    /* 06 */ u16 unk_06;
    /* 08 */ u16 unk_08;
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
    /* 021 */ u8 unk_021;
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

struct Dat
{
    struct Sio_Unk_03002E40 head;
    struct DatBody body;
};

struct Unk_Sio EWRAM_DATA gUnk_Sio_0202F8B0 = { 0 };
struct Unk_Sio * SHOULD_BE_CONST gUnk_Sio_02018648 = &gUnk_Sio_0202F8B0;

u16 EWRAM_DATA gUnk_Sio_02030080[0x200] = { 0 };
u16 EWRAM_DATA gUnk_Sio_02030480[0x200][4] = { 0 };

static u8 s_sio_cnt;
static int s_sio_id;

static struct Unk_Sio_134 * s_unk_03000040;

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
extern struct Sio_Unk_03002E40 gUnk_Sio_03002E40;

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

    // TODO: constants, cleanup

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

void func_common_0201533C(void)
{
    ApplyPalette(Pal_Unk_02017C74, 0);
    Decompress(Img_Unk_02017374, VRAM + GetBgChrOffset(1));
    Decompress(Tm_Unk_02017AA8, gBg1Tm);
    EnableBgSync(BG1_SYNC_BIT);
}

void func_common_02015384(void)
{
    InitBgs(NULL);
    InitProcs();

    SetBgOffset(0, 0, 0);
    SetDispEnable(0, 1, 0, 0, 0);
    SetWinEnable(0, 0, 0);
    SetBlendNone();
    gDispIo.mosaic = 0;
    SyncDispIo();

    func_common_0201533C();
    SetMainFunc(func_common_02015330);
}

void func_common_02015400(void)
{
    REG_DISPSTAT = DISPSTAT_VBLANK_INT_ENABLE;
    REG_IME = TRUE;
    REG_DISPCNT = 0;

    SetOnVBlank(func_common_02015314);
    SetMainFunc(func_common_02015384);
}

void func_common_02015438(void)
{
    int i;
    u32 var_00;
    void * something; // TODO: correct type

    // TODO: cleanup

    if (gUnk_Sio_02018648->unk_004 > 4 && gUnk_Sio_02018648->unk_001 != 0)
    {
        gUnk_Sio_02018648->unk_01E++;

        if (gUnk_Sio_02018648->unk_004 == 6)
        {
            switch (gUnk_Sio_02018648->unk_021)
            {
                case 3:
                    if (gUnk_Sio_02018648->unk_01E > 60)
                    {
                        gUnk_Sio_02018648->unk_00B[gUnk_Sio_02018648->unk_006] = 0;
                        func_common_02015400();
                    }

                    // fallthrough

                case 2:
                    if (gUnk_Sio_02018648->unk_001 != 0 && !func_common_0201596C())
                    {
                        gUnk_Sio_02018648->unk_00B[gUnk_Sio_02018648->unk_006] = 0;
                        func_common_02015400();
                    }

                    // fallthrough

                case 1:
                    for (i = 0; i < 4; i++)
                    {
                        if (gUnk_Sio_02018648->unk_01A[i] > 60)
                        {
                            gUnk_Sio_02018648->unk_00B[i] = 0;
                            func_common_02015400();
                        }
                    }

                    break;
            }
        }

        if (gUnk_Sio_02018648->unk_001 == 1)
        {
            if (gUnk_Sio_02018648->unk_010 == 0)
            {
                if (gUnk_Sio_02018648->unk_011 > 60)
                {
                    func_common_02015400();
                    gUnk_Sio_02018648->unk_004 = 2;
                    return;
                }

                something = func_common_02015E28(&var_00);

                if (something != NULL)
                {
                    if (func_common_02015A3C(something, var_00 + 6) > 0)
                    {
                        gUnk_Sio_02018648->unk_010 = 0;
                        gUnk_Sio_02018648->unk_011++;
                        gUnk_Sio_02018648->unk_02E = 1;
                    }
                }
            }

            gUnk_Sio_02018648->unk_010++;
            gUnk_Sio_02018648->unk_010 = gUnk_Sio_02018648->unk_010 % 9;
        }
        else if (gUnk_Sio_02018648->unk_001 == 2 || gUnk_Sio_02018648->unk_001 == 3)
        {
            if (gUnk_Sio_02018648->unk_006 == 0)
            {
                func_common_02015CEC(&gUnk_Sio_02018648->unk_030, -1);
                gUnk_Sio_02018648->unk_030 = 0x5FFF;
            }
        }
    }
}

void func_common_02015584(void)
{
    REG_TM3CNT_H = 0;
    REG_SIOCNT = s_sio_cnt | SIO_MULTI_MODE | SIO_INTR_ENABLE | SIO_ENABLE;
}

void func_common_020155A8(int arg_0)
{
}

void func_common_020155AC(void)
{
    int i;

    // TODO: cleanup

#if defined(VER_20030206)
    for (i = 0; i < 4; i++)
    {
        DebugPutObjNumber((i * 5 + 7) * 8, 0x88, gUnk_Sio_02018648->unk_026[i], 4);
        DebugPutObjNumber((i * 5 + 7) * 8, 0x90, func_06_02016424(i), 4);
    }

    DebugPutObjStr(0x18, 0x70, "SUM");
    DebugPutObjStr(0x10, 0x78, "TOTAL");
    DebugPutObjStr(0x10, 0x88, "RECV");

    DebugPutObjNumber(0x10, 0x48, gUnk_Sio_02018648->unk_006, 2);
    DebugPutObjNumber(0x10, 0x50, gUnk_Sio_02018648->unk_00A, 2);
    DebugPutObjNumber(0x10, 0x58, gUnk_Sio_02018648->unk_00F, 2);
    DebugPutObjNumber(0x08, 0x90, func_06_02016424(-1), 4);
#endif

    if (gUnk_Sio_02018648->unk_001 != 1)
        return;

    gUnk_Sio_02018648->unk_00F |= 1 << gUnk_Sio_02018648->unk_006;

    for (i = 0; i < 4; i++)
    {
        fu16 var;

#if defined(VER_20030206)
        DebugPutObjNumber((i * 5 + 7) * 8, 0x70, gUnk_Sio_06_03001C30[i], 4);
        DebugPutObjNumber((i * 5 + 7) * 8, 0x78, gUnk_Sio_06_03001CC8[i], 4);
#endif

    redo:
        var = func_common_02015B34(i, gUnk_Sio_02018648->unk_032);

        if (var != 0)
        {
            switch (var)
            {
                struct Sio_Unk_03002E40 * data_a;
                struct Sio_Unk_03002E40 * data_b;

                case 0x0A:
                case 0x16:
                case 0x2A:
                case 0x2E:
                case 0x80:
                    data_a = (void *)gUnk_Sio_02018648->unk_032;

                    if (data_a->unk_00 != SIO_UNK_CC)
                    {
                        if (data_a->unk_00 != SIO_UNK_CF)
                            break;

                        if (data_a->unk_01 == gUnk_Sio_02018648->unk_006)
                            break;

                        if (data_a->unk_02 != gUnk_Sio_02018648->unk_026[data_a->unk_01])
                        {
                            gUnk_Sio_03002E40.unk_00 = SIO_UNK_CE;
                            gUnk_Sio_03002E40.unk_01 = (gUnk_Sio_02018648->unk_006 << 4) | data_a->unk_01;
                            gUnk_Sio_03002E40.unk_02 = gUnk_Sio_02018648->unk_026[data_a->unk_01];

                            func_common_02015A3C(&gUnk_Sio_03002E40, sizeof(gUnk_Sio_03002E40));

                            goto redo;
                        }
                        else
                        {
                            func_common_02015DB4(data_a);

                            gUnk_Sio_03002E40.unk_00 = SIO_UNK_CE;
                            gUnk_Sio_03002E40.unk_01 = (gUnk_Sio_02018648->unk_006 << 4) | data_a->unk_01;
                            gUnk_Sio_03002E40.unk_02 = gUnk_Sio_02018648->unk_026[data_a->unk_01] + 1;

                            func_common_02015A3C(&gUnk_Sio_03002E40, sizeof(gUnk_Sio_03002E40));
                        }

                        break;
                    }

                    if ((func_common_0201592C(i) == 0 && gUnk_Sio_02018648->unk_000 == data_a->unk_02 &&
                         gUnk_Sio_02018648->unk_004 <= 5) ||
                        (func_common_0201592C(i) == 1))
                    {
                        if (gUnk_Sio_02018648->unk_006 == 0)
                        {
                            gUnk_Sio_03002E40.unk_00 = SIO_UNK_C6;
                            gUnk_Sio_03002E40.unk_01 = gUnk_Sio_02018648->unk_006;
                            gUnk_Sio_03002E40.unk_02 = i;

                            func_common_02015A3C(&gUnk_Sio_03002E40, sizeof(gUnk_Sio_03002E40));
                        }

                        break;
                    }

                    if (gUnk_Sio_02018648->unk_006 == 0)
                    {
                        u32 cmd = gUnk_Sio_02018648->unk_000 != data_a->unk_02 ? SIO_UNK_C7 : SIO_UNK_C5;

                        gUnk_Sio_03002E40.unk_00 = cmd;
                        gUnk_Sio_03002E40.unk_01 = gUnk_Sio_02018648->unk_006;
                        gUnk_Sio_03002E40.unk_02 = i;

                        func_common_02015A3C(&gUnk_Sio_03002E40, sizeof(gUnk_Sio_03002E40));
                    }

                    break;

                case 0x04:
                    data_b = (void *)gUnk_Sio_02018648->unk_032;

                    switch (data_b->unk_00)
                    {
                        case SIO_UNK_C9:
                            gUnk_Sio_02018648->unk_00A |= 1 << data_b->unk_01;
                            break;

                        case SIO_UNK_CE:
                            if (gUnk_Sio_02018648->unk_02E != 0)
                            {
                                if ((data_b->unk_01 >> 4) != gUnk_Sio_02018648->unk_006 &&
                                    (data_b->unk_01 & 0x0F) == gUnk_Sio_02018648->unk_006 &&
                                    (data_b->unk_02 == (u16)(gUnk_Sio_02018648->unk_024 + 1)))
                                {
                                    gUnk_Sio_02018648->unk_00F |= 1 << (data_b->unk_01 >> 4);
                                    s_unk_03000040->unk_00 = gUnk_Sio_02018648->unk_00F;

                                    if ((gUnk_Sio_02018648->unk_00F & gUnk_Sio_02018648->unk_009) ==
                                        gUnk_Sio_02018648->unk_009)
                                    {
                                        gUnk_Sio_02018648->unk_024++;
                                        gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C4].unk_04 = 0;
                                        gUnk_Sio_02018648->unk_7C4++;
                                        gUnk_Sio_02018648->unk_7C4 &= 7;
                                        gUnk_Sio_02018648->unk_02E = 0;
                                        gUnk_Sio_02018648->unk_010 = gUnk_Sio_02018648->unk_011 =
                                            gUnk_Sio_02018648->unk_00F = 0;
                                    }
                                }
                            }
                            break;

                        case SIO_UNK_C7:
                            if (func_common_0201592C(data_b->unk_02) == 0)
                            {
                                gUnk_Sio_02018648->unk_00B[gUnk_Sio_02018648->unk_006] = 2;
                                gUnk_Sio_02018648->unk_00B[(gUnk_Sio_02018648->unk_002 & 0x30) >> 4] = 2;
                                gUnk_Sio_02018648->unk_00B[data_b->unk_02] = 2;
                                gUnk_Sio_02018648->unk_004 = 6;
                            }

                            break;

                        case SIO_UNK_C5:
                            if (func_common_0201592C(data_b->unk_02) == 0)
                            {
                                gUnk_Sio_02018648->unk_00B[data_b->unk_02] = 2;
                                gUnk_Sio_02018648->unk_004 = 6;
                            }

                            break;

                        case SIO_UNK_C6:
                            gUnk_Sio_02018648->unk_00B[data_b->unk_02] = 5;
                            gUnk_Sio_02018648->unk_009 |= 1 << data_b->unk_02;
                            gUnk_Sio_02018648->unk_01A[data_b->unk_02] = 0;
                            break;

                        case SIO_UNK_C4:
                            func_common_020155A8(data_b->unk_01);
                            break;
                    }

                    break;
            }
        }
    }
}

void func_common_020158D0(void)
{
}

int func_common_020158D4(void)
{
    int i;

    fu8 count = 0;

    for (i = 0; i < 4; i++)
    {
        if (func_common_0201592C(i) == TRUE)
            count++;
    }

    return count;
}

int func_common_02015900(void)
{
    int i;

    fu8 count = 0;

    for (i = 0; i < 4; i++)
    {
        if (func_common_0201594C(i) == TRUE)
            count++;
    }

    return count;
}

bool func_common_0201592C(fu8 arg_0)
{
    if (((gUnk_Sio_02018648->unk_009 >> arg_0) & 1) != 0)
        return TRUE;

    return FALSE;
}

bool func_common_0201594C(fu8 arg_0)
{
    if (((gUnk_Sio_02018648->unk_008 >> arg_0) & 1) != 0)
        return TRUE;

    return FALSE;
}

bool func_common_0201596C(void)
{
    int old_002 = gUnk_Sio_02018648->unk_002;
    gUnk_Sio_02018648->unk_002 = 0;

    if ((old_002 & 8) == 0 && (REG_SIOCNT & SIO_MULTI_SD) == 0)
    {
        gUnk_Sio_02018648->unk_020++;
    }
    else
    {
        gUnk_Sio_02018648->unk_020 = 0;
    }

    if (gUnk_Sio_02018648->unk_020 > 10)
        return FALSE;

    return TRUE;
}

int func_common_020159C0(void)
{
    if (gUnk_Sio_02018648->unk_7C5 >= gUnk_Sio_02018648->unk_7C4)
    {
        return gUnk_Sio_02018648->unk_7C5 - gUnk_Sio_02018648->unk_7C4;
    }
    else
    {
        return 8 + gUnk_Sio_02018648->unk_7C5 - gUnk_Sio_02018648->unk_7C4;
    }
}

bool func_common_020159F0(void)
{
    int i, count = 0;

    for (i = 0; i < 4; i++)
    {
        if (gUnk_Sio_02018648->unk_00B[i] == 5)
            count++;
    }

#if defined(VER_20030206)
    DebugPutObjNumberHex(0x10, 0x20, gUnk_Sio_02018648->unk_009, 2);
    DebugPutObjNumberHex(0x10, 0x28, count, 2);
    DebugPutObjNumberHex(0x40, 0x28, gUnk_Sio_02018648->unk_006, 2);
#endif

    if ((gUnk_Sio_02018648->unk_009 == 0x3 && count == 2) || (gUnk_Sio_02018648->unk_009 == 0x7 && count == 3) ||
        (gUnk_Sio_02018648->unk_009 == 0xF && count == 4))
    {
        return TRUE;
    }

    return FALSE;
}

fi16 func_common_02015A3C(void const * src, fu16 len)
{
#define SRC_U16 ((u16 const *)src)

    int i;

    u16 magic;

    u16 sum_a = 0;
    u16 sum_b = 0;

    fu16 cur = s_unk_0300004A;

    if (len > 0x80)
        return -1;

    len = len / 2;
    magic = 0x4FFF;
    sum_a = magic + len;

    // write headers

    gUnk_Sio_02030080[cur] = magic;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_unk_03000048)
        return -1;

    gUnk_Sio_02030080[cur] = len;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_unk_03000048)
        return -1;

    // compute checksum

    for (i = 0; i < len; i++)
    {
        u32 frag = SRC_U16[i] * (i + 1);

        sum_a = sum_a + frag;
        sum_b = sum_b + ~frag;
    }

    // write checksum

    gUnk_Sio_02030080[cur] = sum_a;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_unk_03000048)
        return -1;

    gUnk_Sio_02030080[cur] = sum_b;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_unk_03000048)
        return -1;

    // write data

    for (i = 0; i < len; i++)
    {
        gUnk_Sio_02030080[cur] = SRC_U16[i];
        cur = cur + 1;
        cur = cur & 0x1FF;

        if (cur == s_unk_03000048)
            return -1;
    }

    s_unk_0300004A = cur;

    return len;

#undef SRC_U16
}

fi16 func_common_02015B34(fi8 player_id, void * dst)
{
#define DST_U16 ((u16 *)dst)

    int i;

    u16 magic;

    u16 sum_a = 0;
    u16 recv_sum_a;
    u16 sum_b = 0;
    u16 recv_sum_b;

    fu16 count;
    fu16 lookahead;
    fu16 len;

    if (s_unk_03000050[player_id] == s_unk_03000058[player_id])
        return -2;

    if (gUnk_Sio_02030480[s_unk_03000050[player_id]][player_id] != 0x4FFF)
    {
        while (s_unk_03000050[player_id] != s_unk_03000058[player_id])
        {
            s_unk_03000050[player_id] += 1;
            s_unk_03000050[player_id] &= 0x1FF;

            if (gUnk_Sio_02030480[s_unk_03000050[player_id]][player_id] == 0x4FFF &&
                s_unk_03000050[player_id] != s_unk_03000058[player_id])
            {
                goto yes;
            }
        }

        return -4;
    }

yes:
    if (s_unk_03000058[player_id] < s_unk_03000050[player_id])
    {
        count = 0x200 - s_unk_03000050[player_id] + s_unk_03000058[player_id];
    }
    else
    {
        count = s_unk_03000058[player_id] - s_unk_03000050[player_id];
    }

    if (count <= 4)
        return -4;

    if (s_unk_03000050[player_id] + 1 < 0x200)
    {
        lookahead = s_unk_03000050[player_id] + 1;
    }
    else
    {
        lookahead = 0;
    }

    len = gUnk_Sio_02030480[lookahead][player_id];

    if (len > 0x80)
    {
        s_unk_03000050[player_id] += 1;
        s_unk_03000050[player_id] &= 0x1FF;

#if defined(VER_20030206)
        gUnk_Sio_06_03002E58[player_id]++;
        gUnk_Sio_06_03001CC8[player_id]++;
#endif

        return -4;
    }

    if (len + 6 > count)
    {
        return -2;
    }

    s_unk_03000050[player_id] += 2;
    s_unk_03000050[player_id] &= 0x1FF;

    recv_sum_a = gUnk_Sio_02030480[s_unk_03000050[player_id]][player_id];

    s_unk_03000050[player_id] += 1;
    s_unk_03000050[player_id] &= 0x1FF;

    recv_sum_b = gUnk_Sio_02030480[s_unk_03000050[player_id]][player_id];

    s_unk_03000050[player_id] += 1;
    s_unk_03000050[player_id] &= 0x1FF;

    sum_a += 0x4FFF + len;

    for (i = 0; i < len; i++)
    {
        u32 data = gUnk_Sio_02030480[s_unk_03000050[player_id]][player_id];
        u32 frag = data * (i + 1);

        sum_a = sum_a + frag;
        sum_b = sum_b + ~frag;

        DST_U16[i] = data;

        s_unk_03000050[player_id] += 1;
        s_unk_03000050[player_id] &= 0x1FF;
    }

    if (sum_a != recv_sum_a || sum_b != recv_sum_b)
    {
#if defined(VER_20030206)
        gUnk_Sio_06_03001C30[player_id]++;
        gUnk_Sio_06_03001CC8[player_id]++;
#endif

        return -3;
    }

#if defined(VER_20030206)
    gUnk_Sio_06_03001CC8[player_id]++;
#endif

    return len * 2;

#undef DST_U16
}

int func_common_02015CEC(u16 * arg_0, int arg_1)
{
    if (gUnk_Sio_02018648->unk_006 == -1)
        return -1;

    SIO->siodata = *arg_0;

    if (gUnk_Sio_02018648->unk_006 == 0 && arg_1 < 0)
    {
        REG_SIOCNT |= SIO_ENABLE;
        REG_TM3CNT = -gUnk_Sio_02018648->unk_7CC;
        REG_TM3CNT_H = 0xC3; // TODO: constants
    }

    return 0;
}

int func_common_02015D48(int unused_0, u16 * arg_1)
{
    int i;

    if (s_unk_03000050[0] == s_unk_03000058[0])
    {
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;

        return -2;
    }

    for (i = 0; i < 4; i++)
    {
        *arg_1++ = gUnk_Sio_02030480[s_unk_03000050[i]][i];

        s_unk_03000050[i] += 1;
        s_unk_03000050[i] &= 0x1FF;
    }

    return 0;
}

void func_common_02015DB4(void * arg_0)
{
    // TODO: clean up

#define INFO ((struct Dat *)arg_0)

    int i;

    struct Unk_Sio_134 * ent = &gUnk_Sio_02018648->unk_594[gUnk_Sio_02018648->unk_7C7];

    ent->unk_04 = INFO->head.unk_00;
    ent->unk_05 = INFO->head.unk_01;
    ent->unk_06 = INFO->head.unk_02;

    ent->unk_08 = INFO->body.unk_04;

    for (i = 0; i < INFO->body.unk_04; i++)
    {
        ent->unk_0A[i] = INFO->body.unk_06[i];
    }

    gUnk_Sio_02018648->unk_7C7 += 1;
    gUnk_Sio_02018648->unk_7C7 &= 3;

#undef INFO
}

void * func_common_02015E28(u32 * out)
{
    // TODO: clean up

    if (gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C4].unk_04 != SIO_UNK_CF)
        return NULL;

    s_unk_03000040 = &gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C4];

    *out = gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C4].unk_08;
    return &gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C4].unk_04;
}

int func_common_02015E88(u8 * ip, fu16 r7)
{
    // TODO: clean up

    int result;
    fu8 i;

    struct Dat * dat;

    s_unk_03000044 = 1;

    gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C5].unk_00 = 0;

    // TODO: good types
    dat = (void *)&gUnk_Sio_02018648->unk_134[gUnk_Sio_02018648->unk_7C5].unk_04;

    dat->head.unk_00 = SIO_UNK_CF;
    dat->head.unk_01 = gUnk_Sio_02018648->unk_006;
    dat->head.unk_02 = gUnk_Sio_02018648->unk_022;
    dat->body.unk_04 = r7;

    gUnk_Sio_02018648->unk_022++;

    for (i = 0; i < r7; i++)
    {
        dat->body.unk_06[i] = ip[i];
    }

    result = gUnk_Sio_02018648->unk_7C5;

    gUnk_Sio_02018648->unk_7C5 += 1;
    gUnk_Sio_02018648->unk_7C5 &= 7;

    s_unk_03000044 = 0;

    return result;
}
