    .include "asm/head.inc"

	thumb_func_start func_02014B0C
func_02014B0C: @ 0x02014B0C
	push {r4, lr}
	adds r4, r0, #0
	bl IsSramWorking
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L02014B28
	movs r0, #0
	adds r1, r4, #0
	bl ReadSaveBlockInfo
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	b .L02014B2A
.L02014B28:
	movs r0, #0
.L02014B2A:
	pop {r4}
	pop {r1}
	bx r1

	thumb_func_start func_02014B30
func_02014B30: @ 0x02014B30
	push {r4, lr}
	adds r4, r1, #0
	bl GetSaveReadAddr
	ldr r1, .L02014B4C @ =ReadSramFast
	ldr r3, [r1]
	adds r1, r4, #0
	movs r2, #0x20
	bl _call_via_r3
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014B4C: .4byte ReadSramFast

	thumb_func_start ReadGameSaveUnits
ReadGameSaveUnits: @ 0x02014B50
	push {r4, r5, r6, r7, lr}
	bl GetSaveReadAddr
	adds r7, r0, #0
	bl InitUnits
	movs r6, #0
	adds r4, r7, #0
	adds r4, #0x20
	movs r5, #0x33
.L02014B64:
	ldr r1, .L02014B84 @ =gUnits
	adds r1, r6, r1
	adds r0, r4, #0
	bl ReadGameSavePackedUnit
	adds r6, #0x48
	adds r4, #0x28
	subs r5, #1
	cmp r5, #0
	bge .L02014B64
	adds r0, r7, #0
	adds r0, #0x20
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02014B84: .4byte gUnits

	thumb_func_start ReadGameSavePackedUnit
