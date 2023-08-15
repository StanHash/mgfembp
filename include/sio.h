#ifndef SIO_H
#define SIO_H

#include "prelude.h"

#include "proc.h"

#define SIO_MAX_PACKET 0x80

enum
{
#if !defined(VER_FINAL)
    SIO_MSG_C4 = 0x14,
#else
    SIO_MSG_C4 = 0xC4,
#endif
    SIO_MSG_C5,
    SIO_MSG_C6,
    SIO_MSG_C7,
    SIO_MSG_C8,
    SIO_MSG_C9,
    SIO_MSG_CA,
    SIO_MSG_CB,
    SIO_MSG_CC,
    SIO_MSG_CD,
    SIO_MSG_DATA_ACK,
    SIO_MSG_DATA,
};

struct SioBigSendProc
{
    /* 00 */ PROC_HEADER;
    /* 29 */ STRUCT_PAD(0x29, 0x2C); // implicit
    /* 2C */ void (*func)(struct SioBigSendProc *);
    /* 30 */ void const * data;
    /* 34 */ u8 unk_34;
    /* 35 */ STRUCT_PAD(0x35, 0x36); // implicit
    /* 36 */ u16 block_count;
    /* 38 */ u16 current_block;
    /* 3A */ u8 last_block_len;
    /* 3B */ u8 completion_percent;
    /* 3C */ u8 unk_3C;
};

struct SioBigReceiveProc
{
    // identical to SioBigSendProc, except data is non const pointer

    /* 00 */ PROC_HEADER;
    /* 29 */ STRUCT_PAD(0x29, 0x2C); // implicit
    /* 2C */ void (*func)(struct SioBigReceiveProc *);
    /* 30 */ void * data;
    /* 34 */ u8 unk_34;
    /* 35 */ STRUCT_PAD(0x35, 0x36); // implicit
    /* 36 */ u16 block_count;
    /* 38 */ u16 current_block;
    /* 3A */ u8 last_block_len;
    /* 3B */ u8 completion_percent;
    /* 3C */ u8 unk_3C;
};

enum
{
    PLAYER_STATUS_0 = 0,
    PLAYER_STATUS_1 = 1,
    PLAYER_STATUS_2 = 2,
    PLAYER_STATUS_5 = 5,
};

struct SioMessage
{
    /* 00 */ u8 kind;
    /* 01 */ u8 sender;
    /* 02 */ u16 param;
};

struct SioData
{
    /* 00 */ struct SioMessage head;
    /* 04 */ u16 len;
    /* 06 */ u8 bytes[SIO_MAX_PACKET];
    /* 86 */ STRUCT_PAD(0x86, 0x88);
};

struct SioPending
{
    /* 00 */ u8 unk_00;
    /* 01 */ STRUCT_PAD(0x01, 0x04);
    /* 04 */ struct SioData packet;
    /* 8C */ // end
};

struct SioSt
{
    /* 000 */ u8 unk_000;
    /* 001 */ u8 unk_001;
    /* 002 */ u16 last_sio_cnt;
    /* 004 */ u16 unk_004;
    /* 006 */ i8 self_id;
    /* 007 */ u8 unk_007;
    /* 008 */ u8 recv_flags;
    /* 009 */ u8 unk_009;
    /* 00A */ u8 unk_00A;
    /* 00B */ u8 player_status[4];
    /* 00F */ u8 unk_00F;
    /* 010 */ u8 unk_010;
    /* 011 */ u8 unk_011;
    /* 012 */ u16 last_recv[4];
    /* 01A */ u8 timeout_clock[4];
    /* 01E */ u8 unk_01E;
    /* 01F */ u8 unk_01F;
    /* 020 */ u8 unk_020;
    /* 021 */ u8 unk_021;
    /* 022 */ u16 unk_022;
    /* 024 */ u16 self_seq;
    /* 026 */ u16 seq[4];
    /* 02E */ u8 unk_02E;
    /* 02F */ STRUCT_PAD(0x02F, 0x030); // implicit
    /* 030 */ u16 unk_030;
    /* 032 */ u16 buf[SIO_MAX_PACKET];
    /* 132 */ STRUCT_PAD(0x132, 0x134); // implicit
    /* 134 */ struct SioPending pending_send[8];
    /* 594 */ struct SioPending pending_recv[4];
    /* 7C4 */ u8 next_pending_send;
    /* 7C5 */ u8 next_pending_write;
    /* 7C6 */ u8 next_pending_read;
    /* 7C7 */ u8 next_pending_recv;
    /* 7C8 */ u16 unk_7C8;
    /* 7CA */ u16 unk_7CA;
    /* 7CC */ u16 unk_7CC;
    /* 7CE */ u16 unk_7CE;
};

