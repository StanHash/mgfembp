#include "common.h"

#include "gbaio.h"

struct Unk_Sio
{
    /* 000 */ STRUCT_PAD(0x000, 0x014);
    /* 014 */ u16 unk_014;
    /* 016 */ STRUCT_PAD(0x016, 0x7C8);
    /* 7C8 */ u16 unk_7C8;
    /* 7CA */ u16 unk_7CA;
    /* 7CC */ u16 unk_7CC;
};

struct Unk_Sio EWRAM_DATA gUnk_Sio_0202F8B0 = { 0 };
struct Unk_Sio * SHOULD_BE_CONST gUnk_Sio_02018648 = &gUnk_Sio_0202F8B0;

static int pad_03000034; // this could be anywhere

static u8 sUnk_03000038;
static int sUnk_0300003C;

// COMMON
extern int gUnk_Sio_03001C34;
extern int gSioStateId;

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
            REG_SIOCNT = sUnk_03000038 | SIO_INTR_ENABLE | SIO_MULTI_MODE;

            siocnt = REG_SIOCNT;

            if ((siocnt & SIO_MULTI_SD) != 0)
            {
                sUnk_0300003C = siocnt & SIO_MULTI_SI;

                if (sUnk_0300003C != 0)
                    sUnk_0300003C = -1;

                gUnk_Sio_03001C34 = 0;
                gSioStateId = 1;
            }

            return -1;

        case 1:
            siocnt = REG_SIOCNT;

            if ((gUnk_Sio_03001C34 != 0) && ((siocnt & SIO_ERROR) == 0) && (gUnk_Sio_02018648->unk_014 != UINT16_MAX))
            {
                sUnk_0300003C = (siocnt & SIO_ID) >> 4; // TODO: shift constant
                gSioStateId = 2;

                if (sUnk_0300003C == 0)
                    REG_IE &= ~INTR_FLAG_SERIAL;

                return sUnk_0300003C;
            }
            else
            {
                SIO->siodata = ~gUnk_Sio_02018648->unk_7C8;

                if (sUnk_0300003C != 0)
                {
                    REG_SIOCNT = sUnk_03000038 | SIO_INTR_ENABLE | SIO_MULTI_MODE;
                }
                else
                {
                    REG_SIOCNT = sUnk_03000038 | SIO_INTR_ENABLE | SIO_MULTI_MODE | SIO_MULTI_BUSY;
                }

                return -1;
            }

        default:
            return sUnk_0300003C;
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
    sUnk_03000038 = arg_1;
}
