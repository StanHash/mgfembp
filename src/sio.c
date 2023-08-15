#include "sio.h"

#include "async_upload.h"
#include "gbaio.h"
#include "gbasvc.h"
#include "graphics_data.h"
#include "hardware.h"
#include "interrupts.h"
#include "proc.h"
#include "report.h"

#if defined(VER_20030206)
#include "debug_text.h"
#endif

struct SioSt EWRAM_DATA gSioStInstance = { 0 };
struct SioSt * SHOULD_BE_CONST gSioSt = &gSioStInstance;

u16 EWRAM_DATA gSioOutgoing[0x200] = { 0 };
u16 EWRAM_DATA gSioIncoming[0x200][4] = { 0 };

static u8 s_sio_cnt;
static int s_sio_id;

static struct SioPending * s_unk_03000040;

static u32 s_unk_03000044;

static u16 s_send_cursor;
static u16 s_write_cursor;

static u16 s_read_cursor[4];
static u16 s_recv_cursor[4];

#if defined(VER_20030206)
u16 COMMON_DATA(gUnk_Sio_06_03001C30) gUnk_Sio_06_03001C30[4] = { 0 };
u16 COMMON_DATA(gUnk_Sio_06_03001CC8) gUnk_Sio_06_03001CC8[4] = { 0 };
u16 COMMON_DATA(gUnk_Sio_06_03002E58) gUnk_Sio_06_03002E58[4] = { 0 };
#endif

u32 COMMON_DATA(gUnk_Sio_03001C30) gUnk_Sio_03001C30 = 0;
u32 COMMON_DATA(gUnk_Sio_03001C34) gUnk_Sio_03001C34 = 0;
int COMMON_DATA(gSioStateId) gSioStateId = 0;
struct SioMessage COMMON_DATA(gSioMsgBuf) gSioMsgBuf = { 0 };
u8 COMMON_DATA(gUnk_Sio_03002E50) gUnk_Sio_03002E50[SIO_MAX_PACKET] = { 0 }; // unused?

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

            if (gUnk_Sio_03001C34 != 0 && (siocnt & SIO_ERROR) == 0 && gSioSt->last_recv[1] != UINT16_MAX)
            {
                s_sio_id = (siocnt & SIO_ID) >> 4; // TODO: shift constant
                gSioStateId = 2;

                if (s_sio_id == 0)
                    REG_IE &= ~INTR_FLAG_SERIAL;

                return s_sio_id;
            }
            else
            {
                SIO->siodata = ~gSioSt->unk_7C8;

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

void func_02014DC0(fu16 arg_0, fu16 sio_cnt, fu16 arg_2)
{
    gSioSt->unk_7C8 = arg_0;
    gSioSt->unk_7CA = sio_cnt;
    gSioSt->unk_7CC = arg_2;
    s_sio_cnt = sio_cnt;
}

void func_02014DF4(void)
{
    int j, i;

    // TODO: constants

    gUnk_Sio_03001C30 = 0;

    gSioSt->unk_022 = 0;
    gSioSt->self_seq = 0;
    gSioSt->next_pending_send = 0;
    gSioSt->next_pending_write = 0;
    gSioSt->next_pending_read = 0;
    gSioSt->next_pending_recv = 0;
    gSioSt->unk_01E = 0;
    gSioSt->unk_01F = 0;
    gSioSt->unk_020 = 0;
    gSioSt->unk_030 = 0;

    for (i = 0; i < 4; i++)
    {
        gSioSt->player_status[i] = PLAYER_STATUS_0;
        gSioSt->last_recv[i] = UINT16_MAX;
        gSioSt->timeout_clock[i] = 0;
        gSioSt->seq[i] = 0;
    }

    for (i = 0; i < SIO_MAX_PACKET; i++)
    {
        gUnk_Sio_03002E50[i] = 0;
        gSioSt->buf[i] = 0;
    }

    for (j = 0; j < 8; j++)
    {
        struct SioPending * ent = &gSioSt->pending_send[j];

        ent->unk_00 = 0;
        ent->packet.head.kind = 0;

        for (i = 0; i < (int)ARRAY_COUNT(ent->packet.bytes); i++)
            ent->packet.bytes[i] = 0;
    }

    for (j = 0; j < 4; j++)
    {
        struct SioPending * ent = &gSioSt->pending_recv[j];

        ent->unk_00 = 0;
        ent->packet.head.kind = 0;

        for (i = 0; i < (int)ARRAY_COUNT(ent->packet.bytes); i++)
            ent->packet.bytes[i] = 0;
    }

    s_send_cursor = s_write_cursor = 0;

    for (i = 0; i < 0x200; i++)
    {
        gSioOutgoing[i] = 0;
    }

    for (j = 0; j < 4; j++)
    {
        s_read_cursor[j] = s_recv_cursor[j] = 0;

        for (i = 0; i < 0x200; i++)
        {
            gSioIncoming[i][j] = 0;
        }
    }
}

void func_02014F80(void)
{
    int i;

    gSioSt->unk_000 = 0;
    gSioSt->unk_001 = 0;
    gSioSt->last_sio_cnt = 0;
    gSioSt->unk_004 = 0;
    gSioSt->self_id = -1;
    gSioSt->unk_007 = 0;
    gSioSt->recv_flags = 0;
    gSioSt->unk_009 = 0;
    gSioSt->unk_00F = 0;
    gSioSt->unk_010 = 0;
    gSioSt->unk_011 = 0;
    gSioSt->unk_02E = 0;
    gSioSt->unk_00A = 0;

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

    SetIntrFunc(INT_SERIAL, SioOnSerial);
    SetIntrFunc(INT_SERIAL, SioOnSerial);

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

void SioOnSerial(void)
{
    int i;
    u16 recv[4];
    u16 var_08;
    fu16 siocnt;

    fu16 sb = 0;

    // TODO: constants, cleanup

    gUnk_Sio_03001C34 = 1;
    gSioSt->unk_01E = 0;
    gUnk_Sio_03001C30 = 1;
    gSioSt->recv_flags = 0;

    REG_TM3CNT_H = 0;

    gSioSt->last_sio_cnt = siocnt = REG_SIOCNT;

    if (gSioSt->unk_004 != 6)
    {
        gSioSt->self_id = (siocnt >> 4) & 3;
    }

    // ew
    *(u64 *)(recv) = REG_SIOMLT_RECV;

    REG_SIOCNT = s_sio_cnt | SIO_MULTI_MODE | SIO_INTR_ENABLE;
    SIO->siodata = 0x7FFF;

    for (i = 0; i < 4; i++)
    {
        if (recv[i] != 0 && recv[i] != 0xFFFF)
        {
            if (gSioSt->player_status[i] == PLAYER_STATUS_0)
                gSioSt->player_status[i] = PLAYER_STATUS_1;

            gSioSt->recv_flags |= 1 << i;
        }
        else
        {
            if (func_common_0201592C(i) == TRUE)
            {
                if (gSioSt->last_recv[i] == 0xFFFF)
                {
                    gSioSt->timeout_clock[i]++;
                }
                else
                {
                    gSioSt->timeout_clock[i] = 0;
                }
            }
        }

        gSioSt->last_recv[i] = gSioIncoming[s_recv_cursor[i]][i] = recv[i];

        s_recv_cursor[i] = (s_recv_cursor[i] + 1) & 0x1FF;
    }

    if (gSioSt->unk_004 > 4)
    {
        switch (gSioSt->unk_001)
        {
            case 1:
                if (s_write_cursor != s_send_cursor)
                {
                    var_08 = gSioOutgoing[s_send_cursor];
                    s_send_cursor = (s_send_cursor + 1) & 0x1FF;
                    SioSend16(&var_08, 1);
                }

                if (gSioSt->self_id == 0 && gSioSt->unk_7CC != 0)
                {
                    REG_SIOCNT |= SIO_MULTI_BUSY;
                    REG_TM3CNT = -gSioSt->unk_7CC;
                    REG_TM3CNT_H = 0xC3;
                }

                break;

            case 3:
                if (gSioSt->self_id != 0)
                {
                    SioSend16(&gSioSt->unk_030, 1);
                    gSioSt->unk_030 = 0x5FFF;
                }

                for (i = 0; i < 4; i++)
                {
                    if (func_common_0201592C(i) && recv[i] != 0x9ABC)
                        sb++;
                }

                if (sb == 0)
                    gSioSt->unk_7CE = 1;

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

void SioVSync_Loop(void)
{
    int i;
    u32 len;
    struct SioData * dat;

    // TODO: cleanup

    if (gSioSt->unk_004 > 4 && gSioSt->unk_001 != 0)
    {
        gSioSt->unk_01E++;

        if (gSioSt->unk_004 == 6)
        {
            switch (gSioSt->unk_021)
            {
                case 3:
                    if (gSioSt->unk_01E > 60)
                    {
                        gSioSt->player_status[gSioSt->self_id] = PLAYER_STATUS_0;
                        func_common_02015400();
                    }

                    // fallthrough

                case 2:
                    if (gSioSt->unk_001 != 0 && !func_common_0201596C())
                    {
                        gSioSt->player_status[gSioSt->self_id] = PLAYER_STATUS_0;
                        func_common_02015400();
                    }

                    // fallthrough

                case 1:
                    for (i = 0; i < 4; i++)
                    {
                        if (gSioSt->timeout_clock[i] > 60)
                        {
                            gSioSt->player_status[i] = PLAYER_STATUS_0;
                            func_common_02015400();
                        }
                    }

                    break;
            }
        }

        if (gSioSt->unk_001 == 1)
        {
            if (gSioSt->unk_010 == 0)
            {
                if (gSioSt->unk_011 > 60)
                {
                    func_common_02015400();
                    gSioSt->unk_004 = 2;
                    return;
                }

                dat = func_common_02015E28(&len);

                if (dat != NULL)
                {
                    if (SioSend(dat, len + offsetof(struct SioData, bytes)) > 0)
                    {
                        gSioSt->unk_010 = 0;
                        gSioSt->unk_011++;
                        gSioSt->unk_02E = 1;
                    }
                }
            }

            gSioSt->unk_010++;
            gSioSt->unk_010 = gSioSt->unk_010 % 9;
        }
        else if (gSioSt->unk_001 == 2 || gSioSt->unk_001 == 3)
        {
            if (gSioSt->self_id == 0)
            {
                SioSend16(&gSioSt->unk_030, -1);
                gSioSt->unk_030 = 0x5FFF;
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

void SioMain_Loop(void)
{
    int i;

    // TODO: cleanup

#if defined(VER_20030206)
    for (i = 0; i < 4; i++)
    {
        DebugPutObjNumber((i * 5 + 7) * 8, 0x88, gSioSt->seq[i], 4);
        DebugPutObjNumber((i * 5 + 7) * 8, 0x90, func_06_02016424(i), 4);
    }

    DebugPutObjStr(0x18, 0x70, "SUM");
    DebugPutObjStr(0x10, 0x78, "TOTAL");
    DebugPutObjStr(0x10, 0x88, "RECV");

    DebugPutObjNumber(0x10, 0x48, gSioSt->self_id, 2);
    DebugPutObjNumber(0x10, 0x50, gSioSt->unk_00A, 2);
    DebugPutObjNumber(0x10, 0x58, gSioSt->unk_00F, 2);
    DebugPutObjNumber(0x08, 0x90, func_06_02016424(-1), 4);
#endif

    if (gSioSt->unk_001 != 1)
        return;

    gSioSt->unk_00F |= 1 << gSioSt->self_id;

    for (i = 0; i < 4; i++)
    {
        fu16 len;

#if defined(VER_20030206)
        DebugPutObjNumber((i * 5 + 7) * 8, 0x70, gUnk_Sio_06_03001C30[i], 4);
        DebugPutObjNumber((i * 5 + 7) * 8, 0x78, gUnk_Sio_06_03001CC8[i], 4);
#endif

    redo:
        len = func_common_02015B34(i, gSioSt->buf);

        if (len != 0)
        {
            switch (len)
            {
                struct SioMessage * message;
                struct SioData * data_message;

                case 0x0A:
                case 0x16:
                case 0x2A:
                case 0x2E:
                case 0x80:
                    data_message = (void *)gSioSt->buf;

                    if (data_message->head.kind != SIO_MSG_CC)
                    {
                        if (data_message->head.kind != SIO_MSG_DATA)
                            break;

                        if (data_message->head.sender == gSioSt->self_id)
                            break;

                        if (data_message->head.param != gSioSt->seq[data_message->head.sender])
                        {
                            gSioMsgBuf.kind = SIO_MSG_DATA_ACK;
                            gSioMsgBuf.sender = (gSioSt->self_id << 4) | data_message->head.sender;
                            gSioMsgBuf.param = gSioSt->seq[data_message->head.sender];

                            SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));

                            goto redo;
                        }
                        else
                        {
                            SioQueuePendingRecvData(data_message);

                            gSioMsgBuf.kind = SIO_MSG_DATA_ACK;
                            gSioMsgBuf.sender = (gSioSt->self_id << 4) | data_message->head.sender;
                            gSioMsgBuf.param = gSioSt->seq[data_message->head.sender] + 1;

                            SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));
                        }

                        break;
                    }

                    if ((func_common_0201592C(i) == 0 && gSioSt->unk_000 == data_message->head.param &&
                         gSioSt->unk_004 <= 5) ||
                        (func_common_0201592C(i) == 1))
                    {
                        if (gSioSt->self_id == 0)
                        {
                            gSioMsgBuf.kind = SIO_MSG_C6;
                            gSioMsgBuf.sender = gSioSt->self_id;
                            gSioMsgBuf.param = i;

                            SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));
                        }

                        break;
                    }

                    if (gSioSt->self_id == 0)
                    {
                        u32 cmd = gSioSt->unk_000 != data_message->head.param ? SIO_MSG_C7 : SIO_MSG_C5;

                        gSioMsgBuf.kind = cmd;
                        gSioMsgBuf.sender = gSioSt->self_id;
                        gSioMsgBuf.param = i;

                        SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));
                    }

                    break;

                case 0x04:
                    message = (void *)gSioSt->buf;

                    switch (message->kind)
                    {
                        case SIO_MSG_C9:
                            gSioSt->unk_00A |= 1 << message->sender;
                            break;

                        case SIO_MSG_DATA_ACK:
                            if (gSioSt->unk_02E != 0)
                            {
                                if ((message->sender >> 4) != gSioSt->self_id &&
                                    (message->sender & 0x0F) == gSioSt->self_id &&
                                    (message->param == (u16)(gSioSt->self_seq + 1)))
                                {
                                    gSioSt->unk_00F |= 1 << (message->sender >> 4);
                                    s_unk_03000040->unk_00 = gSioSt->unk_00F;

                                    if ((gSioSt->unk_00F & gSioSt->unk_009) == gSioSt->unk_009)
                                    {
                                        gSioSt->self_seq++;
                                        gSioSt->pending_send[gSioSt->next_pending_send].packet.head.kind = 0;
                                        gSioSt->next_pending_send++;
                                        gSioSt->next_pending_send &= 7;
                                        gSioSt->unk_02E = 0;
                                        gSioSt->unk_010 = gSioSt->unk_011 = gSioSt->unk_00F = 0;
                                    }
                                }
                            }

                            break;

                        case SIO_MSG_C7:
                            if (func_common_0201592C(message->param) == 0)
                            {
                                gSioSt->player_status[gSioSt->self_id] = PLAYER_STATUS_2;
                                gSioSt->player_status[(gSioSt->last_sio_cnt & 0x30) >> 4] = PLAYER_STATUS_2;
                                gSioSt->player_status[message->param] = PLAYER_STATUS_2;
                                gSioSt->unk_004 = 6;
                            }

                            break;

                        case SIO_MSG_C5:
                            if (func_common_0201592C(message->param) == 0)
                            {
                                gSioSt->player_status[message->param] = PLAYER_STATUS_2;
                                gSioSt->unk_004 = 6;
                            }

                            break;

                        case SIO_MSG_C6:
                            gSioSt->player_status[message->param] = PLAYER_STATUS_5;
                            gSioSt->unk_009 |= 1 << message->param;
                            gSioSt->timeout_clock[message->param] = 0;
                            break;

                        case SIO_MSG_C4:
                            func_common_020155A8(message->sender);
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

bool func_common_0201592C(fu8 player_id)
{
    if (((gSioSt->unk_009 >> player_id) & 1) != 0)
        return TRUE;

    return FALSE;
}

bool func_common_0201594C(fu8 player_id)
{
    if (((gSioSt->recv_flags >> player_id) & 1) != 0)
        return TRUE;

    return FALSE;
}

bool func_common_0201596C(void)
{
    int last_sio_cnt = gSioSt->last_sio_cnt;
    gSioSt->last_sio_cnt = 0;

    if ((last_sio_cnt & SIO_MULTI_SD) == 0 && (REG_SIOCNT & SIO_MULTI_SD) == 0)
    {
        gSioSt->unk_020++;
    }
    else
    {
        gSioSt->unk_020 = 0;
    }

    if (gSioSt->unk_020 > 10)
        return FALSE;

    return TRUE;
}

int func_common_020159C0(void)
{
    if (gSioSt->next_pending_write >= gSioSt->next_pending_send)
    {
        return gSioSt->next_pending_write - gSioSt->next_pending_send;
    }
    else
    {
        return 8 + gSioSt->next_pending_write - gSioSt->next_pending_send;
    }
}

bool func_common_020159F0(void)
{
    int i, count = 0;

    for (i = 0; i < 4; i++)
    {
        if (gSioSt->player_status[i] == PLAYER_STATUS_5)
            count++;
    }

#if defined(VER_20030206)
    DebugPutObjNumberHex(0x10, 0x20, gSioSt->unk_009, 2);
    DebugPutObjNumberHex(0x10, 0x28, count, 2);
    DebugPutObjNumberHex(0x40, 0x28, gSioSt->self_id, 2);
#endif

    if ((gSioSt->unk_009 == 0x3 && count == 2) || (gSioSt->unk_009 == 0x7 && count == 3) ||
        (gSioSt->unk_009 == 0xF && count == 4))
    {
        return TRUE;
    }

    return FALSE;
}

fi16 SioSend(void const * src, fu16 len)
{
#define SRC_U16 ((u16 const *)src)

    int i;

    u16 magic;

    u16 sum_a = 0;
    u16 sum_b = 0;

    fu16 cur = s_write_cursor;

    if (len > SIO_MAX_PACKET)
        return -1;

    len = len / 2;
    magic = 0x4FFF;
    sum_a = magic + len;

    // write headers

    gSioOutgoing[cur] = magic;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_send_cursor)
        return -1;

    gSioOutgoing[cur] = len;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_send_cursor)
        return -1;

    // compute checksum

    for (i = 0; i < len; i++)
    {
        u32 frag = SRC_U16[i] * (i + 1);

        sum_a = sum_a + frag;
        sum_b = sum_b + ~frag;
    }

    // write checksum

    gSioOutgoing[cur] = sum_a;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_send_cursor)
        return -1;

    gSioOutgoing[cur] = sum_b;
    cur = cur + 1;
    cur = cur & 0x1FF;

    if (cur == s_send_cursor)
        return -1;

    // write data

    for (i = 0; i < len; i++)
    {
        gSioOutgoing[cur] = SRC_U16[i];
        cur = cur + 1;
        cur = cur & 0x1FF;

        if (cur == s_send_cursor)
            return -1;
    }

    s_write_cursor = cur;

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

    if (s_read_cursor[player_id] == s_recv_cursor[player_id])
        return -2;

    if (gSioIncoming[s_read_cursor[player_id]][player_id] != 0x4FFF)
    {
        while (s_read_cursor[player_id] != s_recv_cursor[player_id])
        {
            s_read_cursor[player_id] += 1;
            s_read_cursor[player_id] &= 0x1FF;

            if (gSioIncoming[s_read_cursor[player_id]][player_id] == 0x4FFF &&
                s_read_cursor[player_id] != s_recv_cursor[player_id])
            {
                goto yes;
            }
        }

        return -4;
    }

yes:
    if (s_recv_cursor[player_id] < s_read_cursor[player_id])
    {
        count = 0x200 - s_read_cursor[player_id] + s_recv_cursor[player_id];
    }
    else
    {
        count = s_recv_cursor[player_id] - s_read_cursor[player_id];
    }

    if (count <= 4)
        return -4;

    if (s_read_cursor[player_id] + 1 < 0x200)
    {
        lookahead = s_read_cursor[player_id] + 1;
    }
    else
    {
        lookahead = 0;
    }

    len = gSioIncoming[lookahead][player_id];

    if (len > SIO_MAX_PACKET)
    {
        s_read_cursor[player_id] += 1;
        s_read_cursor[player_id] &= 0x1FF;

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

    s_read_cursor[player_id] += 2;
    s_read_cursor[player_id] &= 0x1FF;

    recv_sum_a = gSioIncoming[s_read_cursor[player_id]][player_id];

    s_read_cursor[player_id] += 1;
    s_read_cursor[player_id] &= 0x1FF;

    recv_sum_b = gSioIncoming[s_read_cursor[player_id]][player_id];

    s_read_cursor[player_id] += 1;
    s_read_cursor[player_id] &= 0x1FF;

    sum_a += 0x4FFF + len;

    for (i = 0; i < len; i++)
    {
        u32 data = gSioIncoming[s_read_cursor[player_id]][player_id];
        u32 frag = data * (i + 1);

        sum_a = sum_a + frag;
        sum_b = sum_b + ~frag;

        DST_U16[i] = data;

        s_read_cursor[player_id] += 1;
        s_read_cursor[player_id] &= 0x1FF;
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

int SioSend16(u16 * word, int arg_1)
{
    if (gSioSt->self_id == -1)
        return -1;

    SIO->siodata = *word;

    if (gSioSt->self_id == 0 && arg_1 < 0)
    {
        REG_SIOCNT |= SIO_ENABLE;
        REG_TM3CNT = -gSioSt->unk_7CC;
        REG_TM3CNT_H = 0xC3; // TODO: constants
    }

    return 0;
}

int func_common_02015D48(int unused_0, u16 * arg_1)
{
    int i;

    if (s_read_cursor[0] == s_recv_cursor[0])
    {
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;
        *arg_1++ = 0x7FFF;

        return -2;
    }

    for (i = 0; i < 4; i++)
    {
        *arg_1++ = gSioIncoming[s_read_cursor[i]][i];

        s_read_cursor[i] += 1;
        s_read_cursor[i] &= 0x1FF;
    }

    return 0;
}

void SioQueuePendingRecvData(struct SioData * data)
{
    // TODO: clean up

    int i;

    struct SioPending * ent = &gSioSt->pending_recv[gSioSt->next_pending_recv];

    ent->packet.head.kind = data->head.kind;
    ent->packet.head.sender = data->head.sender;
    ent->packet.head.param = data->head.param;

    ent->packet.len = data->len;

    for (i = 0; i < data->len; i++)
    {
        ent->packet.bytes[i] = data->bytes[i];
    }

    gSioSt->next_pending_recv += 1;
    gSioSt->next_pending_recv &= 3;
}

struct SioData * func_common_02015E28(u32 * out)
{
    // TODO: clean up

    if (gSioSt->pending_send[gSioSt->next_pending_send].packet.head.kind != SIO_MSG_DATA)
        return NULL;

    s_unk_03000040 = &gSioSt->pending_send[gSioSt->next_pending_send];

    *out = gSioSt->pending_send[gSioSt->next_pending_send].packet.len;
    return &gSioSt->pending_send[gSioSt->next_pending_send].packet;
}

int SioEmitData(u8 const * src, fu16 len)
{
    // TODO: clean up

    int result;
    fu8 i;

    struct SioData * dat;

    s_unk_03000044 = 1;

    gSioSt->pending_send[gSioSt->next_pending_write].unk_00 = 0;
    dat = &gSioSt->pending_send[gSioSt->next_pending_write].packet;

    dat->head.kind = SIO_MSG_DATA;
    dat->head.sender = gSioSt->self_id;
    dat->head.param = gSioSt->unk_022;
    dat->len = len;

    gSioSt->unk_022++;

    for (i = 0; i < len; i++)
    {
        dat->bytes[i] = src[i];
    }

    result = gSioSt->next_pending_write;

    gSioSt->next_pending_write += 1;
    gSioSt->next_pending_write &= 7;

    s_unk_03000044 = 0;

    return result;
}

int SioReceiveData(void * dst, u8 * out_sender_id, bool (*verify)(void *))
{
    fu8 i;
    fu8 sender_id;

    struct SioData * dat = &gSioSt->pending_recv[gSioSt->next_pending_read].packet;

    if (dat->head.kind != SIO_MSG_DATA || dat->head.sender == gSioSt->self_id)
        return 0;

    if (dat->head.param != gSioSt->seq[dat->head.sender])
    {
        gSioMsgBuf.kind = SIO_MSG_DATA_ACK;
        gSioMsgBuf.sender = (gSioSt->self_id << 4) | dat->head.sender;
        gSioMsgBuf.param = gSioSt->seq[dat->head.sender];

        SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));

        dat->head.kind = 0;

        gSioSt->next_pending_read += 1;
        gSioSt->next_pending_read &= 3;

        // recursion!
        return SioReceiveData(dst, out_sender_id, verify);
    }
    else
    {
        for (i = 0; i < dat->len; i++)
        {
            ((u8 *)dst)[i] = dat->bytes[i];
        }

        if (verify != NULL && !verify(dst))
        {
            gSioMsgBuf.kind = SIO_MSG_DATA_ACK;
            gSioMsgBuf.sender = (gSioSt->self_id << 4) | dat->head.sender;
            gSioMsgBuf.param = gSioSt->seq[dat->head.sender];

            SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));

            dat->head.kind = 0;

            gSioSt->next_pending_read += 1;
            gSioSt->next_pending_read &= 3;

            // recursion!
            return SioReceiveData(dst, out_sender_id, verify);
        }
        else
        {
            dat->head.kind = 0;

            sender_id = dat->head.sender;

            gSioSt->seq[dat->head.sender] += 1;

            gSioSt->next_pending_read += 1;
            gSioSt->next_pending_read &= 3;

            *out_sender_id = sender_id;

            gSioMsgBuf.kind = SIO_MSG_DATA_ACK;
            gSioMsgBuf.sender = (gSioSt->self_id << 4) | dat->head.sender;
            gSioMsgBuf.param = gSioSt->seq[dat->head.sender];

            SioSend(&gSioMsgBuf, sizeof(gSioMsgBuf));

            return dat->len;
        }
    }
}

void func_common_020160C0(void)
{
    int i;

    u16 abc = 0x7FFF;

    gSioSt->unk_001 = 0;

    SioSend16(&abc, 1);

    s_write_cursor = s_send_cursor;

    for (i = 0; i < 4; i++)
    {
        s_recv_cursor[i] = s_read_cursor[i];
    }
}

void func_common_02016114(int arg_0)
{
    gSioSt->unk_021 = arg_0;
}

void func_common_02016124(void)
{
    int i;

    u16 abc = 0x7FFF;

    gSioSt->unk_001 = 0;
    gSioSt->unk_7CC = 0;

    SioSend16(&abc, 1);

    s_write_cursor = s_send_cursor;

    for (i = 0; i < 4; i++)
    {
        s_recv_cursor[i] = s_read_cursor[i];
    }

    gSioSt->unk_7CE = 0;
    gSioSt->unk_001 = 3;
}

void func_common_02016198(void)
{
    int i;

    u16 abc = 0x2586;

    gSioSt->unk_004 = 0;
    gSioSt->unk_001 = 0;
    gSioSt->unk_7CC = 15;

    s_write_cursor = s_send_cursor;

    for (i = 0; i < 4; i++)
    {
        s_recv_cursor[i] = s_read_cursor[i];
    }

    gSioSt->unk_001 = 1;
    gSioSt->unk_004 = 6;

    SioSend16(&abc, -1);
}

void func_common_02016210(void)
{
    int i;

    u16 abc = 0x2586;

    gSioSt->unk_004 = 0;
    gSioSt->unk_001 = 0;
    gSioSt->unk_7CC = 24;

    s_write_cursor = s_send_cursor;

    for (i = 0; i < 4; i++)
    {
        s_recv_cursor[i] = s_read_cursor[i];
    }

    gSioSt->unk_001 = 1;
    gSioSt->unk_004 = 6;

    SioSend16(&abc, -1);
}

void func_common_02016288(void)
{
    s_write_cursor = s_send_cursor;
}

#if defined(VER_20030206)
int func_06_02016424(int player_id)
{
    int result;

    if (player_id < 0)
    {
        if (s_send_cursor > s_write_cursor)
        {
            result = 0x200 - s_send_cursor + s_write_cursor;
        }
        else
        {
            result = s_write_cursor - s_send_cursor;
        }
    }
    else
    {
        if (s_read_cursor[player_id] > s_recv_cursor[player_id])
        {
            result = 0x200 - s_read_cursor[player_id] + s_recv_cursor[player_id];
        }
        else
        {
            result = s_recv_cursor[player_id] - s_read_cursor[player_id];
        }
    }

    return result;
}
#endif

void func_common_0201629C(struct SioBigSendProc * proc)
{
    int i;
    u8 data[4];

    gSioSt->self_seq = gSioSt->unk_022 = gSioSt->unk_02E = 0;

    gSioSt->seq[0] = gSioSt->seq[1] = gSioSt->seq[2] = gSioSt->seq[3] = 0;

    func_02014DF4();

    data[0] = proc->unk_34;
    data[1] = proc->block_count >> 8;
    data[2] = proc->block_count & 0xFF;
    data[3] = proc->last_block_len;

    SioEmitData(data, sizeof(data));
    gSioSt->unk_02E = 1;
}

void func_common_020162FC(struct SioBigSendProc * proc)
{
    if (proc->func != NULL)
        proc->func(proc);

    if (gSioSt->unk_02E == 0)
    {
        if (proc->current_block != gSioSt->self_seq - 1)
        {
            proc->data += SIO_MAX_DATA;
            proc->completion_percent = proc->current_block * 100 / proc->block_count;
            proc->current_block++;
        }

        SioEmitData(proc->data, SIO_MAX_DATA);
        gSioSt->unk_02E = 1;

        gSioSt->unk_010 = 0;

        if (proc->current_block >= proc->block_count)
            Proc_Break(proc);
    }
}

void func_common_0201636C(struct SioBigReceiveProc * proc)
{
    gSioSt->self_seq = gSioSt->unk_022 = gSioSt->unk_02E = 0;

    gSioSt->seq[0] = gSioSt->seq[1] = gSioSt->seq[2] = gSioSt->seq[3] = 0;

    func_02014DF4();
}

void func_common_02016394(struct SioBigReceiveProc * proc)
{
    u8 data[4];
    u8 id;

    fu16 got = SioReceiveData(&data, &id, NULL);

    if (got != 0)
    {
        proc->unk_34 = data[0];
        proc->block_count = (data[1] << 8) + (data[2] & 0xFF);
        proc->last_block_len = data[3];

        Proc_Break(proc);
    }
}

void func_common_020163D8(struct SioBigReceiveProc * proc)
{
    int i;
    u8 id;

    u8 * buf = gBuf;

    if (proc->current_block < proc->block_count - 1)
    {
        fu16 got = SioReceiveData(proc->data, &id, NULL);

        if (got != 0)
        {
            proc->data += SIO_MAX_DATA;
            proc->completion_percent = proc->current_block * 100 / proc->block_count;
            proc->current_block++;
        }
    }
    else
    {
        fu16 got = SioReceiveData(buf, &id, NULL);

        if (got != 0)
        {
            for (i = 0; i < proc->last_block_len; i++)
            {
                *((u8 *)proc->data) = buf[i];
                proc->data++;
            }

            proc->completion_percent = proc->current_block * 100 / proc->block_count;
            proc->current_block++;
        }
    }

    if (proc->func != NULL)
        proc->func(proc);

    if (proc->current_block >= proc->block_count)
        Proc_Break(proc);
}

// clang-format off

struct ProcScr SHOULD_BE_CONST ProcScr_SioBigSend[] =
{
    PROC_SLEEP(0),
    PROC_CALL(func_common_0201629C),
    PROC_REPEAT(func_common_020162FC),
    PROC_END,
};

struct ProcScr SHOULD_BE_CONST ProcScr_SioBigReceive[] =
{
    PROC_SLEEP(0),
    PROC_CALL(func_common_0201636C),
    PROC_REPEAT(func_common_02016394),
    PROC_REPEAT(func_common_020163D8),
    PROC_END,
};

// clang-format on

int StartSioBigSend(void * data, u32 len, void (*func)(struct SioBigSendProc *), fu8 arg_3, AnyProc * parent)
{
    struct SioBigSendProc * proc;

    fu8 last_block_len;
    fu16 block_count;

    if (len > SIO_MAX_DATA * UINT16_MAX)
        return -1;

    block_count = len / SIO_MAX_DATA + 1;

    if (len % SIO_MAX_DATA != 0)
        block_count++;

    last_block_len = len % SIO_MAX_DATA;

    proc = SpawnProcLocking(ProcScr_SioBigSend, parent);

    proc->data = data;
    proc->unk_34 = arg_3;
    proc->func = func;
    proc->block_count = block_count;
    proc->last_block_len = last_block_len;
    proc->completion_percent = 0;
    proc->current_block = 0;
    proc->unk_3C = 0;

    return 0;
}

void StartSioBigReceive(void * data, void (*func)(struct SioBigReceiveProc *), AnyProc * parent)
{
    struct SioBigReceiveProc * proc;

    proc = SpawnProcLocking(ProcScr_SioBigReceive, parent);

    proc->func = func;
    proc->data = data;
    proc->completion_percent = 0;
    proc->current_block = 0;
    proc->unk_3C = 0;
}

bool IsSioBigTransferActive(void)
{
    if (FindProc(ProcScr_SioBigSend) == NULL && FindProc(ProcScr_SioBigReceive) == NULL)
        return FALSE;

    return TRUE;
}

int func_common_0201655C(u8 const * src, u8 * dst)
{
    int len = 0;

    while (*src != 0)
    {
        *dst++ = *src++;
        len++;
    }

    *dst++ = *src++;

    return len;
}

void func_common_02016578(void)
{
    func_common_02014FE8();
    func_02014F80();

    gSioSt->unk_001 = 1;
    gSioSt->unk_004 = 0;
}

void func_common_02016598(AnyProc * proc)
{
    u16 var = 0x2586;

    if (func_02014C94() != -1)
    {
        gSioSt->unk_011 = 0;
        gSioSt->unk_004 = 5;
        gSioSt->self_id = func_02014DB0();

        SioSend16(&var, -1);

        Proc_Break(proc);
    }
}

// clang-format off

struct ProcScr SHOULD_BE_CONST ProcScr_SioCon[] =
{
    PROC_NAME("SIOCON"),
    PROC_15,
    PROC_CALL(func_common_02016578),
    PROC_REPEAT(func_common_02016598),
    PROC_END,
};

struct ProcScr SHOULD_BE_CONST ProcScr_SioVSync[] =
{
    PROC_NAME("SIOVSYNC"),
    PROC_15,
    PROC_SLEEP(0),
    PROC_REPEAT(SioVSync_Loop),
    PROC_END,
};

struct ProcScr SHOULD_BE_CONST ProcScr_SioMain[] =
{
    PROC_NAME("SIOMAIN"),
    PROC_15,
    PROC_REPEAT(SioMain_Loop),
    PROC_END,
};

// clang-format on