int func_02014C94(void);
int func_02014DB0(void);
void func_02014DC0(fu16 arg_0, fu16 arg_1, fu16 arg_2);
void func_02014DF4(void);
void func_02014F80(void);
void func_common_02014FE8(void);
void func_common_02015064(void);
void SioOnSerial(void);
void func_common_02015314(void);
void func_common_02015330(void);
void func_common_0201533C(void);
void func_common_02015384(void);
void func_common_02015400(void);
void SioVSync_Loop(void);
void func_common_02015584(void);
void func_common_020155A8(int arg_0);
void SioMain_Loop(void);
void func_common_020158D0(void);
int func_common_020158D4(void);
int func_common_02015900(void);
bool func_common_0201592C(fu8 arg_0);
bool func_common_0201594C(fu8 arg_0);
bool func_common_0201596C(void);
int func_common_020159C0(void);
bool func_common_020159F0(void);
fi16 SioSend(void const * src, fu16 len);
fi16 func_common_02015B34(fi8 player_id, void * dst);
int SioSend16(u16 * arg_0, int arg_1);
int func_common_02015D48(int unused_0, u16 * arg_1);
void SioQueuePendingRecvData(struct SioData * data);
struct SioData * func_common_02015E28(u32 * out);
int SioEmitData(u8 const * src, fu16 len);
int SioReceiveData(void * dst, u8 * arg_1, bool (*verify)(void *));
void func_common_020160C0(void);
void func_common_02016114(int arg_0);
void func_common_02016124(void);
void func_common_02016198(void);
void func_common_02016210(void);
void func_common_02016288(void);
void func_common_0201629C(struct SioBigSendProc * proc);
void func_common_020162FC(struct SioBigSendProc * proc);
void func_common_0201636C(struct SioBigReceiveProc * proc);
void func_common_02016394(struct SioBigReceiveProc * proc);
void func_common_020163D8(struct SioBigReceiveProc * proc);
int StartSioBigSend(void * data, u32 len, void (*func)(struct SioBigSendProc *), fu8 arg_3, AnyProc * parent);
void StartSioBigReceive(void * data, void (*func)(struct SioBigReceiveProc *), AnyProc * parent);
bool IsSioBigTransferActive(void);
int func_common_0201655C(u8 const * src, u8 * dst);
void func_common_02016578(void);
void func_common_02016598(AnyProc * proc);

#if defined(VER_20030206)
int func_06_02016424(int player_id);
#endif

extern struct SioSt * SHOULD_BE_CONST gSioSt;

extern struct ProcScr SHOULD_BE_CONST ProcScr_SioBigSend[];
extern struct ProcScr SHOULD_BE_CONST ProcScr_SioBigReceive[];
extern struct ProcScr SHOULD_BE_CONST ProcScr_SioCon[];
extern struct ProcScr SHOULD_BE_CONST ProcScr_SioVSync[];
extern struct ProcScr SHOULD_BE_CONST ProcScr_SioMain[];

#define SIO_MAX_DATA (SIO_MAX_PACKET - offsetof(struct SioData, bytes))

#endif // SIO_H