ReadGameSavePackedUnit: @ 0x02014B88
	push {r4, r5, lr}
	sub sp, #0x28
	adds r4, r1, #0
	ldr r1, .L02014C90 @ =ReadSramFast
	ldr r3, [r1]
	mov r1, sp
	movs r2, #0x28
	bl _call_via_r3
	ldr r0, [sp]
	lsls r0, r0, #0xd
	lsrs r0, r0, #0x1b
	strb r0, [r4, #8]
	mov r0, sp
	ldrb r0, [r0, #3]
	lsrs r3, r0, #1
	strb r3, [r4, #9]
	mov r0, sp
	ldrb r0, [r0]
	lsls r0, r0, #0x19
	lsrs r0, r0, #0x19
	strb r0, [r4, #0xe]
	mov r0, sp
	ldrh r0, [r0]
	lsls r0, r0, #0x12
	lsrs r0, r0, #0x19
	strb r0, [r4, #0xf]
	ldr r0, [sp, #4]
	lsls r0, r0, #0xe
	lsrs r0, r0, #0x1a
	strb r0, [r4, #0x10]
	mov r0, sp
	ldrb r0, [r0, #6]
	lsls r0, r0, #0x19
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x12]
	mov r0, sp
	ldrh r0, [r0, #6]
	lsls r0, r0, #0x14
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x13]
	mov r0, sp
	ldrb r1, [r0, #7]
	lsrs r1, r1, #4
	ldrb r0, [r0, #8]
	movs r5, #1
	ands r0, r5
	lsls r0, r0, #4
	orrs r0, r1
	strb r0, [r4, #0x14]
	mov r0, sp
	ldrb r0, [r0, #8]
	lsls r0, r0, #0x1a
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x15]
	mov r0, sp
	ldrh r0, [r0, #8]
	lsls r0, r0, #0x15
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x16]
	mov r0, sp
	ldrb r0, [r0, #9]
	lsrs r0, r0, #3
	strb r0, [r4, #0x17]
	mov r0, sp
	ldrb r0, [r0, #0xa]
	lsls r0, r0, #0x1b
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x18]
	mov r0, sp
	ldrh r0, [r0, #0xa]
	lsls r0, r0, #0x16
	lsrs r0, r0, #0x1b
	strb r0, [r4, #0x1a]
	mov r0, sp
	ldrb r1, [r0, #0xb]
	lsrs r1, r1, #2
	ldrb r0, [r0, #0xc]
	lsls r0, r0, #6
	orrs r0, r1
	strh r0, [r4, #0x1c]
	ldr r0, [sp, #0xc]
	lsls r0, r0, #0xa
	lsrs r0, r0, #0x12
	strh r0, [r4, #0x1e]
	mov r0, sp
	ldrh r2, [r0, #0xe]
	lsrs r2, r2, #6
	ldrb r0, [r0, #0x10]
	movs r1, #0xf
	ands r0, r1
	lsls r0, r0, #0xa
	orrs r0, r2
	strh r0, [r4, #0x20]
	ldr r0, [sp, #0x10]
	lsls r0, r0, #0xe
	lsrs r0, r0, #0x12
	strh r0, [r4, #0x22]
	mov r0, sp
	ldrh r0, [r0, #0x12]
	lsrs r0, r0, #2
	strh r0, [r4, #0x24]
	cmp r3, #0x63
	bls .L02014C5C
	movs r0, #0xff
	strb r0, [r4, #9]
.L02014C5C:
	movs r0, #0
	strh r0, [r4, #0xc]
	mov r0, sp
	ldrh r0, [r0, #2]
	lsls r0, r0, #0x17
	lsrs r0, r0, #0x1a
	ands r0, r5
	cmp r0, #0
	beq .L02014C72
	movs r0, #5
	strh r0, [r4, #0xc]
.L02014C72:
	movs r2, #0
	adds r4, #0x30
	mov r3, sp
	adds r3, #0x1e
.L02014C7A:
	adds r0, r4, r2
	adds r1, r3, r2
	ldrb r1, [r1]
	strb r1, [r0]
	adds r2, #1
	cmp r2, #9
	ble .L02014C7A
	add sp, #0x28
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02014C90: .4byte ReadSramFast

	thumb_func_start func_02014C94
func_02014C94: @ 0x02014C94
	push {r4, r5, lr}
	ldr r4, .L02014CA8 @ =0x03001CC8
	ldr r3, [r4]
	cmp r3, #0
	beq .L02014CB0
	cmp r3, #1
	beq .L02014D04
	ldr r0, .L02014CAC @ =0x0300003C
	ldr r0, [r0]
	b .L02014DA6
	.align 2, 0
.L02014CA8: .4byte 0x03001CC8
.L02014CAC: .4byte 0x0300003C
.L02014CB0:
	ldr r0, .L02014CF0 @ =0x04000134
	strh r3, [r0]
	ldr r2, .L02014CF4 @ =0x04000128
	ldr r0, .L02014CF8 @ =0x03000038
	ldrb r0, [r0]
	movs r5, #0xc0
	lsls r5, r5, #7
	adds r1, r5, #0
	orrs r0, r1
	strh r0, [r2]
	ldrh r0, [r2]
	adds r2, r0, #0
	movs r0, #8
	ands r0, r2
	cmp r0, #0
	beq .L02014DA2
	ldr r1, .L02014CFC @ =0x0300003C
	movs r0, #4
	ands r2, r0
	lsls r0, r2, #0x10
	lsrs r0, r0, #0x10
	str r0, [r1]
	cmp r0, #0
	beq .L02014CE6
	movs r0, #1
	rsbs r0, r0, #0
	str r0, [r1]
.L02014CE6:
	ldr r0, .L02014D00 @ =0x03001C34
	str r3, [r0]
	movs r0, #1
	str r0, [r4]
	b .L02014DA2
	.align 2, 0
.L02014CF0: .4byte 0x04000134
.L02014CF4: .4byte 0x04000128
.L02014CF8: .4byte 0x03000038
.L02014CFC: .4byte 0x0300003C
.L02014D00: .4byte 0x03001C34
.L02014D04:
	ldr r0, .L02014D48 @ =0x04000128
	ldrh r0, [r0]
	adds r2, r0, #0
	ldr r0, .L02014D4C @ =0x03001C34
	ldr r0, [r0]
	ldr r3, .L02014D50 @ =.L02018648
	cmp r0, #0
	beq .L02014D64
	movs r0, #0x40
	ands r0, r2
	cmp r0, #0
	bne .L02014D64
	ldr r0, [r3]
	ldrh r1, [r0, #0x14]
	ldr r0, .L02014D54 @ =0x0000FFFF
	cmp r1, r0
	beq .L02014D64
	ldr r3, .L02014D58 @ =0x0300003C
	movs r0, #0x30
	ands r2, r0
	lsrs r1, r2, #4
	str r1, [r3]
	movs r0, #2
	str r0, [r4]
	cmp r1, #0
	bne .L02014D42
	ldr r2, .L02014D5C @ =0x04000200
	ldrh r1, [r2]
	ldr r0, .L02014D60 @ =0x0000FF7F
	ands r0, r1
	strh r0, [r2]
.L02014D42:
	ldr r0, [r3]
	b .L02014DA6
	.align 2, 0
.L02014D48: .4byte 0x04000128
.L02014D4C: .4byte 0x03001C34
.L02014D50: .4byte .L02018648
.L02014D54: .4byte 0x0000FFFF
.L02014D58: .4byte 0x0300003C
.L02014D5C: .4byte 0x04000200
.L02014D60: .4byte 0x0000FF7F
.L02014D64:
	ldr r2, .L02014D88 @ =0x04000128
	ldr r0, [r3]
	movs r1, #0xf9
	lsls r1, r1, #3
	adds r0, r0, r1
	ldrh r0, [r0]
	mvns r0, r0
	strh r0, [r2, #2]
	ldr r0, .L02014D8C @ =0x0300003C
	ldr r0, [r0]
	cmp r0, #0
	beq .L02014D94
	ldr r0, .L02014D90 @ =0x03000038
	ldrb r0, [r0]
	movs r3, #0xc0
	lsls r3, r3, #7
	adds r1, r3, #0
	b .L02014D9E
	.align 2, 0
.L02014D88: .4byte 0x04000128
.L02014D8C: .4byte 0x0300003C
.L02014D90: .4byte 0x03000038
.L02014D94:
	ldr r0, .L02014DAC @ =0x03000038
	ldrb r0, [r0]
	movs r5, #0xc1
	lsls r5, r5, #7
	adds r1, r5, #0
.L02014D9E:
	orrs r0, r1
	strh r0, [r2]
.L02014DA2:
	movs r0, #1
	rsbs r0, r0, #0
.L02014DA6:
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0
.L02014DAC: .4byte 0x03000038

	thumb_func_start func_02014DB0
func_02014DB0: @ 0x02014DB0
	ldr r0, .L02014DBC @ =0x04000128
	ldrh r1, [r0]
	movs r0, #0x30
	ands r0, r1
	lsrs r0, r0, #4
	bx lr
	.align 2, 0
.L02014DBC: .4byte 0x04000128

	thumb_func_start func_02014DC0
func_02014DC0: @ 0x02014DC0
	push {r4, r5, lr}
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	ldr r3, .L02014DE8 @ =.L02018648
	ldr r3, [r3]
	movs r5, #0xf9
	lsls r5, r5, #3
	adds r4, r3, r5
	strh r0, [r4]
	ldr r4, .L02014DEC @ =0x000007CA
	adds r0, r3, r4
	strh r1, [r0]
	adds r5, #4
	adds r3, r3, r5
	strh r2, [r3]
	ldr r0, .L02014DF0 @ =0x03000038
	strb r1, [r0]
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02014DE8: .4byte .L02018648
.L02014DEC: .4byte 0x000007CA
.L02014DF0: .4byte 0x03000038

	thumb_func_start func_02014DF4
func_02014DF4: @ 0x02014DF4
	push {r4, r5, r6, r7, lr}
	mov r7, sb
	mov r6, r8
	push {r6, r7}
	ldr r0, .L02014F4C @ =0x03001C30
	movs r3, #0
	str r3, [r0]
	ldr r2, .L02014F50 @ =.L02018648
	ldr r0, [r2]
	movs r1, #0
	strh r3, [r0, #0x22]
	strh r3, [r0, #0x24]
	ldr r4, .L02014F54 @ =0x000007C4
	adds r0, r0, r4
	strb r1, [r0]
	ldr r0, [r2]
	adds r4, #1
	adds r0, r0, r4
	strb r1, [r0]
	ldr r0, [r2]
	adds r4, #1
	adds r0, r0, r4
	strb r1, [r0]
	ldr r0, [r2]
	adds r4, #1
	adds r0, r0, r4
	strb r1, [r0]
	ldr r0, [r2]
	strb r1, [r0, #0x1e]
	ldr r0, [r2]
	strb r1, [r0, #0x1f]
	ldr r0, [r2]
	adds r0, #0x20
	strb r1, [r0]
	ldr r0, [r2]
	strh r3, [r0, #0x30]
	movs r4, #0
	ldr r0, .L02014F58 @ =0x03000048
	mov sb, r0
	ldr r1, .L02014F5C @ =0x0300004A
	mov r8, r1
	adds r6, r2, #0
	movs r5, #0
	ldr r2, .L02014F60 @ =0x0000FFFF
	adds r7, r2, #0
.L02014E4E:
	ldr r0, [r6]
	adds r0, #0xb
	adds r0, r0, r4
	strb r5, [r0]
	ldr r2, [r6]
	lsls r3, r4, #1
	adds r1, r2, #0
	adds r1, #0x12
	adds r1, r1, r3
	ldrh r0, [r1]
	orrs r0, r7
	strh r0, [r1]
	adds r2, #0x1a
	adds r2, r2, r4
	strb r5, [r2]
	ldr r0, [r6]
	adds r0, #0x26
	adds r0, r0, r3
	strh r5, [r0]
	adds r4, #1
	cmp r4, #3
	ble .L02014E4E
	movs r4, #0
	ldr r5, .L02014F64 @ =0x03002E50
	movs r2, #0
	ldr r3, .L02014F50 @ =.L02018648
.L02014E82:
	adds r0, r4, r5
	strb r2, [r0]
	ldr r0, [r3]
	lsls r1, r4, #1
	adds r0, #0x32
	adds r0, r0, r1
	strh r2, [r0]
	adds r4, #1
	cmp r4, #0x7f
	ble .L02014E82
	movs r3, #0
	ldr r5, .L02014F50 @ =.L02018648
	movs r1, #0
	movs r2, #0x9a
	lsls r2, r2, #1
.L02014EA0:
	ldr r0, [r5]
	adds r0, r0, r2
	strb r1, [r0]
	strb r1, [r0, #4]
	movs r4, #0x7f
	adds r0, #0x89
.L02014EAC:
	strb r1, [r0]
	subs r0, #1
	subs r4, #1
	cmp r4, #0
	bge .L02014EAC
	adds r2, #0x8c
	adds r3, #1
	cmp r3, #7
	ble .L02014EA0
	movs r3, #0
	ldr r4, .L02014F50 @ =.L02018648
	mov ip, r4
	movs r5, #0
	movs r7, #0x8c
	ldr r6, .L02014F68 @ =0x00000594
.L02014ECA:
	adds r0, r3, #0
	muls r0, r7, r0
	adds r0, r0, r6
	mov r2, ip
	ldr r1, [r2]
	adds r1, r1, r0
	strb r5, [r1]
	strb r5, [r1, #4]
	adds r2, r3, #1
	movs r4, #0x7f
	adds r1, #0x89
.L02014EE0:
	strb r5, [r1]
	subs r1, #1
	subs r4, #1
	cmp r4, #0
	bge .L02014EE0
	adds r3, r2, #0
	cmp r3, #3
	ble .L02014ECA
	movs r0, #0
	mov r4, r8
	strh r0, [r4]
	mov r1, sb
	strh r0, [r1]
	movs r1, #0
	ldr r0, .L02014F6C @ =0x02030080
	movs r4, #0x80
	lsls r4, r4, #2
.L02014F02:
	strh r1, [r0]
	adds r0, #2
	subs r4, #1
	cmp r4, #0
	bne .L02014F02
	movs r3, #0
	ldr r2, .L02014F70 @ =0x03000050
	mov r8, r2
	movs r5, #0
	ldr r4, .L02014F74 @ =0x000001FF
	mov ip, r4
	ldr r7, .L02014F78 @ =0x02030480
	ldr r6, .L02014F7C @ =0x03000058
.L02014F1C:
	lsls r0, r3, #1
	mov r1, r8
	adds r2, r0, r1
	adds r1, r0, r6
	strh r5, [r1]
	strh r5, [r2]
	adds r2, r3, #1
	adds r0, r0, r7
	mov r4, ip
	adds r4, #1
.L02014F30:
	strh r5, [r0]
	adds r0, #8
	subs r4, #1
	cmp r4, #0
	bne .L02014F30
	adds r3, r2, #0
	cmp r3, #3
	ble .L02014F1C
	pop {r3, r4}
	mov r8, r3
	mov sb, r4
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014F4C: .4byte 0x03001C30
.L02014F50: .4byte .L02018648
.L02014F54: .4byte 0x000007C4
.L02014F58: .4byte 0x03000048
.L02014F5C: .4byte 0x0300004A
.L02014F60: .4byte 0x0000FFFF
.L02014F64: .4byte 0x03002E50
.L02014F68: .4byte 0x00000594
.L02014F6C: .4byte 0x02030080
.L02014F70: .4byte 0x03000050
.L02014F74: .4byte 0x000001FF
.L02014F78: .4byte 0x02030480
.L02014F7C: .4byte 0x03000058

	thumb_func_start func_02014F80
func_02014F80: @ 0x02014F80
	push {r4, lr}
	ldr r2, .L02014FDC @ =.L02018648
	ldr r0, [r2]
	movs r4, #0
	strb r4, [r0]
	ldr r0, [r2]
	strb r4, [r0, #1]
	ldr r1, [r2]
	movs r3, #0
	strh r4, [r1, #2]
	strh r4, [r1, #4]
	movs r0, #0xff
	strb r0, [r1, #6]
	ldr r0, [r2]
	strb r3, [r0, #7]
	ldr r0, [r2]
	strb r3, [r0, #8]
	ldr r0, [r2]
	strb r3, [r0, #9]
	ldr r0, [r2]
	strb r3, [r0, #0xf]
	ldr r0, [r2]
	strb r3, [r0, #0x10]
	ldr r0, [r2]
	strb r3, [r0, #0x11]
	ldr r0, [r2]
	adds r0, #0x2e
	strb r3, [r0]
	ldr r0, [r2]
	strb r3, [r0, #0xa]
	ldr r0, .L02014FE0 @ =0x00004321
	movs r1, #3
	movs r2, #0xf
	bl func_02014DC0
	movs r0, #0
	bl func_common_02016114
	bl func_02014DF4
	ldr r0, .L02014FE4 @ =0x03000044
	str r4, [r0]
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014FDC: .4byte .L02018648
.L02014FE0: .4byte 0x00004321
.L02014FE4: .4byte 0x03000044

	thumb_func_start func_common_02014FE8
func_common_02014FE8: @ 0x02014FE8
	push {r4, lr}
	ldr r0, .L0201503C @ =0x04000134
	movs r3, #0
	strh r3, [r0]
	ldr r2, .L02015040 @ =0x04000128
	ldr r0, .L02015044 @ =0x03000038
	ldrb r0, [r0]
	movs r4, #0x80
	lsls r4, r4, #6
	adds r1, r4, #0
	orrs r0, r1
	strh r0, [r2]
	ldr r0, .L02015048 @ =0x0400010E
	strh r3, [r0]
	ldr r2, .L0201504C @ =0x03001C34
	ldr r1, .L02015050 @ =0x03001C30
	movs r0, #0
	str r0, [r1]
	str r0, [r2]
	ldr r1, .L02015054 @ =0x03001CC8
	str r0, [r1]
	ldr r1, .L02015058 @ =0x0300003C
	subs r0, #1
	str r0, [r1]
	ldr r4, .L0201505C @ =func_common_020150C4
	movs r0, #0
	adds r1, r4, #0
	bl SetIntrFunc
	movs r0, #0
	adds r1, r4, #0
	bl SetIntrFunc
	ldr r2, .L02015060 @ =0x04000200
	ldrh r0, [r2]
	movs r1, #0xc0
	orrs r0, r1
	strh r0, [r2]
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L0201503C: .4byte 0x04000134
.L02015040: .4byte 0x04000128
.L02015044: .4byte 0x03000038
.L02015048: .4byte 0x0400010E
.L0201504C: .4byte 0x03001C34
.L02015050: .4byte 0x03001C30
.L02015054: .4byte 0x03001CC8
.L02015058: .4byte 0x0300003C
.L0201505C: .4byte func_common_020150C4
.L02015060: .4byte 0x04000200

	thumb_func_start func_common_02015064
func_common_02015064: @ 0x02015064
	push {lr}
	ldr r1, .L020150A8 @ =0x04000134
	movs r2, #0x80
	lsls r2, r2, #8
	adds r0, r2, #0
	strh r0, [r1]
	subs r1, #0xc
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L020150AC @ =0x03001C34
	ldr r1, .L020150B0 @ =0x03001C30
	movs r0, #0
	str r0, [r1]
	str r0, [r2]
	ldr r1, .L020150B4 @ =0x03001CC8
	str r0, [r1]
	ldr r1, .L020150B8 @ =0x0300003C
	subs r0, #1
	str r0, [r1]
	movs r0, #0
	movs r1, #0
	bl SetIntrFunc
	movs r0, #0
	movs r1, #0
	bl SetIntrFunc
	ldr r2, .L020150BC @ =0x04000200
	ldrh r1, [r2]
	ldr r0, .L020150C0 @ =0x0000FF3F
	ands r0, r1
	strh r0, [r2]
	pop {r0}
	bx r0
	.align 2, 0
.L020150A8: .4byte 0x04000134
.L020150AC: .4byte 0x03001C34
.L020150B0: .4byte 0x03001C30
.L020150B4: .4byte 0x03001CC8
.L020150B8: .4byte 0x0300003C
.L020150BC: .4byte 0x04000200
.L020150C0: .4byte 0x0000FF3F

	thumb_func_start func_common_020150C4
func_common_020150C4: @ 0x020150C4
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #0xc
	movs r0, #0
	mov sb, r0
	ldr r0, .L02015158 @ =0x03001C34
	movs r2, #1
	str r2, [r0]
	ldr r1, .L0201515C @ =.L02018648
	ldr r0, [r1]
	mov r3, sb
	strb r3, [r0, #0x1e]
	ldr r0, .L02015160 @ =0x03001C30
	str r2, [r0]
	ldr r0, [r1]
	strb r3, [r0, #8]
	ldr r0, .L02015164 @ =0x0400010E
	mov r2, sb
	strh r2, [r0]
	ldr r2, [r1]
	ldr r3, .L02015168 @ =0x04000128
	ldrh r0, [r3]
	lsls r1, r0, #0x10
	strh r0, [r2, #2]
	ldrh r0, [r2, #4]
	cmp r0, #6
	beq .L02015108
	lsrs r0, r1, #0x14
	movs r1, #3
	ands r0, r1
	strb r0, [r2, #6]
.L02015108:
	ldr r0, .L0201516C @ =0x04000120
	ldr r1, [r0, #4]
	ldr r0, [r0]
	str r0, [sp]
	str r1, [sp, #4]
	ldr r0, .L02015170 @ =0x03000038
	ldrb r0, [r0]
	movs r2, #0xc0
	lsls r2, r2, #7
	adds r1, r2, #0
	orrs r0, r1
	strh r0, [r3]
	ldr r0, .L02015174 @ =0x00007FFF
	strh r0, [r3, #2]
	movs r5, #0
	ldr r3, .L02015178 @ =0x0000FFFF
	mov sl, r3
	mov r4, sp
	movs r7, #0
.L0201512E:
	ldrh r0, [r4]
	cmp r0, #0
	beq .L0201517C
	cmp r0, sl
	beq .L0201517C
	ldr r2, .L0201515C @ =.L02018648
	ldr r0, [r2]
	adds r0, #0xb
	adds r1, r0, r5
	ldrb r0, [r1]
	cmp r0, #0
	bne .L0201514A
	movs r0, #1
	strb r0, [r1]
.L0201514A:
	ldr r0, [r2]
	movs r1, #1
	lsls r1, r5
	ldrb r2, [r0, #8]
	orrs r1, r2
	strb r1, [r0, #8]
	b .L020151B6
	.align 2, 0
.L02015158: .4byte 0x03001C34
.L0201515C: .4byte .L02018648
.L02015160: .4byte 0x03001C30
.L02015164: .4byte 0x0400010E
.L02015168: .4byte 0x04000128
.L0201516C: .4byte 0x04000120
.L02015170: .4byte 0x03000038
.L02015174: .4byte 0x00007FFF
.L02015178: .4byte 0x0000FFFF
.L0201517C:
	lsls r0, r5, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020151B6
	ldr r0, .L020151A8 @ =.L02018648
	ldr r1, [r0]
	adds r0, r1, #0
	adds r0, #0x12
	adds r0, r0, r7
	ldrh r0, [r0]
	cmp r0, sl
	bne .L020151AC
	adds r1, #0x1a
	adds r1, r1, r5
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	b .L020151B6
	.align 2, 0
.L020151A8: .4byte .L02018648
.L020151AC:
	adds r0, r1, #0
	adds r0, #0x1a
	adds r0, r0, r5
	movs r1, #0
	strb r1, [r0]
.L020151B6:
	ldr r0, .L0201520C @ =.L02018648
	mov r8, r0
	ldr r6, [r0]
	adds r3, r6, #0
	adds r3, #0x12
	adds r3, r3, r7
	ldr r1, .L02015210 @ =0x02030480
	ldr r2, .L02015214 @ =0x03000058
	adds r2, r7, r2
	ldrh r0, [r2]
	lsls r0, r0, #3
	adds r0, r7, r0
	adds r0, r0, r1
	ldrh r1, [r4]
	strh r1, [r0]
	ldrh r0, [r4]
	ldr r1, .L02015218 @ =0x0000FFFF
	ands r0, r1
	strh r0, [r3]
	ldrh r0, [r2]
	adds r0, #1
	ldr r3, .L0201521C @ =0x000001FF
	mov ip, r3
	mov r1, ip
	ands r0, r1
	strh r0, [r2]
	adds r4, #2
	adds r7, #2
	adds r5, #1
	cmp r5, #3
	ble .L0201512E
	mov r4, r8
	adds r1, r6, #0
	ldrh r0, [r1, #4]
	cmp r0, #4
	bls .L020152E8
	ldrb r0, [r1, #1]
	cmp r0, #1
	beq .L02015220
	cmp r0, #3
	beq .L02015290
	b .L020152E8
	.align 2, 0
.L0201520C: .4byte .L02018648
.L02015210: .4byte 0x02030480
.L02015214: .4byte 0x03000058
.L02015218: .4byte 0x0000FFFF
.L0201521C: .4byte 0x000001FF
.L02015220:
	ldr r0, .L02015278 @ =0x0300004A
	ldr r2, .L0201527C @ =0x03000048
	ldrh r3, [r2]
	ldrh r0, [r0]
	cmp r0, r3
	beq .L02015248
	ldr r1, .L02015280 @ =0x02030080
	ldrh r0, [r2]
	lsls r0, r0, #1
	adds r0, r0, r1
	ldrh r1, [r0]
	add r0, sp, #8
	strh r1, [r0]
	adds r1, r3, #1
	mov r3, ip
	ands r1, r3
	strh r1, [r2]
	movs r1, #1
	bl func_common_02015CEC
.L02015248:
	ldr r1, [r4]
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	bne .L020152E8
	ldr r0, .L02015284 @ =0x000007CC
	adds r3, r1, r0
	ldrh r0, [r3]
	cmp r0, #0
	beq .L020152E8
	ldr r2, .L02015288 @ =0x04000128
	ldrh r0, [r2]
	movs r1, #0x80
	orrs r0, r1
	strh r0, [r2]
	ldr r1, .L0201528C @ =0x0400010C
	ldrh r0, [r3]
	rsbs r0, r0, #0
	str r0, [r1]
	adds r1, #2
	movs r0, #0xc3
	strh r0, [r1]
	b .L020152E8
	.align 2, 0
.L02015278: .4byte 0x0300004A
.L0201527C: .4byte 0x03000048
.L02015280: .4byte 0x02030080
.L02015284: .4byte 0x000007CC
.L02015288: .4byte 0x04000128
.L0201528C: .4byte 0x0400010C
.L02015290:
	movs r0, #6
	ldrsb r0, [r6, r0]
	cmp r0, #0
	beq .L020152AA
	adds r0, r6, #0
	adds r0, #0x30
	movs r1, #1
	bl func_common_02015CEC
	mov r2, r8
	ldr r1, [r2]
	ldr r0, .L02015300 @ =0x00005FFF
	strh r0, [r1, #0x30]
.L020152AA:
	movs r5, #0
	ldr r6, .L02015304 @ =0x00009ABC
	mov r4, sp
.L020152B0:
	lsls r0, r5, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020152CE
	ldrh r0, [r4]
	cmp r0, r6
	beq .L020152CE
	mov r0, sb
	adds r0, #1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov sb, r0
.L020152CE:
	adds r4, #2
	adds r5, #1
	cmp r5, #3
	ble .L020152B0
	mov r3, sb
	cmp r3, #0
	bne .L020152E8
	ldr r0, .L02015308 @ =.L02018648
	ldr r0, [r0]
	ldr r1, .L0201530C @ =0x000007CE
	adds r0, r0, r1
	movs r1, #1
	strh r1, [r0]
.L020152E8:
	ldr r1, .L02015310 @ =0x03001C30
	movs r0, #0
	str r0, [r1]
	add sp, #0xc
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02015300: .4byte 0x00005FFF
.L02015304: .4byte 0x00009ABC
.L02015308: .4byte .L02018648
.L0201530C: .4byte 0x000007CE
.L02015310: .4byte 0x03001C30

	thumb_func_start func_common_02015314
func_common_02015314: @ 0x02015314
	push {lr}
	ldr r1, .L0201532C @ =0x03007FF8
	movs r0, #1
	strh r0, [r1]
	bl SyncDispIo
	bl SyncBgsAndPal
	bl ApplyAsyncUploads
	pop {r0}
	bx r0
	.align 2, 0
.L0201532C: .4byte 0x03007FF8

	thumb_func_start func_common_02015330
func_common_02015330: @ 0x02015330
	push {lr}
	bl SwiVBlankIntrWait
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_common_0201533C
func_common_0201533C: @ 0x0201533C
	push {r4, lr}
	ldr r0, .L02015374 @ =.L02017C74
	movs r1, #0
	movs r2, #0x20
	bl ApplyPaletteExt
	ldr r4, .L02015378 @ =.L02017374
	movs r0, #1
	bl GetBgChrOffset
	adds r1, r0, #0
	movs r0, #0xc0
	lsls r0, r0, #0x13
	adds r1, r1, r0
	adds r0, r4, #0
	bl func_common_020166B8
	ldr r0, .L0201537C @ =.L02017AA8
	ldr r1, .L02015380 @ =0x0202B220
	bl func_common_020166B8
	movs r0, #2
	bl EnableBgSync
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02015374: .4byte .L02017C74
.L02015378: .4byte .L02017374
.L0201537C: .4byte .L02017AA8
.L02015380: .4byte 0x0202B220

	thumb_func_start func_common_02015384
func_common_02015384: @ 0x02015384
	push {lr}
	movs r0, #0
	bl InitBgs
	bl InitProcs
	movs r0, #0
	movs r1, #0
	movs r2, #0
	bl SetBgOffset
	ldr r3, .L020153F8 @ =gDispIo
	ldrb r1, [r3, #1]
	movs r0, #2
	rsbs r0, r0, #0
	ands r0, r1
	movs r1, #2
	orrs r0, r1
	movs r1, #5
	rsbs r1, r1, #0
	ands r0, r1
	subs r1, #4
	ands r0, r1
	subs r1, #8
	ands r0, r1
	subs r1, #0x10
	ands r0, r1
	subs r1, #0x20
	ands r0, r1
	movs r1, #0x7f
	ands r0, r1
	strb r0, [r3, #1]
	adds r2, r3, #0
	adds r2, #0x3c
	ldrb r1, [r2]
	movs r0, #0x3f
	ands r0, r1
	strb r0, [r2]
	adds r2, #8
	movs r1, #0
	movs r0, #0x10
	strb r0, [r2]
	adds r0, r3, #0
	adds r0, #0x45
	strb r1, [r0]
	adds r0, #1
	strb r1, [r0]
	strh r1, [r3, #0x38]
	bl SyncDispIo
	bl func_common_0201533C
	ldr r0, .L020153FC @ =func_common_02015330
	bl SetMainFunc
	pop {r0}
	bx r0
	.align 2, 0
.L020153F8: .4byte gDispIo
.L020153FC: .4byte func_common_02015330

	thumb_func_start func_common_02015400
func_common_02015400: @ 0x02015400
	push {lr}
	ldr r1, .L02015428 @ =0x04000004
	movs r0, #8
	strh r0, [r1]
	ldr r1, .L0201542C @ =0x04000208
	movs r0, #1
	strh r0, [r1]
	movs r1, #0x80
	lsls r1, r1, #0x13
	movs r0, #0
	strh r0, [r1]
	ldr r0, .L02015430 @ =func_common_02015314
	bl SetOnVBlank
	ldr r0, .L02015434 @ =func_common_02015384
	bl SetMainFunc
	pop {r0}
	bx r0
	.align 2, 0
.L02015428: .4byte 0x04000004
.L0201542C: .4byte 0x04000208
.L02015430: .4byte func_common_02015314
.L02015434: .4byte func_common_02015384

	thumb_func_start func_common_02015438
func_common_02015438: @ 0x02015438
	push {r4, r5, r6, lr}
	sub sp, #4
	ldr r0, .L02015474 @ =.L02018648
	ldr r2, [r0]
	ldrh r1, [r2, #4]
	adds r5, r0, #0
	cmp r1, #4
	bhi .L0201544A
	b .L02015578
.L0201544A:
	ldrb r0, [r2, #1]
	cmp r0, #0
	bne .L02015452
	b .L02015578
.L02015452:
	ldrb r0, [r2, #0x1e]
	adds r0, #1
	strb r0, [r2, #0x1e]
	ldr r1, [r5]
	ldrh r0, [r1, #4]
	cmp r0, #6
	bne .L020154E0
	adds r0, r1, #0
	adds r0, #0x21
	ldrb r0, [r0]
	cmp r0, #2
	beq .L02015492
	cmp r0, #2
	bgt .L02015478
	cmp r0, #1
	beq .L020154B8
	b .L020154E0
	.align 2, 0
.L02015474: .4byte .L02018648
.L02015478:
	cmp r0, #3
	bne .L020154E0
	ldrb r0, [r1, #0x1e]
	cmp r0, #0x3c
	bls .L02015492
	movs r0, #6
	ldrsb r0, [r1, r0]
	adds r1, #0xb
	adds r1, r1, r0
	movs r0, #0
	strb r0, [r1]
	bl func_common_02015400
.L02015492:
	ldr r4, .L02015504 @ =.L02018648
	ldr r0, [r4]
	ldrb r0, [r0, #1]
	cmp r0, #0
	beq .L020154B8
	bl func_common_0201596C
	lsls r0, r0, #0x18
	asrs r2, r0, #0x18
	cmp r2, #0
	bne .L020154B8
	ldr r0, [r4]
	movs r1, #6
	ldrsb r1, [r0, r1]
	adds r0, #0xb
	adds r0, r0, r1
	strb r2, [r0]
	bl func_common_02015400
.L020154B8:
	movs r4, #0
	ldr r5, .L02015504 @ =.L02018648
.L020154BC:
	ldr r0, .L02015504 @ =.L02018648
	ldr r1, [r0]
	adds r0, r1, #0
	adds r0, #0x1a
	adds r0, r0, r4
	ldrb r0, [r0]
	cmp r0, #0x3c
	bls .L020154DA
	adds r0, r1, #0
	adds r0, #0xb
	adds r0, r0, r4
	movs r1, #0
	strb r1, [r0]
	bl func_common_02015400
.L020154DA:
	adds r4, #1
	cmp r4, #3
	ble .L020154BC
.L020154E0:
	adds r4, r5, #0
	ldr r1, [r4]
	ldrb r0, [r1, #1]
	adds r6, r0, #0
	cmp r6, #1
	bne .L02015554
	ldrb r5, [r1, #0x10]
	cmp r5, #0
	bne .L02015536
	ldrb r0, [r1, #0x11]
	cmp r0, #0x3c
	bls .L02015508
	bl func_common_02015400
	ldr r1, [r4]
	movs r0, #2
	strh r0, [r1, #4]
	b .L02015578
	.align 2, 0
.L02015504: .4byte .L02018648
.L02015508:
	mov r0, sp
	bl func_common_02015E28
	cmp r0, #0
	beq .L02015536
	ldr r1, [sp]
	adds r1, #6
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	bl func_common_02015A3C
	lsls r0, r0, #0x10
	cmp r0, #0
	ble .L02015536
	ldr r0, [r4]
	strb r5, [r0, #0x10]
	ldr r1, [r4]
	ldrb r0, [r1, #0x11]
	adds r0, #1
	strb r0, [r1, #0x11]
	ldr r0, [r4]
	adds r0, #0x2e
	strb r6, [r0]
.L02015536:
	ldr r2, .L02015550 @ =.L02018648
	ldr r1, [r2]
	ldrb r0, [r1, #0x10]
	adds r0, #1
	strb r0, [r1, #0x10]
	ldr r4, [r2]
	ldrb r0, [r4, #0x10]
	movs r1, #9
	bl __umodsi3
	strb r0, [r4, #0x10]
	b .L02015578
	.align 2, 0
.L02015550: .4byte .L02018648
.L02015554:
	subs r0, #2
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	cmp r0, #1
	bhi .L02015578
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	bne .L02015578
	adds r0, r1, #0
	adds r0, #0x30
	movs r1, #1
	rsbs r1, r1, #0
	bl func_common_02015CEC
	ldr r1, [r5]
	ldr r0, .L02015580 @ =0x00005FFF
	strh r0, [r1, #0x30]
.L02015578:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02015580: .4byte 0x00005FFF

	thumb_func_start func_common_02015584
func_common_02015584: @ 0x02015584
	ldr r1, .L0201559C @ =0x0400010E
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L020155A0 @ =0x04000128
	ldr r0, .L020155A4 @ =0x03000038
	ldrb r0, [r0]
	movs r3, #0xc1
	lsls r3, r3, #7
	adds r1, r3, #0
	orrs r0, r1
	strh r0, [r2]
	bx lr
	.align 2, 0
.L0201559C: .4byte 0x0400010E
.L020155A0: .4byte 0x04000128
.L020155A4: .4byte 0x03000038

	thumb_func_start func_common_020155A8
func_common_020155A8: @ 0x020155A8
	bx lr
	.align 2, 0

	thumb_func_start func_common_020155AC
func_common_020155AC: @ 0x020155AC
	push {r4, r5, r6, r7, lr}
	ldr r0, .L020155F8 @ =.L02018648
	ldr r2, [r0]
	ldrb r1, [r2, #1]
	cmp r1, #1
	beq .L020155BA
	b .L020158CA
.L020155BA:
	movs r0, #6
	ldrsb r0, [r2, r0]
	lsls r1, r0
	ldrb r0, [r2, #0xf]
	orrs r1, r0
	strb r1, [r2, #0xf]
	movs r7, #0
.L020155C8:
	lsls r4, r7, #0x18
	asrs r0, r4, #0x18
	ldr r5, .L020155F8 @ =.L02018648
	ldr r1, [r5]
	adds r1, #0x32
	bl func_common_02015B34
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	adds r1, r0, #0
	adds r6, r4, #0
	cmp r0, #0
	bne .L020155E4
	b .L020158C2
.L020155E4:
	cmp r0, #0x16
	beq .L02015610
	cmp r0, #0x16
	bgt .L020155FC
	cmp r0, #4
	bne .L020155F2
	b .L02015718
.L020155F2:
	cmp r0, #0xa
	beq .L02015610
	b .L020158C2
	.align 2, 0
.L020155F8: .4byte .L02018648
.L020155FC:
	cmp r0, #0x2e
	beq .L02015610
	cmp r0, #0x2e
	bgt .L0201560A
	cmp r0, #0x2a
	beq .L02015610
	b .L020158C2
.L0201560A:
	cmp r1, #0x80
	beq .L02015610
	b .L020158C2
.L02015610:
	ldr r5, .L02015664 @ =.L02018648
	ldr r2, [r5]
	adds r4, r2, #0
	adds r4, #0x32
	ldrb r0, [r4]
	cmp r0, #0xcc
	beq .L02015698
	cmp r0, #0xcf
	beq .L02015624
	b .L020158C2
.L02015624:
	ldrb r1, [r4, #1]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r1, r0
	bne .L02015630
	b .L020158C2
.L02015630:
	lsls r1, r1, #1
	adds r3, r2, #0
	adds r3, #0x26
	adds r1, r3, r1
	ldrh r0, [r4, #2]
	ldrh r1, [r1]
	cmp r0, r1
	beq .L0201566C
	ldr r0, .L02015668 @ =0x03002E40
	movs r1, #0xce
	strb r1, [r0]
	ldrb r1, [r2, #6]
	lsls r1, r1, #4
	ldrb r2, [r4, #1]
	orrs r1, r2
	strb r1, [r0, #1]
	ldrb r1, [r4, #1]
	lsls r1, r1, #1
	adds r1, r3, r1
	ldrh r1, [r1]
	strh r1, [r0, #2]
	movs r1, #4
	bl func_common_02015A3C
	b .L020155C8
	.align 2, 0
.L02015664: .4byte .L02018648
.L02015668: .4byte 0x03002E40
.L0201566C:
	adds r0, r4, #0
	bl func_common_02015DB4
	ldr r0, .L02015694 @ =0x03002E40
	movs r1, #0xce
	strb r1, [r0]
	ldr r3, [r5]
	ldrb r1, [r3, #6]
	lsls r1, r1, #4
	ldrb r2, [r4, #1]
	orrs r1, r2
	strb r1, [r0, #1]
	ldrb r1, [r4, #1]
	lsls r1, r1, #1
	adds r3, #0x26
	adds r3, r3, r1
	ldrh r1, [r3]
	adds r1, #1
	strh r1, [r0, #2]
	b .L02015708
	.align 2, 0
.L02015694: .4byte 0x03002E40
.L02015698:
	lsrs r0, r6, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020156B4
	ldr r3, [r5]
	ldrb r0, [r3]
	ldrh r1, [r4, #2]
	cmp r0, r1
	bne .L020156B4
	ldrh r0, [r3, #4]
	cmp r0, #5
	bls .L020156C2
.L020156B4:
	lsrs r0, r6, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020156E4
.L020156C2:
	ldr r0, .L020156DC @ =.L02018648
	ldr r2, [r0]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r0, #0
	beq .L020156D0
	b .L020158C2
.L020156D0:
	ldr r0, .L020156E0 @ =0x03002E40
	movs r1, #0xc6
	strb r1, [r0]
	ldrb r1, [r2, #6]
	b .L02015704
	.align 2, 0
.L020156DC: .4byte .L02018648
.L020156E0: .4byte 0x03002E40
.L020156E4:
	ldr r0, .L02015710 @ =.L02018648
	ldr r1, [r0]
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	beq .L020156F2
	b .L020158C2
.L020156F2:
	ldrb r0, [r1]
	movs r2, #0xc5
	ldrh r4, [r4, #2]
	cmp r0, r4
	beq .L020156FE
	movs r2, #0xc7
.L020156FE:
	ldr r0, .L02015714 @ =0x03002E40
	strb r2, [r0]
	ldrb r1, [r1, #6]
.L02015704:
	strb r1, [r0, #1]
	strh r7, [r0, #2]
.L02015708:
	movs r1, #4
	bl func_common_02015A3C
	b .L020158C2
	.align 2, 0
.L02015710: .4byte .L02018648
.L02015714: .4byte 0x03002E40
.L02015718:
	ldr r0, [r5]
	adds r5, r0, #0
	adds r5, #0x32
	ldrb r0, [r5]
	subs r0, #0xc4
	cmp r0, #0xa
	bls .L02015728
	b .L020158C2
.L02015728:
	lsls r0, r0, #2
	ldr r1, .L02015734 @ =.L02015738
	adds r0, r0, r1
	ldr r0, [r0]
	mov pc, r0
	.align 2, 0
.L02015734: .4byte .L02015738
.L02015738: @ jump table
	.4byte .L020158BC @ case 0
	.4byte .L02015864 @ case 1
	.4byte .L0201588C @ case 2
	.4byte .L02015824 @ case 3
	.4byte .L020158C2 @ case 4
	.4byte .L02015764 @ case 5
	.4byte .L020158C2 @ case 6
	.4byte .L020158C2 @ case 7
	.4byte .L020158C2 @ case 8
	.4byte .L020158C2 @ case 9
	.4byte .L0201577C @ case 10
.L02015764:
	ldr r0, .L02015778 @ =.L02018648
	ldr r2, [r0]
	movs r0, #1
	ldrb r5, [r5, #1]
	lsls r0, r5
	ldrb r1, [r2, #0xa]
	orrs r0, r1
	strb r0, [r2, #0xa]
	b .L020158C2
	.align 2, 0
.L02015778: .4byte .L02018648
.L0201577C:
	ldr r6, .L02015818 @ =.L02018648
	ldr r3, [r6]
	adds r0, r3, #0
	adds r0, #0x2e
	ldrb r0, [r0]
	cmp r0, #0
	bne .L0201578C
	b .L020158C2
.L0201578C:
	ldrb r2, [r5, #1]
	lsrs r4, r2, #4
	movs r1, #6
	ldrsb r1, [r3, r1]
	cmp r4, r1
	bne .L0201579A
	b .L020158C2
.L0201579A:
	movs r0, #0xf
	ands r0, r2
	cmp r0, r1
	beq .L020157A4
	b .L020158C2
.L020157A4:
	ldrh r0, [r3, #0x24]
	adds r0, #1
	ldrh r1, [r5, #2]
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	cmp r1, r0
	beq .L020157B4
	b .L020158C2
.L020157B4:
	movs r0, #1
	lsls r0, r4
	ldrb r1, [r3, #0xf]
	orrs r0, r1
	strb r0, [r3, #0xf]
	ldr r0, .L0201581C @ =0x03000040
	ldr r1, [r0]
	ldr r0, [r6]
	ldrb r0, [r0, #0xf]
	strb r0, [r1]
	ldr r4, [r6]
	ldrb r0, [r4, #0xf]
	ldrb r1, [r4, #9]
	ands r0, r1
	cmp r0, r1
	bne .L020158C2
	ldrh r0, [r4, #0x24]
	adds r0, #1
	movs r3, #0
	strh r0, [r4, #0x24]
	ldr r2, .L02015820 @ =0x000007C4
	adds r0, r4, r2
	ldrb r1, [r0]
	movs r0, #0x8c
	muls r0, r1, r0
	adds r0, r4, r0
	movs r1, #0x9c
	lsls r1, r1, #1
	adds r0, r0, r1
	strb r3, [r0]
	ldr r1, [r6]
	adds r1, r1, r2
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	ldr r1, [r6]
	adds r1, r1, r2
	ldrb r2, [r1]
	movs r0, #7
	ands r0, r2
	strb r0, [r1]
	ldr r0, [r6]
	adds r0, #0x2e
	strb r3, [r0]
	ldr r0, [r6]
	strb r3, [r0, #0xf]
	strb r3, [r0, #0x11]
	strb r3, [r0, #0x10]
	b .L020158C2
	.align 2, 0
.L02015818: .4byte .L02018648
.L0201581C: .4byte 0x03000040
.L02015820: .4byte 0x000007C4
.L02015824:
	ldrb r0, [r5, #2]
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020158C2
	ldr r4, .L02015860 @ =.L02018648
	ldr r0, [r4]
	movs r1, #6
	ldrsb r1, [r0, r1]
	adds r0, #0xb
	adds r0, r0, r1
	movs r3, #2
	strb r3, [r0]
	ldr r1, [r4]
	ldrh r2, [r1, #2]
	movs r0, #0x30
	ands r0, r2
	lsrs r0, r0, #4
	adds r1, #0xb
	adds r1, r1, r0
	strb r3, [r1]
	ldr r0, [r4]
	adds r0, #0xb
	ldrh r5, [r5, #2]
	adds r0, r0, r5
	strb r3, [r0]
	ldr r1, [r4]
	b .L02015880
	.align 2, 0
.L02015860: .4byte .L02018648
.L02015864:
	ldrb r0, [r5, #2]
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020158C2
	ldr r2, .L02015888 @ =.L02018648
	ldr r0, [r2]
	adds r0, #0xb
	ldrh r5, [r5, #2]
	adds r0, r0, r5
	movs r1, #2
	strb r1, [r0]
	ldr r1, [r2]
.L02015880:
	movs r0, #6
	strh r0, [r1, #4]
	b .L020158C2
	.align 2, 0
.L02015888: .4byte .L02018648
.L0201588C:
	ldr r3, .L020158B8 @ =.L02018648
	ldr r1, [r3]
	adds r1, #0xb
	ldrh r0, [r5, #2]
	adds r1, r1, r0
	movs r4, #0
	movs r0, #5
	strb r0, [r1]
	ldr r2, [r3]
	movs r0, #1
	ldrh r1, [r5, #2]
	lsls r0, r1
	ldrb r1, [r2, #9]
	orrs r0, r1
	strb r0, [r2, #9]
	ldr r0, [r3]
	adds r0, #0x1a
	ldrh r5, [r5, #2]
	adds r0, r0, r5
	strb r4, [r0]
	b .L020158C2
	.align 2, 0
.L020158B8: .4byte .L02018648
.L020158BC:
	ldrb r0, [r5, #1]
	bl func_common_020155A8
.L020158C2:
	adds r7, #1
	cmp r7, #3
	bgt .L020158CA
	b .L020155C8
.L020158CA:
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0

	thumb_func_start func_common_020158D0
func_common_020158D0: @ 0x020158D0
	bx lr
	.align 2, 0

	thumb_func_start func_common_020158D4
func_common_020158D4: @ 0x020158D4
	push {r4, r5, lr}
	movs r5, #0
	movs r4, #0
.L020158DA:
	lsls r0, r4, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020158F0
	adds r0, r5, #1
	lsls r0, r0, #0x18
	lsrs r5, r0, #0x18
.L020158F0:
	adds r4, #1
	cmp r4, #3
	ble .L020158DA
	adds r0, r5, #0
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_02015900
func_common_02015900: @ 0x02015900
	push {r4, r5, lr}
	movs r5, #0
	movs r4, #0
.L02015906:
	lsls r0, r4, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201594C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L0201591C
	adds r0, r5, #1
	lsls r0, r0, #0x18
	lsrs r5, r0, #0x18
.L0201591C:
	adds r4, #1
	cmp r4, #3
	ble .L02015906
	adds r0, r5, #0
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_0201592C
func_common_0201592C: @ 0x0201592C
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	ldr r1, .L02015944 @ =.L02018648
	ldr r1, [r1]
	ldrb r1, [r1, #9]
	asrs r1, r0
	movs r0, #1
	ands r1, r0
	cmp r1, #0
	bne .L02015948
	movs r0, #0
	b .L0201594A
	.align 2, 0
.L02015944: .4byte .L02018648
.L02015948:
	movs r0, #1
.L0201594A:
	bx lr

	thumb_func_start func_common_0201594C
func_common_0201594C: @ 0x0201594C
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	ldr r1, .L02015964 @ =.L02018648
	ldr r1, [r1]
	ldrb r1, [r1, #8]
	asrs r1, r0
	movs r0, #1
	ands r1, r0
	cmp r1, #0
	bne .L02015968
	movs r0, #0
	b .L0201596A
	.align 2, 0
.L02015964: .4byte .L02018648
.L02015968:
	movs r0, #1
.L0201596A:
	bx lr

	thumb_func_start func_common_0201596C
func_common_0201596C: @ 0x0201596C
	push {r4, lr}
	ldr r2, .L02015998 @ =.L02018648
	ldr r3, [r2]
	ldrh r1, [r3, #2]
	movs r0, #0
	strh r0, [r3, #2]
	movs r4, #8
	ands r1, r4
	cmp r1, #0
	bne .L020159A0
	ldr r0, .L0201599C @ =0x04000128
	ldrh r1, [r0]
	adds r0, r4, #0
	ands r0, r1
	cmp r0, #0
	bne .L020159A0
	adds r1, r3, #0
	adds r1, #0x20
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	b .L020159A8
	.align 2, 0
.L02015998: .4byte .L02018648
.L0201599C: .4byte 0x04000128
.L020159A0:
	ldr r0, [r2]
	adds r0, #0x20
	movs r1, #0
	strb r1, [r0]
.L020159A8:
	ldr r0, [r2]
	adds r0, #0x20
	ldrb r0, [r0]
	cmp r0, #0xa
	bhi .L020159B6
	movs r0, #1
	b .L020159B8
.L020159B6:
	movs r0, #0
.L020159B8:
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_020159C0
func_common_020159C0: @ 0x020159C0
	ldr r0, .L020159DC @ =.L02018648
	ldr r0, [r0]
	ldr r2, .L020159E0 @ =0x000007C5
	adds r1, r0, r2
	ldr r3, .L020159E4 @ =0x000007C4
	adds r2, r0, r3
	ldrb r0, [r1]
	ldrb r3, [r2]
	cmp r0, r3
	bhs .L020159E8
	ldrb r1, [r2]
	subs r1, #8
	b .L020159EC
	.align 2, 0
.L020159DC: .4byte .L02018648
.L020159E0: .4byte 0x000007C5
.L020159E4: .4byte 0x000007C4
.L020159E8:
	ldrb r0, [r1]
	ldrb r1, [r2]
.L020159EC:
	subs r0, r0, r1
	bx lr

	thumb_func_start func_common_020159F0
func_common_020159F0: @ 0x020159F0
	push {r4, lr}
	movs r2, #0
	movs r1, #0
	ldr r4, .L02015A30 @ =.L02018648
	ldr r0, [r4]
	adds r3, r0, #0
	adds r3, #0xb
.L020159FE:
	adds r0, r3, r1
	ldrb r0, [r0]
	cmp r0, #5
	bne .L02015A08
	adds r2, #1
.L02015A08:
	adds r1, #1
	cmp r1, #3
	ble .L020159FE
	ldr r0, [r4]
	ldrb r0, [r0, #9]
	cmp r0, #3
	bne .L02015A1A
	cmp r2, #2
	beq .L02015A2A
.L02015A1A:
	cmp r0, #7
	bne .L02015A22
	cmp r2, #3
	beq .L02015A2A
.L02015A22:
	cmp r0, #0xf
	bne .L02015A34
	cmp r2, #4
	bne .L02015A34
.L02015A2A:
	movs r0, #1
	b .L02015A36
	.align 2, 0
.L02015A30: .4byte .L02018648
.L02015A34:
	movs r0, #0
.L02015A36:
	pop {r4}
	pop {r1}
	bx r1

	thumb_func_start func_common_02015A3C
func_common_02015A3C: @ 0x02015A3C
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	mov sb, r0
	lsls r1, r1, #0x10
	lsrs r5, r1, #0x10
	movs r0, #0
	mov r8, r0
	ldr r0, .L02015ADC @ =0x0300004A
	ldrh r3, [r0]
	cmp r5, #0x80
	bhi .L02015AD4
	lsrs r5, r1, #0x11
	ldr r1, .L02015AE0 @ =0x00004FFF
	adds r4, r5, r1
	ldr r2, .L02015AE4 @ =0x02030080
	lsls r0, r3, #1
	adds r0, r0, r2
	strh r1, [r0]
	adds r3, #1
	ldr r6, .L02015AE8 @ =0x000001FF
	ands r3, r6
	ldr r0, .L02015AEC @ =0x03000048
	ldrh r1, [r0]
	mov ip, r2
	mov sl, r0
	cmp r3, r1
	beq .L02015AD4
	lsls r0, r3, #1
	add r0, ip
	strh r5, [r0]
	adds r3, #1
	ands r3, r6
	lsls r6, r3, #1
	adds r7, r3, #1
	cmp r3, r1
	beq .L02015AD4
	movs r2, #0
	cmp r2, r5
	bge .L02015AB0
	mov r3, sb
.L02015A92:
	ldrh r0, [r3]
	adds r2, #1
	adds r1, r0, #0
	muls r1, r2, r1
	adds r0, r4, r1
	lsls r0, r0, #0x10
	lsrs r4, r0, #0x10
	mvns r1, r1
	add r1, r8
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	mov r8, r1
	adds r3, #2
	cmp r2, r5
	blt .L02015A92
.L02015AB0:
	mov r1, ip
	adds r0, r6, r1
	strh r4, [r0]
	ldr r4, .L02015AE8 @ =0x000001FF
	adds r3, r4, #0
	ands r3, r7
	mov r2, sl
	ldrh r1, [r2]
	cmp r3, r1
	beq .L02015AD4
	lsls r0, r3, #1
	add r0, ip
	mov r2, r8
	strh r2, [r0]
	adds r3, #1
	ands r3, r4
	cmp r3, r1
	bne .L02015AF0
.L02015AD4:
	movs r0, #1
	rsbs r0, r0, #0
	b .L02015B20
	.align 2, 0
.L02015ADC: .4byte 0x0300004A
.L02015AE0: .4byte 0x00004FFF
.L02015AE4: .4byte 0x02030080
.L02015AE8: .4byte 0x000001FF
.L02015AEC: .4byte 0x03000048
.L02015AF0:
	movs r2, #0
	cmp r2, r5
	bge .L02015B18
	mov r8, ip
	adds r7, r4, #0
	mov r4, sb
	mov r6, sl
.L02015AFE:
	lsls r0, r3, #1
	add r0, r8
	ldrh r1, [r4]
	strh r1, [r0]
	adds r3, #1
	ands r3, r7
	ldrh r0, [r6]
	cmp r3, r0
	beq .L02015AD4
	adds r4, #2
	adds r2, #1
	cmp r2, r5
	blt .L02015AFE
.L02015B18:
	ldr r1, .L02015B30 @ =0x0300004A
	strh r3, [r1]
	lsls r0, r5, #0x10
	asrs r0, r0, #0x10
.L02015B20:
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02015B30: .4byte 0x0300004A

	thumb_func_start func_common_02015B34
func_common_02015B34: @ 0x02015B34
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #0x10
	str r1, [sp, #4]
	lsls r0, r0, #0x18
	movs r1, #0
	mov r8, r1
	movs r3, #0
	str r3, [sp, #0xc]
	ldr r2, .L02015BAC @ =0x03000050
	lsrs r7, r0, #0x18
	str r7, [sp]
	asrs r3, r0, #0x17
	adds r4, r3, r2
	ldr r0, .L02015BB0 @ =0x03000058
	adds r7, r3, r0
	ldrh r1, [r4]
	ldrh r5, [r7]
	mov sl, r2
	cmp r1, r5
	beq .L02015C36
	ldr r0, .L02015BB4 @ =0x02030480
	ldrh r2, [r4]
	lsls r1, r2, #3
	adds r1, r3, r1
	adds r1, r1, r0
	ldrh r1, [r1]
	ldr r6, .L02015BB8 @ =0x00004FFF
	mov sb, r0
	cmp r1, r6
	beq .L02015BC0
	cmp r2, r5
	beq .L02015BEE
	adds r1, r3, #0
	adds r3, r4, #0
	mov ip, r6
	adds r4, r7, #0
	ldr r6, .L02015BBC @ =0x000001FF
	mov r5, sb
.L02015B88:
	ldrh r0, [r3]
	adds r0, #1
	ands r0, r6
	strh r0, [r3]
	ldrh r2, [r3]
	lsls r0, r2, #3
	adds r0, r1, r0
	adds r0, r0, r5
	ldrh r0, [r0]
	cmp r0, ip
	bne .L02015BA4
	ldrh r0, [r4]
	cmp r2, r0
	bne .L02015BC0
.L02015BA4:
	ldrh r7, [r4]
	cmp r2, r7
	bne .L02015B88
	b .L02015BEE
	.align 2, 0
.L02015BAC: .4byte 0x03000050
.L02015BB0: .4byte 0x03000058
.L02015BB4: .4byte 0x02030480
.L02015BB8: .4byte 0x00004FFF
.L02015BBC: .4byte 0x000001FF
.L02015BC0:
	ldr r1, [sp]
	lsls r0, r1, #0x18
	asrs r1, r0, #0x17
	ldr r3, .L02015BE0 @ =0x03000058
	adds r2, r1, r3
	add r1, sl
	ldrh r2, [r2]
	ldrh r1, [r1]
	adds r4, r0, #0
	cmp r2, r1
	bhs .L02015BE4
	movs r7, #0x80
	lsls r7, r7, #2
	adds r0, r2, r7
	subs r0, r0, r1
	b .L02015BE6
	.align 2, 0
.L02015BE0: .4byte 0x03000058
.L02015BE4:
	subs r0, r2, r1
.L02015BE6:
	lsls r0, r0, #0x10
	lsrs r1, r0, #0x10
	cmp r1, #4
	bhi .L02015BF4
.L02015BEE:
	movs r0, #4
	rsbs r0, r0, #0
	b .L02015CDC
.L02015BF4:
	asrs r0, r4, #0x17
	add r0, sl
	ldrh r0, [r0]
	adds r3, r0, #1
	ldr r0, .L02015C08 @ =0x000001FF
	cmp r3, r0
	bgt .L02015C0C
	lsls r0, r3, #0x10
	lsrs r0, r0, #0x10
	b .L02015C0E
	.align 2, 0
.L02015C08: .4byte 0x000001FF
.L02015C0C:
	movs r0, #0
.L02015C0E:
	asrs r4, r4, #0x17
	lsls r0, r0, #3
	adds r0, r4, r0
	add r0, sb
	ldrh r6, [r0]
	cmp r6, #0x80
	bls .L02015C30
	mov r1, sl
	adds r0, r4, r1
	ldrh r1, [r0]
	adds r1, #1
	ldr r2, .L02015C2C @ =0x000001FF
	ands r1, r2
	strh r1, [r0]
	b .L02015BEE
	.align 2, 0
.L02015C2C: .4byte 0x000001FF
.L02015C30:
	adds r0, r6, #6
	cmp r0, r1
	ble .L02015C3C
.L02015C36:
	movs r0, #2
	rsbs r0, r0, #0
	b .L02015CDC
.L02015C3C:
	mov r3, sl
	adds r2, r4, r3
	ldrh r0, [r2]
	adds r0, #2
	ldr r7, .L02015CD0 @ =0x000001FF
	ands r0, r7
	strh r0, [r2]
	ldrh r1, [r2]
	lsls r0, r1, #3
	adds r0, r4, r0
	add r0, sb
	ldrh r0, [r0]
	str r0, [sp, #8]
	adds r1, #1
	ands r1, r7
	strh r1, [r2]
	ldrh r1, [r2]
	lsls r0, r1, #3
	adds r0, r4, r0
	add r0, sb
	ldrh r0, [r0]
	mov sl, r0
	adds r1, #1
	ands r1, r7
	strh r1, [r2]
	ldr r0, .L02015CD4 @ =0x00004FFF
	add r0, r8
	adds r0, r6, r0
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov r8, r0
	movs r3, #0
	cmp r3, r6
	bge .L02015CBE
	mov ip, r4
	adds r4, r2, #0
	ldr r5, [sp, #4]
.L02015C86:
	ldrh r0, [r4]
	lsls r0, r0, #3
	add r0, ip
	add r0, sb
	ldrh r2, [r0]
	adds r3, #1
	adds r1, r2, #0
	muls r1, r3, r1
	mov r7, r8
	adds r0, r7, r1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov r8, r0
	mvns r1, r1
	ldr r0, [sp, #0xc]
	adds r1, r0, r1
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	str r1, [sp, #0xc]
	strh r2, [r5]
	ldrh r0, [r4]
	adds r0, #1
	ldr r1, .L02015CD0 @ =0x000001FF
	ands r0, r1
	strh r0, [r4]
	adds r5, #2
	cmp r3, r6
	blt .L02015C86
.L02015CBE:
	ldr r3, [sp, #8]
	cmp r8, r3
	bne .L02015CCA
	ldr r7, [sp, #0xc]
	cmp r7, sl
	beq .L02015CD8
.L02015CCA:
	movs r0, #3
	rsbs r0, r0, #0
	b .L02015CDC
	.align 2, 0
.L02015CD0: .4byte 0x000001FF
.L02015CD4: .4byte 0x00004FFF
.L02015CD8:
	lsls r0, r6, #0x11
	asrs r0, r0, #0x10
.L02015CDC:
	add sp, #0x10
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1

	thumb_func_start func_common_02015CEC
func_common_02015CEC: @ 0x02015CEC
	push {r4, lr}
	adds r4, r0, #0
	ldr r0, .L02015D04 @ =.L02018648
	ldr r3, [r0]
	movs r2, #6
	ldrsb r2, [r3, r2]
	movs r0, #1
	rsbs r0, r0, #0
	cmp r2, r0
	bne .L02015D08
	adds r0, r2, #0
	b .L02015D36
	.align 2, 0
.L02015D04: .4byte .L02018648
.L02015D08:
	ldr r2, .L02015D3C @ =0x04000128
	ldrh r0, [r4]
	strh r0, [r2, #2]
	movs r0, #6
	ldrsb r0, [r3, r0]
	cmp r0, #0
	bne .L02015D34
	cmp r1, #0
	bge .L02015D34
	ldrh r0, [r2]
	movs r1, #0x80
	orrs r0, r1
	strh r0, [r2]
	ldr r1, .L02015D40 @ =0x0400010C
	ldr r2, .L02015D44 @ =0x000007CC
	adds r0, r3, r2
	ldrh r0, [r0]
	rsbs r0, r0, #0
	str r0, [r1]
	adds r1, #2
	movs r0, #0xc3
	strh r0, [r1]
.L02015D34:
	movs r0, #0
.L02015D36:
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0
.L02015D3C: .4byte 0x04000128
.L02015D40: .4byte 0x0400010C
.L02015D44: .4byte 0x000007CC

	thumb_func_start func_common_02015D48
func_common_02015D48: @ 0x02015D48
	push {r4, r5, r6, lr}
	adds r2, r1, #0
	ldr r3, .L02015D70 @ =0x03000050
	ldr r1, .L02015D74 @ =0x03000058
	ldrh r0, [r3]
	ldrh r1, [r1]
	cmp r0, r1
	bne .L02015D7C
	ldr r1, .L02015D78 @ =0x00007FFF
	adds r0, r1, #0
	strh r0, [r2]
	adds r2, #2
	strh r0, [r2]
	adds r2, #2
	strh r0, [r2]
	strh r0, [r2, #2]
	movs r0, #2
	rsbs r0, r0, #0
	b .L02015DA4
	.align 2, 0
.L02015D70: .4byte 0x03000050
.L02015D74: .4byte 0x03000058
.L02015D78: .4byte 0x00007FFF
.L02015D7C:
	movs r4, #0
	ldr r6, .L02015DAC @ =0x02030480
	ldr r5, .L02015DB0 @ =0x000001FF
.L02015D82:
	lsls r1, r4, #1
	ldrh r0, [r3]
	lsls r0, r0, #3
	adds r1, r1, r0
	adds r1, r1, r6
	ldrh r0, [r1]
	strh r0, [r2]
	adds r2, #2
	ldrh r0, [r3]
	adds r0, #1
	ands r0, r5
	strh r0, [r3]
	adds r3, #2
	adds r4, #1
	cmp r4, #3
	ble .L02015D82
	movs r0, #0
.L02015DA4:
	pop {r4, r5, r6}
	pop {r1}
	bx r1
	.align 2, 0
.L02015DAC: .4byte 0x02030480
.L02015DB0: .4byte 0x000001FF

	thumb_func_start func_common_02015DB4
func_common_02015DB4: @ 0x02015DB4
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	ldr r3, .L02015E1C @ =.L02018648
	ldr r2, [r3]
	ldr r1, .L02015E20 @ =0x000007C7
	adds r0, r2, r1
	ldrb r1, [r0]
	movs r0, #0x8c
	muls r0, r1, r0
	ldr r1, .L02015E24 @ =0x00000594
	adds r0, r0, r1
	adds r1, r2, r0
	ldrb r0, [r4]
	strb r0, [r1, #4]
	ldrb r0, [r4, #1]
	strb r0, [r1, #5]
	ldrh r0, [r4, #2]
	strh r0, [r1, #6]
	ldrh r0, [r4, #4]
	strh r0, [r1, #8]
	movs r2, #0
	adds r6, r3, #0
	ldrh r0, [r4, #4]
	cmp r2, r0
	bge .L02015DFC
	adds r5, r1, #0
	adds r5, #0xa
	adds r3, r4, #6
.L02015DEC:
	adds r0, r5, r2
	adds r1, r3, r2
	ldrb r1, [r1]
	strb r1, [r0]
	adds r2, #1
	ldrh r1, [r4, #4]
	cmp r2, r1
	blt .L02015DEC
.L02015DFC:
	ldr r1, [r6]
	ldr r2, .L02015E20 @ =0x000007C7
	adds r1, r1, r2
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	ldr r1, [r6]
	adds r1, r1, r2
	ldrb r2, [r1]
	movs r0, #3
	ands r0, r2
	strb r0, [r1]
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02015E1C: .4byte .L02018648
.L02015E20: .4byte 0x000007C7
.L02015E24: .4byte 0x00000594

	thumb_func_start func_common_02015E28
func_common_02015E28: @ 0x02015E28
	push {r4, r5, r6, r7, lr}
	adds r7, r0, #0
	ldr r0, .L02015E74 @ =.L02018648
	ldr r3, [r0]
	ldr r0, .L02015E78 @ =0x000007C4
	adds r4, r3, r0
	ldrb r0, [r4]
	movs r6, #0x8c
	adds r5, r0, #0
	muls r5, r6, r5
	adds r0, r3, r5
	movs r1, #0x9c
	lsls r1, r1, #1
	adds r0, r0, r1
	ldrb r0, [r0]
	cmp r0, #0xcf
	bne .L02015E80
	ldr r1, .L02015E7C @ =0x03000040
	movs r2, #0x9a
	lsls r2, r2, #1
	adds r0, r5, r2
	adds r0, r3, r0
	str r0, [r1]
	ldrb r0, [r4]
	muls r0, r6, r0
	adds r0, r3, r0
	movs r1, #0x9e
	lsls r1, r1, #1
	adds r0, r0, r1
	ldrh r0, [r0]
	str r0, [r7]
	ldrb r0, [r4]
	muls r0, r6, r0
	adds r0, r0, r2
	adds r0, r3, r0
	adds r0, #4
	b .L02015E82
	.align 2, 0
.L02015E74: .4byte .L02018648
.L02015E78: .4byte 0x000007C4
.L02015E7C: .4byte 0x03000040
.L02015E80:
	movs r0, #0
.L02015E82:
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1

	thumb_func_start func_common_02015E88
func_common_02015E88: @ 0x02015E88
	push {r4, r5, r6, r7, lr}
	mov r7, r8
	push {r7}
	mov ip, r0
	lsls r1, r1, #0x10
	lsrs r7, r1, #0x10
	ldr r6, .L02015F24 @ =0x03000044
	movs r0, #1
	str r0, [r6]
	ldr r4, .L02015F28 @ =.L02018648
	ldr r1, [r4]
	ldr r2, .L02015F2C @ =0x000007C5
	adds r0, r1, r2
	ldrb r0, [r0]
	movs r5, #0x8c
	muls r0, r5, r0
	adds r1, r1, r0
	movs r3, #0x9a
	lsls r3, r3, #1
	adds r1, r1, r3
	movs r0, #0
	strb r0, [r1]
	ldr r1, [r4]
	adds r2, r1, r2
	ldrb r0, [r2]
	muls r0, r5, r0
	adds r0, r0, r3
	adds r5, r1, r0
	adds r2, r5, #4
	movs r0, #0xcf
	strb r0, [r5, #4]
	ldr r0, [r4]
	ldrb r0, [r0, #6]
	strb r0, [r2, #1]
	ldr r1, [r4]
	ldrh r0, [r1, #0x22]
	strh r0, [r2, #2]
	strh r7, [r2, #4]
	ldrh r0, [r1, #0x22]
	adds r0, #1
	strh r0, [r1, #0x22]
	movs r3, #0
	mov r8, r6
	adds r6, r4, #0
	cmp r3, r7
	bhs .L02015EFA
	adds r2, #6
.L02015EE6:
	adds r1, r2, r3
	mov r4, ip
	adds r0, r4, r3
	ldrb r0, [r0]
	strb r0, [r1]
	adds r0, r3, #1
	lsls r0, r0, #0x18
	lsrs r3, r0, #0x18
	cmp r3, r7
	blo .L02015EE6
.L02015EFA:
	ldr r1, [r6]
	ldr r3, .L02015F2C @ =0x000007C5
	adds r1, r1, r3
	ldrb r0, [r1]
	adds r2, r0, #1
	movs r4, #0
	strb r2, [r1]
	ldr r2, [r6]
	adds r2, r2, r3
	ldrb r3, [r2]
	movs r1, #7
	ands r1, r3
	strb r1, [r2]
	mov r1, r8
	str r4, [r1]
	pop {r3}
	mov r8, r3
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02015F24: .4byte 0x03000044
.L02015F28: .4byte .L02018648
.L02015F2C: .4byte 0x000007C5

	thumb_func_start func_common_02015F30
func_common_02015F30: @ 0x02015F30
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #4
	mov sb, r0
	str r1, [sp]
	mov sl, r2
.L02015F42:
	ldr r0, .L02015F70 @ =.L02018648
	mov r8, r0
	ldr r2, [r0]
	ldr r7, .L02015F74 @ =0x000007C6
	adds r0, r2, r7
	ldrb r1, [r0]
	movs r0, #0x8c
	muls r0, r1, r0
	ldr r1, .L02015F78 @ =0x00000594
	adds r0, r0, r1
	adds r5, r2, r0
	adds r6, r5, #4
	ldrb r0, [r5, #4]
	cmp r0, #0xcf
	bne .L02015F6A
	ldrb r1, [r6, #1]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r1, r0
	bne .L02015F7C
.L02015F6A:
	movs r0, #0
	b .L020160A4
	.align 2, 0
.L02015F70: .4byte .L02018648
.L02015F74: .4byte 0x000007C6
.L02015F78: .4byte 0x00000594
.L02015F7C:
	lsls r0, r1, #1
	adds r3, r2, #0
	adds r3, #0x26
	adds r0, r3, r0
	ldrh r1, [r6, #2]
	ldrh r0, [r0]
	cmp r1, r0
	beq .L02015FC8
	ldr r0, .L02015FC4 @ =0x03002E40
	movs r1, #0xce
	strb r1, [r0]
	ldrb r1, [r2, #6]
	lsls r1, r1, #4
	ldrb r2, [r6, #1]
	orrs r1, r2
	strb r1, [r0, #1]
	ldrb r1, [r6, #1]
	lsls r1, r1, #1
	adds r1, r3, r1
	ldrh r1, [r1]
	movs r4, #0
	strh r1, [r0, #2]
	movs r1, #4
	bl func_common_02015A3C
	strb r4, [r5, #4]
	mov r0, r8
	ldr r1, [r0]
	adds r1, r1, r7
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	mov r0, r8
	ldr r1, [r0]
	adds r1, r1, r7
	b .L02016036
	.align 2, 0
.L02015FC4: .4byte 0x03002E40
.L02015FC8:
	movs r2, #0
	ldrh r1, [r6, #4]
	cmp r2, r1
	bhs .L02015FEA
	adds r3, r5, #0
	adds r3, #0xa
.L02015FD4:
	mov r0, sb
	adds r1, r0, r2
	adds r0, r3, r2
	ldrb r0, [r0]
	strb r0, [r1]
	adds r0, r2, #1
	lsls r0, r0, #0x18
	lsrs r2, r0, #0x18
	ldrh r1, [r6, #4]
	cmp r2, r1
	blo .L02015FD4
.L02015FEA:
	mov r0, sl
	cmp r0, #0
	beq .L0201604C
	mov r0, sb
	bl _call_via_sl
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L0201604C
	ldr r0, .L02016040 @ =0x03002E40
	movs r1, #0xce
	strb r1, [r0]
	ldr r5, .L02016044 @ =.L02018648
	ldr r3, [r5]
	ldrb r1, [r3, #6]
	lsls r1, r1, #4
	ldrb r2, [r6, #1]
	orrs r1, r2
	strb r1, [r0, #1]
	ldrb r1, [r6, #1]
	lsls r1, r1, #1
	adds r3, #0x26
	adds r3, r3, r1
	ldrh r1, [r3]
	movs r4, #0
	strh r1, [r0, #2]
	movs r1, #4
	bl func_common_02015A3C
	strb r4, [r6]
	ldr r1, [r5]
	ldr r2, .L02016048 @ =0x000007C6
	adds r1, r1, r2
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	ldr r1, [r5]
	adds r1, r1, r2
.L02016036:
	ldrb r2, [r1]
	movs r0, #3
	ands r0, r2
	strb r0, [r1]
	b .L02015F42
	.align 2, 0
.L02016040: .4byte 0x03002E40
.L02016044: .4byte .L02018648
.L02016048: .4byte 0x000007C6
.L0201604C:
	movs r0, #0
	strb r0, [r6]
	ldrb r5, [r6, #1]
	ldr r4, .L020160B4 @ =.L02018648
	ldr r2, [r4]
	lsls r0, r5, #1
	adds r1, r2, #0
	adds r1, #0x26
	adds r1, r1, r0
	ldrh r0, [r1]
	adds r0, #1
	strh r0, [r1]
	ldr r3, .L020160B8 @ =0x000007C6
	adds r2, r2, r3
	ldrb r0, [r2]
	adds r0, #1
	strb r0, [r2]
	ldr r1, [r4]
	adds r1, r1, r3
	ldrb r2, [r1]
	movs r0, #3
	ands r0, r2
	strb r0, [r1]
	ldr r1, [sp]
	strb r5, [r1]
	ldr r0, .L020160BC @ =0x03002E40
	movs r1, #0xce
	strb r1, [r0]
	ldr r3, [r4]
	ldrb r1, [r3, #6]
	lsls r1, r1, #4
	ldrb r2, [r6, #1]
	orrs r1, r2
	strb r1, [r0, #1]
	ldrb r1, [r6, #1]
	lsls r1, r1, #1
	adds r3, #0x26
	adds r3, r3, r1
	ldrh r1, [r3]
	strh r1, [r0, #2]
	movs r1, #4
	bl func_common_02015A3C
	ldrh r0, [r6, #4]
.L020160A4:
	add sp, #4
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L020160B4: .4byte .L02018648
.L020160B8: .4byte 0x000007C6
.L020160BC: .4byte 0x03002E40

	thumb_func_start func_common_020160C0
func_common_020160C0: @ 0x020160C0
	push {lr}
	sub sp, #4
	ldr r1, .L020160FC @ =0x00007FFF
	mov r0, sp
	strh r1, [r0]
	ldr r0, .L02016100 @ =.L02018648
	ldr r1, [r0]
	movs r0, #0
	strb r0, [r1, #1]
	mov r0, sp
	movs r1, #1
	bl func_common_02015CEC
	ldr r1, .L02016104 @ =0x0300004A
	ldr r0, .L02016108 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	ldr r3, .L0201610C @ =0x03000050
	ldr r2, .L02016110 @ =0x03000058
	movs r1, #3
.L020160E8:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L020160E8
	add sp, #4
	pop {r0}
	bx r0
	.align 2, 0
.L020160FC: .4byte 0x00007FFF
.L02016100: .4byte .L02018648
.L02016104: .4byte 0x0300004A
.L02016108: .4byte 0x03000048
.L0201610C: .4byte 0x03000050
.L02016110: .4byte 0x03000058

	thumb_func_start func_common_02016114
func_common_02016114: @ 0x02016114
	ldr r1, .L02016120 @ =.L02018648
	ldr r1, [r1]
	adds r1, #0x21
	strb r0, [r1]
	bx lr
	.align 2, 0
.L02016120: .4byte .L02018648

	thumb_func_start func_common_02016124
func_common_02016124: @ 0x02016124
	push {lr}
	sub sp, #4
	ldr r1, .L02016178 @ =0x00007FFF
	mov r0, sp
	strh r1, [r0]
	ldr r1, .L0201617C @ =.L02018648
	ldr r0, [r1]
	movs r2, #0
	strb r2, [r0, #1]
	ldr r0, [r1]
	ldr r1, .L02016180 @ =0x000007CC
	adds r0, r0, r1
	strh r2, [r0]
	mov r0, sp
	movs r1, #1
	bl func_common_02015CEC
	ldr r1, .L02016184 @ =0x0300004A
	ldr r0, .L02016188 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	ldr r3, .L0201618C @ =0x03000050
	ldr r2, .L02016190 @ =0x03000058
	movs r1, #3
.L02016154:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L02016154
	ldr r0, .L0201617C @ =.L02018648
	ldr r2, [r0]
	ldr r0, .L02016194 @ =0x000007CE
	adds r1, r2, r0
	movs r0, #0
	strh r0, [r1]
	movs r0, #3
	strb r0, [r2, #1]
	add sp, #4
	pop {r0}
	bx r0
	.align 2, 0
.L02016178: .4byte 0x00007FFF
.L0201617C: .4byte .L02018648
.L02016180: .4byte 0x000007CC
.L02016184: .4byte 0x0300004A
.L02016188: .4byte 0x03000048
.L0201618C: .4byte 0x03000050
.L02016190: .4byte 0x03000058
.L02016194: .4byte 0x000007CE

	thumb_func_start func_common_02016198
func_common_02016198: @ 0x02016198
	push {r4, lr}
	sub sp, #4
	ldr r1, .L020161F4 @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	ldr r3, .L020161F8 @ =.L02018648
	ldr r1, [r3]
	movs r2, #0
	movs r0, #0
	strh r0, [r1, #4]
	strb r2, [r1, #1]
	ldr r0, [r3]
	ldr r1, .L020161FC @ =0x000007CC
	adds r0, r0, r1
	movs r1, #0xf
	strh r1, [r0]
	ldr r1, .L02016200 @ =0x0300004A
	ldr r0, .L02016204 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	adds r4, r3, #0
	ldr r3, .L02016208 @ =0x03000050
	ldr r2, .L0201620C @ =0x03000058
	movs r1, #3
.L020161C8:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L020161C8
	ldr r1, [r4]
	movs r0, #1
	strb r0, [r1, #1]
	ldr r1, [r4]
	movs r0, #6
	strh r0, [r1, #4]
	movs r1, #1
	rsbs r1, r1, #0
	mov r0, sp
	bl func_common_02015CEC
	add sp, #4
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L020161F4: .4byte 0x00002586
.L020161F8: .4byte .L02018648
.L020161FC: .4byte 0x000007CC
.L02016200: .4byte 0x0300004A
.L02016204: .4byte 0x03000048
.L02016208: .4byte 0x03000050
.L0201620C: .4byte 0x03000058

	thumb_func_start func_common_02016210
func_common_02016210: @ 0x02016210
	push {r4, lr}
	sub sp, #4
	ldr r1, .L0201626C @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	ldr r3, .L02016270 @ =.L02018648
	ldr r1, [r3]
	movs r2, #0
	movs r0, #0
	strh r0, [r1, #4]
	strb r2, [r1, #1]
	ldr r0, [r3]
	ldr r1, .L02016274 @ =0x000007CC
	adds r0, r0, r1
	movs r1, #0x18
	strh r1, [r0]
	ldr r1, .L02016278 @ =0x0300004A
	ldr r0, .L0201627C @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	adds r4, r3, #0
	ldr r3, .L02016280 @ =0x03000050
	ldr r2, .L02016284 @ =0x03000058
	movs r1, #3
.L02016240:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L02016240
	ldr r1, [r4]
	movs r0, #1
	strb r0, [r1, #1]
	ldr r1, [r4]
	movs r0, #6
	strh r0, [r1, #4]
	movs r1, #1
	rsbs r1, r1, #0
	mov r0, sp
	bl func_common_02015CEC
	add sp, #4
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L0201626C: .4byte 0x00002586
.L02016270: .4byte .L02018648
.L02016274: .4byte 0x000007CC
.L02016278: .4byte 0x0300004A
.L0201627C: .4byte 0x03000048
.L02016280: .4byte 0x03000050
.L02016284: .4byte 0x03000058

	thumb_func_start func_common_02016288
func_common_02016288: @ 0x02016288
	ldr r0, .L02016294 @ =0x0300004A
	ldr r1, .L02016298 @ =0x03000048
	ldrh r1, [r1]
	strh r1, [r0]
	bx lr
	.align 2, 0
.L02016294: .4byte 0x0300004A
.L02016298: .4byte 0x03000048

	thumb_func_start func_common_0201629C
func_common_0201629C: @ 0x0201629C
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L020162F8 @ =.L02018648
	ldr r1, [r5]
	adds r2, r1, #0
	adds r2, #0x2e
	movs r0, #0
	strb r0, [r2]
	strh r0, [r1, #0x22]
	strh r0, [r1, #0x24]
	ldr r1, [r5]
	strh r0, [r1, #0x2c]
	strh r0, [r1, #0x2a]
	strh r0, [r1, #0x28]
	strh r0, [r1, #0x26]
	bl func_02014DF4
	mov r1, sp
	adds r0, r4, #0
	adds r0, #0x34
	ldrb r0, [r0]
	strb r0, [r1]
	mov r2, sp
	ldrh r1, [r4, #0x36]
	lsrs r0, r1, #8
	strb r0, [r2, #1]
	mov r0, sp
	strb r1, [r0, #2]
	mov r1, sp
	adds r4, #0x3a
	ldrb r0, [r4]
	strb r0, [r1, #3]
	mov r0, sp
	movs r1, #4
	bl func_common_02015E88
	ldr r0, [r5]
	adds r0, #0x2e
	movs r1, #1
	strb r1, [r0]
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L020162F8: .4byte .L02018648

	thumb_func_start func_common_020162FC
func_common_020162FC: @ 0x020162FC
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	ldr r1, [r4, #0x2c]
	cmp r1, #0
	beq .L0201630A
	bl _call_via_r1
.L0201630A:
	ldr r5, .L02016368 @ =.L02018648
	ldr r1, [r5]
	adds r0, r1, #0
	adds r0, #0x2e
	ldrb r6, [r0]
	cmp r6, #0
	bne .L02016360
	ldrh r2, [r4, #0x38]
	ldrh r0, [r1, #0x24]
	subs r0, #1
	cmp r2, r0
	beq .L0201633E
	ldr r0, [r4, #0x30]
	adds r0, #0x7a
	str r0, [r4, #0x30]
	movs r0, #0x64
	muls r0, r2, r0
	ldrh r1, [r4, #0x36]
	bl __divsi3
	adds r1, r4, #0
	adds r1, #0x3b
	strb r0, [r1]
	ldrh r0, [r4, #0x38]
	adds r0, #1
	strh r0, [r4, #0x38]
.L0201633E:
	ldr r0, [r4, #0x30]
	movs r1, #0x7a
	bl func_common_02015E88
	ldr r0, [r5]
	adds r0, #0x2e
	movs r1, #1
	strb r1, [r0]
	ldr r0, [r5]
	strb r6, [r0, #0x10]
	ldrh r0, [r4, #0x38]
	ldrh r1, [r4, #0x36]
	cmp r0, r1
	blo .L02016360
	adds r0, r4, #0
	bl Proc_Break
.L02016360:
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016368: .4byte .L02018648

	thumb_func_start func_common_0201636C
func_common_0201636C: @ 0x0201636C
	push {lr}
	ldr r2, .L02016390 @ =.L02018648
	ldr r1, [r2]
	adds r3, r1, #0
	adds r3, #0x2e
	movs r0, #0
	strb r0, [r3]
	strh r0, [r1, #0x22]
	strh r0, [r1, #0x24]
	ldr r1, [r2]
	strh r0, [r1, #0x2c]
	strh r0, [r1, #0x2a]
	strh r0, [r1, #0x28]
	strh r0, [r1, #0x26]
	bl func_02014DF4
	pop {r0}
	bx r0
	.align 2, 0
.L02016390: .4byte .L02018648

	thumb_func_start func_common_02016394
func_common_02016394: @ 0x02016394
	push {r4, lr}
	sub sp, #8
	adds r4, r0, #0
	add r1, sp, #4
	mov r0, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L020163D0
	mov r0, sp
	ldrb r1, [r0]
	adds r0, r4, #0
	adds r0, #0x34
	strb r1, [r0]
	mov r0, sp
	ldrb r1, [r0, #1]
	lsls r1, r1, #8
	ldrb r0, [r0, #2]
	adds r0, r0, r1
	strh r0, [r4, #0x36]
	mov r0, sp
	ldrb r0, [r0, #3]
	adds r1, r4, #0
	adds r1, #0x3a
	strb r0, [r1]
	adds r0, r4, #0
	bl Proc_Break
.L020163D0:
	add sp, #8
	pop {r4}
	pop {r0}
	bx r0

	thumb_func_start func_common_020163D8
func_common_020163D8: @ 0x020163D8
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L02016414 @ =gBuf
	ldrh r1, [r4, #0x38]
	ldrh r0, [r4, #0x36]
	subs r0, #1
	cmp r1, r0
	bge .L02016418
	ldr r0, [r4, #0x30]
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016462
	ldr r0, [r4, #0x30]
	adds r0, #0x7a
	str r0, [r4, #0x30]
	ldrh r1, [r4, #0x38]
	movs r0, #0x64
	muls r0, r1, r0
	ldrh r1, [r4, #0x36]
	bl __divsi3
	adds r1, r4, #0
	adds r1, #0x3b
	strb r0, [r1]
	b .L0201645C
	.align 2, 0
.L02016414: .4byte gBuf
.L02016418:
	adds r0, r5, #0
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016462
	movs r2, #0
	adds r3, r4, #0
	adds r3, #0x3a
	adds r6, r4, #0
	adds r6, #0x3b
	ldrb r0, [r3]
	cmp r2, r0
	bge .L0201644E
.L02016438:
	ldr r1, [r4, #0x30]
	adds r0, r5, r2
	ldrb r0, [r0]
	strb r0, [r1]
	ldr r0, [r4, #0x30]
	adds r0, #1
	str r0, [r4, #0x30]
	adds r2, #1
	ldrb r1, [r3]
	cmp r2, r1
	blt .L02016438
.L0201644E:
	ldrh r1, [r4, #0x38]
	movs r0, #0x64
	muls r0, r1, r0
	ldrh r1, [r4, #0x36]
	bl __divsi3
	strb r0, [r6]
.L0201645C:
	ldrh r0, [r4, #0x38]
	adds r0, #1
	strh r0, [r4, #0x38]
.L02016462:
	ldr r1, [r4, #0x2c]
	cmp r1, #0
	beq .L0201646E
	adds r0, r4, #0
	bl _call_via_r1
.L0201646E:
	ldrh r0, [r4, #0x38]
	ldrh r1, [r4, #0x36]
	cmp r0, r1
	blo .L0201647C
	adds r0, r4, #0
	bl Proc_Break
.L0201647C:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0

	thumb_func_start func_common_02016484
func_common_02016484: @ 0x02016484
	push {r4, r5, r6, r7, lr}
	mov r7, r8
	push {r7}
	adds r7, r0, #0
	adds r4, r1, #0
	mov r8, r2
	lsls r3, r3, #0x18
	lsrs r6, r3, #0x18
	ldr r0, .L020164A0 @ =0x0079FF86
	cmp r4, r0
	bls .L020164A4
	movs r0, #1
	rsbs r0, r0, #0
	b .L020164F6
	.align 2, 0
.L020164A0: .4byte 0x0079FF86
.L020164A4:
	adds r0, r4, #0
	movs r1, #0x7a
	bl __udivsi3
	adds r0, #1
	lsls r0, r0, #0x10
	lsrs r5, r0, #0x10
	adds r0, r4, #0
	movs r1, #0x7a
	bl __umodsi3
	adds r4, r0, #0
	cmp r4, #0
	beq .L020164C6
	adds r0, r5, #1
	lsls r0, r0, #0x10
	lsrs r5, r0, #0x10
.L020164C6:
	lsls r4, r4, #0x18
	lsrs r4, r4, #0x18
	ldr r0, .L02016500 @ =.L0201864C
	ldr r1, [sp, #0x18]
	bl SpawnProcLocking
	adds r3, r0, #0
	str r7, [r3, #0x30]
	adds r0, #0x34
	movs r2, #0
	strb r6, [r0]
	mov r0, r8
	str r0, [r3, #0x2c]
	movs r1, #0
	strh r5, [r3, #0x36]
	adds r0, r3, #0
	adds r0, #0x3a
	strb r4, [r0]
	adds r0, #1
	strb r1, [r0]
	strh r2, [r3, #0x38]
	adds r0, #1
	strb r1, [r0]
	movs r0, #0
.L020164F6:
	pop {r3}
	mov r8, r3
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02016500: .4byte .L0201864C

	thumb_func_start func_common_02016504
func_common_02016504: @ 0x02016504
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r1, #0
	adds r1, r2, #0
	ldr r0, .L0201652C @ =.L0201866C
	bl SpawnProcLocking
	str r4, [r0, #0x2c]
	str r5, [r0, #0x30]
	adds r2, r0, #0
	adds r2, #0x3b
	movs r1, #0
	strb r1, [r2]
	movs r2, #0
	strh r1, [r0, #0x38]
	adds r0, #0x3c
	strb r2, [r0]
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L0201652C: .4byte .L0201866C

	thumb_func_start func_common_02016530
func_common_02016530: @ 0x02016530
	push {lr}
	ldr r0, .L0201654C @ =.L0201864C
	bl FindProc
	cmp r0, #0
	bne .L02016554
	ldr r0, .L02016550 @ =.L0201866C
	bl FindProc
	cmp r0, #0
	bne .L02016554
	movs r0, #0
	b .L02016556
	.align 2, 0
.L0201654C: .4byte .L0201864C
.L02016550: .4byte .L0201866C
.L02016554:
	movs r0, #1
.L02016556:
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_0201655C
func_common_0201655C: @ 0x0201655C
	movs r3, #0
	b .L02016568
.L02016560:
	strb r2, [r1]
	adds r0, #1
	adds r1, #1
	adds r3, #1
.L02016568:
	ldrb r2, [r0]
	cmp r2, #0
	bne .L02016560
	ldrb r0, [r0]
	strb r0, [r1]
	adds r0, r3, #0
	bx lr
	.align 2, 0

	thumb_func_start func_common_02016578
func_common_02016578: @ 0x02016578
	push {lr}
	bl func_common_02014FE8
	bl func_02014F80
	ldr r2, .L02016594 @ =.L02018648
	ldr r1, [r2]
	movs r3, #0
	movs r0, #1
	strb r0, [r1, #1]
	ldr r0, [r2]
	strh r3, [r0, #4]
	pop {r0}
	bx r0
	.align 2, 0
.L02016594: .4byte .L02018648

	thumb_func_start func_common_02016598
func_common_02016598: @ 0x02016598
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r6, r0, #0
	ldr r0, .L020165DC @ =0x00002586
	mov r1, sp
	strh r0, [r1]
	bl func_02014C94
	movs r5, #1
	rsbs r5, r5, #0
	cmp r0, r5
	beq .L020165D4
	ldr r4, .L020165E0 @ =.L02018648
	ldr r1, [r4]
	movs r0, #0
	strb r0, [r1, #0x11]
	ldr r1, [r4]
	movs r0, #5
	strh r0, [r1, #4]
	bl func_02014DB0
	ldr r1, [r4]
	strb r0, [r1, #6]
	mov r0, sp
	adds r1, r5, #0
	bl func_common_02015CEC
	adds r0, r6, #0
	bl Proc_Break
.L020165D4:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L020165DC: .4byte 0x00002586
.L020165E0: .4byte .L02018648

	thumb_func_start ClearUnit
ClearUnit: @ 0x020165E4
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldrb r5, [r4, #0xb]
	mov r1, sp
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L02016608 @ =0x01000024
	mov r0, sp
	adds r1, r4, #0
	bl SwiCpuSet
	strb r5, [r4, #0xb]
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016608: .4byte 0x01000024

	thumb_func_start InitUnits
InitUnits: @ 0x0201660C
	push {r4, r5, r6, r7, lr}
	movs r5, #0
	ldr r7, .L02016638 @ =.L02018704
	movs r6, #0xff
.L02016614:
	adds r0, r5, #0
	ands r0, r6
	lsls r0, r0, #2
	adds r0, r0, r7
	ldr r4, [r0]
	cmp r4, #0
	beq .L0201662A
	adds r0, r4, #0
	bl ClearUnit
	strb r5, [r4, #0xb]
.L0201662A:
	adds r5, #1
	cmp r5, #0x3d
	ble .L02016614
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02016638: .4byte .L02018704

	thumb_func_start func_common_0201663C
func_common_0201663C: @ 0x0201663C
	ldr r0, [r0]
	lsrs r0, r0, #8
	bx lr
	.align 2, 0

	thumb_func_start func_common_02016644
func_common_02016644: @ 0x02016644
	push {r4, r5, lr}
	adds r4, r0, #0
	adds r5, r1, #0
	bl func_common_0201663C
	adds r2, r0, #0
	subs r1, r2, #4
	movs r0, #0x1f
	ands r0, r1
	cmp r0, #0
	beq .L0201666C
	adds r0, r4, #4
	lsrs r2, r1, #0x1f
	adds r2, r1, r2
	lsls r2, r2, #0xa
	lsrs r2, r2, #0xb
	adds r1, r5, #0
	bl SwiCpuSet
	b .L02016682
.L0201666C:
	adds r3, r4, #4
	adds r0, r1, #0
	cmp r0, #0
	bge .L02016676
	subs r0, r2, #1
.L02016676:
	lsls r2, r0, #9
	lsrs r2, r2, #0xb
	adds r0, r3, #0
	adds r1, r5, #0
	bl SwiCpuFastSet
.L02016682:
	pop {r4, r5}
	pop {r0}
	bx r0

	thumb_func_start func_common_02016688
func_common_02016688: @ 0x02016688
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	adds r5, r1, #0
	ldr r6, .L020166B4 @ =gBuf
	adds r1, r6, #0
	bl SwiLZ77UnCompReadNormalWrite8bit
	adds r0, r4, #0
	bl func_common_0201663C
	cmp r0, #0
	bge .L020166A2
	adds r0, #3
.L020166A2:
	lsls r2, r0, #9
	lsrs r2, r2, #0xb
	adds r0, r6, #0
	adds r1, r5, #0
	bl SwiCpuFastSet
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L020166B4: .4byte gBuf

	thumb_func_start func_common_020166B8
func_common_020166B8: @ 0x020166B8
	push {r4, r5, lr}
	adds r3, r0, #0
	adds r4, r1, #0
	movs r0, #0xfa
	lsls r0, r0, #0x18
	adds r1, r4, r0
	ldr r0, .L020166F0 @ =0x00017FFF
	movs r5, #1
	cmp r1, r0
	bhi .L020166CE
	movs r5, #0
.L020166CE:
	ldr r2, .L020166F4 @ =.L02018804
	ldrb r1, [r3]
	movs r0, #0xf0
	ands r0, r1
	lsrs r0, r0, #3
	adds r0, r5, r0
	lsls r0, r0, #2
	adds r0, r0, r2
	ldr r2, [r0]
	adds r0, r3, #0
	adds r1, r4, #0
	bl _call_via_r2
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L020166F0: .4byte 0x00017FFF
.L020166F4: .4byte .L02018804

	thumb_func_start func_common_020166F8
func_common_020166F8: @ 0x020166F8
	push {r4, r5, lr}
	sub sp, #4
	adds r5, r0, #0
	ldr r1, .L02016764 @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	movs r0, #0
	bl InitBgs
	ldr r0, .L02016768 @ =.L02017C74
	movs r1, #0
	movs r2, #0x20
	bl ApplyPaletteExt
	ldr r4, .L0201676C @ =.L02017374
	movs r0, #1
	bl GetBgChrOffset
	adds r1, r0, #0
	movs r0, #0xc0
	lsls r0, r0, #0x13
	adds r1, r1, r0
	adds r0, r4, #0
	bl func_common_020166B8
	ldr r0, .L02016770 @ =.L02017908
	ldr r1, .L02016774 @ =0x0202B220
	bl func_common_020166B8
	movs r0, #2
	bl EnableBgSync
	ldr r0, .L02016778 @ =.L020186BC
	movs r1, #0
	bl SpawnProc
	ldr r0, .L0201677C @ =.L020186E4
	adds r1, r5, #0
	bl SpawnProc
	ldr r0, .L02016780 @ =.L02018694
	adds r1, r5, #0
	bl SpawnProc
	movs r1, #1
	rsbs r1, r1, #0
	mov r0, sp
	bl func_common_02015CEC
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016764: .4byte 0x00002586
.L02016768: .4byte .L02017C74
.L0201676C: .4byte .L02017374
.L02016770: .4byte .L02017908
.L02016774: .4byte 0x0202B220
.L02016778: .4byte .L020186BC
.L0201677C: .4byte .L020186E4
.L02016780: .4byte .L02018694

	thumb_func_start func_common_02016784
func_common_02016784: @ 0x02016784
	push {r4, r5, r6, lr}
	adds r6, r0, #0
	movs r4, #0
	ldr r0, .L020167D0 @ =.L02018694
	bl FindProc
	cmp r0, #0
	bne .L02016814
	movs r1, #0
	ldr r0, .L020167D4 @ =.L02018648
	ldr r0, [r0]
	adds r2, r0, #0
	adds r2, #0x1a
.L0201679E:
	adds r0, r2, r1
	ldrb r0, [r0]
	cmp r0, #0x3c
	bls .L020167A8
	adds r4, #1
.L020167A8:
	adds r1, #1
	cmp r1, #3
	ble .L0201679E
	bl func_common_0201596C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020167C6
	ldr r5, .L020167D4 @ =.L02018648
	ldr r2, [r5]
	ldrb r0, [r2, #0x1e]
	cmp r0, #0x3c
	bhi .L020167C6
	cmp r4, #0
	beq .L020167D8
.L020167C6:
	adds r0, r6, #0
	movs r1, #0xa
	bl Proc_Goto
	b .L02016814
	.align 2, 0
.L020167D0: .4byte .L02018694
.L020167D4: .4byte .L02018648
.L020167D8:
	ldr r0, .L0201681C @ =0x03001C40
	movs r1, #0xcc
	strb r1, [r0]
	ldrb r1, [r2, #6]
	strb r1, [r0, #1]
	ldrb r1, [r2]
	strh r1, [r0, #2]
	movs r1, #0xa
	bl func_common_02015A3C
	ldr r2, [r5]
	ldrb r0, [r2, #9]
	movs r1, #3
	ands r1, r0
	cmp r1, #3
	bne .L02016814
	strb r1, [r2, #9]
	bl func_common_02016288
	ldr r0, [r5]
	movs r1, #6
	strh r1, [r0, #4]
	movs r1, #0
	strb r1, [r0, #0x1e]
	movs r0, #3
	bl func_common_02016114
	adds r0, r6, #0
	bl Proc_Break
.L02016814:
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L0201681C: .4byte 0x03001C40

	thumb_func_start func_common_02016820
func_common_02016820: @ 0x02016820
	push {lr}
	ldr r0, .L02016840 @ =.L020186BC
	bl Proc_EndEach
	ldr r0, .L02016844 @ =.L020186E4
	bl Proc_EndEach
	ldr r0, .L02016848 @ =.L02018694
	bl Proc_EndEach
	bl func_common_02015064
	bl func_02014F80
	pop {r0}
	bx r0
	.align 2, 0
.L02016840: .4byte .L020186BC
.L02016844: .4byte .L020186E4
.L02016848: .4byte .L02018694

	thumb_func_start func_common_0201684C
func_common_0201684C: @ 0x0201684C
	bx lr
	.align 2, 0

	thumb_func_start func_common_02016850
func_common_02016850: @ 0x02016850
	push {lr}
	adds r1, r0, #0
	ldr r2, .L02016878 @ =0x080000B2
	ldr r3, .L0201687C @ =0x03000060
	movs r0, #0
	strb r0, [r3]
	str r0, [r1, #0x58]
	ldrb r0, [r2]
	cmp r0, #0x96
	beq .L02016880
	str r0, [r1, #0x5c]
	movs r0, #1
	str r0, [r1, #0x58]
	strb r0, [r3]
	adds r0, r1, #0
	movs r1, #0xb
	bl Proc_Goto
	b .L0201689A
	.align 2, 0
.L02016878: .4byte 0x080000B2
.L0201687C: .4byte 0x03000060
.L02016880:
	ldr r0, .L020168A8 @ =0x080000AC
	ldr r2, [r0]
	ldr r0, .L020168AC @ =0x4A454641
	cmp r2, r0
	beq .L0201689A
	str r2, [r1, #0x5c]
	movs r0, #2
	str r0, [r1, #0x58]
	strb r0, [r3]
	adds r0, r1, #0
	movs r1, #0xb
	bl Proc_Goto
.L0201689A:
	ldr r0, .L020168B0 @ =0x03000060
	movs r1, #4
	bl func_common_02015E88
	pop {r0}
	bx r0
	.align 2, 0
.L020168A8: .4byte 0x080000AC
.L020168AC: .4byte 0x4A454641
.L020168B0: .4byte 0x03000060

	thumb_func_start func_common_020168B4
func_common_020168B4: @ 0x020168B4
	push {r4, r5, lr}
	sub sp, #0x20
	ldr r0, .L02016954 @ =0x03000068
	movs r2, #0
	movs r1, #0x55
	strb r1, [r0]
	strb r2, [r0, #4]
	movs r4, #0
	adds r5, r0, #1
	adds r3, r0, #0
	adds r3, #0xc
	adds r1, r0, #5
.L020168CC:
	adds r0, r4, r5
	strb r2, [r0]
	strb r2, [r1]
	strb r2, [r1, #4]
	stm r3!, {r2}
	adds r1, #1
	adds r4, #1
	cmp r4, #2
	ble .L020168CC
	movs r4, #0
	mov r5, sp
.L020168E2:
	adds r0, r4, #0
	bl func_02014B0C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L0201693C
	adds r0, r4, #0
	mov r1, sp
	bl func_02014B30
	ldr r2, .L02016954 @ =0x03000068
	adds r0, r2, #5
	adds r0, r4, r0
	ldrb r1, [r5, #0xe]
	strb r1, [r0]
	ldrb r1, [r5, #0x14]
	movs r0, #0x20
	ands r0, r1
	cmp r0, #0
	beq .L0201691A
	adds r0, r2, #1
	adds r0, r4, r0
	ldrb r1, [r0]
	adds r1, #1
	strb r1, [r0]
	ldrb r0, [r2, #4]
	adds r0, #1
	strb r0, [r2, #4]
.L0201691A:
	ldrb r1, [r5, #0x14]
	movs r0, #0x40
	ands r0, r1
	cmp r0, #0
	beq .L02016930
	adds r1, r2, #0
	adds r1, #9
	adds r1, r4, r1
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
.L02016930:
	lsls r0, r4, #2
	adds r1, r2, #0
	adds r1, #0xc
	adds r0, r0, r1
	ldr r1, [sp]
	str r1, [r0]
.L0201693C:
	adds r4, #1
	cmp r4, #2
	ble .L020168E2
	ldr r0, .L02016954 @ =0x03000068
	movs r1, #0x28
	bl func_common_02015E88
	add sp, #0x20
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016954: .4byte 0x03000068

	thumb_func_start func_common_02016958
func_common_02016958: @ 0x02016958
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L0201698C @ =0x03000060
	adds r0, r5, #0
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016984
	ldrb r0, [r5]
	str r0, [r4, #0x58]
	bl ReadGameSaveUnits
	str r0, [r4, #0x54]
	movs r0, #1
	str r0, [r4, #0x58]
	adds r0, r4, #0
	bl Proc_Break
.L02016984:
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L0201698C: .4byte 0x03000060

	thumb_func_start func_common_02016990
func_common_02016990: @ 0x02016990
	push {r4, r5, r6, lr}
	movs r4, #0
	ldr r6, .L020169D4 @ =.L02018704
	ldr r5, .L020169D8 @ =0x03000084
.L02016998:
	movs r0, #0xff
	ands r0, r4
	lsls r0, r0, #2
	adds r0, r0, r6
	ldr r0, [r0]
	ldrb r3, [r0, #0xe]
	lsls r2, r3, #0x18
	cmp r2, #0
	beq .L020169C8
	ldrh r1, [r0, #0xc]
	movs r0, #4
	ands r0, r1
	cmp r0, #0
	bne .L020169C8
	asrs r2, r2, #0x1d
	lsls r2, r2, #2
	adds r2, r2, r5
	movs r0, #0x1f
	ands r0, r3
	movs r1, #1
	lsls r1, r0
	ldr r0, [r2]
	orrs r0, r1
	str r0, [r2]
.L020169C8:
	adds r4, #1
	cmp r4, #0x3d
	ble .L02016998
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L020169D4: .4byte .L02018704
.L020169D8: .4byte 0x03000084

	thumb_func_start func_common_020169DC
func_common_020169DC: @ 0x020169DC
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r6, r0, #0
	mov r1, sp
	movs r0, #0
	strh r0, [r1]
	ldr r4, .L02016A18 @ =0x03000080
	ldr r2, .L02016A1C @ =0x01000012
	mov r0, sp
	adds r1, r4, #0
	bl SwiCpuSet
	movs r5, #0
	movs r0, #0x66
	strb r0, [r4]
	movs r0, #1
	strb r0, [r4, #1]
	bl func_common_02016990
	adds r0, r4, #0
	movs r1, #0x28
	bl func_common_02015E88
	str r0, [r6, #0x60]
	str r5, [r6, #0x58]
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016A18: .4byte 0x03000080
.L02016A1C: .4byte 0x01000012

	thumb_func_start func_common_02016A20
func_common_02016A20: @ 0x02016A20
	bx lr
	.align 2, 0

	thumb_func_start func_common_02016A24
func_common_02016A24: @ 0x02016A24
	push {r4, lr}
	adds r4, r0, #0
	ldr r0, .L02016A5C @ =.L02018648
	ldr r2, [r0]
	ldr r1, [r4, #0x60]
	movs r0, #0x8c
	muls r0, r1, r0
	adds r0, r2, r0
	movs r1, #0x9a
	lsls r1, r1, #1
	adds r0, r0, r1
	ldrb r0, [r0]
	ldrb r2, [r2, #9]
	cmp r0, r2
	bne .L02016A56
	ldr r0, .L02016A60 @ =.L020179D8
	ldr r1, .L02016A64 @ =0x0202B220
	bl func_common_020166B8
	movs r0, #2
	bl EnableBgSync
	adds r0, r4, #0
	bl Proc_Break
.L02016A56:
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02016A5C: .4byte .L02018648
.L02016A60: .4byte .L020179D8
.L02016A64: .4byte 0x0202B220

	thumb_func_start func_common_02016A68
func_common_02016A68: @ 0x02016A68
	push {lr}
	movs r0, #0
	bl func_common_02016114
	pop {r0}
	bx r0

	thumb_func_start func_common_02016A74
func_common_02016A74: @ 0x02016A74
	push {lr}
	adds r1, r0, #0
	ldr r0, .L02016A84 @ =.L02018824
	bl SpawnProcLocking
	pop {r0}
	bx r0
	.align 2, 0
.L02016A84: .4byte .L02018824

	thumb_func_start GetUnit
GetUnit: @ 0x02016A88
	ldr r2, .L02016A98 @ =.L02018704
	movs r1, #0xff
	ands r1, r0
	lsls r1, r1, #2
	adds r1, r1, r2
	ldr r0, [r1]
	bx lr
	.align 2, 0
.L02016A98: .4byte .L02018704

	.section ".fake_glue", "ax"

	@ this section should be generated by the linker, but modern ld won't generating matching veneers
	@ (specifically: the padding nop is replaced by another instruction).

	.global ClearOam_thm
	.type ClearOam_thm, function

	.thumb
ClearOam_thm:
	bx pc
	nop
	.arm
	b ClearOam

	.size Checksum32_thm, . - Checksum32_thm

	.global Checksum32_thm
	.type Checksum32_thm, function

	.thumb
Checksum32_thm:
	bx pc
	nop
	.arm
	b Checksum32

	.size Checksum32_thm, . - Checksum32_thm

	.section ".rodata"

.L02017374:
	.byte 0x10, 0x00, 0x10, 0x00, 0x30, 0x00, 0x00, 0xF0, 0x01, 0xF0, 0x01, 0x00
	.byte 0x00, 0x30, 0x33, 0x00, 0x33, 0x33, 0x23, 0x22, 0x22, 0x22, 0x30, 0x33, 0x40, 0x32, 0x20, 0x07
	.byte 0x23, 0x32, 0x22, 0x23, 0x23, 0x33, 0x28, 0x32, 0x23, 0x60, 0x1F, 0x03, 0x00, 0x21, 0x32, 0x23
	.byte 0x22, 0x02, 0x30, 0x21, 0x23, 0x33, 0x03, 0x13, 0x20, 0x1A, 0x23, 0x10, 0x33, 0x21, 0x23, 0x60
	.byte 0x1F, 0x33, 0x33, 0x00, 0x00, 0x00, 0x22, 0x32, 0x00, 0x30, 0x32, 0x03, 0x00, 0x23, 0x02, 0x22
	.byte 0x32, 0x30, 0x22, 0x33, 0x32, 0x20, 0x07, 0x21, 0xB0, 0xE0, 0x66, 0x00, 0x00, 0x17, 0x00, 0x23
	.byte 0x33, 0x00, 0x30, 0x22, 0x18, 0x31, 0x33, 0x00, 0x60, 0x3F, 0x40, 0x44, 0x03, 0x33, 0x22, 0x03
	.byte 0x22, 0x03, 0x03, 0x23, 0x23, 0x03, 0x10, 0x5E, 0x00, 0x07, 0xD4, 0x00, 0x2E, 0x80, 0x3C, 0x03
	.byte 0x00, 0x3C, 0x32, 0x00, 0x26, 0x21, 0x03, 0x27, 0x00, 0x32, 0x00, 0x40, 0x32, 0x33, 0x00, 0x10
	.byte 0x90, 0x01, 0x00, 0x0E, 0x08, 0x30, 0x32, 0x30, 0x00, 0x00, 0x9B, 0x03, 0x22, 0x22, 0x03, 0x13
	.byte 0x32, 0x23, 0x31, 0x30, 0x31, 0xE0, 0xE7, 0x00, 0x03, 0x1C, 0x23, 0x03, 0x30, 0x00, 0x03, 0x20
	.byte 0x01, 0x80, 0x1F, 0x03, 0x03, 0xB8, 0x00, 0x3C, 0x32, 0x00, 0xFF, 0x00, 0xE5, 0x00, 0xB9, 0x13
	.byte 0x12, 0x03, 0x7D, 0x30, 0x00, 0x67, 0xF1, 0x1F, 0x20, 0x79, 0x10, 0x68, 0x00, 0x03, 0x12, 0xA0
	.byte 0x80, 0x58, 0x03, 0x30, 0x80, 0x03, 0x00, 0x80, 0x01, 0x01, 0x22, 0x31, 0x00, 0x3A, 0x33, 0x23
	.byte 0xC0, 0xA0, 0xF0, 0x7F, 0x90, 0xFC, 0x30, 0x00, 0x34, 0x23, 0x00, 0x03, 0x33, 0x23, 0x13, 0x32
	.byte 0x13, 0x12, 0x30, 0x7E, 0x31, 0x20, 0x6B, 0x00, 0x64, 0x70, 0x39, 0x11, 0x36, 0x11, 0x5E, 0x00
	.byte 0x98, 0x33, 0x03, 0x32, 0x30, 0x12, 0x23, 0x32, 0x13, 0x00, 0x8B, 0x70, 0xFA, 0xFF, 0x11, 0x13
	.byte 0x11, 0x83, 0x01, 0x45, 0x00, 0x48, 0x00, 0x85, 0x00, 0x2C, 0x10, 0x6E, 0xB1, 0x7F, 0xFF, 0x21
	.byte 0x9F, 0x40, 0xA5, 0x01, 0x83, 0xA1, 0x7E, 0x00, 0x44, 0x00, 0x1B, 0x20, 0x07, 0x21, 0xCF, 0xDC
	.byte 0x00, 0x69, 0xF2, 0x29, 0x00, 0x00, 0x19, 0x20, 0x37, 0x01, 0x11, 0x00, 0x13, 0xF8, 0x60, 0x58
	.byte 0x00, 0x29, 0x01, 0xB6, 0x10, 0x03, 0x01, 0xC2, 0x33, 0x22, 0x21, 0xFF, 0x00, 0xFD, 0x00, 0x63
	.byte 0x60, 0x1F, 0x50, 0xA4, 0x10, 0x14, 0x01, 0x5E, 0x30, 0x07, 0x80, 0xDD, 0x9E, 0x91, 0x1D, 0x00
	.byte 0x30, 0x01, 0xF7, 0x01, 0x6C, 0x20, 0x07, 0xF2, 0x3E, 0x12, 0xFF, 0x00, 0x07, 0x01, 0x99, 0x32
	.byte 0x4A, 0xD0, 0x41, 0x21, 0x07, 0x60, 0x07, 0x10, 0xC5, 0xF2, 0x7E, 0xFE, 0x00, 0x03, 0x20, 0x07
	.byte 0x02, 0x60, 0x60, 0x1F, 0x20, 0x79, 0x00, 0xF8, 0x11, 0xFA, 0x32, 0x7E, 0x32, 0x11, 0x40, 0x30
	.byte 0x07, 0xA0, 0x5B, 0x00, 0x0D, 0x02, 0x5A, 0x10, 0x03, 0x30, 0x5D, 0x32, 0x22, 0xE4, 0x21, 0xB0
	.byte 0x5F, 0x00, 0x1F, 0x01, 0xD4, 0x30, 0x01, 0x97, 0x7B, 0x00, 0x00, 0x3D, 0x10, 0x03, 0x70, 0x3F
	.byte 0x00, 0x09, 0x33, 0x00, 0x60, 0x02, 0x42, 0xEF, 0x03, 0x60, 0x00, 0x79, 0x01, 0x5C, 0x23, 0xC2
	.byte 0x1F, 0x40, 0xFD, 0xA0, 0x03, 0xF3, 0xA7, 0xFE, 0x20, 0x3B, 0x42, 0x9F, 0xC0, 0xDE, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xC0, 0x01, 0x22, 0xD3, 0x32, 0xE3, 0x02, 0xAF, 0x10, 0x03, 0x10, 0x57, 0x33, 0x12
	.byte 0x13, 0x01, 0x5E, 0x01, 0x23, 0xF0, 0x31, 0x3B, 0x13, 0xEB, 0x01, 0xD4, 0x00, 0x03, 0x21, 0x33
	.byte 0x30, 0x21, 0x03, 0x12, 0x21, 0x33, 0x12, 0x32, 0x12, 0x02, 0x96, 0x03, 0x7A, 0xA4, 0x30, 0x1F
	.byte 0x33, 0x00, 0xEC, 0x22, 0x32, 0x02, 0xB2, 0x33, 0x33, 0x35, 0x21, 0x12, 0x10, 0x45, 0x10, 0x1D
	.byte 0x21, 0x01, 0x18, 0x33, 0x12, 0x27, 0xFF, 0x01, 0x2F, 0x00, 0xE6, 0x03, 0x09, 0x13, 0xB6, 0x01
	.byte 0x15, 0x22, 0x7F, 0x62, 0x63, 0x20, 0x3F, 0xA1, 0x03, 0xE3, 0x23, 0x04, 0x53, 0x12, 0x12, 0x23
	.byte 0x33, 0x03, 0xB1, 0x8E, 0x01, 0x13, 0x21, 0x03, 0x30, 0x10, 0x2D, 0x13, 0xEC, 0x00, 0x01, 0x12
	.byte 0x9F, 0x00, 0x2C, 0x22, 0x31, 0x00, 0x76, 0x00, 0x19, 0x02, 0x14, 0x02, 0xB5, 0x00, 0xF7, 0xE8
	.byte 0x00, 0x50, 0x50, 0x40, 0x10, 0x31, 0x12, 0x01, 0x47, 0x32, 0x21, 0x22, 0x76, 0x03, 0x03, 0xF7
	.byte 0x00, 0x81, 0x01, 0x80, 0x21, 0x03, 0x97, 0x41, 0xFA, 0x23, 0x6C, 0x03, 0x10, 0x55, 0x00, 0x15
	.byte 0x33, 0x00, 0x03, 0x14, 0xB5, 0x21, 0x03, 0x7E, 0x03, 0x01, 0x3A, 0x22, 0x09, 0x21, 0x4F, 0x53
	.byte 0xCA, 0x50, 0x03, 0x11, 0x53, 0x13, 0xEF, 0x03, 0x3D, 0x60, 0x20, 0x23, 0x2D, 0x21, 0x14, 0x6D
	.byte 0xA0, 0x28, 0x22, 0x61, 0x20, 0xC0, 0x07, 0x03, 0x33, 0x21, 0x22, 0x31, 0x00, 0x1E, 0x11, 0xF2
	.byte 0x00, 0x69, 0xBF, 0x03, 0x7D, 0x21, 0x33, 0x85, 0xF0, 0x7F, 0xF0, 0x7F, 0x05, 0x67, 0x41, 0x7F
	.byte 0x30, 0x07, 0x2E, 0x13, 0x22, 0x04, 0x67, 0x13, 0x03, 0x41, 0x01, 0xE8, 0x21, 0x3F, 0x23, 0xF8
	.byte 0x00, 0x01, 0x04, 0x73, 0x10, 0xD8, 0x30, 0xDC, 0x30, 0x07, 0x33, 0x30, 0x03, 0xFF, 0x20, 0x1F
	.byte 0x20, 0xA9, 0x00, 0x03, 0x10, 0x07, 0x23, 0x39, 0x05, 0xA7, 0x11, 0x72, 0x00, 0x85, 0xFF, 0x30
	.byte 0x3F, 0x11, 0xA2, 0x43, 0x13, 0x20, 0x03, 0x15, 0x78, 0x12, 0x7A, 0x00, 0x07, 0x40, 0xBE, 0xFF
	.byte 0x01, 0xDB, 0x24, 0x90, 0x23, 0x55, 0x11, 0xA4, 0x00, 0x4B, 0x31, 0xBC, 0x10, 0x5F, 0x30, 0x2B
	.byte 0xFA, 0x15, 0xA7, 0x50, 0x03, 0x13, 0xD3, 0x62, 0xD7, 0xC2, 0xAE, 0x13, 0x03, 0xD6, 0x30, 0x7B
	.byte 0x21, 0x01, 0x31, 0x61, 0xDF, 0x40, 0x80, 0x11, 0xD2, 0x12, 0x40, 0x0B, 0x81, 0xBE, 0xFE, 0x14
	.byte 0x34, 0x04, 0x45, 0x53, 0xEB, 0x20, 0x46, 0x21, 0x80, 0x33, 0xAB, 0x10, 0x69, 0x12, 0xFD, 0x20
	.byte 0xCA, 0x53, 0x1B, 0x00, 0xA2, 0x14, 0xB7, 0x15, 0x99, 0x20, 0x1F, 0x21, 0x04, 0x6D, 0xFF, 0x01
	.byte 0x81, 0x23, 0x49, 0x10, 0x03, 0x15, 0x91, 0x15, 0x54, 0x50, 0x5E, 0x02, 0x9B, 0x13, 0x31, 0xFC
	.byte 0x06, 0x87, 0x20, 0x5F, 0x00, 0xBB, 0x20, 0x07, 0x00, 0x0F, 0x31, 0x5F, 0x22, 0x32, 0x94, 0x13
	.byte 0x4E, 0x31, 0x30, 0x10, 0x40, 0x32, 0x00, 0x3C, 0x21, 0x31, 0xDE, 0x00, 0x07, 0x01, 0xBE, 0x03
	.byte 0x40, 0xA0, 0x12, 0x77, 0x20, 0x01, 0x00, 0xC0, 0x23, 0xFC, 0x00, 0x1B, 0xD1, 0xFE, 0x11, 0x8B
	.byte 0x05, 0x8D, 0x21, 0xDE, 0x00, 0x18, 0x23, 0x30, 0x0F, 0x23, 0x31, 0x23, 0x23, 0x00, 0x34, 0x00
	.byte 0xB2, 0x20, 0x5F, 0x53, 0xE7, 0xFE, 0x80, 0x07, 0x00, 0xB1, 0x04, 0x03, 0x15, 0x3D, 0x73, 0xEF
	.byte 0x24, 0x36, 0x20, 0x03, 0x31, 0x0F, 0x23, 0x31, 0x13, 0x22, 0x02, 0xE3, 0x42, 0xBF, 0xF2, 0x9F
	.byte 0xC2, 0x9F, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0x34, 0xF9, 0x06, 0xBF, 0x00, 0xC8, 0x00, 0x05, 0x03
	.byte 0x90, 0x00, 0x07, 0xFF, 0x01, 0x37, 0x00, 0x86, 0x95, 0x37, 0x10, 0x0C, 0x36, 0x37, 0x14, 0x09
	.byte 0x00, 0x07, 0x01, 0x68, 0xFF, 0xD7, 0x5D, 0x31, 0xDE, 0x11, 0xE7, 0x16, 0x9D, 0xB6, 0x3F, 0x11
	.byte 0xD4, 0x02, 0x7C, 0x10, 0xCC, 0xFE, 0x60, 0x03, 0xF0, 0x87, 0x38, 0x00, 0x31, 0xEE, 0x80, 0x20
	.byte 0x00, 0x4F, 0x05, 0x38, 0x22, 0xCF, 0x11, 0x3E, 0x10, 0x01, 0x30, 0x32, 0x14, 0x11, 0x76, 0xFF
	.byte 0x10, 0x28, 0x11, 0x14, 0xF7, 0x21, 0x48, 0x10, 0x07, 0x32, 0x87, 0xA8, 0x3F, 0x33, 0x07, 0xC2
	.byte 0x18, 0x78, 0x01, 0x8F, 0xFF, 0x25, 0x7F, 0x01, 0x4E, 0xF6, 0x60, 0x01, 0x06, 0x13, 0x01, 0x30
	.byte 0x07, 0x78, 0xDF, 0x50, 0x65, 0xFF, 0x00, 0x84, 0x20, 0x43, 0x10, 0x07, 0x10, 0x03, 0xF6, 0x5E
	.byte 0x10, 0x14, 0x27, 0x3A, 0x00, 0x43, 0xFF, 0x13, 0x2D, 0xF0, 0x01, 0x56, 0x83, 0xD8, 0x9E, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE9, 0xAC, 0x2A, 0xCF, 0xE5, 0x2B, 0xAD, 0x40, 0x03
	.byte 0x03, 0x61, 0x22, 0x12, 0x54, 0x7E, 0x00, 0x03, 0x61, 0xF6, 0x09, 0x8A, 0x06, 0xE4, 0x05, 0x23
	.byte 0x00, 0x03, 0x23, 0x00, 0x2D, 0x04, 0x16, 0x13, 0xD3, 0x35, 0x74, 0x20, 0x1F, 0x30, 0x1A, 0x2F
	.byte 0x23, 0x31, 0x14, 0xBE, 0x00, 0x07, 0x6B, 0x13, 0x0B, 0xD3, 0x14, 0xA7, 0x30, 0x47, 0xA0, 0x33
	.byte 0x19, 0xE8, 0x05, 0xD8, 0x07, 0x23, 0x31, 0x12, 0x33, 0x31, 0x27, 0x8B, 0x08, 0x08, 0x04, 0xE3
	.byte 0xDF, 0x00, 0x06, 0x20, 0x1F, 0x30, 0x03, 0xE3, 0x13, 0xB2, 0x03, 0xCD, 0x06, 0xDD, 0x07, 0xA7
	.byte 0x07, 0x32, 0x21, 0x03, 0x21, 0x31, 0x00, 0x74, 0x03, 0xAB, 0x45, 0x1F, 0xFD, 0x13, 0xE6, 0x0A
	.byte 0xFA, 0x14, 0x99, 0x03, 0xFF, 0x08, 0x81, 0x08, 0x53, 0x22, 0x13, 0xEC, 0xFF, 0x56, 0x5F, 0x16
	.byte 0x3E, 0x56, 0x1C, 0x10, 0x51, 0x0A, 0x65, 0x1A, 0x03, 0x30, 0x1F, 0x43, 0xE7, 0xFE, 0x70, 0x03
	.byte 0x10, 0xBA, 0x78, 0xBF, 0x18, 0xCB, 0x0C, 0x11, 0x1C, 0xAC, 0x10, 0x68, 0x23, 0xFE, 0x08, 0x9E
	.byte 0x0C, 0x16, 0x78, 0x20, 0x53, 0xEB, 0x10, 0x3B, 0x14, 0x33, 0x08, 0x69, 0x33, 0x77, 0x13, 0x00
	.byte 0x2B, 0x07, 0x5E, 0x57, 0xA1, 0x31, 0x2B, 0xAD, 0x08, 0x97, 0x10, 0xDD, 0x9F, 0x30, 0x3F, 0x32
	.byte 0x13, 0x04, 0xDD, 0x25, 0x1B, 0x28, 0xCB, 0x98, 0x0E, 0xC8, 0xDF, 0xFF, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0x70, 0x01
.L02017908:
	.byte 0x10, 0x00, 0x05, 0x00, 0x3F, 0x00, 0x00, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xD0, 0x01, 0x01, 0x00, 0x02, 0x00, 0x03, 0x00, 0x00, 0x04, 0x00, 0x05, 0x00
	.byte 0x06, 0x00, 0x07, 0x00, 0x00, 0x08, 0x00, 0x09, 0x00, 0x0A, 0x00, 0x0B, 0x38, 0x00, 0x0C, 0xF0
	.byte 0x28, 0xF0, 0x01, 0x20, 0x01, 0x21, 0x00, 0x22, 0x00, 0x00, 0x23, 0x00, 0x24, 0x00, 0x25, 0x00
	.byte 0x26, 0x00, 0x00, 0x27, 0x00, 0x28, 0x00, 0x29, 0x00, 0x2A, 0x0F, 0x00, 0x2B, 0x00, 0x2C, 0xF0
	.byte 0x28, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFC, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0x20, 0x01, 0x00
.L020179D8:
	.byte 0x10, 0x00, 0x05, 0x00, 0x3F, 0x00, 0x00, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xD0, 0x01, 0x40, 0x00, 0x41, 0x00, 0x42, 0x00, 0x00, 0x43, 0x00, 0x44, 0x00
	.byte 0x45, 0x00, 0x46, 0x00, 0x00, 0x47, 0x00, 0x48, 0x00, 0x49, 0x00, 0x4A, 0x38, 0x00, 0x4B, 0xF0
	.byte 0x28, 0xF0, 0x01, 0x20, 0x01, 0x60, 0x00, 0x61, 0x00, 0x00, 0x62, 0x00, 0x63, 0x00, 0x64, 0x00
	.byte 0x65, 0x00, 0x00, 0x66, 0x00, 0x67, 0x00, 0x68, 0x00, 0x69, 0x0F, 0x00, 0x6A, 0x00, 0x6B, 0xF0
	.byte 0x28, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFC, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0x20, 0x01, 0x00
.L02017AA8:
	.byte 0x10, 0xE5, 0x08, 0x00, 0x3F, 0x00, 0x00, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0
	.byte 0x01, 0xF0, 0x01, 0x30, 0x01, 0x0D, 0x00, 0x0E, 0x00, 0x0F, 0x00, 0x00, 0x10, 0x00, 0x11, 0x00
	.byte 0x12, 0x00, 0x13, 0x00, 0x00, 0x14, 0x00, 0x15, 0x00, 0x16, 0x00, 0x17, 0x00, 0x00, 0x18, 0x00
	.byte 0x19, 0x00, 0x1A, 0x00, 0x1B, 0x00, 0x00, 0x1C, 0x00, 0x1D, 0x00, 0x1E, 0x00, 0x0A, 0x0C, 0x00
	.byte 0x0B, 0x00, 0x0C, 0xF0, 0x3A, 0x20, 0x01, 0x2D, 0x00, 0x00, 0x2E, 0x00, 0x2F, 0x00, 0x30, 0x00
	.byte 0x31, 0x00, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34, 0x00, 0x35, 0x00, 0x00, 0x36, 0x00, 0x37, 0x00
	.byte 0x38, 0x00, 0x39, 0x00, 0x00, 0x3A, 0x00, 0x3B, 0x00, 0x3C, 0x00, 0x3D, 0x00, 0x01, 0x3E, 0x00
	.byte 0x2A, 0x00, 0x2B, 0x00, 0x2C, 0xF0, 0x3A, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xE0, 0xF0, 0x01, 0xF0, 0x01, 0x60, 0x01, 0x43, 0x4C, 0x52, 0x46, 0x80, 0x98, 0x00, 0x07, 0xFF
	.byte 0xFF, 0xF0, 0x01, 0xD0, 0x01, 0x0F, 0x00, 0x00, 0x7E, 0xFE, 0x10, 0x03, 0xF0, 0x19, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0x90, 0x01, 0x4C, 0x10, 0x49, 0x4E, 0x4B, 0x00, 0x5B, 0x00, 0x6D, 0x6F
	.byte 0x6A, 0x00, 0x69, 0x5F, 0x63, 0x68, 0x75, 0x75, 0x69, 0x2E, 0x00, 0x41, 0x43, 0x47, 0x00, 0x43
	.byte 0x4D, 0x4E, 0x54, 0x40, 0x10, 0x00, 0x16, 0x01, 0x0E, 0x83, 0x52, 0x83, 0x81, 0x00, 0x83, 0x93
	.byte 0x83, 0x67, 0x96, 0xA2, 0x90, 0xDD, 0x24, 0x92, 0xE8, 0x00, 0xB6, 0x43, 0x02, 0x20, 0xC0, 0x4D
	.byte 0x4F, 0x10, 0x44, 0x45, 0x04, 0x00, 0x07, 0x20, 0x20, 0x00, 0x02, 0x04, 0x56, 0x45, 0x52, 0x20
	.byte 0x08, 0x00, 0x0B, 0x49, 0x53, 0x00, 0x2D, 0x41, 0x53, 0x43, 0x30, 0x33, 0x45, 0x4E, 0x20, 0x44
	.byte 0x20, 0x10, 0x23, 0x00
.L02017C74:
	.byte 0x00, 0x00, 0x34, 0x6E, 0xFF, 0x7F, 0xC7, 0x14, 0x11, 0x3E, 0xD7, 0x5A
	.byte 0xC7, 0x14, 0xCA, 0x7D, 0xF8, 0x7F, 0x63, 0x2C, 0xB5, 0x26, 0xDF, 0x47, 0x09, 0x05, 0x8E, 0x26
	.byte 0xFD, 0x6F, 0x63, 0x0D, 0x53, 0x49, 0x4F, 0x43, 0x4F, 0x4E, 0x00, 0x00, 0x53, 0x49, 0x4F, 0x56
	.byte 0x53, 0x59, 0x4E, 0x43, 0x00, 0x00, 0x00, 0x00, 0x53, 0x49, 0x4F, 0x4D, 0x41, 0x49, 0x4E, 0x00

	.data

.L02018648:
	.byte 0xB0, 0xF8, 0x02, 0x02
.L0201864C:
	.byte 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x9D, 0x62, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0xFD, 0x62, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.L0201866C:
	.byte 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x6D, 0x63, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x95, 0x63, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0xD9, 0x63, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018694:
	.byte 0x01, 0x00, 0x00, 0x00, 0x94, 0x7C, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x79, 0x65, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x99, 0x65, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.L020186BC:
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0x9C, 0x7C, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x39, 0x54, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L020186E4:
	.byte 0x01, 0x00, 0x00, 0x00, 0xA8, 0x7C, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xAD, 0x55, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018704:
	.byte 0x00, 0x00, 0x00, 0x00, 0xD0, 0x1C, 0x00, 0x03, 0x18, 0x1D, 0x00, 0x03
	.byte 0x60, 0x1D, 0x00, 0x03, 0xA8, 0x1D, 0x00, 0x03, 0xF0, 0x1D, 0x00, 0x03, 0x38, 0x1E, 0x00, 0x03
	.byte 0x80, 0x1E, 0x00, 0x03, 0xC8, 0x1E, 0x00, 0x03, 0x10, 0x1F, 0x00, 0x03, 0x58, 0x1F, 0x00, 0x03
	.byte 0xA0, 0x1F, 0x00, 0x03, 0xE8, 0x1F, 0x00, 0x03, 0x30, 0x20, 0x00, 0x03, 0x78, 0x20, 0x00, 0x03
	.byte 0xC0, 0x20, 0x00, 0x03, 0x08, 0x21, 0x00, 0x03, 0x50, 0x21, 0x00, 0x03, 0x98, 0x21, 0x00, 0x03
	.byte 0xE0, 0x21, 0x00, 0x03, 0x28, 0x22, 0x00, 0x03, 0x70, 0x22, 0x00, 0x03, 0xB8, 0x22, 0x00, 0x03
	.byte 0x00, 0x23, 0x00, 0x03, 0x48, 0x23, 0x00, 0x03, 0x90, 0x23, 0x00, 0x03, 0xD8, 0x23, 0x00, 0x03
	.byte 0x20, 0x24, 0x00, 0x03, 0x68, 0x24, 0x00, 0x03, 0xB0, 0x24, 0x00, 0x03, 0xF8, 0x24, 0x00, 0x03
	.byte 0x40, 0x25, 0x00, 0x03, 0x88, 0x25, 0x00, 0x03, 0xD0, 0x25, 0x00, 0x03, 0x18, 0x26, 0x00, 0x03
	.byte 0x60, 0x26, 0x00, 0x03, 0xA8, 0x26, 0x00, 0x03, 0xF0, 0x26, 0x00, 0x03, 0x38, 0x27, 0x00, 0x03
	.byte 0x80, 0x27, 0x00, 0x03, 0xC8, 0x27, 0x00, 0x03, 0x10, 0x28, 0x00, 0x03, 0x58, 0x28, 0x00, 0x03
	.byte 0xA0, 0x28, 0x00, 0x03, 0xE8, 0x28, 0x00, 0x03, 0x30, 0x29, 0x00, 0x03, 0x78, 0x29, 0x00, 0x03
	.byte 0xC0, 0x29, 0x00, 0x03, 0x08, 0x2A, 0x00, 0x03, 0x50, 0x2A, 0x00, 0x03, 0x98, 0x2A, 0x00, 0x03
	.byte 0xE0, 0x2A, 0x00, 0x03, 0x28, 0x2B, 0x00, 0x03, 0x70, 0x2B, 0x00, 0x03, 0xB8, 0x2B, 0x00, 0x03
	.byte 0x00, 0x2C, 0x00, 0x03, 0x48, 0x2C, 0x00, 0x03, 0x90, 0x2C, 0x00, 0x03, 0xD8, 0x2C, 0x00, 0x03
	.byte 0x20, 0x2D, 0x00, 0x03, 0x68, 0x2D, 0x00, 0x03, 0xB0, 0x2D, 0x00, 0x03, 0xF8, 0x2D, 0x00, 0x03
	.byte 0x00, 0x00, 0x00, 0x00
.L02018804:
	.byte 0x45, 0x66, 0x01, 0x02, 0x45, 0x66, 0x01, 0x02, 0xA9, 0x6A, 0x01, 0x02
	.byte 0xAD, 0x6A, 0x01, 0x02, 0xA5, 0x6A, 0x01, 0x02, 0xA5, 0x6A, 0x01, 0x02, 0xB1, 0x6A, 0x01, 0x02
	.byte 0xB5, 0x6A, 0x01, 0x02
.L02018824:
	.byte 0x02, 0x00, 0x00, 0x00, 0xF9, 0x66, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x85, 0x67, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00, 0x51, 0x68, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00
	.byte 0xB5, 0x68, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x59, 0x69, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00
	.byte 0xDD, 0x69, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x25, 0x6A, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x69, 0x6A, 0x01, 0x02, 0x0B, 0x00, 0x0A, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x21, 0x68, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x4D, 0x68, 0x01, 0x02, 0x0B, 0x00, 0x0B, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x21, 0x6A, 0x01, 0x02
