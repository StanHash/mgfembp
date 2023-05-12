    .syntax unified

    .text

    .global ArmCodeStart
    .type ArmCodeStart, object

ArmCodeStart:

.L0201015C: .4byte 0x0202A620
.L02010160: .4byte 0x0202A020
.L02010164: .4byte 0x0202A000

    .global ColorFadeTick
    .type ColorFadeTick, function

    .arm
ColorFadeTick: @ 0x02010168
    push {r4, r5, r6, r7}
    mov r7, #0x3e0
.L02010170:
    ldr r0, .L02010164 @ =0x0202A000
    add r0, r0, r7, lsr #5
    ldrsb r5, [r0]
    tst r5, r5
    beq .L02010228
    ldr r4, .L02010160 @ =0x0202A020
    lsr r0, r7, #1
    add r0, r0, r0, lsl #1
    add r0, r0, #0x30
    add r4, r4, r0
    mov r6, #0x1e
.L0201019C:
    sub r4, r4, #3
    ldrb r0, [r4]
    add r0, r0, r5
    strb r0, [r4]
    subs r0, r0, #0x20
    bpl .L020101B8
    mov r0, #0
.L020101B8:
    cmp r0, #0x20
    blo .L020101C4
    mov r0, #0x1f
.L020101C4:
    ldrb r1, [r4, #1]
    add r1, r1, r5
    strb r1, [r4, #1]
    subs r1, r1, #0x20
    bpl .L020101DC
    mov r1, #0
.L020101DC:
    cmp r1, #0x20
    blo .L020101E8
    mov r1, #0x1f
.L020101E8:
    ldrb r2, [r4, #2]
    add r2, r2, r5
    strb r2, [r4, #2]
    subs r2, r2, #0x20
    bpl .L02010200
    mov r2, #0
.L02010200:
    cmp r2, #0x20
    blo .L0201020C
    mov r2, #0x1f
.L0201020C:
    add r0, r0, r1, lsl #5
    add r0, r0, r2, lsl #10
    ldr r1, .L0201015C @ =0x0202A620
    add r1, r1, r6
    strh r0, [r1, r7]
    subs r6, r6, #2
    bpl .L0201019C
.L02010228:
    subs r7, r7, #0x20
    bpl .L02010170
    pop {r4, r5, r6, r7}
    bx lr

    .size ColorFadeTick, . - ColorFadeTick

    .global ClearOam
    .type ClearOam, function

    .arm
ClearOam:
    lsr r1, r1, #4
    sub r1, r1, #1
    mov r2, #0xa0
.L02010244:
    str r2, [r0]
    str r2, [r0, #8]
    str r2, [r0, #0x10]
    str r2, [r0, #0x18]
    str r2, [r0, #0x20]
    str r2, [r0, #0x28]
    str r2, [r0, #0x30]
    str r2, [r0, #0x38]
    str r2, [r0, #0x40]
    str r2, [r0, #0x48]
    str r2, [r0, #0x50]
    str r2, [r0, #0x58]
    str r2, [r0, #0x60]
    str r2, [r0, #0x68]
    str r2, [r0, #0x70]
    str r2, [r0, #0x78]
    add r0, r0, #0x80
    subs r1, r1, #1
    bpl .L02010244
    bx lr

    .size ClearOam, . - ClearOam

    .global Checksum32
    .type Checksum32, function

    .arm
Checksum32:
    push {r4, r5, r6, r7}
    sub r1, r1, #2
    mov r2, #0
    mov r3, #0
.L020102A4:
    ldrh r4, [r0]
    add r2, r2, r4
    eor r3, r3, r4
    add r0, r0, #2
    subs r1, r1, #2
    bpl .L020102A4
    mov r0, #0x10000
    sub r0, r0, #1
    and r2, r2, r0
    lsl r3, r3, #0x10
    mov r0, r2
    add r0, r0, r3
    pop {r4, r5, r6, r7}
    bx lr

    .global func_020102DC
    .type func_020102DC, function

    .arm
func_020102DC: @ 0x020102DC
    push {r4, r5, r6, r7}
    mov r4, r0
    sub r6, r2, #0
.L020102E8:
    sub r5, r1, #0
.L020102EC:
    strh r3, [r4]
    add r4, r4, #2
    subs r5, r5, #1
    bpl .L020102EC
    add r0, r0, #0x40
    mov r4, r0
    subs r6, r6, #1
    bpl .L020102E8
    pop {r4, r5, r6, r7}
    bx lr

    .global func_02010314
    .type func_02010314, function

    .arm
func_02010314: @ 0x02010314
    push {r4, r5, r6, r7}
    tst r2, r2
    beq .L02010368
    bmi .L02010368
    tst r3, r3
    beq .L02010368
    bmi .L02010368
    mov r4, #0x40
    sub r4, r4, r2, lsl #1
    sub r6, r3, #1
.L0201033C:
    sub r5, r2, #1
.L02010340:
    ldrh r7, [r0]
    strh r7, [r1]
    add r0, r0, #2
    add r1, r1, #2
    subs r5, r5, #1
    bpl .L02010340
    add r0, r0, r4
    add r1, r1, r4
    subs r6, r6, #1
    bpl .L0201033C
.L02010368:
    pop {r4, r5, r6, r7}
    bx lr

    .global func_02010370
    .type func_02010370, function

    .arm
func_02010370: @ 0x02010370
    push {r4, r5, r6, r7}
    ldrb r3, [r1]
    ldrb r4, [r1, #1]
    add r1, r1, #2
    lsl r7, r4, #6
    add r0, r0, r7
    mov r6, r4
.L0201038C:
    mov r5, r3
.L02010390:
    ldrh r7, [r1]
    add r7, r7, r2
    strh r7, [r0]
    add r0, r0, #2
    add r1, r1, #2
    subs r5, r5, #1
    bpl .L02010390
    sub r0, r0, r3, lsl #1
    sub r0, r0, #0x42
    subs r6, r6, #1
    bpl .L0201038C
    pop {r4, r5, r6, r7}
    bx lr
    .align 2, 0
.L020103C4: .4byte 0x03000A00

    .global func_020103C8
    .type func_020103C8, function

    .arm
func_020103C8: @ 0x020103C8
    push {r4, r5, r6, r7}
    ldr r7, .L020103C4 @ =0x03000A00
.L020103D0:
    ldr r5, [r7]
    ldrh r4, [r2]
    tst r4, r4
    beq .L0201045C
    bmi .L0201045C
    add r2, r2, #2
    add r6, r5, r4, lsl #3
    str r6, [r7]
    mov r7, #0x10000
    sub r7, r7, #1
    and r0, r0, r7
    and r1, r1, r7
    orr r0, r0, r1, lsl #16
.L02010404:
    ldrh r1, [r2]
    orr r6, r1, r0, lsr #16
    and r6, r6, #0xff00
    add r7, r1, r0, lsr #16
    and r7, r7, #0xff
    orr r6, r6, r7
    strh r6, [r5]
    ldrh r1, [r2, #2]
    orr r6, r1, r0
    and r6, r6, #0xfe00
    add r7, r1, r0
    lsl r7, r7, #0x17
    lsr r7, r7, #0x17
    orr r6, r6, r7
    strh r6, [r5, #2]
    ldrh r1, [r2, #4]
    add r6, r1, r3
    strh r6, [r5, #4]
    add r2, r2, #6
    add r5, r5, #8
    subs r4, r4, #1
    bne .L02010404
.L0201045C:
    pop {r4, r5, r6, r7}
    bx lr
    .align 2, 0
.L02010464: .4byte 0x03000340


    .global func_02010468
    .type func_02010468, function

    .arm
func_02010468: @ 0x02010468
    push {r4, r5, r6, r7}
    ldr r7, .L02010464 @ =0x03000340
    b .L020103D0

    .global ArmCodeEnd
    .type ArmCodeEnd, object

ArmCodeEnd:
