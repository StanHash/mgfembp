    .syntax unified

    .text

    @ TODO: clean this up

    .global _start
    .type _start, function

    .arm
_start:
    mov r0, #0x12
    msr cpsr_fc, r0
    ldr sp, .L02010038 @ =0x03007FA0
    mov r0, #0x1f
    msr cpsr_fc, r0
    ldr sp, .L02010034 @ =0x03007E00
    ldr r1, .L02010150 @ =0x03007FFC
    adr r0, IrqMain
    str r0, [r1]
    ldr r1, .LMain @ =Main
    mov lr, pc
    bx  r1
    b   _start

    .align 2, 0
.L02010034: .4byte 0x03007E00
.L02010038: .4byte 0x03007FA0

    .global IrqMain
    .type IrqMain, function

    .arm
IrqMain: @ 0x0201003C
    mov r3, #0x4000000
    add r3, r3, #0x200
    ldr r2, [r3]
    lsl r1, r2, #0x10
    lsr r1, r1, #0x10
    mrs r0, spsr
    push {r0, r1, r3, lr}
    and r1, r2, r2, lsr #16
    ands r0, r1, #0x2000
.L02010060:
    bne .L02010060
    mov r2, #0
    ands r0, r1, #0xc0
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #1
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #2
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #4
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #8
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x10
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x20
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x100
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x200
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x400
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x800
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x1000
    bne .L02010100
    add r2, r2, #4
    ands r0, r1, #0x2000
.L020100FC:
    bne .L020100FC
.L02010100:
    strh r0, [r3, #2]
    mrs r3, apsr
    bic r3, r3, #0xdf
    orr r3, r3, #0x1f
    msr cpsr_fc, r3
    ldr r1, .LIrqFuncTable @ =gIrqFuncTable
    add r1, r1, r2
    ldr r0, [r1]
    stmdb sp!, {lr}
    adr lr, .L0201012C
    bx r0
.L0201012C:
    ldm sp!, {lr}
    mrs r3, apsr
    bic r3, r3, #0xdf
    orr r3, r3, #0x92
    msr cpsr_fc, r3
    pop {r0, r1, r3, lr}
    strh r1, [r3]
    msr spsr_fc, r0
    bx lr

    .align 2, 0
.L02010150: .4byte 0x03007FFC

.LMain: .4byte Main
.LIrqFuncTable: .4byte gIrqFuncTable

    @ would using .size here make sense? both funcs overlap
