    .include "asm/head.inc"

	thumb_func_start StringEquals
StringEquals: @ 0x02014694
	push {r4, lr}
	adds r4, r0, #0
	b .L020146A6
.L0201469A:
	adds r1, #1
	adds r4, #1
	cmp r2, r3
	beq .L020146A6
	movs r0, #0
	b .L020146B4
.L020146A6:
	ldrb r2, [r4]
	ldrb r3, [r1]
	adds r0, r3, #0
	orrs r0, r2
	cmp r0, #0
	bne .L0201469A
	movs r0, #1
.L020146B4:
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start StringCopy
StringCopy: @ 0x020146BC
	adds r3, r0, #0
	b .L020146C6
.L020146C0:
	strb r2, [r3]
	adds r1, #1
	adds r3, #1
.L020146C6:
	ldrb r2, [r1]
	cmp r2, #0
	bne .L020146C0
	ldrb r0, [r1]
	strb r0, [r3]
	bx lr
	.align 2, 0

	thumb_func_start SramChecksum32
SramChecksum32: @ 0x020146D4
	push {r4, r5, lr}
	adds r5, r1, #0
	ldr r1, .L020146F4 @ =ReadSramFast
	ldr r4, .L020146F8 @ =0x02028000
	ldr r3, [r1]
	adds r1, r4, #0
	adds r2, r5, #0
	bl _call_via_r3
	adds r0, r4, #0
	adds r1, r5, #0
	bl Checksum32_thm
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0
.L020146F4: .4byte ReadSramFast
.L020146F8: .4byte 0x02028000

	thumb_func_start VerifySaveBlockChecksum
VerifySaveBlockChecksum: @ 0x020146FC
	push {r4, r5, lr}
	adds r4, r0, #0
	ldrh r5, [r4, #0xa]
	ldrh r0, [r4, #8]
	bl SramOffsetToAddr
	adds r1, r5, #0
	bl SramChecksum32
	ldr r1, [r4, #0xc]
	cmp r1, r0
	bne .L02014718
	movs r0, #1
	b .L0201471A
.L02014718:
	movs r0, #0
.L0201471A:
	pop {r4, r5}
	pop {r1}
	bx r1

	thumb_func_start PopulateSaveBlockChecksum
PopulateSaveBlockChecksum: @ 0x02014720
	push {r4, r5, lr}
	adds r4, r0, #0
	ldrh r5, [r4, #0xa]
	ldrh r0, [r4, #8]
	bl SramOffsetToAddr
	adds r1, r5, #0
	bl SramChecksum32
	str r0, [r4, #0xc]
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_0201473C
func_0201473C: @ 0x0201473C
	push {r4, r5, lr}
	ldr r2, .L02014784 @ =0x0202F8A4
	lsrs r1, r0, #0x14
	movs r3, #0xf
	ands r1, r3
	adds r1, #0x30
	movs r5, #0
	strb r1, [r2]
	lsrs r1, r0, #0x10
	ands r1, r3
	adds r1, #0x30
	strb r1, [r2, #1]
	movs r4, #0x2f
	strb r4, [r2, #2]
	lsrs r1, r0, #0xc
	ands r1, r3
	adds r1, #0x30
	strb r1, [r2, #3]
	lsrs r1, r0, #8
	ands r1, r3
	adds r1, #0x30
	strb r1, [r2, #4]
	strb r4, [r2, #5]
	lsrs r1, r0, #4
	ands r1, r3
	adds r1, #0x30
	strb r1, [r2, #6]
	ands r0, r3
	adds r0, #0x30
	strb r0, [r2, #7]
	strb r5, [r2, #8]
	adds r0, r2, #0
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0
.L02014784: .4byte 0x0202F8A4

	thumb_func_start func_02014788
func_02014788: @ 0x02014788
	bx lr
	.align 2, 0

	thumb_func_start SramInit
SramInit: @ 0x0201478C
	push {r4, r5, lr}
	sub sp, #8
	ldr r0, .L020147E4 @ =0x12345678
	str r0, [sp]
	ldr r0, .L020147E8 @ =0x87654321
	str r0, [sp, #4]
	bl SetSramFastFunc
	ldr r2, .L020147EC @ =0x04000200
	ldrh r0, [r2]
	movs r3, #0x80
	lsls r3, r3, #6
	adds r1, r3, #0
	orrs r0, r1
	strh r0, [r2]
	ldr r5, .L020147F0 @ =.L020185A4
	ldr r1, [r5]
	ldr r4, .L020147F4 @ =0x000070F4
	adds r1, r1, r4
	mov r0, sp
	movs r2, #4
	bl WriteSramFast
	ldr r2, .L020147F8 @ =ReadSramFast
	ldr r0, [r5]
	adds r0, r0, r4
	add r1, sp, #4
	ldr r3, [r2]
	movs r2, #4
	bl _call_via_r3
	ldr r3, .L020147FC @ =0x0202F8AE
	movs r2, #0
	ldr r1, [sp, #4]
	ldr r0, [sp]
	cmp r1, r0
	bne .L020147D8
	movs r2, #1
.L020147D8:
	strb r2, [r3]
	add sp, #8
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L020147E4: .4byte 0x12345678
.L020147E8: .4byte 0x87654321
.L020147EC: .4byte 0x04000200
.L020147F0: .4byte .L020185A4
.L020147F4: .4byte 0x000070F4
.L020147F8: .4byte ReadSramFast
.L020147FC: .4byte 0x0202F8AE

	thumb_func_start IsSramWorking
IsSramWorking: @ 0x02014800
	ldr r0, .L0201480C @ =0x0202F8AE
	ldrb r0, [r0]
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	bx lr
	.align 2, 0
.L0201480C: .4byte 0x0202F8AE

	thumb_func_start func_02014810
func_02014810: @ 0x02014810
	push {lr}
	bl WriteAndVerifySramFast
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start WipeSram
WipeSram: @ 0x0201481C
	push {r4, r5, r6, lr}
	sub sp, #0x40
	movs r1, #1
	rsbs r1, r1, #0
	add r0, sp, #0x3c
.L02014826:
	str r1, [r0]
	subs r0, #4
	cmp r0, sp
	bge .L02014826
	movs r4, #0
	ldr r6, .L02014850 @ =.L020185A4
	ldr r5, .L02014854 @ =0x000001FF
.L02014834:
	lsls r0, r4, #6
	ldr r1, [r6]
	adds r1, r1, r0
	mov r0, sp
	movs r2, #0x40
	bl func_02014810
	adds r4, #1
	cmp r4, r5
	ble .L02014834
	add sp, #0x40
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02014850: .4byte .L020185A4
.L02014854: .4byte 0x000001FF

	thumb_func_start Checksum16
Checksum16: @ 0x02014858
	push {r4, lr}
	adds r2, r0, #0
	movs r3, #0
	movs r4, #0
	lsrs r0, r1, #0x1f
	adds r1, r1, r0
	asrs r1, r1, #1
	cmp r3, r1
	bge .L02014878
.L0201486A:
	ldrh r0, [r2]
	adds r3, r3, r0
	eors r4, r0
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bne .L0201486A
.L02014878:
	adds r0, r3, r4
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	pop {r4}
	pop {r1}
	bx r1

	thumb_func_start ReadGlobalSaveInfo
ReadGlobalSaveInfo: @ 0x02014884
	push {r4, lr}
	sub sp, #0x20
	adds r4, r0, #0
	bl IsSramWorking
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020148F4
	cmp r4, #0
	bne .L0201489A
	mov r4, sp
.L0201489A:
	ldr r1, .L020148E0 @ =ReadSramFast
	ldr r0, .L020148E4 @ =.L020185A4
	ldr r0, [r0]
	ldr r3, [r1]
	adds r1, r4, #0
	movs r2, #0x20
	bl _call_via_r3
	ldr r1, .L020148E8 @ =.L02017554
	adds r0, r4, #0
	bl StringEquals
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020148F4
	ldr r1, [r4, #8]
	ldr r0, .L020148EC @ =0x00011217
	cmp r1, r0
	bne .L020148F4
	ldrh r1, [r4, #0xc]
	ldr r0, .L020148F0 @ =0x0000200A
	cmp r1, r0
	bne .L020148F4
	adds r0, r4, #0
	movs r1, #0x1c
	bl Checksum16
	ldrh r1, [r4, #0x1c]
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	cmp r1, r0
	bne .L020148F4
	movs r0, #1
	b .L020148F6
	.align 2, 0
.L020148E0: .4byte ReadSramFast
.L020148E4: .4byte .L020185A4
.L020148E8: .4byte .L02017554
.L020148EC: .4byte 0x00011217
.L020148F0: .4byte 0x0000200A
.L020148F4:
	movs r0, #0
.L020148F6:
	add sp, #0x20
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start WriteGlobalSaveInfo
WriteGlobalSaveInfo: @ 0x02014900
	push {r4, lr}
	adds r4, r0, #0
	movs r1, #0x1c
	bl Checksum16
	strh r0, [r4, #0x1c]
	ldr r0, .L02014920 @ =.L020185A4
	ldr r1, [r0]
	adds r0, r4, #0
	movs r2, #0x20
	bl func_02014810
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014920: .4byte .L020185A4

	thumb_func_start WriteGlobalSaveInfoNoChecksum
WriteGlobalSaveInfoNoChecksum: @ 0x02014924
	push {lr}
	ldr r1, .L02014934 @ =.L020185A4
	ldr r1, [r1]
	movs r2, #0x20
	bl func_02014810
	pop {r0}
	bx r0
	.align 2, 0
.L02014934: .4byte .L020185A4

	thumb_func_start InitGlobalSaveInfo
InitGlobalSaveInfo: @ 0x02014938
	push {lr}
	sub sp, #0x20
	bl WipeSram
	ldr r1, .L020149A8 @ =.L02017554
	mov r0, sp
	bl StringCopy
	ldr r0, .L020149AC @ =0x00011217
	str r0, [sp, #8]
	mov r1, sp
	movs r3, #0
	ldr r0, .L020149B0 @ =0x0000200A
	strh r0, [r1, #0xc]
	mov r2, sp
	ldrb r1, [r2, #0xe]
	movs r0, #2
	rsbs r0, r0, #0
	ands r0, r1
	strb r0, [r2, #0xe]
	movs r1, #5
	rsbs r1, r1, #0
	ands r1, r0
	strb r1, [r2, #0xe]
	mov r0, sp
	movs r2, #3
	rsbs r2, r2, #0
	ands r2, r1
	strb r2, [r0, #0xe]
	mov r1, sp
	movs r0, #9
	rsbs r0, r0, #0
	ands r0, r2
	strb r0, [r1, #0xe]
	mov r2, sp
	ldrh r1, [r2, #0xe]
	movs r0, #0xf
	ands r0, r1
	strh r0, [r2, #0xe]
	mov r0, sp
	strb r3, [r0, #0x1f]
	strb r3, [r0, #0x1e]
	add r1, sp, #0x10
	movs r2, #0
	adds r0, #0x1b
.L02014992:
	strb r2, [r0]
	subs r0, #1
	cmp r0, r1
	bge .L02014992
	mov r0, sp
	bl WriteGlobalSaveInfo
	add sp, #0x20
	pop {r0}
	bx r0
	.align 2, 0
.L020149A8: .4byte .L02017554
.L020149AC: .4byte 0x00011217
.L020149B0: .4byte 0x0000200A

	thumb_func_start SramOffsetToAddr
SramOffsetToAddr: @ 0x020149B4
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	ldr r1, .L020149C4 @ =.L020185A4
	ldr r1, [r1]
	adds r1, r1, r0
	adds r0, r1, #0
	bx lr
	.align 2, 0
.L020149C4: .4byte .L020185A4

	thumb_func_start SramAddrToOffset
SramAddrToOffset: @ 0x020149C8
	ldr r1, .L020149D4 @ =.L020185A4
	ldr r1, [r1]
	subs r0, r0, r1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	bx lr
	.align 2, 0
.L020149D4: .4byte .L020185A4

	thumb_func_start ReadSaveBlockInfo
ReadSaveBlockInfo: @ 0x020149D8
	push {r4, r5, lr}
	sub sp, #0x10
	adds r4, r0, #0
	adds r5, r1, #0
	cmp r4, #0
	bne .L020149E6
	mov r4, sp
.L020149E6:
	ldr r2, .L02014A14 @ =ReadSramFast
	ldr r0, .L02014A18 @ =.L020185A4
	lsls r1, r5, #4
	adds r1, #0x20
	ldr r0, [r0]
	adds r0, r0, r1
	ldr r3, [r2]
	adds r1, r4, #0
	movs r2, #0x10
	bl _call_via_r3
	ldrh r1, [r4, #4]
	ldr r0, .L02014A1C @ =0x0000200A
	cmp r1, r0
	bne .L02014A68
	cmp r5, #6
	bhi .L02014A68
	lsls r0, r5, #2
	ldr r1, .L02014A20 @ =.L02014A24
	adds r0, r0, r1
	ldr r0, [r0]
	mov pc, r0
	.align 2, 0
.L02014A14: .4byte ReadSramFast
.L02014A18: .4byte .L020185A4
.L02014A1C: .4byte 0x0000200A
.L02014A20: .4byte .L02014A24
.L02014A24: @ jump table
	.4byte .L02014A40 @ case 0
	.4byte .L02014A40 @ case 1
	.4byte .L02014A40 @ case 2
	.4byte .L02014A40 @ case 3
	.4byte .L02014A40 @ case 4
	.4byte .L02014A48 @ case 5
	.4byte .L02014A50 @ case 6
.L02014A40:
	ldr r1, .L02014A44 @ =0x00011217
	b .L02014A52
	.align 2, 0
.L02014A44: .4byte 0x00011217
.L02014A48:
	ldr r1, .L02014A4C @ =0x00020112
	b .L02014A52
	.align 2, 0
.L02014A4C: .4byte 0x00020112
.L02014A50:
	ldr r1, .L02014A64 @ =0x00020223
.L02014A52:
	ldr r0, [r4]
	cmp r0, r1
	bne .L02014A68
	adds r0, r4, #0
	bl VerifySaveBlockChecksum
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	b .L02014A6A
	.align 2, 0
.L02014A64: .4byte 0x00020223
.L02014A68:
	movs r0, #0
.L02014A6A:
	add sp, #0x10
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start GetSaveReadAddr
GetSaveReadAddr: @ 0x02014A74
	push {lr}
	sub sp, #0x10
	adds r1, r0, #0
	mov r0, sp
	bl ReadSaveBlockInfo
	mov r0, sp
	ldrh r0, [r0, #8]
	bl SramOffsetToAddr
	add sp, #0x10
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start IsNotFirstPlaythrough
IsNotFirstPlaythrough: @ 0x02014A90
	push {lr}
	sub sp, #0x20
	mov r0, sp
	bl ReadGlobalSaveInfo
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L02014AA4
	movs r0, #0
	b .L02014AAC
.L02014AA4:
	mov r0, sp
	ldrb r0, [r0, #0xe]
	lsls r0, r0, #0x1f
	lsrs r0, r0, #0x1f
.L02014AAC:
	add sp, #0x20
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02014AB4
func_02014AB4: @ 0x02014AB4
	movs r0, #1
	bx lr

	thumb_func_start func_02014AB8
func_02014AB8: @ 0x02014AB8
	push {lr}
	bl IsSramWorking
	adds r1, r0, #0
	lsls r1, r1, #0x18
	cmp r1, #0
	bne .L02014ACA
	movs r0, #0
	b .L02014AD2
.L02014ACA:
	movs r1, #2
.L02014ACC:
	subs r1, #1
	cmp r1, #0
	bge .L02014ACC
.L02014AD2:
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02014AD8
func_02014AD8: @ 0x02014AD8
	push {lr}
	bl IsNotFirstPlaythrough
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02014AE8
func_02014AE8: @ 0x02014AE8
	sub sp, #0x20
	movs r2, #0
	mov r0, sp
	ldrb r1, [r0, #0x14]
	movs r0, #0x20
	ands r0, r1
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
.L02014AF8:
	cmp r0, #0
	beq .L02014B00
	movs r0, #1
	b .L02014B08
.L02014B00:
	adds r2, #1
	cmp r2, #2
	ble .L02014AF8
	movs r0, #0
.L02014B08:
	add sp, #0x20
	bx lr

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
	ldr r4, .L02014CA8 @ =0x03001CD0
	ldr r3, [r4]
	cmp r3, #0
	beq .L02014CB0
	cmp r3, #1
	beq .L02014D04
	ldr r0, .L02014CAC @ =0x0300003C
	ldr r0, [r0]
	b .L02014DA6
	.align 2, 0
.L02014CA8: .4byte 0x03001CD0
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
	ldr r0, .L02014D00 @ =0x03001C3C
	str r3, [r0]
	movs r0, #1
	str r0, [r4]
	b .L02014DA2
	.align 2, 0
.L02014CF0: .4byte 0x04000134
.L02014CF4: .4byte 0x04000128
.L02014CF8: .4byte 0x03000038
.L02014CFC: .4byte 0x0300003C
.L02014D00: .4byte 0x03001C3C
.L02014D04:
	ldr r0, .L02014D48 @ =0x04000128
	ldrh r0, [r0]
	adds r2, r0, #0
	ldr r0, .L02014D4C @ =0x03001C3C
	ldr r0, [r0]
	ldr r3, .L02014D50 @ =.L020185A8
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
.L02014D4C: .4byte 0x03001C3C
.L02014D50: .4byte .L020185A8
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
	ldr r3, .L02014DE8 @ =.L020185A8
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
.L02014DE8: .4byte .L020185A8
.L02014DEC: .4byte 0x000007CA
.L02014DF0: .4byte 0x03000038

	thumb_func_start func_02014DF4
func_02014DF4: @ 0x02014DF4
	push {r4, r5, r6, r7, lr}
	mov r7, sb
	mov r6, r8
	push {r6, r7}
	ldr r0, .L02014F4C @ =0x03001C38
	movs r3, #0
	str r3, [r0]
	ldr r2, .L02014F50 @ =.L020185A8
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
	ldr r5, .L02014F64 @ =0x03002E60
	movs r2, #0
	ldr r3, .L02014F50 @ =.L020185A8
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
	ldr r5, .L02014F50 @ =.L020185A8
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
	ldr r4, .L02014F50 @ =.L020185A8
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
.L02014F4C: .4byte 0x03001C38
.L02014F50: .4byte .L020185A8
.L02014F54: .4byte 0x000007C4
.L02014F58: .4byte 0x03000048
.L02014F5C: .4byte 0x0300004A
.L02014F60: .4byte 0x0000FFFF
.L02014F64: .4byte 0x03002E60
.L02014F68: .4byte 0x00000594
.L02014F6C: .4byte 0x02030080
.L02014F70: .4byte 0x03000050
.L02014F74: .4byte 0x000001FF
.L02014F78: .4byte 0x02030480
.L02014F7C: .4byte 0x03000058

	thumb_func_start func_02014F80
func_02014F80: @ 0x02014F80
	push {r4, lr}
	ldr r2, .L02014FF8 @ =.L020185A8
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
	ldr r0, .L02014FFC @ =0x00004321
	movs r1, #3
	movs r2, #0xf
	bl func_02014DC0
	movs r0, #0
	bl func_common_02016114
	bl func_02014DF4
	ldr r0, .L02015000 @ =0x03000044
	str r4, [r0]
	movs r3, #0
	ldr r4, .L02015004 @ =0x03001CC8
	ldr r2, .L02015008 @ =0x03001C30
	ldr r1, .L0201500C @ =0x03002E58
	movs r0, #3
.L02014FDE:
	strh r3, [r4]
	strh r3, [r2]
	strh r3, [r1]
	adds r4, #2
	adds r2, #2
	adds r1, #2
	subs r0, #1
	cmp r0, #0
	bge .L02014FDE
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014FF8: .4byte .L020185A8
.L02014FFC: .4byte 0x00004321
.L02015000: .4byte 0x03000044
.L02015004: .4byte 0x03001CC8
.L02015008: .4byte 0x03001C30
.L0201500C: .4byte 0x03002E58

	thumb_func_start func_common_02014FE8
func_common_02014FE8: @ 0x02015010
	push {r4, lr}
	ldr r0, .L02015064 @ =0x04000134
	movs r3, #0
	strh r3, [r0]
	ldr r2, .L02015068 @ =0x04000128
	ldr r0, .L0201506C @ =0x03000038
	ldrb r0, [r0]
	movs r4, #0x80
	lsls r4, r4, #6
	adds r1, r4, #0
	orrs r0, r1
	strh r0, [r2]
	ldr r0, .L02015070 @ =0x0400010E
	strh r3, [r0]
	ldr r2, .L02015074 @ =0x03001C3C
	ldr r1, .L02015078 @ =0x03001C38
	movs r0, #0
	str r0, [r1]
	str r0, [r2]
	ldr r1, .L0201507C @ =0x03001CD0
	str r0, [r1]
	ldr r1, .L02015080 @ =0x0300003C
	subs r0, #1
	str r0, [r1]
	ldr r4, .L02015084 @ =func_common_020150C4
	movs r0, #0
	adds r1, r4, #0
	bl SetIntrFunc
	movs r0, #0
	adds r1, r4, #0
	bl SetIntrFunc
	ldr r2, .L02015088 @ =0x04000200
	ldrh r0, [r2]
	movs r1, #0xc0
	orrs r0, r1
	strh r0, [r2]
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02015064: .4byte 0x04000134
.L02015068: .4byte 0x04000128
.L0201506C: .4byte 0x03000038
.L02015070: .4byte 0x0400010E
.L02015074: .4byte 0x03001C3C
.L02015078: .4byte 0x03001C38
.L0201507C: .4byte 0x03001CD0
.L02015080: .4byte 0x0300003C
.L02015084: .4byte func_common_020150C4
.L02015088: .4byte 0x04000200

	thumb_func_start func_common_02015064
func_common_02015064: @ 0x0201508C
	push {lr}
	ldr r1, .L020150D0 @ =0x04000134
	movs r2, #0x80
	lsls r2, r2, #8
	adds r0, r2, #0
	strh r0, [r1]
	subs r1, #0xc
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L020150D4 @ =0x03001C3C
	ldr r1, .L020150D8 @ =0x03001C38
	movs r0, #0
	str r0, [r1]
	str r0, [r2]
	ldr r1, .L020150DC @ =0x03001CD0
	str r0, [r1]
	ldr r1, .L020150E0 @ =0x0300003C
	subs r0, #1
	str r0, [r1]
	movs r0, #0
	movs r1, #0
	bl SetIntrFunc
	movs r0, #0
	movs r1, #0
	bl SetIntrFunc
	ldr r2, .L020150E4 @ =0x04000200
	ldrh r1, [r2]
	ldr r0, .L020150E8 @ =0x0000FF3F
	ands r0, r1
	strh r0, [r2]
	pop {r0}
	bx r0
	.align 2, 0
.L020150D0: .4byte 0x04000134
.L020150D4: .4byte 0x03001C3C
.L020150D8: .4byte 0x03001C38
.L020150DC: .4byte 0x03001CD0
.L020150E0: .4byte 0x0300003C
.L020150E4: .4byte 0x04000200
.L020150E8: .4byte 0x0000FF3F

	thumb_func_start func_common_020150C4
func_common_020150C4: @ 0x020150EC
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #0xc
	movs r0, #0
	mov sb, r0
	ldr r0, .L02015180 @ =0x03001C3C
	movs r2, #1
	str r2, [r0]
	ldr r1, .L02015184 @ =.L020185A8
	ldr r0, [r1]
	mov r3, sb
	strb r3, [r0, #0x1e]
	ldr r0, .L02015188 @ =0x03001C38
	str r2, [r0]
	ldr r0, [r1]
	strb r3, [r0, #8]
	ldr r0, .L0201518C @ =0x0400010E
	mov r2, sb
	strh r2, [r0]
	ldr r2, [r1]
	ldr r3, .L02015190 @ =0x04000128
	ldrh r0, [r3]
	lsls r1, r0, #0x10
	strh r0, [r2, #2]
	ldrh r0, [r2, #4]
	cmp r0, #6
	beq .L02015130
	lsrs r0, r1, #0x14
	movs r1, #3
	ands r0, r1
	strb r0, [r2, #6]
.L02015130:
	ldr r0, .L02015194 @ =0x04000120
	ldr r1, [r0, #4]
	ldr r0, [r0]
	str r0, [sp]
	str r1, [sp, #4]
	ldr r0, .L02015198 @ =0x03000038
	ldrb r0, [r0]
	movs r2, #0xc0
	lsls r2, r2, #7
	adds r1, r2, #0
	orrs r0, r1
	strh r0, [r3]
	ldr r0, .L0201519C @ =0x00007FFF
	strh r0, [r3, #2]
	movs r5, #0
	ldr r3, .L020151A0 @ =0x0000FFFF
	mov sl, r3
	mov r4, sp
	movs r7, #0
.L02015156:
	ldrh r0, [r4]
	cmp r0, #0
	beq .L020151A4
	cmp r0, sl
	beq .L020151A4
	ldr r2, .L02015184 @ =.L020185A8
	ldr r0, [r2]
	adds r0, #0xb
	adds r1, r0, r5
	ldrb r0, [r1]
	cmp r0, #0
	bne .L02015172
	movs r0, #1
	strb r0, [r1]
.L02015172:
	ldr r0, [r2]
	movs r1, #1
	lsls r1, r5
	ldrb r2, [r0, #8]
	orrs r1, r2
	strb r1, [r0, #8]
	b .L020151DE
	.align 2, 0
.L02015180: .4byte 0x03001C3C
.L02015184: .4byte .L020185A8
.L02015188: .4byte 0x03001C38
.L0201518C: .4byte 0x0400010E
.L02015190: .4byte 0x04000128
.L02015194: .4byte 0x04000120
.L02015198: .4byte 0x03000038
.L0201519C: .4byte 0x00007FFF
.L020151A0: .4byte 0x0000FFFF
.L020151A4:
	lsls r0, r5, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020151DE
	ldr r0, .L020151D0 @ =.L020185A8
	ldr r1, [r0]
	adds r0, r1, #0
	adds r0, #0x12
	adds r0, r0, r7
	ldrh r0, [r0]
	cmp r0, sl
	bne .L020151D4
	adds r1, #0x1a
	adds r1, r1, r5
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	b .L020151DE
	.align 2, 0
.L020151D0: .4byte .L020185A8
.L020151D4:
	adds r0, r1, #0
	adds r0, #0x1a
	adds r0, r0, r5
	movs r1, #0
	strb r1, [r0]
.L020151DE:
	ldr r0, .L02015234 @ =.L020185A8
	mov r8, r0
	ldr r6, [r0]
	adds r3, r6, #0
	adds r3, #0x12
	adds r3, r3, r7
	ldr r1, .L02015238 @ =0x02030480
	ldr r2, .L0201523C @ =0x03000058
	adds r2, r7, r2
	ldrh r0, [r2]
	lsls r0, r0, #3
	adds r0, r7, r0
	adds r0, r0, r1
	ldrh r1, [r4]
	strh r1, [r0]
	ldrh r0, [r4]
	ldr r1, .L02015240 @ =0x0000FFFF
	ands r0, r1
	strh r0, [r3]
	ldrh r0, [r2]
	adds r0, #1
	ldr r3, .L02015244 @ =0x000001FF
	mov ip, r3
	mov r1, ip
	ands r0, r1
	strh r0, [r2]
	adds r4, #2
	adds r7, #2
	adds r5, #1
	cmp r5, #3
	ble .L02015156
	mov r4, r8
	adds r1, r6, #0
	ldrh r0, [r1, #4]
	cmp r0, #4
	bls .L02015310
	ldrb r0, [r1, #1]
	cmp r0, #1
	beq .L02015248
	cmp r0, #3
	beq .L020152B8
	b .L02015310
	.align 2, 0
.L02015234: .4byte .L020185A8
.L02015238: .4byte 0x02030480
.L0201523C: .4byte 0x03000058
.L02015240: .4byte 0x0000FFFF
.L02015244: .4byte 0x000001FF
.L02015248:
	ldr r0, .L020152A0 @ =0x0300004A
	ldr r2, .L020152A4 @ =0x03000048
	ldrh r3, [r2]
	ldrh r0, [r0]
	cmp r0, r3
	beq .L02015270
	ldr r1, .L020152A8 @ =0x02030080
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
.L02015270:
	ldr r1, [r4]
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	bne .L02015310
	ldr r0, .L020152AC @ =0x000007CC
	adds r3, r1, r0
	ldrh r0, [r3]
	cmp r0, #0
	beq .L02015310
	ldr r2, .L020152B0 @ =0x04000128
	ldrh r0, [r2]
	movs r1, #0x80
	orrs r0, r1
	strh r0, [r2]
	ldr r1, .L020152B4 @ =0x0400010C
	ldrh r0, [r3]
	rsbs r0, r0, #0
	str r0, [r1]
	adds r1, #2
	movs r0, #0xc3
	strh r0, [r1]
	b .L02015310
	.align 2, 0
.L020152A0: .4byte 0x0300004A
.L020152A4: .4byte 0x03000048
.L020152A8: .4byte 0x02030080
.L020152AC: .4byte 0x000007CC
.L020152B0: .4byte 0x04000128
.L020152B4: .4byte 0x0400010C
.L020152B8:
	movs r0, #6
	ldrsb r0, [r6, r0]
	cmp r0, #0
	beq .L020152D2
	adds r0, r6, #0
	adds r0, #0x30
	movs r1, #1
	bl func_common_02015CEC
	mov r2, r8
	ldr r1, [r2]
	ldr r0, .L02015328 @ =0x00005FFF
	strh r0, [r1, #0x30]
.L020152D2:
	movs r5, #0
	ldr r6, .L0201532C @ =0x00009ABC
	mov r4, sp
.L020152D8:
	lsls r0, r5, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020152F6
	ldrh r0, [r4]
	cmp r0, r6
	beq .L020152F6
	mov r0, sb
	adds r0, #1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov sb, r0
.L020152F6:
	adds r4, #2
	adds r5, #1
	cmp r5, #3
	ble .L020152D8
	mov r3, sb
	cmp r3, #0
	bne .L02015310
	ldr r0, .L02015330 @ =.L020185A8
	ldr r0, [r0]
	ldr r1, .L02015334 @ =0x000007CE
	adds r0, r0, r1
	movs r1, #1
	strh r1, [r0]
.L02015310:
	ldr r1, .L02015338 @ =0x03001C38
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
.L02015328: .4byte 0x00005FFF
.L0201532C: .4byte 0x00009ABC
.L02015330: .4byte .L020185A8
.L02015334: .4byte 0x000007CE
.L02015338: .4byte 0x03001C38

	thumb_func_start func_common_02015314
func_common_02015314: @ 0x0201533C
	push {lr}
	ldr r1, .L02015354 @ =0x03007FF8
	movs r0, #1
	strh r0, [r1]
	bl SyncDispIo
	bl SyncBgsAndPal
	bl ApplyAsyncUploads
	pop {r0}
	bx r0
	.align 2, 0
.L02015354: .4byte 0x03007FF8

	thumb_func_start func_common_02015330
func_common_02015330: @ 0x02015358
	push {lr}
	bl SwiVBlankIntrWait
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_common_0201533C
func_common_0201533C: @ 0x02015364
	push {r4, lr}
	ldr r0, .L0201539C @ =.L02017BAC
	movs r1, #0
	movs r2, #0x20
	bl ApplyPaletteExt
	ldr r4, .L020153A0 @ =.L0201755C
	movs r0, #1
	bl GetBgChrOffset
	adds r1, r0, #0
	movs r0, #0xc0
	lsls r0, r0, #0x13
	adds r1, r1, r0
	adds r0, r4, #0
	bl func_common_020166B8
	ldr r0, .L020153A4 @ =.L020179E0
	ldr r1, .L020153A8 @ =0x0202B220
	bl func_common_020166B8
	movs r0, #2
	bl EnableBgSync
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L0201539C: .4byte .L02017BAC
.L020153A0: .4byte .L0201755C
.L020153A4: .4byte .L020179E0
.L020153A8: .4byte 0x0202B220

	thumb_func_start func_common_02015384
func_common_02015384: @ 0x020153AC
	push {lr}
	movs r0, #0
	bl InitBgs
	bl InitProcs
	movs r0, #0
	movs r1, #0
	movs r2, #0
	bl SetBgOffset
	ldr r3, .L02015420 @ =gDispIo
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
	ldr r0, .L02015424 @ =func_common_02015330
	bl SetMainFunc
	pop {r0}
	bx r0
	.align 2, 0
.L02015420: .4byte gDispIo
.L02015424: .4byte func_common_02015330

	thumb_func_start func_common_02015400
func_common_02015400: @ 0x02015428
	push {lr}
	ldr r1, .L02015450 @ =0x04000004
	movs r0, #8
	strh r0, [r1]
	ldr r1, .L02015454 @ =0x04000208
	movs r0, #1
	strh r0, [r1]
	movs r1, #0x80
	lsls r1, r1, #0x13
	movs r0, #0
	strh r0, [r1]
	ldr r0, .L02015458 @ =func_common_02015314
	bl SetOnVBlank
	ldr r0, .L0201545C @ =func_common_02015384
	bl SetMainFunc
	pop {r0}
	bx r0
	.align 2, 0
.L02015450: .4byte 0x04000004
.L02015454: .4byte 0x04000208
.L02015458: .4byte func_common_02015314
.L0201545C: .4byte func_common_02015384

	thumb_func_start func_common_02015438
func_common_02015438: @ 0x02015460
	push {r4, r5, r6, lr}
	sub sp, #4
	ldr r0, .L0201549C @ =.L020185A8
	ldr r2, [r0]
	ldrh r1, [r2, #4]
	adds r5, r0, #0
	cmp r1, #4
	bhi .L02015472
	b .L020155A0
.L02015472:
	ldrb r0, [r2, #1]
	cmp r0, #0
	bne .L0201547A
	b .L020155A0
.L0201547A:
	ldrb r0, [r2, #0x1e]
	adds r0, #1
	strb r0, [r2, #0x1e]
	ldr r1, [r5]
	ldrh r0, [r1, #4]
	cmp r0, #6
	bne .L02015508
	adds r0, r1, #0
	adds r0, #0x21
	ldrb r0, [r0]
	cmp r0, #2
	beq .L020154BA
	cmp r0, #2
	bgt .L020154A0
	cmp r0, #1
	beq .L020154E0
	b .L02015508
	.align 2, 0
.L0201549C: .4byte .L020185A8
.L020154A0:
	cmp r0, #3
	bne .L02015508
	ldrb r0, [r1, #0x1e]
	cmp r0, #0x3c
	bls .L020154BA
	movs r0, #6
	ldrsb r0, [r1, r0]
	adds r1, #0xb
	adds r1, r1, r0
	movs r0, #0
	strb r0, [r1]
	bl func_common_02015400
.L020154BA:
	ldr r4, .L0201552C @ =.L020185A8
	ldr r0, [r4]
	ldrb r0, [r0, #1]
	cmp r0, #0
	beq .L020154E0
	bl func_common_0201596C
	lsls r0, r0, #0x18
	asrs r2, r0, #0x18
	cmp r2, #0
	bne .L020154E0
	ldr r0, [r4]
	movs r1, #6
	ldrsb r1, [r0, r1]
	adds r0, #0xb
	adds r0, r0, r1
	strb r2, [r0]
	bl func_common_02015400
.L020154E0:
	movs r4, #0
	ldr r5, .L0201552C @ =.L020185A8
.L020154E4:
	ldr r0, .L0201552C @ =.L020185A8
	ldr r1, [r0]
	adds r0, r1, #0
	adds r0, #0x1a
	adds r0, r0, r4
	ldrb r0, [r0]
	cmp r0, #0x3c
	bls .L02015502
	adds r0, r1, #0
	adds r0, #0xb
	adds r0, r0, r4
	movs r1, #0
	strb r1, [r0]
	bl func_common_02015400
.L02015502:
	adds r4, #1
	cmp r4, #3
	ble .L020154E4
.L02015508:
	adds r4, r5, #0
	ldr r1, [r4]
	ldrb r0, [r1, #1]
	adds r6, r0, #0
	cmp r6, #1
	bne .L0201557C
	ldrb r5, [r1, #0x10]
	cmp r5, #0
	bne .L0201555E
	ldrb r0, [r1, #0x11]
	cmp r0, #0x3c
	bls .L02015530
	bl func_common_02015400
	ldr r1, [r4]
	movs r0, #2
	strh r0, [r1, #4]
	b .L020155A0
	.align 2, 0
.L0201552C: .4byte .L020185A8
.L02015530:
	mov r0, sp
	bl func_common_02015E28
	cmp r0, #0
	beq .L0201555E
	ldr r1, [sp]
	adds r1, #6
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	bl func_common_02015A3C
	lsls r0, r0, #0x10
	cmp r0, #0
	ble .L0201555E
	ldr r0, [r4]
	strb r5, [r0, #0x10]
	ldr r1, [r4]
	ldrb r0, [r1, #0x11]
	adds r0, #1
	strb r0, [r1, #0x11]
	ldr r0, [r4]
	adds r0, #0x2e
	strb r6, [r0]
.L0201555E:
	ldr r2, .L02015578 @ =.L020185A8
	ldr r1, [r2]
	ldrb r0, [r1, #0x10]
	adds r0, #1
	strb r0, [r1, #0x10]
	ldr r4, [r2]
	ldrb r0, [r4, #0x10]
	movs r1, #9
	bl __umodsi3
	strb r0, [r4, #0x10]
	b .L020155A0
	.align 2, 0
.L02015578: .4byte .L020185A8
.L0201557C:
	subs r0, #2
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	cmp r0, #1
	bhi .L020155A0
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	bne .L020155A0
	adds r0, r1, #0
	adds r0, #0x30
	movs r1, #1
	rsbs r1, r1, #0
	bl func_common_02015CEC
	ldr r1, [r5]
	ldr r0, .L020155A8 @ =0x00005FFF
	strh r0, [r1, #0x30]
.L020155A0:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L020155A8: .4byte 0x00005FFF

	thumb_func_start func_common_02015584
func_common_02015584: @ 0x020155AC
	ldr r1, .L020155C4 @ =0x0400010E
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L020155C8 @ =0x04000128
	ldr r0, .L020155CC @ =0x03000038
	ldrb r0, [r0]
	movs r3, #0xc1
	lsls r3, r3, #7
	adds r1, r3, #0
	orrs r0, r1
	strh r0, [r2]
	bx lr
	.align 2, 0
.L020155C4: .4byte 0x0400010E
.L020155C8: .4byte 0x04000128
.L020155CC: .4byte 0x03000038

	thumb_func_start func_common_020155A8
func_common_020155A8: @ 0x020155D0
	bx lr
	.align 2, 0

	thumb_func_start func_common_020155AC
func_common_020155AC: @ 0x020155D4
	push {r4, r5, r6, r7, lr}
	mov r7, r8
	push {r7}
	movs r6, #0
	movs r4, #0x38
.L020155DE:
	ldr r5, .L020156E0 @ =.L020185A8
	ldr r0, [r5]
	lsls r1, r6, #1
	adds r0, #0x26
	adds r0, r0, r1
	ldrh r2, [r0]
	adds r0, r4, #0
	movs r1, #0x88
	movs r3, #4
	bl DebugPutObjNumber
	adds r0, r6, #0
	bl func_06_02016424
	adds r2, r0, #0
	adds r0, r4, #0
	movs r1, #0x90
	movs r3, #4
	bl DebugPutObjNumber
	adds r4, #0x28
	adds r6, #1
	cmp r6, #3
	ble .L020155DE
	ldr r2, .L020156E4 @ =.L02017BCC
	movs r0, #0x18
	movs r1, #0x70
	bl DebugPutObjStr
	ldr r2, .L020156E8 @ =.L02017BD0
	movs r0, #0x10
	movs r1, #0x78
	bl DebugPutObjStr
	ldr r2, .L020156EC @ =.L02017BD8
	movs r0, #0x10
	movs r1, #0x88
	bl DebugPutObjStr
	ldr r0, [r5]
	movs r2, #6
	ldrsb r2, [r0, r2]
	movs r0, #0x10
	movs r1, #0x48
	movs r3, #2
	bl DebugPutObjNumber
	ldr r0, [r5]
	ldrb r2, [r0, #0xa]
	movs r0, #0x10
	movs r1, #0x50
	movs r3, #2
	bl DebugPutObjNumber
	ldr r0, [r5]
	ldrb r2, [r0, #0xf]
	movs r0, #0x10
	movs r1, #0x58
	movs r3, #2
	bl DebugPutObjNumber
	movs r0, #1
	rsbs r0, r0, #0
	bl func_06_02016424
	adds r2, r0, #0
	movs r0, #8
	movs r1, #0x90
	movs r3, #4
	bl DebugPutObjNumber
	ldr r2, [r5]
	ldrb r1, [r2, #1]
	cmp r1, #1
	beq .L02015676
	b .L020159C6
.L02015676:
	movs r0, #6
	ldrsb r0, [r2, r0]
	lsls r1, r0
	ldrb r0, [r2, #0xf]
	orrs r1, r0
	strb r1, [r2, #0xf]
	movs r6, #0
.L02015684:
	lsls r4, r6, #2
	adds r4, r4, r6
	adds r4, #7
	lsls r4, r4, #3
	ldr r0, .L020156F0 @ =0x03001C30
	lsls r5, r6, #1
	adds r0, r5, r0
	ldrh r2, [r0]
	adds r0, r4, #0
	movs r1, #0x70
	movs r3, #4
	bl DebugPutObjNumber
	ldr r0, .L020156F4 @ =0x03001CC8
	adds r5, r5, r0
	ldrh r2, [r5]
	adds r0, r4, #0
	movs r1, #0x78
	movs r3, #4
	bl DebugPutObjNumber
	adds r0, r6, #1
	mov r8, r0
	lsls r7, r6, #0x18
.L020156B4:
	asrs r0, r7, #0x18
	ldr r4, .L020156E0 @ =.L020185A8
	ldr r1, [r4]
	adds r1, #0x32
	bl func_06_02015C5C
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	adds r1, r0, #0
	cmp r0, #0
	bne .L020156CC
	b .L020159BE
.L020156CC:
	cmp r0, #0x16
	beq .L0201570C
	cmp r0, #0x16
	bgt .L020156F8
	cmp r0, #4
	bne .L020156DA
	b .L02015814
.L020156DA:
	cmp r0, #0xa
	beq .L0201570C
	b .L020159BE
	.align 2, 0
.L020156E0: .4byte .L020185A8
.L020156E4: .4byte .L02017BCC
.L020156E8: .4byte .L02017BD0
.L020156EC: .4byte .L02017BD8
.L020156F0: .4byte 0x03001C30
.L020156F4: .4byte 0x03001CC8
.L020156F8:
	cmp r0, #0x2e
	beq .L0201570C
	cmp r0, #0x2e
	bgt .L02015706
	cmp r0, #0x2a
	beq .L0201570C
	b .L020159BE
.L02015706:
	cmp r1, #0x80
	beq .L0201570C
	b .L020159BE
.L0201570C:
	ldr r5, .L02015760 @ =.L020185A8
	ldr r2, [r5]
	adds r4, r2, #0
	adds r4, #0x32
	ldrb r0, [r4]
	cmp r0, #0x1c
	beq .L02015794
	cmp r0, #0x1f
	beq .L02015720
	b .L020159BE
.L02015720:
	ldrb r1, [r4, #1]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r1, r0
	bne .L0201572C
	b .L020159BE
.L0201572C:
	lsls r1, r1, #1
	adds r3, r2, #0
	adds r3, #0x26
	adds r1, r3, r1
	ldrh r0, [r4, #2]
	ldrh r1, [r1]
	cmp r0, r1
	beq .L02015768
	ldr r0, .L02015764 @ =0x03002E50
	movs r1, #0x1e
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
	b .L020156B4
	.align 2, 0
.L02015760: .4byte .L020185A8
.L02015764: .4byte 0x03002E50
.L02015768:
	adds r0, r4, #0
	bl func_common_02015DB4
	ldr r0, .L02015790 @ =0x03002E50
	movs r1, #0x1e
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
	b .L02015804
	.align 2, 0
.L02015790: .4byte 0x03002E50
.L02015794:
	lsrs r0, r7, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020157B0
	ldr r3, [r5]
	ldrb r0, [r3]
	ldrh r1, [r4, #2]
	cmp r0, r1
	bne .L020157B0
	ldrh r0, [r3, #4]
	cmp r0, #5
	bls .L020157BE
.L020157B0:
	lsrs r0, r7, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020157E0
.L020157BE:
	ldr r0, .L020157D8 @ =.L020185A8
	ldr r2, [r0]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r0, #0
	beq .L020157CC
	b .L020159BE
.L020157CC:
	ldr r0, .L020157DC @ =0x03002E50
	movs r1, #0x16
	strb r1, [r0]
	ldrb r1, [r2, #6]
	b .L02015800
	.align 2, 0
.L020157D8: .4byte .L020185A8
.L020157DC: .4byte 0x03002E50
.L020157E0:
	ldr r0, .L0201580C @ =.L020185A8
	ldr r1, [r0]
	movs r0, #6
	ldrsb r0, [r1, r0]
	cmp r0, #0
	beq .L020157EE
	b .L020159BE
.L020157EE:
	ldrb r0, [r1]
	movs r2, #0x15
	ldrh r4, [r4, #2]
	cmp r0, r4
	beq .L020157FA
	movs r2, #0x17
.L020157FA:
	ldr r0, .L02015810 @ =0x03002E50
	strb r2, [r0]
	ldrb r1, [r1, #6]
.L02015800:
	strb r1, [r0, #1]
	strh r6, [r0, #2]
.L02015804:
	movs r1, #4
	bl func_common_02015A3C
	b .L020159BE
	.align 2, 0
.L0201580C: .4byte .L020185A8
.L02015810: .4byte 0x03002E50
.L02015814:
	ldr r0, [r4]
	adds r5, r0, #0
	adds r5, #0x32
	ldrb r0, [r5]
	subs r0, #0x14
	cmp r0, #0xa
	bls .L02015824
	b .L020159BE
.L02015824:
	lsls r0, r0, #2
	ldr r1, .L02015830 @ =.L02015834
	adds r0, r0, r1
	ldr r0, [r0]
	mov pc, r0
	.align 2, 0
.L02015830: .4byte .L02015834
.L02015834: @ jump table
	.4byte .L020159B8 @ case 0
	.4byte .L02015960 @ case 1
	.4byte .L02015988 @ case 2
	.4byte .L02015920 @ case 3
	.4byte .L020159BE @ case 4
	.4byte .L02015860 @ case 5
	.4byte .L020159BE @ case 6
	.4byte .L020159BE @ case 7
	.4byte .L020159BE @ case 8
	.4byte .L020159BE @ case 9
	.4byte .L02015878 @ case 10
.L02015860:
	ldr r0, .L02015874 @ =.L020185A8
	ldr r2, [r0]
	movs r0, #1
	ldrb r5, [r5, #1]
	lsls r0, r5
	ldrb r1, [r2, #0xa]
	orrs r0, r1
	strb r0, [r2, #0xa]
	b .L020159BE
	.align 2, 0
.L02015874: .4byte .L020185A8
.L02015878:
	ldr r6, .L02015914 @ =.L020185A8
	ldr r3, [r6]
	adds r0, r3, #0
	adds r0, #0x2e
	ldrb r0, [r0]
	cmp r0, #0
	bne .L02015888
	b .L020159BE
.L02015888:
	ldrb r2, [r5, #1]
	lsrs r4, r2, #4
	movs r1, #6
	ldrsb r1, [r3, r1]
	cmp r4, r1
	bne .L02015896
	b .L020159BE
.L02015896:
	movs r0, #0xf
	ands r0, r2
	cmp r0, r1
	beq .L020158A0
	b .L020159BE
.L020158A0:
	ldrh r0, [r3, #0x24]
	adds r0, #1
	ldrh r1, [r5, #2]
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	cmp r1, r0
	beq .L020158B0
	b .L020159BE
.L020158B0:
	movs r0, #1
	lsls r0, r4
	ldrb r1, [r3, #0xf]
	orrs r0, r1
	strb r0, [r3, #0xf]
	ldr r0, .L02015918 @ =0x03000040
	ldr r1, [r0]
	ldr r0, [r6]
	ldrb r0, [r0, #0xf]
	strb r0, [r1]
	ldr r4, [r6]
	ldrb r0, [r4, #0xf]
	ldrb r1, [r4, #9]
	ands r0, r1
	cmp r0, r1
	bne .L020159BE
	ldrh r0, [r4, #0x24]
	adds r0, #1
	movs r3, #0
	strh r0, [r4, #0x24]
	ldr r2, .L0201591C @ =0x000007C4
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
	b .L020159BE
	.align 2, 0
.L02015914: .4byte .L020185A8
.L02015918: .4byte 0x03000040
.L0201591C: .4byte 0x000007C4
.L02015920:
	ldrb r0, [r5, #2]
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020159BE
	ldr r4, .L0201595C @ =.L020185A8
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
	b .L0201597C
	.align 2, 0
.L0201595C: .4byte .L020185A8
.L02015960:
	ldrb r0, [r5, #2]
	bl func_common_0201592C
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020159BE
	ldr r2, .L02015984 @ =.L020185A8
	ldr r0, [r2]
	adds r0, #0xb
	ldrh r5, [r5, #2]
	adds r0, r0, r5
	movs r1, #2
	strb r1, [r0]
	ldr r1, [r2]
.L0201597C:
	movs r0, #6
	strh r0, [r1, #4]
	b .L020159BE
	.align 2, 0
.L02015984: .4byte .L020185A8
.L02015988:
	ldr r3, .L020159B4 @ =.L020185A8
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
	b .L020159BE
	.align 2, 0
.L020159B4: .4byte .L020185A8
.L020159B8:
	ldrb r0, [r5, #1]
	bl func_common_020155A8
.L020159BE:
	mov r6, r8
	cmp r6, #3
	bgt .L020159C6
	b .L02015684
.L020159C6:
	pop {r3}
	mov r8, r3
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0

	thumb_func_start func_common_020158D0
func_common_020158D0: @ 0x020159D0
	bx lr
	.align 2, 0

	thumb_func_start func_common_020158D4
func_common_020158D4: @ 0x020159D4
	push {r4, r5, lr}
	movs r5, #0
	movs r4, #0
.L020159DA:
	lsls r0, r4, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201592C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L020159F0
	adds r0, r5, #1
	lsls r0, r0, #0x18
	lsrs r5, r0, #0x18
.L020159F0:
	adds r4, #1
	cmp r4, #3
	ble .L020159DA
	adds r0, r5, #0
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_02015900
func_common_02015900: @ 0x02015A00
	push {r4, r5, lr}
	movs r5, #0
	movs r4, #0
.L02015A06:
	lsls r0, r4, #0x18
	lsrs r0, r0, #0x18
	bl func_common_0201594C
	lsls r0, r0, #0x18
	asrs r0, r0, #0x18
	cmp r0, #1
	bne .L02015A1C
	adds r0, r5, #1
	lsls r0, r0, #0x18
	lsrs r5, r0, #0x18
.L02015A1C:
	adds r4, #1
	cmp r4, #3
	ble .L02015A06
	adds r0, r5, #0
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_0201592C
func_common_0201592C: @ 0x02015A2C
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	ldr r1, .L02015A44 @ =.L020185A8
	ldr r1, [r1]
	ldrb r1, [r1, #9]
	asrs r1, r0
	movs r0, #1
	ands r1, r0
	cmp r1, #0
	bne .L02015A48
	movs r0, #0
	b .L02015A4A
	.align 2, 0
.L02015A44: .4byte .L020185A8
.L02015A48:
	movs r0, #1
.L02015A4A:
	bx lr

	thumb_func_start func_common_0201594C
func_common_0201594C: @ 0x02015A4C
	lsls r0, r0, #0x18
	lsrs r0, r0, #0x18
	ldr r1, .L02015A64 @ =.L020185A8
	ldr r1, [r1]
	ldrb r1, [r1, #8]
	asrs r1, r0
	movs r0, #1
	ands r1, r0
	cmp r1, #0
	bne .L02015A68
	movs r0, #0
	b .L02015A6A
	.align 2, 0
.L02015A64: .4byte .L020185A8
.L02015A68:
	movs r0, #1
.L02015A6A:
	bx lr

	thumb_func_start func_common_0201596C
func_common_0201596C: @ 0x02015A6C
	push {r4, lr}
	ldr r2, .L02015A98 @ =.L020185A8
	ldr r3, [r2]
	ldrh r1, [r3, #2]
	movs r0, #0
	strh r0, [r3, #2]
	movs r4, #8
	ands r1, r4
	cmp r1, #0
	bne .L02015AA0
	ldr r0, .L02015A9C @ =0x04000128
	ldrh r1, [r0]
	adds r0, r4, #0
	ands r0, r1
	cmp r0, #0
	bne .L02015AA0
	adds r1, r3, #0
	adds r1, #0x20
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	b .L02015AA8
	.align 2, 0
.L02015A98: .4byte .L020185A8
.L02015A9C: .4byte 0x04000128
.L02015AA0:
	ldr r0, [r2]
	adds r0, #0x20
	movs r1, #0
	strb r1, [r0]
.L02015AA8:
	ldr r0, [r2]
	adds r0, #0x20
	ldrb r0, [r0]
	cmp r0, #0xa
	bhi .L02015AB6
	movs r0, #1
	b .L02015AB8
.L02015AB6:
	movs r0, #0
.L02015AB8:
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_020159C0
func_common_020159C0: @ 0x02015AC0
	ldr r0, .L02015ADC @ =.L020185A8
	ldr r0, [r0]
	ldr r2, .L02015AE0 @ =0x000007C5
	adds r1, r0, r2
	ldr r3, .L02015AE4 @ =0x000007C4
	adds r2, r0, r3
	ldrb r0, [r1]
	ldrb r3, [r2]
	cmp r0, r3
	bhs .L02015AE8
	ldrb r1, [r2]
	subs r1, #8
	b .L02015AEC
	.align 2, 0
.L02015ADC: .4byte .L020185A8
.L02015AE0: .4byte 0x000007C5
.L02015AE4: .4byte 0x000007C4
.L02015AE8:
	ldrb r0, [r1]
	ldrb r1, [r2]
.L02015AEC:
	subs r0, r0, r1
	bx lr

	thumb_func_start func_06_02015AF0
func_06_02015AF0: @ 0x02015AF0
	push {r4, r5, lr}
	movs r4, #0
	movs r1, #0
	ldr r5, .L02015B58 @ =.L020185A8
	ldr r0, [r5]
	adds r2, r0, #0
	adds r2, #0xb
.L02015AFE:
	adds r0, r2, r1
	ldrb r0, [r0]
	cmp r0, #5
	bne .L02015B08
	adds r4, #1
.L02015B08:
	adds r1, #1
	cmp r1, #3
	ble .L02015AFE
	ldr r0, [r5]
	ldrb r2, [r0, #9]
	movs r0, #0x10
	movs r1, #0x20
	movs r3, #2
	bl DebugPutObjNumberHex
	movs r0, #0x10
	movs r1, #0x28
	adds r2, r4, #0
	movs r3, #2
	bl DebugPutObjNumberHex
	ldr r0, [r5]
	movs r2, #6
	ldrsb r2, [r0, r2]
	movs r0, #0x40
	movs r1, #0x28
	movs r3, #2
	bl DebugPutObjNumberHex
	ldr r0, [r5]
	ldrb r0, [r0, #9]
	cmp r0, #3
	bne .L02015B44
	cmp r4, #2
	beq .L02015B54
.L02015B44:
	cmp r0, #7
	bne .L02015B4C
	cmp r4, #3
	beq .L02015B54
.L02015B4C:
	cmp r0, #0xf
	bne .L02015B5C
	cmp r4, #4
	bne .L02015B5C
.L02015B54:
	movs r0, #1
	b .L02015B5E
	.align 2, 0
.L02015B58: .4byte .L020185A8
.L02015B5C:
	movs r0, #0
.L02015B5E:
	pop {r4, r5}
	pop {r1}
	bx r1

	thumb_func_start func_common_02015A3C
func_common_02015A3C: @ 0x02015B64
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
	ldr r0, .L02015C04 @ =0x0300004A
	ldrh r3, [r0]
	cmp r5, #0x80
	bhi .L02015BFC
	lsrs r5, r1, #0x11
	ldr r1, .L02015C08 @ =0x00004FFF
	adds r4, r5, r1
	ldr r2, .L02015C0C @ =0x02030080
	lsls r0, r3, #1
	adds r0, r0, r2
	strh r1, [r0]
	adds r3, #1
	ldr r6, .L02015C10 @ =0x000001FF
	ands r3, r6
	ldr r0, .L02015C14 @ =0x03000048
	ldrh r1, [r0]
	mov ip, r2
	mov sl, r0
	cmp r3, r1
	beq .L02015BFC
	lsls r0, r3, #1
	add r0, ip
	strh r5, [r0]
	adds r3, #1
	ands r3, r6
	lsls r6, r3, #1
	adds r7, r3, #1
	cmp r3, r1
	beq .L02015BFC
	movs r2, #0
	cmp r2, r5
	bge .L02015BD8
	mov r3, sb
.L02015BBA:
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
	blt .L02015BBA
.L02015BD8:
	mov r1, ip
	adds r0, r6, r1
	strh r4, [r0]
	ldr r4, .L02015C10 @ =0x000001FF
	adds r3, r4, #0
	ands r3, r7
	mov r2, sl
	ldrh r1, [r2]
	cmp r3, r1
	beq .L02015BFC
	lsls r0, r3, #1
	add r0, ip
	mov r2, r8
	strh r2, [r0]
	adds r3, #1
	ands r3, r4
	cmp r3, r1
	bne .L02015C18
.L02015BFC:
	movs r0, #1
	rsbs r0, r0, #0
	b .L02015C48
	.align 2, 0
.L02015C04: .4byte 0x0300004A
.L02015C08: .4byte 0x00004FFF
.L02015C0C: .4byte 0x02030080
.L02015C10: .4byte 0x000001FF
.L02015C14: .4byte 0x03000048
.L02015C18:
	movs r2, #0
	cmp r2, r5
	bge .L02015C40
	mov r8, ip
	adds r7, r4, #0
	mov r4, sb
	mov r6, sl
.L02015C26:
	lsls r0, r3, #1
	add r0, r8
	ldrh r1, [r4]
	strh r1, [r0]
	adds r3, #1
	ands r3, r7
	ldrh r0, [r6]
	cmp r3, r0
	beq .L02015BFC
	adds r4, #2
	adds r2, #1
	cmp r2, r5
	blt .L02015C26
.L02015C40:
	ldr r1, .L02015C58 @ =0x0300004A
	strh r3, [r1]
	lsls r0, r5, #0x10
	asrs r0, r0, #0x10
.L02015C48:
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02015C58: .4byte 0x0300004A

	thumb_func_start func_06_02015C5C
func_06_02015C5C: @ 0x02015C5C
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #0x14
	str r1, [sp, #4]
	lsls r0, r0, #0x18
	movs r1, #0
	mov sb, r1
	movs r2, #0
	str r2, [sp, #0xc]
	ldr r2, .L02015CD8 @ =0x03000050
	lsrs r3, r0, #0x18
	str r3, [sp]
	asrs r3, r0, #0x17
	adds r4, r3, r2
	ldr r0, .L02015CDC @ =0x03000058
	adds r7, r3, r0
	ldrh r1, [r4]
	ldrh r5, [r7]
	mov ip, r2
	cmp r1, r5
	bne .L02015C8E
	b .L02015D86
.L02015C8E:
	ldr r0, .L02015CE0 @ =0x02030480
	ldrh r2, [r4]
	lsls r1, r2, #3
	adds r1, r3, r1
	adds r1, r1, r0
	ldrh r1, [r1]
	ldr r6, .L02015CE4 @ =0x00004FFF
	mov sl, r0
	cmp r1, r6
	beq .L02015CEC
	cmp r2, r5
	beq .L02015D1A
	adds r1, r3, #0
	adds r3, r4, #0
	mov r8, r6
	adds r4, r7, #0
	ldr r6, .L02015CE8 @ =0x000001FF
	mov r5, sl
.L02015CB2:
	ldrh r0, [r3]
	adds r0, #1
	ands r0, r6
	strh r0, [r3]
	ldrh r2, [r3]
	lsls r0, r2, #3
	adds r0, r1, r0
	adds r0, r0, r5
	ldrh r0, [r0]
	cmp r0, r8
	bne .L02015CCE
	ldrh r7, [r4]
	cmp r2, r7
	bne .L02015CEC
.L02015CCE:
	ldrh r0, [r4]
	cmp r2, r0
	bne .L02015CB2
	b .L02015D1A
	.align 2, 0
.L02015CD8: .4byte 0x03000050
.L02015CDC: .4byte 0x03000058
.L02015CE0: .4byte 0x02030480
.L02015CE4: .4byte 0x00004FFF
.L02015CE8: .4byte 0x000001FF
.L02015CEC:
	ldr r1, [sp]
	lsls r0, r1, #0x18
	asrs r1, r0, #0x17
	ldr r3, .L02015D0C @ =0x03000058
	adds r2, r1, r3
	add r1, ip
	ldrh r2, [r2]
	ldrh r1, [r1]
	mov r8, r0
	cmp r2, r1
	bhs .L02015D10
	movs r7, #0x80
	lsls r7, r7, #2
	adds r0, r2, r7
	subs r0, r0, r1
	b .L02015D12
	.align 2, 0
.L02015D0C: .4byte 0x03000058
.L02015D10:
	subs r0, r2, r1
.L02015D12:
	lsls r0, r0, #0x10
	lsrs r1, r0, #0x10
	cmp r1, #4
	bhi .L02015D20
.L02015D1A:
	movs r0, #4
	rsbs r0, r0, #0
	b .L02015E5E
.L02015D20:
	mov r2, r8
	asrs r0, r2, #0x17
	add r0, ip
	ldrh r0, [r0]
	adds r3, r0, #1
	ldr r0, .L02015D38 @ =0x000001FF
	cmp r3, r0
	bgt .L02015D3C
	lsls r0, r3, #0x10
	lsrs r0, r0, #0x10
	b .L02015D3E
	.align 2, 0
.L02015D38: .4byte 0x000001FF
.L02015D3C:
	movs r0, #0
.L02015D3E:
	mov r3, r8
	asrs r4, r3, #0x17
	lsls r0, r0, #3
	adds r0, r4, r0
	add r0, sl
	ldrh r6, [r0]
	cmp r6, #0x80
	bls .L02015D80
	mov r7, ip
	adds r2, r4, r7
	ldrh r0, [r2]
	adds r0, #1
	ldr r1, .L02015D74 @ =0x000001FF
	ands r0, r1
	strh r0, [r2]
	ldr r1, .L02015D78 @ =0x03002E58
	adds r1, r4, r1
	ldrh r0, [r1]
	adds r0, #1
	strh r0, [r1]
	ldr r1, .L02015D7C @ =0x03001CC8
	adds r1, r4, r1
	ldrh r0, [r1]
	adds r0, #1
	strh r0, [r1]
	b .L02015D1A
	.align 2, 0
.L02015D74: .4byte 0x000001FF
.L02015D78: .4byte 0x03002E58
.L02015D7C: .4byte 0x03001CC8
.L02015D80:
	adds r0, r6, #6
	cmp r0, r1
	ble .L02015D8C
.L02015D86:
	movs r0, #2
	rsbs r0, r0, #0
	b .L02015E5E
.L02015D8C:
	mov r0, ip
	adds r2, r4, r0
	ldrh r0, [r2]
	adds r0, #2
	ldr r7, .L02015E3C @ =0x000001FF
	ands r0, r7
	strh r0, [r2]
	ldrh r1, [r2]
	lsls r0, r1, #3
	adds r0, r4, r0
	add r0, sl
	ldrh r0, [r0]
	str r0, [sp, #8]
	adds r1, #1
	ands r1, r7
	strh r1, [r2]
	ldrh r1, [r2]
	lsls r0, r1, #3
	adds r0, r4, r0
	add r0, sl
	ldrh r0, [r0]
	str r0, [sp, #0x10]
	adds r1, #1
	ands r1, r7
	strh r1, [r2]
	ldr r0, .L02015E40 @ =0x00004FFF
	add r0, sb
	adds r0, r6, r0
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov sb, r0
	movs r3, #0
	cmp r3, r6
	bge .L02015E0E
	mov ip, r4
	adds r4, r2, #0
	ldr r5, [sp, #4]
.L02015DD6:
	ldrh r0, [r4]
	lsls r0, r0, #3
	add r0, ip
	add r0, sl
	ldrh r2, [r0]
	adds r3, #1
	adds r1, r2, #0
	muls r1, r3, r1
	mov r7, sb
	adds r0, r7, r1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	mov sb, r0
	mvns r1, r1
	ldr r0, [sp, #0xc]
	adds r1, r0, r1
	lsls r1, r1, #0x10
	lsrs r1, r1, #0x10
	str r1, [sp, #0xc]
	strh r2, [r5]
	ldrh r0, [r4]
	adds r0, #1
	ldr r1, .L02015E3C @ =0x000001FF
	ands r0, r1
	strh r0, [r4]
	adds r5, #2
	cmp r3, r6
	blt .L02015DD6
.L02015E0E:
	ldr r2, [sp, #8]
	cmp sb, r2
	bne .L02015E1C
	ldr r3, [sp, #0xc]
	ldr r7, [sp, #0x10]
	cmp r3, r7
	beq .L02015E4C
.L02015E1C:
	ldr r1, .L02015E44 @ =0x03001C30
	mov r0, r8
	asrs r2, r0, #0x17
	adds r1, r2, r1
	ldrh r0, [r1]
	adds r0, #1
	strh r0, [r1]
	ldr r1, .L02015E48 @ =0x03001CC8
	adds r2, r2, r1
	ldrh r0, [r2]
	adds r0, #1
	strh r0, [r2]
	movs r0, #3
	rsbs r0, r0, #0
	b .L02015E5E
	.align 2, 0
.L02015E3C: .4byte 0x000001FF
.L02015E40: .4byte 0x00004FFF
.L02015E44: .4byte 0x03001C30
.L02015E48: .4byte 0x03001CC8
.L02015E4C:
	mov r2, r8
	asrs r0, r2, #0x17
	ldr r3, .L02015E70 @ =0x03001CC8
	adds r0, r0, r3
	ldrh r1, [r0]
	adds r1, #1
	strh r1, [r0]
	lsls r0, r6, #0x11
	asrs r0, r0, #0x10
.L02015E5E:
	add sp, #0x14
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02015E70: .4byte 0x03001CC8

	thumb_func_start func_common_02015CEC
func_common_02015CEC: @ 0x02015E74
	push {r4, lr}
	adds r4, r0, #0
	ldr r0, .L02015E8C @ =.L020185A8
	ldr r3, [r0]
	movs r2, #6
	ldrsb r2, [r3, r2]
	movs r0, #1
	rsbs r0, r0, #0
	cmp r2, r0
	bne .L02015E90
	adds r0, r2, #0
	b .L02015EBE
	.align 2, 0
.L02015E8C: .4byte .L020185A8
.L02015E90:
	ldr r2, .L02015EC4 @ =0x04000128
	ldrh r0, [r4]
	strh r0, [r2, #2]
	movs r0, #6
	ldrsb r0, [r3, r0]
	cmp r0, #0
	bne .L02015EBC
	cmp r1, #0
	bge .L02015EBC
	ldrh r0, [r2]
	movs r1, #0x80
	orrs r0, r1
	strh r0, [r2]
	ldr r1, .L02015EC8 @ =0x0400010C
	ldr r2, .L02015ECC @ =0x000007CC
	adds r0, r3, r2
	ldrh r0, [r0]
	rsbs r0, r0, #0
	str r0, [r1]
	adds r1, #2
	movs r0, #0xc3
	strh r0, [r1]
.L02015EBC:
	movs r0, #0
.L02015EBE:
	pop {r4}
	pop {r1}
	bx r1
	.align 2, 0
.L02015EC4: .4byte 0x04000128
.L02015EC8: .4byte 0x0400010C
.L02015ECC: .4byte 0x000007CC

	thumb_func_start func_common_02015D48
func_common_02015D48: @ 0x02015ED0
	push {r4, r5, r6, lr}
	adds r2, r1, #0
	ldr r3, .L02015EF8 @ =0x03000050
	ldr r1, .L02015EFC @ =0x03000058
	ldrh r0, [r3]
	ldrh r1, [r1]
	cmp r0, r1
	bne .L02015F04
	ldr r1, .L02015F00 @ =0x00007FFF
	adds r0, r1, #0
	strh r0, [r2]
	adds r2, #2
	strh r0, [r2]
	adds r2, #2
	strh r0, [r2]
	strh r0, [r2, #2]
	movs r0, #2
	rsbs r0, r0, #0
	b .L02015F2C
	.align 2, 0
.L02015EF8: .4byte 0x03000050
.L02015EFC: .4byte 0x03000058
.L02015F00: .4byte 0x00007FFF
.L02015F04:
	movs r4, #0
	ldr r6, .L02015F34 @ =0x02030480
	ldr r5, .L02015F38 @ =0x000001FF
.L02015F0A:
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
	ble .L02015F0A
	movs r0, #0
.L02015F2C:
	pop {r4, r5, r6}
	pop {r1}
	bx r1
	.align 2, 0
.L02015F34: .4byte 0x02030480
.L02015F38: .4byte 0x000001FF

	thumb_func_start func_common_02015DB4
func_common_02015DB4: @ 0x02015F3C
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	ldr r3, .L02015FA4 @ =.L020185A8
	ldr r2, [r3]
	ldr r1, .L02015FA8 @ =0x000007C7
	adds r0, r2, r1
	ldrb r1, [r0]
	movs r0, #0x8c
	muls r0, r1, r0
	ldr r1, .L02015FAC @ =0x00000594
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
	bge .L02015F84
	adds r5, r1, #0
	adds r5, #0xa
	adds r3, r4, #6
.L02015F74:
	adds r0, r5, r2
	adds r1, r3, r2
	ldrb r1, [r1]
	strb r1, [r0]
	adds r2, #1
	ldrh r1, [r4, #4]
	cmp r2, r1
	blt .L02015F74
.L02015F84:
	ldr r1, [r6]
	ldr r2, .L02015FA8 @ =0x000007C7
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
.L02015FA4: .4byte .L020185A8
.L02015FA8: .4byte 0x000007C7
.L02015FAC: .4byte 0x00000594

	thumb_func_start func_common_02015E28
func_common_02015E28: @ 0x02015FB0
	push {r4, r5, r6, r7, lr}
	adds r7, r0, #0
	ldr r0, .L02015FFC @ =.L020185A8
	ldr r3, [r0]
	ldr r0, .L02016000 @ =0x000007C4
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
	cmp r0, #0x1f
	bne .L02016008
	ldr r1, .L02016004 @ =0x03000040
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
	b .L0201600A
	.align 2, 0
.L02015FFC: .4byte .L020185A8
.L02016000: .4byte 0x000007C4
.L02016004: .4byte 0x03000040
.L02016008:
	movs r0, #0
.L0201600A:
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1

	thumb_func_start func_common_02015E88
func_common_02015E88: @ 0x02016010
	push {r4, r5, r6, r7, lr}
	mov r7, r8
	push {r7}
	mov ip, r0
	lsls r1, r1, #0x10
	lsrs r7, r1, #0x10
	ldr r6, .L020160AC @ =0x03000044
	movs r0, #1
	str r0, [r6]
	ldr r4, .L020160B0 @ =.L020185A8
	ldr r1, [r4]
	ldr r2, .L020160B4 @ =0x000007C5
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
	movs r0, #0x1f
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
	bhs .L02016082
	adds r2, #6
.L0201606E:
	adds r1, r2, r3
	mov r4, ip
	adds r0, r4, r3
	ldrb r0, [r0]
	strb r0, [r1]
	adds r0, r3, #1
	lsls r0, r0, #0x18
	lsrs r3, r0, #0x18
	cmp r3, r7
	blo .L0201606E
.L02016082:
	ldr r1, [r6]
	ldr r3, .L020160B4 @ =0x000007C5
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
.L020160AC: .4byte 0x03000044
.L020160B0: .4byte .L020185A8
.L020160B4: .4byte 0x000007C5

	thumb_func_start func_common_02015F30
func_common_02015F30: @ 0x020160B8
	push {r4, r5, r6, r7, lr}
	mov r7, sl
	mov r6, sb
	mov r5, r8
	push {r5, r6, r7}
	sub sp, #4
	mov sb, r0
	str r1, [sp]
	mov sl, r2
.L020160CA:
	ldr r0, .L020160F8 @ =.L020185A8
	mov r8, r0
	ldr r2, [r0]
	ldr r7, .L020160FC @ =0x000007C6
	adds r0, r2, r7
	ldrb r1, [r0]
	movs r0, #0x8c
	muls r0, r1, r0
	ldr r1, .L02016100 @ =0x00000594
	adds r0, r0, r1
	adds r5, r2, r0
	adds r6, r5, #4
	ldrb r0, [r5, #4]
	cmp r0, #0x1f
	bne .L020160F2
	ldrb r1, [r6, #1]
	movs r0, #6
	ldrsb r0, [r2, r0]
	cmp r1, r0
	bne .L02016104
.L020160F2:
	movs r0, #0
	b .L0201622C
	.align 2, 0
.L020160F8: .4byte .L020185A8
.L020160FC: .4byte 0x000007C6
.L02016100: .4byte 0x00000594
.L02016104:
	lsls r0, r1, #1
	adds r3, r2, #0
	adds r3, #0x26
	adds r0, r3, r0
	ldrh r1, [r6, #2]
	ldrh r0, [r0]
	cmp r1, r0
	beq .L02016150
	ldr r0, .L0201614C @ =0x03002E50
	movs r1, #0x1e
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
	b .L020161BE
	.align 2, 0
.L0201614C: .4byte 0x03002E50
.L02016150:
	movs r2, #0
	ldrh r1, [r6, #4]
	cmp r2, r1
	bhs .L02016172
	adds r3, r5, #0
	adds r3, #0xa
.L0201615C:
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
	blo .L0201615C
.L02016172:
	mov r0, sl
	cmp r0, #0
	beq .L020161D4
	mov r0, sb
	bl _call_via_sl
	lsls r0, r0, #0x18
	cmp r0, #0
	bne .L020161D4
	ldr r0, .L020161C8 @ =0x03002E50
	movs r1, #0x1e
	strb r1, [r0]
	ldr r5, .L020161CC @ =.L020185A8
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
	ldr r2, .L020161D0 @ =0x000007C6
	adds r1, r1, r2
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
	ldr r1, [r5]
	adds r1, r1, r2
.L020161BE:
	ldrb r2, [r1]
	movs r0, #3
	ands r0, r2
	strb r0, [r1]
	b .L020160CA
	.align 2, 0
.L020161C8: .4byte 0x03002E50
.L020161CC: .4byte .L020185A8
.L020161D0: .4byte 0x000007C6
.L020161D4:
	movs r0, #0
	strb r0, [r6]
	ldrb r5, [r6, #1]
	ldr r4, .L0201623C @ =.L020185A8
	ldr r2, [r4]
	lsls r0, r5, #1
	adds r1, r2, #0
	adds r1, #0x26
	adds r1, r1, r0
	ldrh r0, [r1]
	adds r0, #1
	strh r0, [r1]
	ldr r3, .L02016240 @ =0x000007C6
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
	ldr r0, .L02016244 @ =0x03002E50
	movs r1, #0x1e
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
.L0201622C:
	add sp, #4
	pop {r3, r4, r5}
	mov r8, r3
	mov sb, r4
	mov sl, r5
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L0201623C: .4byte .L020185A8
.L02016240: .4byte 0x000007C6
.L02016244: .4byte 0x03002E50

	thumb_func_start func_common_020160C0
func_common_020160C0: @ 0x02016248
	push {lr}
	sub sp, #4
	ldr r1, .L02016284 @ =0x00007FFF
	mov r0, sp
	strh r1, [r0]
	ldr r0, .L02016288 @ =.L020185A8
	ldr r1, [r0]
	movs r0, #0
	strb r0, [r1, #1]
	mov r0, sp
	movs r1, #1
	bl func_common_02015CEC
	ldr r1, .L0201628C @ =0x0300004A
	ldr r0, .L02016290 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	ldr r3, .L02016294 @ =0x03000050
	ldr r2, .L02016298 @ =0x03000058
	movs r1, #3
.L02016270:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L02016270
	add sp, #4
	pop {r0}
	bx r0
	.align 2, 0
.L02016284: .4byte 0x00007FFF
.L02016288: .4byte .L020185A8
.L0201628C: .4byte 0x0300004A
.L02016290: .4byte 0x03000048
.L02016294: .4byte 0x03000050
.L02016298: .4byte 0x03000058

	thumb_func_start func_common_02016114
func_common_02016114: @ 0x0201629C
	ldr r1, .L020162A8 @ =.L020185A8
	ldr r1, [r1]
	adds r1, #0x21
	strb r0, [r1]
	bx lr
	.align 2, 0
.L020162A8: .4byte .L020185A8

	thumb_func_start func_common_02016124
func_common_02016124: @ 0x020162AC
	push {lr}
	sub sp, #4
	ldr r1, .L02016300 @ =0x00007FFF
	mov r0, sp
	strh r1, [r0]
	ldr r1, .L02016304 @ =.L020185A8
	ldr r0, [r1]
	movs r2, #0
	strb r2, [r0, #1]
	ldr r0, [r1]
	ldr r1, .L02016308 @ =0x000007CC
	adds r0, r0, r1
	strh r2, [r0]
	mov r0, sp
	movs r1, #1
	bl func_common_02015CEC
	ldr r1, .L0201630C @ =0x0300004A
	ldr r0, .L02016310 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	ldr r3, .L02016314 @ =0x03000050
	ldr r2, .L02016318 @ =0x03000058
	movs r1, #3
.L020162DC:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L020162DC
	ldr r0, .L02016304 @ =.L020185A8
	ldr r2, [r0]
	ldr r0, .L0201631C @ =0x000007CE
	adds r1, r2, r0
	movs r0, #0
	strh r0, [r1]
	movs r0, #3
	strb r0, [r2, #1]
	add sp, #4
	pop {r0}
	bx r0
	.align 2, 0
.L02016300: .4byte 0x00007FFF
.L02016304: .4byte .L020185A8
.L02016308: .4byte 0x000007CC
.L0201630C: .4byte 0x0300004A
.L02016310: .4byte 0x03000048
.L02016314: .4byte 0x03000050
.L02016318: .4byte 0x03000058
.L0201631C: .4byte 0x000007CE

	thumb_func_start func_common_02016198
func_common_02016198: @ 0x02016320
	push {r4, lr}
	sub sp, #4
	ldr r1, .L0201637C @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	ldr r3, .L02016380 @ =.L020185A8
	ldr r1, [r3]
	movs r2, #0
	movs r0, #0
	strh r0, [r1, #4]
	strb r2, [r1, #1]
	ldr r0, [r3]
	ldr r1, .L02016384 @ =0x000007CC
	adds r0, r0, r1
	movs r1, #0xf
	strh r1, [r0]
	ldr r1, .L02016388 @ =0x0300004A
	ldr r0, .L0201638C @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	adds r4, r3, #0
	ldr r3, .L02016390 @ =0x03000050
	ldr r2, .L02016394 @ =0x03000058
	movs r1, #3
.L02016350:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L02016350
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
.L0201637C: .4byte 0x00002586
.L02016380: .4byte .L020185A8
.L02016384: .4byte 0x000007CC
.L02016388: .4byte 0x0300004A
.L0201638C: .4byte 0x03000048
.L02016390: .4byte 0x03000050
.L02016394: .4byte 0x03000058

	thumb_func_start func_common_02016210
func_common_02016210: @ 0x02016398
	push {r4, lr}
	sub sp, #4
	ldr r1, .L020163F4 @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	ldr r3, .L020163F8 @ =.L020185A8
	ldr r1, [r3]
	movs r2, #0
	movs r0, #0
	strh r0, [r1, #4]
	strb r2, [r1, #1]
	ldr r0, [r3]
	ldr r1, .L020163FC @ =0x000007CC
	adds r0, r0, r1
	movs r1, #0x18
	strh r1, [r0]
	ldr r1, .L02016400 @ =0x0300004A
	ldr r0, .L02016404 @ =0x03000048
	ldrh r0, [r0]
	strh r0, [r1]
	adds r4, r3, #0
	ldr r3, .L02016408 @ =0x03000050
	ldr r2, .L0201640C @ =0x03000058
	movs r1, #3
.L020163C8:
	ldrh r0, [r3]
	strh r0, [r2]
	adds r3, #2
	adds r2, #2
	subs r1, #1
	cmp r1, #0
	bge .L020163C8
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
.L020163F4: .4byte 0x00002586
.L020163F8: .4byte .L020185A8
.L020163FC: .4byte 0x000007CC
.L02016400: .4byte 0x0300004A
.L02016404: .4byte 0x03000048
.L02016408: .4byte 0x03000050
.L0201640C: .4byte 0x03000058

	thumb_func_start func_common_02016288
func_common_02016288: @ 0x02016410
	ldr r0, .L0201641C @ =0x0300004A
	ldr r1, .L02016420 @ =0x03000048
	ldrh r1, [r1]
	strh r1, [r0]
	bx lr
	.align 2, 0
.L0201641C: .4byte 0x0300004A
.L02016420: .4byte 0x03000048

	thumb_func_start func_06_02016424
func_06_02016424: @ 0x02016424
	adds r1, r0, #0
	cmp r1, #0
	bge .L02016440
	ldr r2, .L02016438 @ =0x03000048
	ldr r1, .L0201643C @ =0x0300004A
	ldrh r0, [r2]
	ldrh r3, [r1]
	cmp r0, r3
	bhi .L02016452
	b .L02016468
	.align 2, 0
.L02016438: .4byte 0x03000048
.L0201643C: .4byte 0x0300004A
.L02016440:
	ldr r0, .L02016460 @ =0x03000050
	lsls r1, r1, #1
	adds r2, r1, r0
	ldr r0, .L02016464 @ =0x03000058
	adds r1, r1, r0
	ldrh r0, [r2]
	ldrh r3, [r1]
	cmp r0, r3
	bls .L02016468
.L02016452:
	ldrh r0, [r1]
	movs r1, #0x80
	lsls r1, r1, #2
	adds r0, r0, r1
	ldrh r1, [r2]
	subs r0, r0, r1
	b .L0201646E
	.align 2, 0
.L02016460: .4byte 0x03000050
.L02016464: .4byte 0x03000058
.L02016468:
	ldrh r1, [r1]
	ldrh r0, [r2]
	subs r0, r1, r0
.L0201646E:
	bx lr

	thumb_func_start func_common_0201629C
func_common_0201629C: @ 0x02016470
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L020164CC @ =.L020185A8
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
.L020164CC: .4byte .L020185A8

	thumb_func_start func_common_020162FC
func_common_020162FC: @ 0x020164D0
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	ldr r1, [r4, #0x2c]
	cmp r1, #0
	beq .L020164DE
	bl _call_via_r1
.L020164DE:
	ldr r5, .L0201653C @ =.L020185A8
	ldr r1, [r5]
	adds r0, r1, #0
	adds r0, #0x2e
	ldrb r6, [r0]
	cmp r6, #0
	bne .L02016534
	ldrh r2, [r4, #0x38]
	ldrh r0, [r1, #0x24]
	subs r0, #1
	cmp r2, r0
	beq .L02016512
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
.L02016512:
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
	blo .L02016534
	adds r0, r4, #0
	bl Proc_Break
.L02016534:
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L0201653C: .4byte .L020185A8

	thumb_func_start func_common_0201636C
func_common_0201636C: @ 0x02016540
	push {lr}
	ldr r2, .L02016564 @ =.L020185A8
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
.L02016564: .4byte .L020185A8

	thumb_func_start func_common_02016394
func_common_02016394: @ 0x02016568
	push {r4, lr}
	sub sp, #8
	adds r4, r0, #0
	add r1, sp, #4
	mov r0, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L020165A4
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
.L020165A4:
	add sp, #8
	pop {r4}
	pop {r0}
	bx r0

	thumb_func_start func_common_020163D8
func_common_020163D8: @ 0x020165AC
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L020165E8 @ =0x02028000
	ldrh r1, [r4, #0x38]
	ldrh r0, [r4, #0x36]
	subs r0, #1
	cmp r1, r0
	bge .L020165EC
	ldr r0, [r4, #0x30]
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016636
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
	b .L02016630
	.align 2, 0
.L020165E8: .4byte 0x02028000
.L020165EC:
	adds r0, r5, #0
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016636
	movs r2, #0
	adds r3, r4, #0
	adds r3, #0x3a
	adds r6, r4, #0
	adds r6, #0x3b
	ldrb r0, [r3]
	cmp r2, r0
	bge .L02016622
.L0201660C:
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
	blt .L0201660C
.L02016622:
	ldrh r1, [r4, #0x38]
	movs r0, #0x64
	muls r0, r1, r0
	ldrh r1, [r4, #0x36]
	bl __divsi3
	strb r0, [r6]
.L02016630:
	ldrh r0, [r4, #0x38]
	adds r0, #1
	strh r0, [r4, #0x38]
.L02016636:
	ldr r1, [r4, #0x2c]
	cmp r1, #0
	beq .L02016642
	adds r0, r4, #0
	bl _call_via_r1
.L02016642:
	ldrh r0, [r4, #0x38]
	ldrh r1, [r4, #0x36]
	cmp r0, r1
	blo .L02016650
	adds r0, r4, #0
	bl Proc_Break
.L02016650:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0

	thumb_func_start func_common_02016484
func_common_02016484: @ 0x02016658
	push {r4, r5, r6, r7, lr}
	mov r7, r8
	push {r7}
	adds r7, r0, #0
	adds r4, r1, #0
	mov r8, r2
	lsls r3, r3, #0x18
	lsrs r6, r3, #0x18
	ldr r0, .L02016674 @ =0x0079FF86
	cmp r4, r0
	bls .L02016678
	movs r0, #1
	rsbs r0, r0, #0
	b .L020166CA
	.align 2, 0
.L02016674: .4byte 0x0079FF86
.L02016678:
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
	beq .L0201669A
	adds r0, r5, #1
	lsls r0, r0, #0x10
	lsrs r5, r0, #0x10
.L0201669A:
	lsls r4, r4, #0x18
	lsrs r4, r4, #0x18
	ldr r0, .L020166D4 @ =.L020185AC
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
.L020166CA:
	pop {r3}
	mov r8, r3
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L020166D4: .4byte .L020185AC

	thumb_func_start func_common_02016504
func_common_02016504: @ 0x020166D8
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r1, #0
	adds r1, r2, #0
	ldr r0, .L02016700 @ =.L020185CC
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
.L02016700: .4byte .L020185CC

	thumb_func_start func_common_02016530
func_common_02016530: @ 0x02016704
	push {lr}
	ldr r0, .L02016720 @ =.L020185AC
	bl FindProc
	cmp r0, #0
	bne .L02016728
	ldr r0, .L02016724 @ =.L020185CC
	bl FindProc
	cmp r0, #0
	bne .L02016728
	movs r0, #0
	b .L0201672A
	.align 2, 0
.L02016720: .4byte .L020185AC
.L02016724: .4byte .L020185CC
.L02016728:
	movs r0, #1
.L0201672A:
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_common_0201655C
func_common_0201655C: @ 0x02016730
	movs r3, #0
	b .L0201673C
.L02016734:
	strb r2, [r1]
	adds r0, #1
	adds r1, #1
	adds r3, #1
.L0201673C:
	ldrb r2, [r0]
	cmp r2, #0
	bne .L02016734
	ldrb r0, [r0]
	strb r0, [r1]
	adds r0, r3, #0
	bx lr
	.align 2, 0

	thumb_func_start func_common_02016578
func_common_02016578: @ 0x0201674C
	push {lr}
	bl func_common_02014FE8
	bl func_02014F80
	ldr r2, .L02016768 @ =.L020185A8
	ldr r1, [r2]
	movs r3, #0
	movs r0, #1
	strb r0, [r1, #1]
	ldr r0, [r2]
	strh r3, [r0, #4]
	pop {r0}
	bx r0
	.align 2, 0
.L02016768: .4byte .L020185A8

	thumb_func_start func_common_02016598
func_common_02016598: @ 0x0201676C
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r6, r0, #0
	ldr r0, .L020167B0 @ =0x00002586
	mov r1, sp
	strh r0, [r1]
	bl func_02014C94
	movs r5, #1
	rsbs r5, r5, #0
	cmp r0, r5
	beq .L020167A8
	ldr r4, .L020167B4 @ =.L020185A8
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
.L020167A8:
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L020167B0: .4byte 0x00002586
.L020167B4: .4byte .L020185A8

	thumb_func_start func_06_020167B8
func_06_020167B8: @ 0x020167B8
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldrb r5, [r4, #0xb]
	mov r1, sp
	movs r0, #0
	strh r0, [r1]
	ldr r2, .L020167DC @ =0x01000024
	mov r0, sp
	adds r1, r4, #0
	bl SwiCpuSet
	strb r5, [r4, #0xb]
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L020167DC: .4byte 0x01000024

	thumb_func_start InitUnits
InitUnits: @ 0x020167E0
	push {r4, r5, r6, r7, lr}
	movs r5, #0
	ldr r7, .L0201680C @ =.L02018664
	movs r6, #0xff
.L020167E8:
	adds r0, r5, #0
	ands r0, r6
	lsls r0, r0, #2
	adds r0, r0, r7
	ldr r4, [r0]
	cmp r4, #0
	beq .L020167FE
	adds r0, r4, #0
	bl func_06_020167B8
	strb r5, [r4, #0xb]
.L020167FE:
	adds r5, #1
	cmp r5, #0x3d
	ble .L020167E8
	pop {r4, r5, r6, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L0201680C: .4byte .L02018664

	thumb_func_start func_06_02016810
func_06_02016810: @ 0x02016810
	ldr r0, [r0]
	lsrs r0, r0, #8
	bx lr
	.align 2, 0

	thumb_func_start func_06_02016818
func_06_02016818: @ 0x02016818
	push {r4, r5, lr}
	adds r4, r0, #0
	adds r5, r1, #0
	bl func_06_02016810
	adds r2, r0, #0
	subs r1, r2, #4
	movs r0, #0x1f
	ands r0, r1
	cmp r0, #0
	beq .L02016840
	adds r0, r4, #4
	lsrs r2, r1, #0x1f
	adds r2, r1, r2
	lsls r2, r2, #0xa
	lsrs r2, r2, #0xb
	adds r1, r5, #0
	bl SwiCpuSet
	b .L02016856
.L02016840:
	adds r3, r4, #4
	adds r0, r1, #0
	cmp r0, #0
	bge .L0201684A
	subs r0, r2, #1
.L0201684A:
	lsls r2, r0, #9
	lsrs r2, r2, #0xb
	adds r0, r3, #0
	adds r1, r5, #0
	bl SwiCpuFastSet
.L02016856:
	pop {r4, r5}
	pop {r0}
	bx r0

	thumb_func_start func_06_0201685C
func_06_0201685C: @ 0x0201685C
	push {r4, r5, r6, lr}
	adds r4, r0, #0
	adds r5, r1, #0
	ldr r6, .L02016888 @ =0x02028000
	adds r1, r6, #0
	bl SwiLZ77UnCompReadNormalWrite8bit
	adds r0, r4, #0
	bl func_06_02016810
	cmp r0, #0
	bge .L02016876
	adds r0, #3
.L02016876:
	lsls r2, r0, #9
	lsrs r2, r2, #0xb
	adds r0, r6, #0
	adds r1, r5, #0
	bl SwiCpuFastSet
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016888: .4byte 0x02028000

	thumb_func_start func_common_020166B8
func_common_020166B8: @ 0x0201688C
	push {r4, r5, lr}
	adds r3, r0, #0
	adds r4, r1, #0
	movs r0, #0xfa
	lsls r0, r0, #0x18
	adds r1, r4, r0
	ldr r0, .L020168C4 @ =0x00017FFF
	movs r5, #1
	cmp r1, r0
	bhi .L020168A2
	movs r5, #0
.L020168A2:
	ldr r2, .L020168C8 @ =.L02018764
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
.L020168C4: .4byte 0x00017FFF
.L020168C8: .4byte .L02018764

	thumb_func_start func_06_020168CC
func_06_020168CC: @ 0x020168CC
	push {r4, r5, lr}
	sub sp, #4
	adds r5, r0, #0
	ldr r1, .L02016940 @ =0x00002586
	mov r0, sp
	strh r1, [r0]
	movs r0, #0
	bl InitBgs
	ldr r0, .L02016944 @ =.L02017BAC
	movs r1, #0
	movs r2, #0x20
	bl ApplyPaletteExt
	ldr r4, .L02016948 @ =.L0201755C
	movs r0, #1
	bl GetBgChrOffset
	adds r1, r0, #0
	movs r0, #0xc0
	lsls r0, r0, #0x13
	adds r1, r1, r0
	adds r0, r4, #0
	bl func_common_020166B8
	ldr r0, .L0201694C @ =.L02017910
	ldr r1, .L02016950 @ =0x0202B220
	bl func_common_020166B8
	movs r0, #2
	bl EnableBgSync
	ldr r0, .L02016954 @ =.L0201861C
	movs r1, #0
	bl SpawnProc
	ldr r0, .L02016958 @ =.L02018644
	adds r1, r5, #0
	bl SpawnProc
	ldr r0, .L0201695C @ =.L020185F4
	adds r1, r5, #0
	bl SpawnProc
	movs r4, #1
	rsbs r4, r4, #0
	mov r0, sp
	adds r1, r4, #0
	bl func_common_02015CEC
	adds r0, r4, #0
	movs r1, #9
	bl DebugInitObj
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016940: .4byte 0x00002586
.L02016944: .4byte .L02017BAC
.L02016948: .4byte .L0201755C
.L0201694C: .4byte .L02017910
.L02016950: .4byte 0x0202B220
.L02016954: .4byte .L0201861C
.L02016958: .4byte .L02018644
.L0201695C: .4byte .L020185F4

	thumb_func_start func_06_02016960
func_06_02016960: @ 0x02016960
	push {r4, r5, r6, lr}
	adds r6, r0, #0
	movs r4, #0
	ldr r0, .L0201697C @ =.L020185F4
	bl FindProc
	cmp r0, #0
	beq .L02016984
	ldr r2, .L02016980 @ =.L02017BFC
	movs r0, #8
	movs r1, #0x10
	bl DebugPutObjStr
	b .L02016A0A
	.align 2, 0
.L0201697C: .4byte .L020185F4
.L02016980: .4byte .L02017BFC
.L02016984:
	movs r1, #0
	ldr r0, .L020169C0 @ =.L020185A8
	ldr r0, [r0]
	adds r2, r0, #0
	adds r2, #0x1a
.L0201698E:
	adds r0, r2, r1
	ldrb r0, [r0]
	cmp r0, #0x3c
	bls .L02016998
	adds r4, #1
.L02016998:
	adds r1, #1
	cmp r1, #3
	ble .L0201698E
	bl func_common_0201596C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L020169B6
	ldr r5, .L020169C0 @ =.L020185A8
	ldr r2, [r5]
	ldrb r0, [r2, #0x1e]
	cmp r0, #0x3c
	bhi .L020169B6
	cmp r4, #0
	beq .L020169C4
.L020169B6:
	adds r0, r6, #0
	movs r1, #0xa
	bl Proc_Goto
	b .L02016A0A
	.align 2, 0
.L020169C0: .4byte .L020185A8
.L020169C4:
	ldr r0, .L02016A10 @ =0x03001C40
	movs r1, #0x1c
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
	bne .L02016A00
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
.L02016A00:
	ldr r2, .L02016A14 @ =.L02017BFC
	movs r0, #8
	movs r1, #0x10
	bl DebugPutObjStr
.L02016A0A:
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016A10: .4byte 0x03001C40
.L02016A14: .4byte .L02017BFC

	thumb_func_start func_06_02016A18
func_06_02016A18: @ 0x02016A18
	push {lr}
	ldr r0, .L02016A38 @ =.L0201861C
	bl Proc_EndEach
	ldr r0, .L02016A3C @ =.L02018644
	bl Proc_EndEach
	ldr r0, .L02016A40 @ =.L020185F4
	bl Proc_EndEach
	bl func_common_02015064
	bl func_02014F80
	pop {r0}
	bx r0
	.align 2, 0
.L02016A38: .4byte .L0201861C
.L02016A3C: .4byte .L02018644
.L02016A40: .4byte .L020185F4

	thumb_func_start func_06_02016A44
func_06_02016A44: @ 0x02016A44
	push {lr}
	ldr r2, .L02016A54 @ =.L02017C04
	movs r0, #8
	movs r1, #0x10
	bl DebugPutObjStr
	pop {r0}
	bx r0
	.align 2, 0
.L02016A54: .4byte .L02017C04

	thumb_func_start func_common_02016850
func_common_02016850: @ 0x02016A58
	push {lr}
	adds r1, r0, #0
	ldr r2, .L02016A80 @ =0x080000B2
	ldr r3, .L02016A84 @ =0x03000060
	movs r0, #0
	strb r0, [r3]
	str r0, [r1, #0x58]
	ldrb r0, [r2]
	cmp r0, #0x96
	beq .L02016A88
	str r0, [r1, #0x5c]
	movs r0, #1
	str r0, [r1, #0x58]
	strb r0, [r3]
	adds r0, r1, #0
	movs r1, #0xb
	bl Proc_Goto
	b .L02016AA2
	.align 2, 0
.L02016A80: .4byte 0x080000B2
.L02016A84: .4byte 0x03000060
.L02016A88:
	ldr r0, .L02016AB0 @ =0x080000AC
	ldr r2, [r0]
	ldr r0, .L02016AB4 @ =0x4A454641
	cmp r2, r0
	beq .L02016AA2
	str r2, [r1, #0x5c]
	movs r0, #2
	str r0, [r1, #0x58]
	strb r0, [r3]
	adds r0, r1, #0
	movs r1, #0xb
	bl Proc_Goto
.L02016AA2:
	ldr r0, .L02016AB8 @ =0x03000060
	movs r1, #4
	bl func_common_02015E88
	pop {r0}
	bx r0
	.align 2, 0
.L02016AB0: .4byte 0x080000AC
.L02016AB4: .4byte 0x4A454641
.L02016AB8: .4byte 0x03000060

	thumb_func_start func_common_020168B4
func_common_020168B4: @ 0x02016ABC
	push {r4, r5, lr}
	sub sp, #0x20
	ldr r0, .L02016B5C @ =0x03000068
	movs r2, #0
	movs r1, #0x55
	strb r1, [r0]
	strb r2, [r0, #4]
	movs r4, #0
	adds r5, r0, #1
	adds r3, r0, #0
	adds r3, #0xc
	adds r1, r0, #5
.L02016AD4:
	adds r0, r4, r5
	strb r2, [r0]
	strb r2, [r1]
	strb r2, [r1, #4]
	stm r3!, {r2}
	adds r1, #1
	adds r4, #1
	cmp r4, #2
	ble .L02016AD4
	movs r4, #0
	mov r5, sp
.L02016AEA:
	adds r0, r4, #0
	bl func_02014B0C
	lsls r0, r0, #0x18
	cmp r0, #0
	beq .L02016B44
	adds r0, r4, #0
	mov r1, sp
	bl func_02014B30
	ldr r2, .L02016B5C @ =0x03000068
	adds r0, r2, #5
	adds r0, r4, r0
	ldrb r1, [r5, #0xe]
	strb r1, [r0]
	ldrb r1, [r5, #0x14]
	movs r0, #0x20
	ands r0, r1
	cmp r0, #0
	beq .L02016B22
	adds r0, r2, #1
	adds r0, r4, r0
	ldrb r1, [r0]
	adds r1, #1
	strb r1, [r0]
	ldrb r0, [r2, #4]
	adds r0, #1
	strb r0, [r2, #4]
.L02016B22:
	ldrb r1, [r5, #0x14]
	movs r0, #0x40
	ands r0, r1
	cmp r0, #0
	beq .L02016B38
	adds r1, r2, #0
	adds r1, #9
	adds r1, r4, r1
	ldrb r0, [r1]
	adds r0, #1
	strb r0, [r1]
.L02016B38:
	lsls r0, r4, #2
	adds r1, r2, #0
	adds r1, #0xc
	adds r0, r0, r1
	ldr r1, [sp]
	str r1, [r0]
.L02016B44:
	adds r4, #1
	cmp r4, #2
	ble .L02016AEA
	ldr r0, .L02016B5C @ =0x03000068
	movs r1, #0x28
	bl func_common_02015E88
	add sp, #0x20
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016B5C: .4byte 0x03000068

	thumb_func_start func_06_02016B60
func_06_02016B60: @ 0x02016B60
	push {r4, r5, lr}
	sub sp, #4
	adds r4, r0, #0
	ldr r5, .L02016B94 @ =0x03000060
	adds r0, r5, #0
	mov r1, sp
	movs r2, #0
	bl func_common_02015F30
	lsls r0, r0, #0x10
	cmp r0, #0
	beq .L02016B8C
	ldrb r0, [r5]
	str r0, [r4, #0x58]
	bl ReadGameSaveUnits
	str r0, [r4, #0x54]
	movs r0, #1
	str r0, [r4, #0x58]
	adds r0, r4, #0
	bl Proc_Break
.L02016B8C:
	add sp, #4
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016B94: .4byte 0x03000060

	thumb_func_start func_common_02016990
func_common_02016990: @ 0x02016B98
	push {r4, r5, r6, lr}
	movs r4, #0
	ldr r6, .L02016BDC @ =.L02018664
	ldr r5, .L02016BE0 @ =0x03000084
.L02016BA0:
	movs r0, #0xff
	ands r0, r4
	lsls r0, r0, #2
	adds r0, r0, r6
	ldr r0, [r0]
	ldrb r3, [r0, #0xe]
	lsls r2, r3, #0x18
	cmp r2, #0
	beq .L02016BD0
	ldrh r1, [r0, #0xc]
	movs r0, #4
	ands r0, r1
	cmp r0, #0
	bne .L02016BD0
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
.L02016BD0:
	adds r4, #1
	cmp r4, #0x3d
	ble .L02016BA0
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016BDC: .4byte .L02018664
.L02016BE0: .4byte 0x03000084

	thumb_func_start func_06_02016BE4
func_06_02016BE4: @ 0x02016BE4
	push {r4, r5, r6, lr}
	sub sp, #4
	adds r6, r0, #0
	mov r1, sp
	movs r0, #0
	strh r0, [r1]
	ldr r4, .L02016C1C @ =0x03000080
	ldr r2, .L02016C20 @ =0x01000012
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
	str r5, [r6, #0x58]
	add sp, #4
	pop {r4, r5, r6}
	pop {r0}
	bx r0
	.align 2, 0
.L02016C1C: .4byte 0x03000080
.L02016C20: .4byte 0x01000012

	thumb_func_start func_06_02016C24
func_06_02016C24: @ 0x02016C24
	push {lr}
	movs r0, #0
	bl func_common_02016114
	ldr r2, .L02016C3C @ =.L02017C08
	movs r0, #8
	movs r1, #0x10
	bl DebugPutObjStr
	pop {r0}
	bx r0
	.align 2, 0
.L02016C3C: .4byte .L02017C08

	thumb_func_start func_06_02016C40
func_06_02016C40: @ 0x02016C40
	push {lr}
	movs r0, #0
	bl func_common_02016114
	ldr r2, .L02016C58 @ =.L02017C08
	movs r0, #8
	movs r1, #0x10
	bl DebugPutObjStr
	pop {r0}
	bx r0
	.align 2, 0
.L02016C58: .4byte .L02017C08

	thumb_func_start func_common_02016A74
func_common_02016A74: @ 0x02016C5C
	push {lr}
	adds r1, r0, #0
	ldr r0, .L02016C6C @ =.L02018784
	bl SpawnProcLocking
	pop {r0}
	bx r0
	.align 2, 0
.L02016C6C: .4byte .L02018784

	thumb_func_start GetUnit
GetUnit: @ 0x02016C70
	ldr r2, .L02016C80 @ =.L02018664
	movs r1, #0xff
	ands r1, r0
	lsls r1, r1, #2
	adds r1, r1, r2
	ldr r0, [r1]
	bx lr
	.align 2, 0
.L02016C80: .4byte .L02018664

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

.L02017554:
	.byte 0x41, 0x47, 0x42, 0x2D, 0x46, 0x45, 0x36, 0x00
.L0201755C:
	.byte 0x10, 0x00, 0x08, 0x00
	.byte 0x30, 0x00, 0x00, 0xF0, 0x01, 0xF0, 0x01, 0x00, 0x00, 0x30, 0x33, 0x00, 0x33, 0x33, 0x23, 0x22
	.byte 0x22, 0x22, 0x30, 0x33, 0x40, 0x32, 0x20, 0x07, 0x23, 0x32, 0x22, 0x23, 0x23, 0x33, 0x28, 0x32
	.byte 0x23, 0x60, 0x1F, 0x03, 0x00, 0x21, 0x32, 0x23, 0x22, 0x02, 0x30, 0x21, 0x23, 0x33, 0x03, 0x13
	.byte 0x20, 0x1A, 0x23, 0x10, 0x33, 0x21, 0x23, 0x60, 0x1F, 0x33, 0x33, 0x00, 0x00, 0x00, 0x22, 0x32
	.byte 0x00, 0x30, 0x32, 0x03, 0x00, 0x23, 0x02, 0x22, 0x32, 0x30, 0x22, 0x33, 0x32, 0x20, 0x07, 0x21
	.byte 0xB0, 0xE0, 0x66, 0x00, 0x00, 0x17, 0x00, 0x23, 0x33, 0x00, 0x30, 0x22, 0x18, 0x31, 0x33, 0x00
	.byte 0x60, 0x3F, 0x40, 0x44, 0x03, 0x33, 0x22, 0x03, 0x22, 0x03, 0x03, 0x23, 0x23, 0x03, 0x10, 0x5E
	.byte 0x00, 0x07, 0xD4, 0x00, 0x2E, 0x80, 0x3C, 0x03, 0x00, 0x3C, 0x32, 0x00, 0x26, 0x21, 0x03, 0x27
	.byte 0x00, 0x32, 0x00, 0x40, 0x32, 0x33, 0x00, 0x10, 0x90, 0x01, 0x00, 0x0E, 0x08, 0x30, 0x32, 0x30
	.byte 0x00, 0x00, 0x9B, 0x03, 0x22, 0x22, 0x03, 0x13, 0x32, 0x23, 0x31, 0x30, 0x31, 0xE0, 0xE7, 0x00
	.byte 0x03, 0x1C, 0x23, 0x03, 0x30, 0x00, 0x03, 0x20, 0x01, 0x80, 0x1F, 0x03, 0x03, 0xB8, 0x00, 0x3C
	.byte 0x32, 0x00, 0xFF, 0x00, 0xE5, 0x00, 0xB9, 0x13, 0x12, 0x03, 0x7D, 0x30, 0x00, 0x67, 0xF1, 0x1F
	.byte 0x20, 0x79, 0x10, 0x68, 0x00, 0x03, 0x12, 0xA0, 0x80, 0x58, 0x03, 0x30, 0x80, 0x03, 0x00, 0x80
	.byte 0x01, 0x01, 0x22, 0x31, 0x00, 0x3A, 0x33, 0x23, 0xC0, 0xA0, 0xF0, 0x7F, 0x90, 0xFC, 0x30, 0x00
	.byte 0x34, 0x23, 0x00, 0x03, 0x33, 0x23, 0x13, 0x32, 0x13, 0x12, 0x30, 0x7E, 0x31, 0x20, 0x6B, 0x00
	.byte 0x64, 0x70, 0x39, 0x11, 0x36, 0x11, 0x5E, 0x00, 0x98, 0x33, 0x03, 0x32, 0x30, 0x12, 0x23, 0x32
	.byte 0x13, 0x00, 0x8B, 0x70, 0xFA, 0xFF, 0x11, 0x13, 0x11, 0x83, 0x01, 0x45, 0x00, 0x48, 0x00, 0x85
	.byte 0x00, 0x2C, 0x10, 0x6E, 0xB1, 0x7F, 0xFF, 0x21, 0x9F, 0x40, 0xA5, 0x01, 0x83, 0xA1, 0x7E, 0x00
	.byte 0x44, 0x00, 0x1B, 0x20, 0x07, 0x21, 0xCF, 0xDC, 0x00, 0x69, 0xF2, 0x29, 0x00, 0x00, 0x19, 0x20
	.byte 0x37, 0x01, 0x11, 0x00, 0x13, 0xF8, 0x60, 0x58, 0x00, 0x29, 0x01, 0xB6, 0x10, 0x03, 0x01, 0xC2
	.byte 0x33, 0x22, 0x21, 0xFF, 0x00, 0xFD, 0x00, 0x63, 0x60, 0x1F, 0x50, 0xA4, 0x10, 0x14, 0x01, 0x5E
	.byte 0x30, 0x07, 0x80, 0xDD, 0x9E, 0x91, 0x1D, 0x00, 0x30, 0x01, 0xF7, 0x01, 0x6C, 0x20, 0x07, 0xF2
	.byte 0x3E, 0x12, 0xFF, 0x00, 0x07, 0x01, 0x99, 0x32, 0x4A, 0xD0, 0x41, 0x21, 0x07, 0x60, 0x07, 0x10
	.byte 0xC5, 0xF2, 0x7E, 0xFE, 0x00, 0x03, 0x20, 0x07, 0x02, 0x60, 0x60, 0x1F, 0x20, 0x79, 0x00, 0xF8
	.byte 0x11, 0xFA, 0x32, 0x7E, 0x32, 0x11, 0x40, 0x30, 0x07, 0xA0, 0x5B, 0x00, 0x0D, 0x02, 0x5A, 0x10
	.byte 0x03, 0x30, 0x5D, 0x32, 0x22, 0xE4, 0x21, 0xB0, 0x5F, 0x00, 0x1F, 0x01, 0xD4, 0x30, 0x01, 0x97
	.byte 0x7B, 0x00, 0x00, 0x3D, 0x10, 0x03, 0x70, 0x3F, 0x00, 0x09, 0x33, 0x00, 0x60, 0x02, 0x42, 0xEF
	.byte 0x03, 0x60, 0x00, 0x79, 0x01, 0x5C, 0x23, 0xC2, 0x1F, 0x40, 0xFD, 0xA0, 0x03, 0xF3, 0xA7, 0xFE
	.byte 0x20, 0x3B, 0x42, 0x9F, 0xC0, 0xDE, 0xF0, 0x01, 0xF0, 0x01, 0xC0, 0x01, 0x22, 0xD3, 0x32, 0xE3
	.byte 0x02, 0xAF, 0x10, 0x03, 0x10, 0x57, 0x33, 0x12, 0x13, 0x01, 0x5E, 0x01, 0x23, 0xF0, 0x31, 0x3B
	.byte 0x13, 0xEB, 0x01, 0xD4, 0x00, 0x03, 0x21, 0x33, 0x30, 0x21, 0x03, 0x12, 0x21, 0x33, 0x12, 0x32
	.byte 0x12, 0x02, 0x96, 0x03, 0x7A, 0xA4, 0x30, 0x1F, 0x33, 0x00, 0xEC, 0x22, 0x32, 0x02, 0xB2, 0x33
	.byte 0x33, 0x35, 0x21, 0x12, 0x10, 0x45, 0x10, 0x1D, 0x21, 0x01, 0x18, 0x33, 0x12, 0x27, 0xFF, 0x01
	.byte 0x2F, 0x00, 0xE6, 0x03, 0x09, 0x13, 0xB6, 0x01, 0x15, 0x22, 0x7F, 0x62, 0x63, 0x20, 0x3F, 0xA1
	.byte 0x03, 0xE3, 0x23, 0x04, 0x53, 0x12, 0x12, 0x23, 0x33, 0x03, 0xB1, 0x8E, 0x01, 0x13, 0x21, 0x03
	.byte 0x30, 0x10, 0x2D, 0x13, 0xEC, 0x00, 0x01, 0x12, 0x9F, 0x00, 0x2C, 0x22, 0x31, 0x00, 0x76, 0x00
	.byte 0x19, 0x02, 0x14, 0x02, 0xB5, 0x00, 0xF7, 0xE8, 0x00, 0x50, 0x50, 0x40, 0x10, 0x31, 0x12, 0x01
	.byte 0x47, 0x32, 0x21, 0x22, 0x76, 0x03, 0x03, 0xF7, 0x00, 0x81, 0x01, 0x80, 0x21, 0x03, 0x97, 0x41
	.byte 0xFA, 0x23, 0x6C, 0x03, 0x10, 0x55, 0x00, 0x15, 0x33, 0x00, 0x03, 0x14, 0xB5, 0x21, 0x03, 0x7E
	.byte 0x03, 0x01, 0x3A, 0x22, 0x09, 0x21, 0x4F, 0x53, 0xCA, 0x50, 0x03, 0x11, 0x53, 0x13, 0xEF, 0x03
	.byte 0x3D, 0x60, 0x20, 0x23, 0x2D, 0x21, 0x14, 0x6D, 0xA0, 0x28, 0x22, 0x61, 0x20, 0xC0, 0x07, 0x03
	.byte 0x33, 0x21, 0x22, 0x31, 0x00, 0x1E, 0x11, 0xF2, 0x00, 0x69, 0xBF, 0x03, 0x7D, 0x21, 0x33, 0x85
	.byte 0xF0, 0x7F, 0xF0, 0x7F, 0x05, 0x67, 0x41, 0x7F, 0x30, 0x07, 0x2E, 0x13, 0x22, 0x04, 0x67, 0x13
	.byte 0x03, 0x41, 0x01, 0xE8, 0x21, 0x3F, 0x23, 0xF8, 0x00, 0x01, 0x04, 0x73, 0x10, 0xD8, 0x30, 0xDC
	.byte 0x30, 0x07, 0x33, 0x30, 0x03, 0xFF, 0x20, 0x1F, 0x20, 0xA9, 0x00, 0x03, 0x10, 0x07, 0x23, 0x39
	.byte 0x05, 0xA7, 0x11, 0x72, 0x00, 0x85, 0xFF, 0x30, 0x3F, 0x11, 0xA2, 0x43, 0x13, 0x20, 0x03, 0x15
	.byte 0x78, 0x12, 0x7A, 0x00, 0x07, 0x40, 0xBE, 0xFF, 0x01, 0xDB, 0x24, 0x90, 0x23, 0x55, 0x11, 0xA4
	.byte 0x00, 0x4B, 0x31, 0xBC, 0x10, 0x5F, 0x30, 0x2B, 0xFA, 0x15, 0xA7, 0x50, 0x03, 0x13, 0xD3, 0x62
	.byte 0xD7, 0xC2, 0xAE, 0x13, 0x03, 0xD6, 0x30, 0x7B, 0x21, 0x01, 0x31, 0x61, 0xDF, 0x40, 0x80, 0x11
	.byte 0xD2, 0x12, 0x40, 0x0B, 0x81, 0xBE, 0xFE, 0x14, 0x34, 0x04, 0x45, 0x53, 0xEB, 0x20, 0x46, 0x21
	.byte 0x80, 0x33, 0xAB, 0x10, 0x69, 0x12, 0xFD, 0x20, 0xCA, 0x53, 0x1B, 0x00, 0xA2, 0x14, 0xB7, 0x15
	.byte 0x99, 0x20, 0x1F, 0x21, 0x04, 0x6D, 0xFF, 0x01, 0x81, 0x23, 0x49, 0x10, 0x03, 0x15, 0x91, 0x15
	.byte 0x54, 0x50, 0x5E, 0x02, 0x9B, 0x13, 0x31, 0xFC, 0x06, 0x87, 0x20, 0x5F, 0x00, 0xBB, 0x20, 0x07
	.byte 0x00, 0x0F, 0x31, 0x5F, 0x22, 0x32, 0x94, 0x13, 0x4E, 0x31, 0x30, 0x10, 0x40, 0x32, 0x00, 0x3C
	.byte 0x21, 0x31, 0xDE, 0x00, 0x07, 0x01, 0xBE, 0x03, 0x40, 0xA0, 0x12, 0x77, 0x20, 0x01, 0x00, 0xC0
	.byte 0x23, 0xFC, 0x00, 0x1B, 0xD1, 0xFE, 0x11, 0x8B, 0x05, 0x8D, 0x21, 0xDE, 0x00, 0x18, 0x23, 0x30
	.byte 0x0F, 0x23, 0x31, 0x23, 0x23, 0x00, 0x34, 0x00, 0xB2, 0x20, 0x5F, 0x53, 0xE7, 0xFE, 0x80, 0x07
	.byte 0x00, 0xB1, 0x04, 0x03, 0x15, 0x3D, 0x73, 0xEF, 0x24, 0x36, 0x20, 0x03, 0x31, 0x0F, 0x23, 0x31
	.byte 0x13, 0x22, 0x02, 0xE3, 0x42, 0xBF, 0xF2, 0x9F, 0xC2, 0x9F, 0xC0, 0xF0, 0x01, 0xA0, 0x01, 0x00
.L02017910:
	.byte 0x10, 0x00, 0x05, 0x00, 0x3F, 0x00, 0x00, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0, 0x01, 0xF0, 0x01, 0xD0, 0x01, 0x01, 0x00, 0x02
	.byte 0x00, 0x03, 0x00, 0x00, 0x04, 0x00, 0x05, 0x00, 0x06, 0x00, 0x07, 0x00, 0x00, 0x08, 0x00, 0x09
	.byte 0x00, 0x0A, 0x00, 0x0B, 0x38, 0x00, 0x0C, 0xF0, 0x28, 0xF0, 0x01, 0x20, 0x01, 0x21, 0x00, 0x22
	.byte 0x00, 0x00, 0x23, 0x00, 0x24, 0x00, 0x25, 0x00, 0x26, 0x00, 0x00, 0x27, 0x00, 0x28, 0x00, 0x29
	.byte 0x00, 0x2A, 0x0F, 0x00, 0x2B, 0x00, 0x2C, 0xF0, 0x28, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xFC, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0x20, 0x01, 0x00
.L020179E0:
	.byte 0x10, 0xE5, 0x08, 0x00, 0x3F, 0x00, 0x00, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0, 0x01, 0xF0, 0x01, 0x30, 0x01, 0x0D, 0x00, 0x0E
	.byte 0x00, 0x0F, 0x00, 0x00, 0x10, 0x00, 0x11, 0x00, 0x12, 0x00, 0x13, 0x00, 0x00, 0x14, 0x00, 0x15
	.byte 0x00, 0x16, 0x00, 0x17, 0x00, 0x00, 0x18, 0x00, 0x19, 0x00, 0x1A, 0x00, 0x1B, 0x00, 0x00, 0x1C
	.byte 0x00, 0x1D, 0x00, 0x1E, 0x00, 0x0A, 0x0C, 0x00, 0x0B, 0x00, 0x0C, 0xF0, 0x3A, 0x20, 0x01, 0x2D
	.byte 0x00, 0x00, 0x2E, 0x00, 0x2F, 0x00, 0x30, 0x00, 0x31, 0x00, 0x00, 0x32, 0x00, 0x33, 0x00, 0x34
	.byte 0x00, 0x35, 0x00, 0x00, 0x36, 0x00, 0x37, 0x00, 0x38, 0x00, 0x39, 0x00, 0x00, 0x3A, 0x00, 0x3B
	.byte 0x00, 0x3C, 0x00, 0x3D, 0x00, 0x01, 0x3E, 0x00, 0x2A, 0x00, 0x2B, 0x00, 0x2C, 0xF0, 0x3A, 0xFF
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0
	.byte 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xFF, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01
	.byte 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0xE0, 0xF0, 0x01, 0xF0, 0x01, 0x60, 0x01, 0x43
	.byte 0x4C, 0x52, 0x46, 0x80, 0x98, 0x00, 0x07, 0xFF, 0xFF, 0xF0, 0x01, 0xD0, 0x01, 0x0F, 0x00, 0x00
	.byte 0x7E, 0xFE, 0x10, 0x03, 0xF0, 0x19, 0xF0, 0x01, 0xF0, 0x01, 0xF0, 0x01, 0x90, 0x01, 0x4C, 0x10
	.byte 0x49, 0x4E, 0x4B, 0x00, 0x5B, 0x00, 0x6D, 0x6F, 0x6A, 0x00, 0x69, 0x5F, 0x63, 0x68, 0x75, 0x75
	.byte 0x69, 0x2E, 0x00, 0x41, 0x43, 0x47, 0x00, 0x43, 0x4D, 0x4E, 0x54, 0x40, 0x10, 0x00, 0x16, 0x01
	.byte 0x0E, 0x83, 0x52, 0x83, 0x81, 0x00, 0x83, 0x93, 0x83, 0x67, 0x96, 0xA2, 0x90, 0xDD, 0x24, 0x92
	.byte 0xE8, 0x00, 0xB6, 0x43, 0x02, 0x20, 0xC0, 0x4D, 0x4F, 0x10, 0x44, 0x45, 0x04, 0x00, 0x07, 0x20
	.byte 0x20, 0x00, 0x02, 0x04, 0x56, 0x45, 0x52, 0x20, 0x08, 0x00, 0x0B, 0x49, 0x53, 0x00, 0x2D, 0x41
	.byte 0x53, 0x43, 0x30, 0x33, 0x45, 0x4E, 0x20, 0x44, 0x20, 0x10, 0x23, 0x00
.L02017BAC:
	.byte 0x00, 0x00, 0x34, 0x6E
	.byte 0xFF, 0x7F, 0xC7, 0x14, 0x11, 0x3E, 0xD7, 0x5A, 0xC7, 0x14, 0xCA, 0x7D, 0xF8, 0x7F, 0x63, 0x2C
	.byte 0xB5, 0x26, 0xDF, 0x47, 0x09, 0x05, 0x8E, 0x26, 0xFD, 0x6F, 0x63, 0x0D
.L02017BCC:
	.byte 0x53, 0x55, 0x4D, 0x00
.L02017BD0:
	.byte 0x54, 0x4F, 0x54, 0x41, 0x4C, 0x00, 0x00, 0x00
.L02017BD8:
	.byte 0x52, 0x45, 0x43, 0x56, 0x00, 0x00, 0x00, 0x00
	.byte 0x53, 0x49, 0x4F, 0x43, 0x4F, 0x4E, 0x00, 0x00, 0x53, 0x49, 0x4F, 0x56, 0x53, 0x59, 0x4E, 0x43
	.byte 0x00, 0x00, 0x00, 0x00, 0x53, 0x49, 0x4F, 0x4D, 0x41, 0x49, 0x4E, 0x00
.L02017BFC:
	.byte 0x57, 0x41, 0x49, 0x54
	.byte 0x00, 0x00, 0x00, 0x00
.L02017C04:
	.byte 0x45, 0x4E, 0x44, 0x00
.L02017C08:
	.byte 0x48, 0x41, 0x4C, 0x54, 0x00, 0x00, 0x00, 0x00

	.data

.L020185A4:
	.byte 0x00, 0x00, 0x00, 0x0E
.L020185A8:
	.byte 0xB0, 0xF8, 0x02, 0x02
.L020185AC:
	.byte 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x71, 0x64, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0xD1, 0x64, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.L020185CC:
	.byte 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x41, 0x65, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x69, 0x65, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0xAD, 0x65, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L020185F4:
	.byte 0x01, 0x00, 0x00, 0x00, 0xE0, 0x7B, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x4D, 0x67, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x6D, 0x67, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.L0201861C:
	.byte 0x01, 0x00, 0x00, 0x00
	.byte 0xE8, 0x7B, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x61, 0x54, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018644:
	.byte 0x01, 0x00, 0x00, 0x00, 0xF4, 0x7B, 0x01, 0x02, 0x15, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0xD5, 0x55, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018664:
	.byte 0x00, 0x00, 0x00, 0x00, 0xE0, 0x1C, 0x00, 0x03, 0x28, 0x1D, 0x00, 0x03
	.byte 0x70, 0x1D, 0x00, 0x03, 0xB8, 0x1D, 0x00, 0x03, 0x00, 0x1E, 0x00, 0x03, 0x48, 0x1E, 0x00, 0x03
	.byte 0x90, 0x1E, 0x00, 0x03, 0xD8, 0x1E, 0x00, 0x03, 0x20, 0x1F, 0x00, 0x03, 0x68, 0x1F, 0x00, 0x03
	.byte 0xB0, 0x1F, 0x00, 0x03, 0xF8, 0x1F, 0x00, 0x03, 0x40, 0x20, 0x00, 0x03, 0x88, 0x20, 0x00, 0x03
	.byte 0xD0, 0x20, 0x00, 0x03, 0x18, 0x21, 0x00, 0x03, 0x60, 0x21, 0x00, 0x03, 0xA8, 0x21, 0x00, 0x03
	.byte 0xF0, 0x21, 0x00, 0x03, 0x38, 0x22, 0x00, 0x03, 0x80, 0x22, 0x00, 0x03, 0xC8, 0x22, 0x00, 0x03
	.byte 0x10, 0x23, 0x00, 0x03, 0x58, 0x23, 0x00, 0x03, 0xA0, 0x23, 0x00, 0x03, 0xE8, 0x23, 0x00, 0x03
	.byte 0x30, 0x24, 0x00, 0x03, 0x78, 0x24, 0x00, 0x03, 0xC0, 0x24, 0x00, 0x03, 0x08, 0x25, 0x00, 0x03
	.byte 0x50, 0x25, 0x00, 0x03, 0x98, 0x25, 0x00, 0x03, 0xE0, 0x25, 0x00, 0x03, 0x28, 0x26, 0x00, 0x03
	.byte 0x70, 0x26, 0x00, 0x03, 0xB8, 0x26, 0x00, 0x03, 0x00, 0x27, 0x00, 0x03, 0x48, 0x27, 0x00, 0x03
	.byte 0x90, 0x27, 0x00, 0x03, 0xD8, 0x27, 0x00, 0x03, 0x20, 0x28, 0x00, 0x03, 0x68, 0x28, 0x00, 0x03
	.byte 0xB0, 0x28, 0x00, 0x03, 0xF8, 0x28, 0x00, 0x03, 0x40, 0x29, 0x00, 0x03, 0x88, 0x29, 0x00, 0x03
	.byte 0xD0, 0x29, 0x00, 0x03, 0x18, 0x2A, 0x00, 0x03, 0x60, 0x2A, 0x00, 0x03, 0xA8, 0x2A, 0x00, 0x03
	.byte 0xF0, 0x2A, 0x00, 0x03, 0x38, 0x2B, 0x00, 0x03, 0x80, 0x2B, 0x00, 0x03, 0xC8, 0x2B, 0x00, 0x03
	.byte 0x10, 0x2C, 0x00, 0x03, 0x58, 0x2C, 0x00, 0x03, 0xA0, 0x2C, 0x00, 0x03, 0xE8, 0x2C, 0x00, 0x03
	.byte 0x30, 0x2D, 0x00, 0x03, 0x78, 0x2D, 0x00, 0x03, 0xC0, 0x2D, 0x00, 0x03, 0x08, 0x2E, 0x00, 0x03
	.byte 0x00, 0x00, 0x00, 0x00
.L02018764:
	.byte 0x19, 0x68, 0x01, 0x02, 0x19, 0x68, 0x01, 0x02, 0x91, 0x6C, 0x01, 0x02
	.byte 0x95, 0x6C, 0x01, 0x02, 0x8D, 0x6C, 0x01, 0x02, 0x8D, 0x6C, 0x01, 0x02, 0x99, 0x6C, 0x01, 0x02
	.byte 0x9D, 0x6C, 0x01, 0x02
.L02018784:
	.byte 0x02, 0x00, 0x00, 0x00, 0xCD, 0x68, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x61, 0x69, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00, 0x59, 0x6A, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00
	.byte 0xBD, 0x6A, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x61, 0x6B, 0x01, 0x02, 0x02, 0x00, 0x00, 0x00
	.byte 0xE5, 0x6B, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00, 0x41, 0x6C, 0x01, 0x02, 0x0B, 0x00, 0x0A, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00, 0x19, 0x6A, 0x01, 0x02, 0x03, 0x00, 0x00, 0x00
	.byte 0x45, 0x6A, 0x01, 0x02, 0x0B, 0x00, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00
	.byte 0x25, 0x6C, 0x01, 0x02
