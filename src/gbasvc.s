    .text
    .syntax unified

    .thumb

    .global SwiCpuFastSet
    .type SwiCpuFastSet, function
SwiCpuFastSet:
    svc #0x0C
    bx lr

    .global SwiCpuSet
    .type SwiCpuSet, function
SwiCpuSet:
    svc #0x0B
    bx lr

    .global SwiHuffUnCompReadNormal
    .type SwiHuffUnCompReadNormal, function
SwiHuffUnCompReadNormal:
    svc #0x13
    bx lr

    .global SwiLZ77UnCompReadNormalWrite16bit
    .type SwiLZ77UnCompReadNormalWrite16bit, function
SwiLZ77UnCompReadNormalWrite16bit:
    svc #0x12
    bx lr

    .global SwiLZ77UnCompReadNormalWrite8bit
    .type SwiLZ77UnCompReadNormalWrite8bit, function
SwiLZ77UnCompReadNormalWrite8bit:
    svc #0x11
    bx lr

    .global SwiRLUnCompReadNormalWrite16bit
    .type SwiRLUnCompReadNormalWrite16bit, function
SwiRLUnCompReadNormalWrite16bit:
    svc #0x15
    bx lr

    .global SwiRLUnCompReadNormalWrite8bit
    .type SwiRLUnCompReadNormalWrite8bit, function
SwiRLUnCompReadNormalWrite8bit:
    svc #0x14
    bx lr

    .global SwiSoftReset
    .type SwiSoftReset, function
SwiSoftReset:
    ldr r3, .L02016AC8 @ =0x04000208
    movs r2, #0
    strb r2, [r3]
    ldr r1, .L02016ACC @ =0x03007F00
    mov sp, r1
    svc #0x01
    svc #0x00
    movs r0, r0
    .align 2, 0
.L02016AC8: .4byte 0x04000208
.L02016ACC: .4byte 0x03007F00

    .global SwiSoundBiasReset
    .type SwiSoundBiasReset, function
SwiSoundBiasReset:
    movs r0, #0
    svc #0x19
    bx lr
    .align 2, 0

    .global SwiSoundBiasSet
    .type SwiSoundBiasSet, function
SwiSoundBiasSet:
    movs r0, #1
    svc #0x19
    bx lr
    .align 2, 0

    .global SwiVBlankIntrWait
    .type SwiVBlankIntrWait, function
SwiVBlankIntrWait:
    movs r2, #0
    svc #0x05
    bx lr
    .align 2, 0
