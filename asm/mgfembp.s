    .include "asm/head.inc"

	thumb_func_start IrqInit
IrqInit: @ 0x02010558
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	movs r0, #0
	str r0, [r7]
.L02010562:
	ldr r0, [r7]
	cmp r0, #0xc
	ble .L0201056A
	b .L02010588
.L0201056A:
	ldr r0, .L02010580 @ =gIrqFuncTable
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L02010584 @ =DummyFunc
	str r1, [r0]
	ldr r0, [r7]
	adds r1, r0, #1
	str r1, [r7]
	b .L02010562
	.align 2, 0
.L02010580: .4byte gIrqFuncTable
.L02010584: .4byte DummyFunc
.L02010588:
	ldr r0, .L020105A4 @ =IrqMain
	ldr r1, .L020105A8 @ =0x03001420
	movs r2, #0x80
	lsls r2, r2, #2
	bl SwiCpuFastSet
	ldr r0, .L020105AC @ =0x03007FFC
	ldr r1, .L020105A8 @ =0x03001420
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020105A4: .4byte IrqMain
.L020105A8: .4byte 0x03001420
.L020105AC: .4byte 0x03007FFC

	thumb_func_start DummyFunc
DummyFunc: @ 0x020105B0
	push {r7, lr}
	mov r7, sp
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start SetIrqFunc
SetIrqFunc: @ 0x020105BC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, .L020105DC @ =gIrqFuncTable
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, [r7, #4]
	str r1, [r0]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020105DC: .4byte gIrqFuncTable

	thumb_func_start GetGameTime
GetGameTime: @ 0x020105E0
	push {r7, lr}
	mov r7, sp
	ldr r0, .L020105EC @ =0x03000004
	ldr r1, [r0]
	adds r0, r1, #0
	b .L020105F0
	.align 2, 0
.L020105EC: .4byte 0x03000004
.L020105F0:
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start SetGameTime
SetGameTime: @ 0x020105F8
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02010610 @ =0x03000004
	ldr r1, [r7]
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010610: .4byte 0x03000004

	thumb_func_start IncGameTime
IncGameTime: @ 0x02010614
	push {r7, lr}
	mov r7, sp
	ldr r1, .L02010638 @ =0x03000004
	ldr r0, .L02010638 @ =0x03000004
	ldr r1, .L02010638 @ =0x03000004
	ldr r2, [r1]
	adds r1, r2, #1
	str r1, [r0]
	ldr r0, .L02010638 @ =0x03000004
	ldr r1, [r0]
	ldr r0, .L0201063C @ =0x0CDFE5FF
	cmp r1, r0
	bls .L02010644
	ldr r0, .L02010638 @ =0x03000004
	ldr r1, .L02010640 @ =0x0CBEF080
	str r1, [r0]
	b .L02010644
	.align 2, 0
.L02010638: .4byte 0x03000004
.L0201063C: .4byte 0x0CDFE5FF
.L02010640: .4byte 0x0CBEF080
.L02010644:
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start FormatTime
FormatTime: @ 0x0201064C
	push {r4, r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r4, [r7, #0xc]
	ldr r1, [r7]
	adds r0, r1, #0
	movs r1, #0x3c
	bl _udivsi3
	adds r1, r0, #0
	adds r0, r1, #0
	movs r1, #0x3c
	bl _umodsi3
	adds r1, r0, #0
	strh r1, [r4]
	ldr r4, [r7, #8]
	ldr r1, [r7]
	adds r0, r1, #0
	movs r1, #0xe1
	lsls r1, r1, #4
	bl _udivsi3
	adds r1, r0, #0
	adds r0, r1, #0
	movs r1, #0x3c
	bl _umodsi3
	adds r1, r0, #0
	strh r1, [r4]
	ldr r4, [r7, #4]
	ldr r1, [r7]
	adds r0, r1, #0
	ldr r1, .L020106BC @ =0x00034BC0
	bl _udivsi3
	adds r1, r0, #0
	strh r1, [r4]
	ldr r1, [r7]
	adds r0, r1, #0
	movs r1, #0x1e
	bl _udivsi3
	adds r1, r0, #0
	movs r2, #1
	adds r0, r1, #0
	ands r0, r2
	adds r1, r0, #0
	lsls r0, r1, #0x18
	asrs r1, r0, #0x18
	adds r0, r1, #0
	b .L020106C0
	.align 2, 0
.L020106BC: .4byte 0x00034BC0
.L020106C0:
	add sp, #0x10
	pop {r4, r7}
	pop {r1}
	bx r1

	thumb_func_start EnableBgSync
EnableBgSync: @ 0x020106C8
	push {r7, lr}
	mov r7, sp
	ldr r1, .L020106E0 @ =0x03000000
	ldr r2, .L020106E0 @ =0x03000000
	ldrb r3, [r2]
	adds r2, r0, #0
	orrs r3, r2
	adds r2, r3, #0
	strb r2, [r1]
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020106E0: .4byte 0x03000000

	thumb_func_start EnableBgSyncById
EnableBgSyncById: @ 0x020106E4
	push {r4, r7, lr}
	mov r7, sp
	ldr r1, .L02010700 @ =0x03000000
	ldr r2, .L02010700 @ =0x03000000
	movs r4, #1
	adds r3, r4, #0
	lsls r3, r0
	ldrb r2, [r2]
	orrs r2, r3
	adds r3, r2, #0
	strb r3, [r1]
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010700: .4byte 0x03000000

	thumb_func_start DisableBgSync
DisableBgSync: @ 0x02010704
	push {r4, r7, lr}
	mov r7, sp
	ldr r1, .L02010724 @ =0x03000000
	ldr r2, .L02010724 @ =0x03000000
	adds r3, r0, #0
	mvns r4, r3
	ldrb r2, [r2]
	adds r3, r4, #0
	adds r4, r3, #0
	ands r2, r4
	adds r3, r2, #0
	strb r3, [r1]
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010724: .4byte 0x03000000

	thumb_func_start EnablePalSync
EnablePalSync: @ 0x02010728
	push {r7, lr}
	mov r7, sp
	ldr r0, .L02010738 @ =0x03000001
	movs r1, #1
	strb r1, [r0]
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010738: .4byte 0x03000001

	thumb_func_start DisablePalSync
DisablePalSync: @ 0x0201073C
	push {r7, lr}
	mov r7, sp
	ldr r0, .L0201074C @ =0x03000001
	movs r1, #0
	strb r1, [r0]
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L0201074C: .4byte 0x03000001

	thumb_func_start ApplyPaletteExt
ApplyPaletteExt: @ 0x02010750
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r0, [r7, #8]
	movs r1, #0x1f
	ands r0, r1
	cmp r0, #0
	beq .L0201078C
	ldr r1, [r7, #4]
	asrs r0, r1, #1
	adds r1, r0, #0
	lsls r0, r1, #1
	ldr r2, .L02010788 @ =0x0202A620
	adds r1, r0, r2
	ldr r0, [r7, #8]
	asrs r2, r0, #0x1f
	lsrs r3, r2, #0x1f
	adds r2, r0, r3
	asrs r0, r2, #1
	lsls r3, r0, #0xb
	lsrs r2, r3, #0xb
	ldr r0, [r7]
	bl SwiCpuSet
	b .L020107AE
	.align 2, 0
.L02010788: .4byte 0x0202A620
.L0201078C:
	ldr r1, [r7, #4]
	asrs r0, r1, #1
	adds r1, r0, #0
	lsls r0, r1, #1
	ldr r2, .L020107BC @ =0x0202A620
	adds r1, r0, r2
	ldr r2, [r7, #8]
	adds r0, r2, #0
	cmp r0, #0
	bge .L020107A2
	adds r0, #3
.L020107A2:
	asrs r0, r0, #2
	lsls r3, r0, #0xb
	lsrs r2, r3, #0xb
	ldr r0, [r7]
	bl SwiCpuFastSet
.L020107AE:
	bl EnablePalSync
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020107BC: .4byte 0x0202A620

	thumb_func_start SyncDispIo
SyncDispIo: @ 0x020107C0
	push {r7, lr}
	mov r7, sp
	movs r0, #0x80
	lsls r0, r0, #0x13
	ldr r1, .L02010894 @ =0x03000350
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L02010898 @ =0x04000004
	ldr r1, .L0201089C @ =0x03000354
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L020108A0 @ =0x04000008
	ldr r1, .L020108A4 @ =0x0300035C
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L020108A8 @ =0x0400000A
	ldr r1, .L020108AC @ =0x03000360
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L020108B0 @ =0x0400000C
	ldr r1, .L020108B4 @ =0x03000364
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L020108B8 @ =0x0400000E
	ldr r1, .L020108BC @ =0x03000368
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L020108C0 @ =0x04000010
	ldr r1, .L020108C4 @ =0x0300036C
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108C8 @ =0x04000014
	ldr r1, .L020108CC @ =0x03000370
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108D0 @ =0x04000018
	ldr r1, .L020108D4 @ =0x03000374
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108D8 @ =0x0400001C
	ldr r1, .L020108DC @ =0x03000378
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108E0 @ =0x04000040
	ldr r1, .L020108E4 @ =0x0300037C
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108E8 @ =0x04000044
	ldr r1, .L020108EC @ =0x03000380
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108F0 @ =0x04000048
	ldr r1, .L020108F4 @ =0x03000384
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020108F8 @ =0x0400004C
	ldr r1, .L020108FC @ =0x03000388
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L02010900 @ =0x04000050
	ldr r1, .L02010904 @ =0x0300038C
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L02010908 @ =0x04000052
	ldr r1, .L0201090C @ =0x03000394
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L02010910 @ =0x04000054
	ldr r1, .L02010914 @ =0x03000396
	ldrb r2, [r1]
	strb r2, [r0]
	ldr r0, .L02010918 @ =0x04000020
	ldr r1, .L0201091C @ =0x03000398
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010920 @ =0x04000024
	ldr r1, .L02010924 @ =0x0300039C
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010928 @ =0x04000028
	ldr r1, .L0201092C @ =0x030003A0
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010930 @ =0x0400002C
	ldr r1, .L02010934 @ =0x030003A4
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010938 @ =0x04000030
	ldr r1, .L0201093C @ =0x030003A8
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010940 @ =0x04000034
	ldr r1, .L02010944 @ =0x030003AC
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010948 @ =0x04000038
	ldr r1, .L0201094C @ =0x030003B0
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L02010950 @ =0x0400003C
	ldr r1, .L02010954 @ =0x030003B4
	ldr r2, [r1]
	str r2, [r0]
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010894: .4byte 0x03000350
.L02010898: .4byte 0x04000004
.L0201089C: .4byte 0x03000354
.L020108A0: .4byte 0x04000008
.L020108A4: .4byte 0x0300035C
.L020108A8: .4byte 0x0400000A
.L020108AC: .4byte 0x03000360
.L020108B0: .4byte 0x0400000C
.L020108B4: .4byte 0x03000364
.L020108B8: .4byte 0x0400000E
.L020108BC: .4byte 0x03000368
.L020108C0: .4byte 0x04000010
.L020108C4: .4byte 0x0300036C
.L020108C8: .4byte 0x04000014
.L020108CC: .4byte 0x03000370
.L020108D0: .4byte 0x04000018
.L020108D4: .4byte 0x03000374
.L020108D8: .4byte 0x0400001C
.L020108DC: .4byte 0x03000378
.L020108E0: .4byte 0x04000040
.L020108E4: .4byte 0x0300037C
.L020108E8: .4byte 0x04000044
.L020108EC: .4byte 0x03000380
.L020108F0: .4byte 0x04000048
.L020108F4: .4byte 0x03000384
.L020108F8: .4byte 0x0400004C
.L020108FC: .4byte 0x03000388
.L02010900: .4byte 0x04000050
.L02010904: .4byte 0x0300038C
.L02010908: .4byte 0x04000052
.L0201090C: .4byte 0x03000394
.L02010910: .4byte 0x04000054
.L02010914: .4byte 0x03000396
.L02010918: .4byte 0x04000020
.L0201091C: .4byte 0x03000398
.L02010920: .4byte 0x04000024
.L02010924: .4byte 0x0300039C
.L02010928: .4byte 0x04000028
.L0201092C: .4byte 0x030003A0
.L02010930: .4byte 0x0400002C
.L02010934: .4byte 0x030003A4
.L02010938: .4byte 0x04000030
.L0201093C: .4byte 0x030003A8
.L02010940: .4byte 0x04000034
.L02010944: .4byte 0x030003AC
.L02010948: .4byte 0x04000038
.L0201094C: .4byte 0x030003B0
.L02010950: .4byte 0x0400003C
.L02010954: .4byte 0x030003B4

	thumb_func_start GetBgCt
GetBgCt: @ 0x02010958
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	adds r1, r7, #0
	strh r0, [r1]
	adds r1, r7, #0
	ldrh r0, [r1]
	cmp r0, #1
	beq .L02010988
	cmp r0, #1
	bgt .L02010974
	cmp r0, #0
	beq .L0201097E
	b .L020109A0
.L02010974:
	cmp r0, #2
	beq .L02010990
	cmp r0, #3
	beq .L02010998
	b .L020109A0
.L0201097E:
	ldr r0, .L02010984 @ =0x0300035C
	b .L020109A0
	.align 2, 0
.L02010984: .4byte 0x0300035C
.L02010988:
	ldr r0, .L0201098C @ =0x03000360
	b .L020109A0
	.align 2, 0
.L0201098C: .4byte 0x03000360
.L02010990:
	ldr r0, .L02010994 @ =0x03000364
	b .L020109A0
	.align 2, 0
.L02010994: .4byte 0x03000364
.L02010998:
	ldr r0, .L0201099C @ =0x03000368
	b .L020109A0
	.align 2, 0
.L0201099C: .4byte 0x03000368
.L020109A0:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start GetBgChrOffset
GetBgChrOffset: @ 0x020109A8
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	ldr r1, [r0]
	lsls r0, r1, #0x1c
	lsrs r2, r0, #0x1e
	lsls r1, r2, #0x10
	lsrs r0, r1, #0x10
	adds r1, r0, #0
	lsls r2, r1, #0xe
	adds r0, r2, #0
	b .L020109D4
.L020109D4:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start GetBgChrId
GetBgChrId: @ 0x020109DC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7, #4]
	lsls r1, r0, #0x10
	lsrs r0, r1, #0x10
	str r0, [r7, #4]
	ldr r0, [r7]
	bl GetBgChrOffset
	ldr r2, [r7, #4]
	subs r1, r2, r0
	adds r0, r1, #0
	cmp r0, #0
	bge .L02010A00
	adds r0, #0x1f
.L02010A00:
	asrs r1, r0, #5
	adds r0, r1, #0
	b .L02010A06
.L02010A06:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start GetBgTilemapOffset
GetBgTilemapOffset: @ 0x02010A10
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	ldr r1, [r0]
	lsls r0, r1, #0x13
	lsrs r2, r0, #0x1b
	lsls r1, r2, #0x10
	lsrs r0, r1, #0x10
	adds r1, r0, #0
	lsls r2, r1, #0xb
	adds r0, r2, #0
	b .L02010A3C
.L02010A3C:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start SetBgChrOffset
SetBgChrOffset: @ 0x02010A44
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r2, [r7, #4]
	asrs r1, r2, #0xe
	adds r2, r1, #0
	movs r3, #3
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	lsls r1, r2, #2
	ldrb r2, [r0]
	movs r3, #0xf3
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SetBgTilemapOffset
SetBgTilemapOffset: @ 0x02010A88
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #8]
	ldr r0, [r7, #4]
	lsls r1, r0, #0x15
	lsrs r0, r1, #0x15
	cmp r0, #0
	beq .L02010AAE
	b .L02010AE0
.L02010AAE:
	ldr r0, [r7, #8]
	ldr r2, [r7, #4]
	asrs r1, r2, #0xb
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	ldrb r2, [r0, #1]
	movs r3, #0xe0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0, #1]
	ldr r0, .L02010AE8 @ =0x0202CA20
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, [r7, #4]
	movs r2, #0xc0
	lsls r2, r2, #0x13
	orrs r1, r2
	str r1, [r0]
.L02010AE0:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010AE8: .4byte 0x0202CA20

	thumb_func_start SetBgScreenSize
SetBgScreenSize: @ 0x02010AEC
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r2, r1, #0
	lsls r1, r2, #6
	ldrb r2, [r0, #1]
	movs r3, #0x3f
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0, #1]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SetBgBpp
SetBgBpp: @ 0x02010B28
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	bl GetBgCt
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	movs r1, #0
	ldr r2, [r7, #4]
	cmp r2, #8
	bne .L02010B4E
	movs r1, #1
.L02010B4E:
	adds r2, r1, #0
	lsls r1, r2, #7
	ldrb r2, [r0]
	movs r3, #0x7f
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start SyncBgsAndPal
SyncBgsAndPal: @ 0x02010B6C
	push {r7, lr}
	mov r7, sp
	ldr r0, .L02010C24 @ =0x03000000
	ldrb r1, [r0]
	movs r2, #1
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02010B92
	ldr r0, .L02010C28 @ =0x0202AA20
	ldr r2, .L02010C2C @ =0x0202CA20
	ldr r1, [r2]
	movs r2, #0x80
	lsls r2, r2, #2
	bl SwiCpuFastSet
.L02010B92:
	ldr r0, .L02010C24 @ =0x03000000
	ldrb r1, [r0]
	movs r2, #2
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02010BB4
	ldr r0, .L02010C30 @ =0x0202B220
	ldr r2, .L02010C2C @ =0x0202CA20
	ldr r1, [r2, #4]
	movs r2, #0x80
	lsls r2, r2, #2
	bl SwiCpuFastSet
.L02010BB4:
	ldr r0, .L02010C24 @ =0x03000000
	ldrb r1, [r0]
	movs r2, #4
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02010BD6
	ldr r0, .L02010C34 @ =0x0202BA20
	ldr r2, .L02010C2C @ =0x0202CA20
	ldr r1, [r2, #8]
	movs r2, #0x80
	lsls r2, r2, #2
	bl SwiCpuFastSet
.L02010BD6:
	ldr r0, .L02010C24 @ =0x03000000
	ldrb r1, [r0]
	movs r2, #8
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02010BF8
	ldr r0, .L02010C38 @ =0x0202C220
	ldr r2, .L02010C2C @ =0x0202CA20
	ldr r1, [r2, #0xc]
	movs r2, #0x80
	lsls r2, r2, #2
	bl SwiCpuFastSet
.L02010BF8:
	ldr r0, .L02010C24 @ =0x03000000
	movs r1, #0
	strb r1, [r0]
	ldr r0, .L02010C3C @ =0x03000001
	movs r1, #0
	ldrsb r1, [r0, r1]
	cmp r1, #1
	bne .L02010C1C
	ldr r0, .L02010C40 @ =0x0202A620
	movs r1, #0xa0
	lsls r1, r1, #0x13
	movs r2, #0x80
	lsls r2, r2, #1
	bl SwiCpuFastSet
	ldr r0, .L02010C3C @ =0x03000001
	movs r1, #0
	strb r1, [r0]
.L02010C1C:
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010C24: .4byte 0x03000000
.L02010C28: .4byte 0x0202AA20
.L02010C2C: .4byte 0x0202CA20
.L02010C30: .4byte 0x0202B220
.L02010C34: .4byte 0x0202BA20
.L02010C38: .4byte 0x0202C220
.L02010C3C: .4byte 0x03000001
.L02010C40: .4byte 0x0202A620

	thumb_func_start TmFill
TmFill: @ 0x02010C44
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7, #4]
	lsls r0, r1, #0x10
	ldr r1, [r7, #4]
	adds r0, r1, r0
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	str r0, [r7, #8]
	adds r0, r7, #0
	adds r0, #8
	ldr r2, .L02010C70 @ =0x01000200
	ldr r1, [r7]
	bl SwiCpuFastSet
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010C70: .4byte 0x01000200

	thumb_func_start SetBlankChr
SetBlankChr: @ 0x02010C74
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	adds r1, r0, #0
	lsls r0, r1, #5
	movs r2, #0xc0
	lsls r2, r2, #0x13
	adds r1, r0, r2
	movs r0, #0
	movs r2, #0x20
	bl AsyncDataFill
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SetOnVBlank
SetOnVBlank: @ 0x02010C98
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	cmp r0, #0
	beq .L02010CD4
	ldr r0, .L02010CCC @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #8
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	movs r0, #1
	ldr r1, [r7]
	bl SetIrqFunc
	ldr r0, .L02010CD0 @ =0x04000200
	ldr r1, .L02010CD0 @ =0x04000200
	ldrh r2, [r1]
	movs r3, #1
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02010CF0
	.align 2, 0
.L02010CCC: .4byte 0x03000350
.L02010CD0: .4byte 0x04000200
.L02010CD4:
	ldr r0, .L02010CF8 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0xf7
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r0, .L02010CFC @ =0x04000200
	ldr r1, .L02010CFC @ =0x04000200
	ldrh r2, [r1]
	ldr r3, .L02010D00 @ =0x0000FFFE
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	strh r2, [r0]
.L02010CF0:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010CF8: .4byte 0x03000350
.L02010CFC: .4byte 0x04000200
.L02010D00: .4byte 0x0000FFFE

	thumb_func_start SetOnVMatch
SetOnVMatch: @ 0x02010D04
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	cmp r0, #0
	beq .L02010D40
	ldr r0, .L02010D38 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0x20
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	movs r0, #3
	ldr r1, [r7]
	bl SetIrqFunc
	ldr r0, .L02010D3C @ =0x04000200
	ldr r1, .L02010D3C @ =0x04000200
	ldrh r2, [r1]
	movs r3, #4
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02010D68
	.align 2, 0
.L02010D38: .4byte 0x03000350
.L02010D3C: .4byte 0x04000200
.L02010D40:
	ldr r0, .L02010D70 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0xdf
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r0, .L02010D74 @ =0x04000200
	ldr r1, .L02010D74 @ =0x04000200
	ldrh r2, [r1]
	ldr r3, .L02010D78 @ =0x0000FFFB
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02010D70 @ =0x03000350
	ldrb r1, [r0, #5]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #5]
.L02010D68:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010D70: .4byte 0x03000350
.L02010D74: .4byte 0x04000200
.L02010D78: .4byte 0x0000FFFB

	thumb_func_start SetNextVCount
SetNextVCount: @ 0x02010D7C
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	adds r0, r7, #4
	ldr r1, .L02010DC0 @ =0x04000004
	ldrh r2, [r1]
	strh r2, [r0]
	adds r0, r7, #4
	adds r1, r7, #4
	ldrh r2, [r1]
	movs r3, #0xff
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	adds r0, r7, #4
	adds r1, r7, #4
	ldr r3, [r7]
	adds r2, r3, #0
	lsls r3, r2, #8
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r1, r2
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02010DC0 @ =0x04000004
	adds r1, r7, #4
	ldrh r2, [r1]
	strh r2, [r0]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010DC0: .4byte 0x04000004

	thumb_func_start SetVCount
SetVCount: @ 0x02010DC4
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02010DE8 @ =0x03000350
	ldr r2, [r7]
	adds r1, r2, #0
	ldrb r2, [r0, #5]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0, #5]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010DE8: .4byte 0x03000350

	thumb_func_start SetMainFunc
SetMainFunc: @ 0x02010DEC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02010E04 @ =0x0202CA30
	ldr r1, [r7]
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010E04: .4byte 0x0202CA30

	thumb_func_start RunMainFunc
RunMainFunc: @ 0x02010E08
	push {r4, r7, lr}
	mov r7, sp
	ldr r0, .L02010E24 @ =0x0202CA30
	ldr r1, [r0]
	cmp r1, #0
	beq .L02010E1C
	ldr r0, .L02010E24 @ =0x0202CA30
	ldr r4, [r0]
	bl _call_via_r4
.L02010E1C:
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010E24: .4byte 0x0202CA30

	thumb_func_start RefreshKeyStFromKeys
RefreshKeyStFromKeys: @ 0x02010E28
	push {r4, r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	adds r0, r1, #0
	adds r1, r7, #4
	strh r0, [r1]
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r0, #0xa]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1, #4]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0xa]
	ldr r0, [r7]
	adds r1, r7, #4
	ldrh r2, [r0, #4]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #4]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r7]
	ldr r3, [r7]
	ldrh r2, [r2, #4]
	ldrh r3, [r3, #0xa]
	eors r2, r3
	ldr r3, [r7]
	ldrh r3, [r3, #4]
	adds r4, r3, #0
	ands r2, r4
	ldrh r3, [r1, #6]
	movs r4, #0
	ands r3, r4
	adds r4, r3, #0
	adds r3, r2, #0
	orrs r4, r3
	adds r3, r4, #0
	strh r3, [r1, #6]
	adds r1, r2, #0
	movs r2, #0
	bics r1, r2
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #8]
	ldr r0, [r7]
	ldrh r1, [r0, #8]
	cmp r1, #0
	beq .L02010EBC
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r0, #0xc]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1, #4]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0xc]
.L02010EBC:
	ldr r0, [r7]
	ldrh r1, [r0, #0xe]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0xe]
	ldr r0, [r7]
	ldrh r1, [r0, #4]
	cmp r1, #0
	bne .L02010F04
	ldr r0, [r7]
	ldrh r1, [r0, #0xc]
	cmp r1, #0
	beq .L02010F04
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r1, #0xa]
	ldr r3, .L02010F68 @ =0x00000303
	adds r1, r2, #0
	ands r1, r3
	ldrh r0, [r0, #0xc]
	lsls r2, r1, #0x10
	lsrs r1, r2, #0x10
	cmp r0, r1
	bne .L02010F04
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r0, #0xe]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1, #0xa]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0xe]
.L02010F04:
	ldr r0, [r7]
	ldrh r1, [r0, #4]
	cmp r1, #0
	beq .L02010F6C
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r0, [r0, #4]
	ldrh r1, [r1, #0xa]
	cmp r0, r1
	bne .L02010F6C
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldrb r2, [r1, #2]
	subs r1, r2, #1
	ldrb r2, [r0, #2]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0, #2]
	ldr r0, [r7]
	ldrb r1, [r0, #2]
	cmp r1, #0
	bne .L02010F66
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r0, #6]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1, #4]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #6]
	ldr r0, [r7]
	ldr r1, [r7]
	ldrb r2, [r0, #2]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1, #1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0, #2]
.L02010F66:
	b .L02010F82
	.align 2, 0
.L02010F68: .4byte 0x00000303
.L02010F6C:
	ldr r0, [r7]
	ldr r1, [r7]
	ldrb r2, [r0, #2]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0, #2]
.L02010F82:
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r7]
	ldrh r1, [r1, #4]
	ldrh r2, [r2, #0x10]
	eors r1, r2
	ldr r2, [r7]
	ldrh r2, [r2, #4]
	adds r3, r2, #0
	ands r1, r3
	ldrh r2, [r0, #0x10]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x10]
	adds r0, r7, #4
	ldrh r1, [r0]
	ldr r2, .L02010FC8 @ =0x000003F3
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	asrs r0, r1, #0x10
	cmp r0, #0
	beq .L02010FCC
	ldr r0, [r7]
	ldrh r1, [r0, #0x12]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0x12]
	b .L02010FF0
	.align 2, 0
.L02010FC8: .4byte 0x000003F3
.L02010FCC:
	ldr r0, [r7]
	ldrh r1, [r0, #0x12]
	ldr r0, .L02010FF8 @ =0x0000FFFE
	cmp r1, r0
	bhi .L02010FF0
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r1, #0x12]
	adds r1, r2, #1
	ldrh r2, [r0, #0x12]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x12]
.L02010FF0:
	add sp, #8
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02010FF8: .4byte 0x0000FFFE

	thumb_func_start RefreshKeySt
RefreshKeySt: @ 0x02010FFC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02011024 @ =0x04000130
	ldrh r1, [r0]
	mvns r0, r1
	adds r1, r0, #0
	lsls r2, r1, #0x16
	lsrs r0, r2, #0x16
	adds r1, r0, #0
	lsls r0, r1, #0x10
	asrs r1, r0, #0x10
	ldr r0, [r7]
	bl RefreshKeyStFromKeys
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011024: .4byte 0x04000130

	thumb_func_start ClearKeySt
ClearKeySt: @ 0x02011028
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldrh r1, [r0, #8]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, [r7]
	ldrh r1, [r0, #6]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #6]
	ldr r0, [r7]
	ldrh r1, [r0, #4]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #4]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start InitKeySt
InitKeySt: @ 0x0201105C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #0xc
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	ldrb r1, [r0, #1]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #4
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, [r7]
	ldrh r1, [r0, #0xa]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0xa]
	ldr r0, [r7]
	ldrh r1, [r0, #4]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #4]
	ldr r0, [r7]
	ldrh r1, [r0, #8]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, [r7]
	ldrb r1, [r0, #2]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #2]
	ldr r0, [r7]
	ldrh r1, [r0, #0x12]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0x12]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SetBgOffset
SetBgOffset: @ 0x020110D0
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	adds r3, r0, #0
	adds r0, r2, #0
	adds r2, r7, #0
	strh r3, [r2]
	adds r2, r7, #2
	strh r1, [r2]
	adds r1, r7, #4
	strh r0, [r1]
	adds r1, r7, #0
	ldrh r0, [r1]
	cmp r0, #1
	beq .L02011134
	cmp r0, #1
	bgt .L020110F8
	cmp r0, #0
	beq .L02011102
	b .L020111D0
.L020110F8:
	cmp r0, #2
	beq .L02011168
	cmp r0, #3
	beq .L0201119C
	b .L020111D0
.L02011102:
	ldr r0, .L02011130 @ =0x03000350
	adds r1, r7, #2
	ldrh r2, [r0, #0x1c]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x1c]
	ldr r0, .L02011130 @ =0x03000350
	adds r1, r7, #4
	ldrh r2, [r0, #0x1e]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x1e]
	b .L020111D0
	.align 2, 0
.L02011130: .4byte 0x03000350
.L02011134:
	ldr r0, .L02011164 @ =0x03000350
	adds r1, r7, #2
	ldrh r2, [r0, #0x20]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x20]
	ldr r0, .L02011164 @ =0x03000350
	adds r1, r7, #4
	ldrh r2, [r0, #0x22]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x22]
	b .L020111D0
	.align 2, 0
.L02011164: .4byte 0x03000350
.L02011168:
	ldr r0, .L02011198 @ =0x03000350
	adds r1, r7, #2
	ldrh r2, [r0, #0x24]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x24]
	ldr r0, .L02011198 @ =0x03000350
	adds r1, r7, #4
	ldrh r2, [r0, #0x26]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x26]
	b .L020111D0
	.align 2, 0
.L02011198: .4byte 0x03000350
.L0201119C:
	ldr r0, .L020111CC @ =0x03000350
	adds r1, r7, #2
	ldrh r2, [r0, #0x28]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x28]
	ldr r0, .L020111CC @ =0x03000350
	adds r1, r7, #4
	ldrh r2, [r0, #0x2a]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x2a]
	b .L020111D0
	.align 2, 0
.L020111CC: .4byte 0x03000350
.L020111D0:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_020111D8
func_020111D8: @ 0x020111D8
	push {r7, lr}
	mov r7, sp
	ldr r0, .L02011200 @ =0x03000008
	ldr r1, .L02011204 @ =0x03000009
	movs r2, #0
	strb r2, [r1]
	movs r1, #0
	strb r1, [r0]
	ldr r1, .L02011208 @ =0x0202AA20
	adds r0, r1, #0
	movs r1, #0
	bl TmFill
	movs r0, #1
	bl EnableBgSync
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011200: .4byte 0x03000008
.L02011204: .4byte 0x03000009
.L02011208: .4byte 0x0202AA20

	thumb_func_start func_0201120C
func_0201120C: @ 0x0201120C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	adds r2, r0, #0
	adds r0, r1, #0
	adds r1, r7, #0
	strb r2, [r1]
	adds r1, r7, #1
	strb r0, [r1]
	ldr r0, .L02011238 @ =0x03000008
	adds r1, r7, #0
	ldrb r2, [r1]
	strb r2, [r0]
	ldr r0, .L0201123C @ =0x03000009
	adds r1, r7, #1
	ldrb r2, [r1]
	strb r2, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011238: .4byte 0x03000008
.L0201123C: .4byte 0x03000009

	thumb_func_start func_02011240
func_02011240: @ 0x02011240
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, .L02011258 @ =0x0000027F
	str r0, [r7, #8]
.L0201124E:
	ldr r0, [r7, #8]
	cmp r0, #0
	bge .L0201125C
	b .L02011276
	.align 2, 0
.L02011258: .4byte 0x0000027F
.L0201125C:
	ldr r0, [r7]
	adds r1, r7, #4
	ldr r2, [r1]
	ldrh r3, [r2]
	strh r3, [r0]
	adds r2, #2
	str r2, [r1]
	adds r0, #2
	str r0, [r7]
	ldr r0, [r7, #8]
	subs r1, r0, #1
	str r1, [r7, #8]
	b .L0201124E
.L02011276:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_02011280
func_02011280: @ 0x02011280
	push {r4, r5, r7, lr}
	sub sp, #0x18
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	adds r1, r2, #0
	adds r0, r3, #0
	adds r2, r7, #0
	adds r2, #8
	strb r1, [r2]
	adds r1, r7, #0
	adds r1, #9
	strb r0, [r1]
	ldr r0, [r7, #4]
	adds r1, r0, #2
	str r1, [r7, #0xc]
	adds r0, r7, #0
	adds r0, #0x14
	ldr r1, [r7, #4]
	ldr r2, [r1]
	adds r1, r2, #0
	strb r1, [r0]
	adds r0, r7, #0
	adds r0, #0x15
	ldr r1, [r7, #4]
	ldr r2, [r1]
	lsrs r1, r2, #8
	adds r2, r1, #0
	strb r2, [r0]
	adds r0, r7, #0
	adds r0, #0x17
	adds r1, r7, #0
	adds r1, #0x15
	ldrb r2, [r1]
	strb r2, [r0]
.L020112C6:
	adds r0, r7, #0
	adds r0, #0x17
	movs r1, #0
	ldrsb r1, [r0, r1]
	cmp r1, #0
	bge .L020112D4
	b .L02011352
.L020112D4:
	adds r1, r7, #0
	adds r1, #0x17
	movs r0, #0
	ldrsb r0, [r1, r0]
	adds r1, r7, #0
	adds r1, #9
	ldrb r2, [r1]
	lsls r0, r2
	ldr r1, [r7]
	adds r0, r1, r0
	str r0, [r7, #0x10]
	adds r0, r7, #0
	adds r0, #0x16
	adds r1, r7, #0
	adds r1, #0x14
	ldrb r2, [r1]
	strb r2, [r0]
.L020112F6:
	adds r0, r7, #0
	adds r0, #0x16
	movs r1, #0
	ldrsb r1, [r0, r1]
	cmp r1, #0
	bge .L02011304
	b .L0201133C
.L02011304:
	adds r0, r7, #0
	adds r0, #0x10
	ldr r1, [r0]
	adds r2, r7, #0
	adds r2, #0xc
	ldr r3, [r2]
	adds r4, r7, #0
	adds r4, #8
	ldrb r5, [r3]
	ldrb r4, [r4]
	adds r5, r5, r4
	adds r4, r5, #0
	strb r4, [r1]
	adds r3, #1
	str r3, [r2]
	adds r1, #1
	str r1, [r0]
	adds r1, r7, #0
	adds r1, #0x16
	adds r0, r7, #0
	adds r0, #0x16
	adds r1, r7, #0
	adds r1, #0x16
	ldrb r2, [r1]
	subs r1, r2, #1
	adds r2, r1, #0
	strb r2, [r0]
	b .L020112F6
.L0201133C:
	adds r1, r7, #0
	adds r1, #0x17
	adds r0, r7, #0
	adds r0, #0x17
	adds r1, r7, #0
	adds r1, #0x17
	ldrb r2, [r1]
	subs r1, r2, #1
	adds r2, r1, #0
	strb r2, [r0]
	b .L020112C6
.L02011352:
	add sp, #0x18
	pop {r4, r5, r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_0201135C
func_0201135C: @ 0x0201135C
	push {r7, lr}
	sub sp, #0x24
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r0, [r7, #4]
	ldrh r1, [r0]
	movs r2, #0xff
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	asrs r0, r1, #0x10
	str r0, [r7, #0xc]
	ldr r0, [r7, #4]
	movs r2, #0
	ldrsh r1, [r0, r2]
	asrs r0, r1, #8
	adds r1, r0, #0
	movs r2, #0xff
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	asrs r0, r1, #0x10
	str r0, [r7, #0x10]
	movs r0, #0
	str r0, [r7, #0x1c]
	ldr r0, [r7, #4]
	adds r1, r0, #2
	str r1, [r7, #4]
	movs r0, #0
	str r0, [r7, #0x18]
.L020113A0:
	ldr r0, [r7, #0x18]
	ldr r1, [r7, #0x10]
	cmp r0, r1
	blt .L020113AA
	b .L020113F8
.L020113AA:
	ldr r1, [r7, #0x18]
	lsls r0, r1, #5
	adds r1, r0, #0
	lsls r0, r1, #1
	ldr r1, [r7]
	adds r0, r1, r0
	str r0, [r7, #0x20]
	movs r0, #0
	str r0, [r7, #0x14]
.L020113BC:
	ldr r0, [r7, #0x14]
	ldr r1, [r7, #0xc]
	cmp r0, r1
	blt .L020113C6
	b .L020113F0
.L020113C6:
	adds r0, r7, #4
	ldr r1, [r0]
	movs r3, #0
	ldrsh r2, [r1, r3]
	ldr r3, [r7, #0x1c]
	adds r2, r3, r2
	str r2, [r7, #0x1c]
	adds r1, #2
	str r1, [r0]
	adds r0, r7, #0
	adds r0, #0x20
	ldr r1, [r0]
	ldr r3, [r7, #0x1c]
	adds r2, r3, #0
	strh r2, [r1]
	adds r1, #2
	str r1, [r0]
	ldr r0, [r7, #0x14]
	adds r1, r0, #1
	str r1, [r7, #0x14]
	b .L020113BC
.L020113F0:
	ldr r0, [r7, #0x18]
	adds r1, r0, #1
	str r1, [r7, #0x18]
	b .L020113A0
.L020113F8:
	add sp, #0x24
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start ColorFadeInit
ColorFadeInit: @ 0x02011400
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	movs r0, #0x1f
	str r0, [r7]
.L0201140A:
	ldr r0, [r7]
	cmp r0, #0
	bge .L02011412
	b .L02011430
.L02011412:
	ldr r0, .L0201142C @ =0x0202A000
	ldr r1, [r7]
	adds r0, r0, r1
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	subs r1, r0, #1
	str r1, [r7]
	b .L0201140A
	.align 2, 0
.L0201142C: .4byte 0x0202A000
.L02011430:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_02011438
func_02011438: @ 0x02011438
	push {r4, r5, r7, lr}
	sub sp, #0x20
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r0, [r7, #0xc]
	cmp r0, #0
	bge .L02011450
	movs r0, #0x20
	b .L02011452
.L02011450:
	movs r0, #0
.L02011452:
	str r0, [r7, #0x18]
	ldr r0, [r7, #4]
	adds r2, r0, #0
	lsls r1, r2, #1
	adds r1, r1, r0
	lsls r0, r1, #4
	str r0, [r7, #0x1c]
	movs r0, #0
	str r0, [r7, #0x10]
.L02011464:
	ldr r0, [r7, #0x10]
	ldr r1, [r7, #8]
	cmp r0, r1
	blt .L0201146E
	b .L02011554
.L0201146E:
	ldr r0, .L02011498 @ =0x0202A000
	ldr r1, [r7, #4]
	ldr r2, [r7, #0x10]
	adds r1, r1, r2
	adds r0, r0, r1
	ldr r2, [r7, #0xc]
	adds r1, r2, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0]
	movs r0, #0
	str r0, [r7, #0x14]
.L0201148E:
	ldr r0, [r7, #0x14]
	cmp r0, #0xf
	ble .L0201149C
	b .L0201154C
	.align 2, 0
.L02011498: .4byte 0x0202A000
.L0201149C:
	ldr r2, .L02011548 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x1c
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7]
	ldrh r4, [r3]
	adds r3, r4, #0
	movs r4, #0x1f
	ands r3, r4
	ldr r5, [r7, #0x18]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r2, .L02011548 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x1c
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7]
	ldrh r4, [r3]
	lsrs r3, r4, #5
	adds r4, r3, #0
	movs r5, #0x1f
	adds r3, r4, #0
	ands r3, r5
	ldr r5, [r7, #0x18]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r2, .L02011548 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x1c
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7]
	ldrh r4, [r3]
	lsrs r3, r4, #0xa
	adds r4, r3, #0
	movs r5, #0x1f
	adds r3, r4, #0
	ands r3, r5
	ldr r5, [r7, #0x18]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r0, [r7]
	adds r1, r0, #2
	str r1, [r7]
	ldr r0, [r7, #0x14]
	adds r1, r0, #1
	str r1, [r7, #0x14]
	b .L0201148E
	.align 2, 0
.L02011548: .4byte 0x0202A020
.L0201154C:
	ldr r0, [r7, #0x10]
	adds r1, r0, #1
	str r1, [r7, #0x10]
	b .L02011464
.L02011554:
	add sp, #0x20
	pop {r4, r5, r7}
	pop {r0}
	bx r0

	thumb_func_start func_0201155C
func_0201155C: @ 0x0201155C
	push {r4, r5, r7, lr}
	sub sp, #0x20
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r0, [r7]
	adds r1, r0, #0
	lsls r0, r1, #4
	str r0, [r7, #0x18]
	ldr r0, [r7, #0x18]
	adds r1, r0, #0
	lsls r0, r1, #1
	ldr r1, .L0201158C @ =0x0202A620
	adds r0, r1, r0
	str r0, [r7, #0x1c]
	movs r0, #0
	str r0, [r7, #0x10]
.L02011582:
	ldr r0, [r7, #0x10]
	ldr r1, [r7, #4]
	cmp r0, r1
	blt .L02011590
	b .L02011674
	.align 2, 0
.L0201158C: .4byte 0x0202A620
.L02011590:
	ldr r0, .L020115B8 @ =0x0202A000
	ldr r1, [r7]
	ldr r2, [r7, #0x10]
	adds r1, r1, r2
	adds r0, r0, r1
	ldr r2, [r7, #0xc]
	adds r1, r2, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0]
	movs r0, #0
	str r0, [r7, #0x14]
.L020115B0:
	ldr r0, [r7, #0x14]
	cmp r0, #0xf
	ble .L020115BC
	b .L0201166C
	.align 2, 0
.L020115B8: .4byte 0x0202A000
.L020115BC:
	ldr r2, .L02011668 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x18
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7, #0x1c]
	ldrh r4, [r3]
	adds r3, r4, #0
	movs r4, #0x1f
	ands r3, r4
	ldr r5, [r7, #8]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r2, .L02011668 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x18
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7, #0x1c]
	ldrh r4, [r3]
	lsrs r3, r4, #5
	adds r4, r3, #0
	movs r5, #0x1f
	adds r3, r4, #0
	ands r3, r5
	ldr r5, [r7, #8]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r2, .L02011668 @ =0x0202A020
	adds r0, r7, #0
	adds r0, #0x18
	ldr r1, [r0]
	adds r3, r1, #0
	adds r2, r2, r3
	ldr r3, [r7, #0x1c]
	ldrh r4, [r3]
	lsrs r3, r4, #0xa
	adds r4, r3, #0
	movs r5, #0x1f
	adds r3, r4, #0
	ands r3, r5
	ldr r5, [r7, #8]
	adds r4, r5, #0
	adds r5, r3, #0
	adds r3, r4, r5
	ldrb r4, [r2]
	movs r5, #0
	ands r4, r5
	adds r5, r4, #0
	adds r4, r5, #0
	orrs r4, r3
	adds r3, r4, #0
	strb r3, [r2]
	adds r1, #1
	str r1, [r0]
	ldr r0, [r7, #0x1c]
	adds r1, r0, #2
	str r1, [r7, #0x1c]
	ldr r0, [r7, #0x14]
	adds r1, r0, #1
	str r1, [r7, #0x14]
	b .L020115B0
	.align 2, 0
.L02011668: .4byte 0x0202A020
.L0201166C:
	ldr r0, [r7, #0x10]
	adds r1, r0, #1
	str r1, [r7, #0x10]
	b .L02011582
.L02011674:
	add sp, #0x20
	pop {r4, r5, r7}
	pop {r0}
	bx r0

	thumb_func_start func_0201167C
func_0201167C: @ 0x0201167C
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r0, [r7]
	str r0, [r7, #0xc]
.L0201168C:
	ldr r0, [r7]
	ldr r1, [r7, #4]
	adds r0, r0, r1
	ldr r1, [r7, #0xc]
	cmp r1, r0
	blt .L0201169A
	b .L020116C0
.L0201169A:
	ldr r0, .L020116BC @ =0x0202A000
	ldr r1, [r7, #0xc]
	adds r0, r0, r1
	ldr r2, [r7, #8]
	adds r1, r2, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
	b .L0201168C
	.align 2, 0
.L020116BC: .4byte 0x0202A000
.L020116C0:
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_020116C8
func_020116C8: @ 0x020116C8
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	adds r1, r7, #0
	strb r0, [r1]
	movs r0, #0x1f
	str r0, [r7, #4]
.L020116D6:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L020116DE
	b .L020117F8
.L020116DE:
	ldr r0, .L02011704 @ =0x0202A000
	ldr r1, [r7, #4]
	adds r0, r0, r1
	adds r1, r7, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	movs r0, #0
	str r0, [r7, #8]
.L020116FC:
	ldr r0, [r7, #8]
	cmp r0, #0xf
	ble .L02011708
	b .L020117F0
	.align 2, 0
.L02011704: .4byte 0x0202A000
.L02011708:
	ldr r0, .L020117E8 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r0, r0, r2
	ldr r1, .L020117EC @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	adds r1, r2, #0
	movs r2, #0x1f
	ands r1, r2
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L020117E8 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #1
	adds r0, r0, r1
	ldr r1, .L020117EC @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #5
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L020117E8 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L020117EC @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #0xa
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L020116FC
	.align 2, 0
.L020117E8: .4byte 0x0202A020
.L020117EC: .4byte 0x0202A620
.L020117F0:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L020116D6
.L020117F8:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_02011800
func_02011800: @ 0x02011800
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	adds r1, r7, #0
	strb r0, [r1]
	movs r0, #0x1f
	str r0, [r7, #4]
.L0201180E:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02011816
	b .L02011920
.L02011816:
	ldr r0, .L0201183C @ =0x0202A000
	ldr r1, [r7, #4]
	adds r0, r0, r1
	adds r1, r7, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	movs r0, #0
	str r0, [r7, #8]
.L02011834:
	ldr r0, [r7, #8]
	cmp r0, #0xf
	ble .L02011840
	b .L02011918
	.align 2, 0
.L0201183C: .4byte 0x0202A000
.L02011840:
	ldr r0, .L02011910 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r0, r0, r2
	ldr r1, .L02011914 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	adds r1, r2, #0
	movs r2, #0x1f
	ands r1, r2
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011910 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #1
	adds r0, r0, r1
	ldr r1, .L02011914 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #5
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011910 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L02011914 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #0xa
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L02011834
	.align 2, 0
.L02011910: .4byte 0x0202A020
.L02011914: .4byte 0x0202A620
.L02011918:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L0201180E
.L02011920:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_02011928
func_02011928: @ 0x02011928
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	adds r1, r7, #0
	strb r0, [r1]
	movs r0, #0x1f
	str r0, [r7, #4]
.L02011936:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L0201193E
	b .L02011A58
.L0201193E:
	ldr r0, .L02011964 @ =0x0202A000
	ldr r1, [r7, #4]
	adds r0, r0, r1
	adds r1, r7, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	movs r0, #0
	str r0, [r7, #8]
.L0201195C:
	ldr r0, [r7, #8]
	cmp r0, #0xf
	ble .L02011968
	b .L02011A50
	.align 2, 0
.L02011964: .4byte 0x0202A000
.L02011968:
	ldr r0, .L02011A48 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r0, r0, r2
	ldr r1, .L02011A4C @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	adds r1, r2, #0
	movs r2, #0x1f
	ands r1, r2
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011A48 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #1
	adds r0, r0, r1
	ldr r1, .L02011A4C @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #5
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011A48 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L02011A4C @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #0xa
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x20
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L0201195C
	.align 2, 0
.L02011A48: .4byte 0x0202A020
.L02011A4C: .4byte 0x0202A620
.L02011A50:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L02011936
.L02011A58:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start func_02011A60
func_02011A60: @ 0x02011A60
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	adds r1, r7, #0
	strb r0, [r1]
	movs r0, #0x1f
	str r0, [r7, #4]
.L02011A6E:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02011A76
	b .L02011B90
.L02011A76:
	ldr r0, .L02011A9C @ =0x0202A000
	ldr r1, [r7, #4]
	adds r0, r0, r1
	adds r1, r7, #0
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	movs r0, #0
	str r0, [r7, #8]
.L02011A94:
	ldr r0, [r7, #8]
	cmp r0, #0xf
	ble .L02011AA0
	b .L02011B88
	.align 2, 0
.L02011A9C: .4byte 0x0202A000
.L02011AA0:
	ldr r0, .L02011B80 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r0, r0, r2
	ldr r1, .L02011B84 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	adds r1, r2, #0
	movs r2, #0x1f
	ands r1, r2
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x40
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011B80 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #1
	adds r0, r0, r1
	ldr r1, .L02011B84 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #5
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x40
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011B80 @ =0x0202A020
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L02011B84 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r3, r2, #0
	lsls r2, r3, #4
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r3, r2, #0
	lsls r2, r3, #1
	adds r1, r1, r2
	ldrh r2, [r1]
	lsrs r1, r2, #0xa
	adds r2, r1, #0
	movs r3, #0x1f
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	adds r1, r2, #0
	adds r1, #0x40
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L02011A94
	.align 2, 0
.L02011B80: .4byte 0x0202A020
.L02011B84: .4byte 0x0202A620
.L02011B88:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L02011A6E
.L02011B90:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start ColorFadeTick2
ColorFadeTick2: @ 0x02011B98
	push {r4, r7, lr}
	sub sp, #0x14
	mov r7, sp
	movs r0, #0x1f
	str r0, [r7]
.L02011BA2:
	ldr r0, [r7]
	cmp r0, #0
	bge .L02011BAA
	b .L02011DA4
.L02011BAA:
	ldr r0, .L02011BBC @ =0x0202A000
	ldr r1, [r7]
	adds r0, r0, r1
	movs r1, #0
	ldrsb r1, [r0, r1]
	cmp r1, #0
	bne .L02011BC0
	b .L02011D9C
	.align 2, 0
.L02011BBC: .4byte 0x0202A000
.L02011BC0:
	movs r0, #0xf
	str r0, [r7, #4]
.L02011BC4:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02011BCC
	b .L02011D9C
.L02011BCC:
	ldr r0, [r7]
	adds r1, r0, #0
	lsls r0, r1, #4
	ldr r1, [r7, #4]
	adds r0, r0, r1
	str r0, [r7, #0x10]
	ldr r0, .L02011D90 @ =0x0202A020
	ldr r1, [r7, #0x10]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r0, r0, r2
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r1, r1, r3
	ldr r2, .L02011D94 @ =0x0202A000
	ldr r3, [r7]
	adds r2, r2, r3
	ldrb r1, [r1]
	ldrb r2, [r2]
	adds r1, r1, r2
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011D90 @ =0x0202A020
	ldr r1, [r7, #0x10]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #1
	adds r0, r0, r1
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r2, r3, #1
	adds r1, r1, r2
	ldr r2, .L02011D94 @ =0x0202A000
	ldr r3, [r7]
	adds r2, r2, r3
	ldrb r1, [r1]
	ldrb r2, [r2]
	adds r1, r1, r2
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, .L02011D90 @ =0x0202A020
	ldr r1, [r7, #0x10]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	adds r1, r2, #2
	adds r0, r0, r1
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r2, r3, #2
	adds r1, r1, r2
	ldr r2, .L02011D94 @ =0x0202A000
	ldr r3, [r7]
	adds r2, r2, r3
	ldrb r1, [r1]
	ldrb r2, [r2]
	adds r1, r1, r2
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	adds r0, r7, #0
	adds r0, #8
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r1, r1, r3
	movs r2, #0
	ldrsb r2, [r1, r2]
	adds r1, r2, #0
	adds r2, r1, #0
	subs r2, #0x20
	adds r1, r2, #0
	strh r1, [r0]
	adds r0, r7, #0
	adds r0, #8
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0x1f
	ble .L02011CAE
	adds r0, r7, #0
	adds r0, #8
	movs r1, #0x1f
	strh r1, [r0]
.L02011CAE:
	adds r0, r7, #0
	adds r0, #8
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0
	bge .L02011CC2
	adds r0, r7, #0
	adds r0, #8
	movs r1, #0
	strh r1, [r0]
.L02011CC2:
	adds r0, r7, #0
	adds r0, #0xa
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r2, r3, #1
	adds r1, r1, r2
	movs r2, #0
	ldrsb r2, [r1, r2]
	adds r1, r2, #0
	adds r2, r1, #0
	subs r2, #0x20
	adds r1, r2, #0
	strh r1, [r0]
	adds r0, r7, #0
	adds r0, #0xa
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0x1f
	ble .L02011CF6
	adds r0, r7, #0
	adds r0, #0xa
	movs r1, #0x1f
	strh r1, [r0]
.L02011CF6:
	adds r0, r7, #0
	adds r0, #0xa
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0
	bge .L02011D0A
	adds r0, r7, #0
	adds r0, #0xa
	movs r1, #0
	strh r1, [r0]
.L02011D0A:
	adds r0, r7, #0
	adds r0, #0xc
	ldr r1, .L02011D90 @ =0x0202A020
	ldr r2, [r7, #0x10]
	adds r4, r2, #0
	lsls r3, r4, #1
	adds r3, r3, r2
	adds r2, r3, #2
	adds r1, r1, r2
	movs r2, #0
	ldrsb r2, [r1, r2]
	adds r1, r2, #0
	adds r2, r1, #0
	subs r2, #0x20
	adds r1, r2, #0
	strh r1, [r0]
	adds r0, r7, #0
	adds r0, #0xc
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0x1f
	ble .L02011D3E
	adds r0, r7, #0
	adds r0, #0xc
	movs r1, #0x1f
	strh r1, [r0]
.L02011D3E:
	adds r0, r7, #0
	adds r0, #0xc
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0
	bge .L02011D52
	adds r0, r7, #0
	adds r0, #0xc
	movs r1, #0
	strh r1, [r0]
.L02011D52:
	ldr r0, .L02011D98 @ =0x0202A620
	ldr r1, [r7, #0x10]
	adds r2, r1, #0
	lsls r1, r2, #1
	adds r0, r0, r1
	adds r1, r7, #0
	adds r1, #0xc
	ldrh r2, [r1]
	lsls r1, r2, #0xa
	adds r2, r7, #0
	adds r2, #0xa
	ldrh r3, [r2]
	lsls r2, r3, #5
	adds r1, r1, r2
	adds r2, r7, #0
	adds r2, #8
	ldrh r2, [r2]
	adds r1, r1, r2
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L02011BC4
	.align 2, 0
.L02011D90: .4byte 0x0202A020
.L02011D94: .4byte 0x0202A000
.L02011D98: .4byte 0x0202A620
.L02011D9C:
	ldr r0, [r7]
	subs r1, r0, #1
	str r1, [r7]
	b .L02011BA2
.L02011DA4:
	bl EnablePalSync
	add sp, #0x14
	pop {r4, r7}
	pop {r0}
	bx r0

	thumb_func_start InitBgs
InitBgs: @ 0x02011DB0
	push {r7, lr}
	sub sp, #0x20
	mov r7, sp
	str r0, [r7]
	adds r0, r7, #4
	adds r1, r7, #4
	ldr r2, .L02011E70 @ =.L02017150
	adds r0, r1, #0
	adds r1, r2, #0
	movs r2, #0x18
	bl memcpy
	ldr r0, [r7]
	cmp r0, #0
	bne .L02011DD2
	adds r0, r7, #4
	str r0, [r7]
.L02011DD2:
	ldr r0, .L02011E74 @ =0x0300035C
	movs r1, #0
	strh r1, [r0]
	ldr r0, .L02011E78 @ =0x03000360
	movs r1, #0
	strh r1, [r0]
	ldr r0, .L02011E7C @ =0x03000364
	movs r1, #0
	strh r1, [r0]
	ldr r0, .L02011E80 @ =0x03000368
	movs r1, #0
	strh r1, [r0]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0]
	movs r2, #0x7f
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0]
	movs r2, #0xf8
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #1
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #2
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #4
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #8
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #0x10
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #0xdf
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #0xbf
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	ldr r0, .L02011E84 @ =0x03000350
	ldrb r1, [r0, #1]
	movs r2, #0x7f
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #1]
	movs r0, #0
	str r0, [r7, #0x1c]
.L02011E66:
	ldr r0, [r7, #0x1c]
	cmp r0, #3
	ble .L02011E88
	b .L02011EDE
	.align 2, 0
.L02011E70: .4byte .L02017150
.L02011E74: .4byte 0x0300035C
.L02011E78: .4byte 0x03000360
.L02011E7C: .4byte 0x03000364
.L02011E80: .4byte 0x03000368
.L02011E84: .4byte 0x03000350
.L02011E88:
	ldr r0, [r7, #0x1c]
	ldr r2, [r7]
	ldrh r1, [r2]
	adds r2, #2
	str r2, [r7]
	bl SetBgChrOffset
	ldr r0, [r7, #0x1c]
	ldr r2, [r7]
	ldrh r1, [r2]
	adds r2, #2
	str r2, [r7]
	bl SetBgTilemapOffset
	ldr r0, [r7, #0x1c]
	ldr r2, [r7]
	ldrh r1, [r2]
	adds r2, #2
	str r2, [r7]
	bl SetBgScreenSize
	ldr r1, [r7, #0x1c]
	adds r0, r1, #0
	lsls r2, r0, #0x10
	lsrs r1, r2, #0x10
	adds r0, r1, #0
	movs r1, #0
	movs r2, #0
	bl SetBgOffset
	ldr r1, [r7, #0x1c]
	adds r0, r1, #0
	bl GetBgTilemap
	adds r1, r0, #0
	adds r0, r1, #0
	movs r1, #0
	bl TmFill
	ldr r0, [r7, #0x1c]
	adds r1, r0, #1
	str r1, [r7, #0x1c]
	b .L02011E66
.L02011EDE:
	movs r0, #0xf
	bl EnableBgSync
	movs r0, #0
	bl InitOam
	ldr r0, .L02011F04 @ =0x0202A620
	ldrh r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0]
	bl EnablePalSync
	add sp, #0x20
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011F04: .4byte 0x0202A620

	thumb_func_start GetBgTilemap
GetBgTilemap: @ 0x02011F08
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02011F20 @ =.L02017CEC
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, [r0]
	adds r0, r1, #0
	b .L02011F24
	.align 2, 0
.L02011F20: .4byte .L02017CEC
.L02011F24:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start SoftResetIfKeyCombo
SoftResetIfKeyCombo: @ 0x02011F2C
	push {r7, lr}
	mov r7, sp
	ldr r1, .L02011F48 @ =gKeySt
	ldr r0, [r1]
	ldrh r1, [r0, #4]
	cmp r1, #0xf
	bne .L02011F40
	movs r0, #0xff
	bl SwiSoftReset
.L02011F40:
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011F48: .4byte gKeySt

	thumb_func_start func_02011F4C
func_02011F4C: @ 0x02011F4C
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	adds r0, r7, #4
	ldr r1, .L02011FBC @ =0x04000200
	ldrh r2, [r1]
	strh r2, [r0]
	ldr r0, .L02011FC0 @ =0x04000132
	ldr r2, [r7]
	adds r1, r2, #0
	ldr r3, .L02011FC4 @ =0xFFFFC000
	adds r2, r1, r3
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L02011FBC @ =0x04000200
	ldr r1, .L02011FBC @ =0x04000200
	ldrh r2, [r1]
	ldr r3, .L02011FC8 @ =0x0000DF7F
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02011FBC @ =0x04000200
	ldr r1, .L02011FBC @ =0x04000200
	ldrh r2, [r1]
	movs r3, #0x80
	lsls r3, r3, #5
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	movs r0, #0x80
	lsls r0, r0, #0x13
	movs r1, #0x80
	lsls r1, r1, #0x13
	ldrh r2, [r1]
	movs r3, #0x80
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	bl SwiSoundBiasReset
	svc #3
	bl SwiSoundBiasSet
	ldr r0, .L02011FBC @ =0x04000200
	adds r1, r7, #4
	ldrh r2, [r1]
	strh r2, [r0]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011FBC: .4byte 0x04000200
.L02011FC0: .4byte 0x04000132
.L02011FC4: .4byte 0xFFFFC000
.L02011FC8: .4byte 0x0000DF7F

	thumb_func_start OnHBlankBoth
OnHBlankBoth: @ 0x02011FCC
	push {r4, r7, lr}
	mov r7, sp
	ldr r0, .L02011FF8 @ =0x030003FC
	ldr r1, [r0]
	cmp r1, #0
	beq .L02011FE0
	ldr r0, .L02011FF8 @ =0x030003FC
	ldr r4, [r0]
	bl _call_via_r4
.L02011FE0:
	ldr r0, .L02011FFC @ =0x03000A04
	ldr r1, [r0]
	cmp r1, #0
	beq .L02011FF0
	ldr r0, .L02011FFC @ =0x03000A04
	ldr r4, [r0]
	bl _call_via_r4
.L02011FF0:
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02011FF8: .4byte 0x030003FC
.L02011FFC: .4byte 0x03000A04

	thumb_func_start RefreshOnHBlank
RefreshOnHBlank: @ 0x02012000
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	movs r0, #0
	str r0, [r7]
	ldr r0, .L02012038 @ =0x030003FC
	ldr r1, [r0]
	cmp r1, #0
	beq .L02012018
	ldr r0, [r7]
	adds r1, r0, #1
	str r1, [r7]
.L02012018:
	ldr r0, .L0201203C @ =0x03000A04
	ldr r1, [r0]
	cmp r1, #0
	beq .L02012026
	ldr r0, [r7]
	adds r1, r0, #2
	str r1, [r7]
.L02012026:
	ldr r0, [r7]
	cmp r0, #1
	beq .L02012074
	cmp r0, #1
	bgt .L02012040
	cmp r0, #0
	beq .L0201204A
	b .L02012110
	.align 2, 0
.L02012038: .4byte 0x030003FC
.L0201203C: .4byte 0x03000A04
.L02012040:
	cmp r0, #2
	beq .L020120A8
	cmp r0, #3
	beq .L020120DC
	b .L02012110
.L0201204A:
	ldr r0, .L02012068 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0xef
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r0, .L0201206C @ =0x04000200
	ldr r1, .L0201206C @ =0x04000200
	ldrh r2, [r1]
	ldr r3, .L02012070 @ =0x0000FFFD
	adds r1, r2, #0
	ands r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02012110
	.align 2, 0
.L02012068: .4byte 0x03000350
.L0201206C: .4byte 0x04000200
.L02012070: .4byte 0x0000FFFD
.L02012074:
	ldr r0, .L0201209C @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0x10
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r0, .L020120A0 @ =0x030003FC
	ldr r1, [r0]
	movs r0, #2
	bl SetIrqFunc
	ldr r0, .L020120A4 @ =0x04000200
	ldr r1, .L020120A4 @ =0x04000200
	ldrh r2, [r1]
	movs r3, #2
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02012110
	.align 2, 0
.L0201209C: .4byte 0x03000350
.L020120A0: .4byte 0x030003FC
.L020120A4: .4byte 0x04000200
.L020120A8:
	ldr r0, .L020120D0 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0x10
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r0, .L020120D4 @ =0x03000A04
	ldr r1, [r0]
	movs r0, #2
	bl SetIrqFunc
	ldr r0, .L020120D8 @ =0x04000200
	ldr r1, .L020120D8 @ =0x04000200
	ldrh r2, [r1]
	movs r3, #2
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02012110
	.align 2, 0
.L020120D0: .4byte 0x03000350
.L020120D4: .4byte 0x03000A04
.L020120D8: .4byte 0x04000200
.L020120DC:
	ldr r0, .L02012104 @ =0x03000350
	ldrb r1, [r0, #4]
	movs r2, #0x10
	orrs r1, r2
	adds r2, r1, #0
	strb r2, [r0, #4]
	ldr r1, .L02012108 @ =OnHBlankBoth
	movs r0, #2
	bl SetIrqFunc
	ldr r0, .L0201210C @ =0x04000200
	ldr r1, .L0201210C @ =0x04000200
	ldrh r2, [r1]
	movs r3, #2
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	b .L02012110
	.align 2, 0
.L02012104: .4byte 0x03000350
.L02012108: .4byte OnHBlankBoth
.L0201210C: .4byte 0x04000200
.L02012110:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SetOnHBlankA
SetOnHBlankA: @ 0x02012118
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012134 @ =0x030003FC
	ldr r1, [r7]
	str r1, [r0]
	bl RefreshOnHBlank
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012134: .4byte 0x030003FC

	thumb_func_start SetOnHBlankB
SetOnHBlankB: @ 0x02012138
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012154 @ =0x03000A04
	ldr r1, [r7]
	str r1, [r0]
	bl RefreshOnHBlank
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012154: .4byte 0x03000A04

	thumb_func_start ClearAsyncDataList
ClearAsyncDataList: @ 0x02012158
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r0, .L02012178 @ =0x0202CA4C
	movs r1, #0
	str r1, [r0]
	ldr r0, .L02012178 @ =0x0202CA4C
	movs r1, #0
	str r1, [r0, #4]
	movs r0, #0
	str r0, [r7]
.L0201216E:
	ldr r0, [r7]
	cmp r0, #0x1f
	ble .L0201217C
	b .L020121E0
	.align 2, 0
.L02012178: .4byte 0x0202CA4C
.L0201217C:
	ldr r0, .L020121DC @ =0x0202CA54
	ldr r1, [r7]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	lsls r1, r2, #2
	adds r0, r0, r1
	movs r1, #0
	str r1, [r0]
	ldr r0, .L020121DC @ =0x0202CA54
	ldr r1, [r7]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	lsls r1, r2, #2
	adds r0, #4
	adds r1, r0, r1
	movs r0, #0
	str r0, [r1]
	ldr r0, .L020121DC @ =0x0202CA54
	ldr r1, [r7]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	lsls r1, r2, #2
	adds r0, r0, r1
	ldrh r1, [r0, #8]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, .L020121DC @ =0x0202CA54
	ldr r1, [r7]
	adds r3, r1, #0
	lsls r2, r3, #1
	adds r2, r2, r1
	lsls r1, r2, #2
	adds r0, r0, r1
	ldrh r1, [r0, #0xa]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0xa]
	ldr r0, [r7]
	adds r1, r0, #1
	str r1, [r7]
	b .L0201216E
	.align 2, 0
.L020121DC: .4byte 0x0202CA54
.L020121E0:
	ldr r0, .L020121F0 @ =0x0202CA54
	movs r1, #0
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020121F0: .4byte 0x0202CA54

	thumb_func_start AsyncDataMove
AsyncDataMove: @ 0x020121F4
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r1, .L02012270 @ =0x0202CA4C
	ldr r0, [r1]
	adds r2, r0, #0
	lsls r1, r2, #1
	adds r1, r1, r0
	lsls r0, r1, #2
	ldr r1, .L02012274 @ =0x0202CA54
	adds r0, r1, r0
	str r0, [r7, #0xc]
	ldr r0, [r7, #0xc]
	ldr r1, [r7]
	str r1, [r0]
	ldr r0, [r7, #0xc]
	ldr r1, [r7, #4]
	str r1, [r0, #4]
	ldr r0, [r7, #0xc]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, [r7, #0xc]
	movs r1, #0
	ldr r2, [r7, #8]
	movs r3, #0x1f
	ands r2, r3
	cmp r2, #0
	bne .L02012242
	movs r1, #1
.L02012242:
	ldrh r2, [r0, #0xa]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #0xa]
	ldr r0, .L02012270 @ =0x0202CA4C
	ldr r1, .L02012270 @ =0x0202CA4C
	ldr r2, [r1, #4]
	ldr r1, [r7, #8]
	adds r2, r2, r1
	str r2, [r0, #4]
	ldr r1, .L02012270 @ =0x0202CA4C
	ldr r0, .L02012270 @ =0x0202CA4C
	ldr r1, .L02012270 @ =0x0202CA4C
	ldr r2, [r1]
	adds r1, r2, #1
	str r1, [r0]
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012270: .4byte 0x0202CA4C
.L02012274: .4byte 0x0202CA54

	thumb_func_start AsyncDataFill
AsyncDataFill: @ 0x02012278
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r1, .L020122EC @ =0x0202CA4C
	ldr r0, [r1]
	adds r2, r0, #0
	lsls r1, r2, #1
	adds r1, r1, r0
	lsls r0, r1, #2
	ldr r1, .L020122F0 @ =0x0202CA54
	adds r0, r1, r0
	str r0, [r7, #0xc]
	ldr r0, [r7, #0xc]
	ldr r1, [r7]
	str r1, [r0]
	ldr r0, [r7, #0xc]
	ldr r1, [r7, #4]
	str r1, [r0, #4]
	ldr r0, [r7, #0xc]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, [r7, #0xc]
	ldrh r1, [r0, #0xa]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #2
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #0xa]
	ldr r0, .L020122EC @ =0x0202CA4C
	ldr r1, .L020122EC @ =0x0202CA4C
	ldr r2, [r1, #4]
	ldr r1, [r7, #8]
	adds r2, r2, r1
	str r2, [r0, #4]
	ldr r1, .L020122EC @ =0x0202CA4C
	ldr r0, .L020122EC @ =0x0202CA4C
	ldr r1, .L020122EC @ =0x0202CA4C
	ldr r2, [r1]
	adds r1, r2, #1
	str r1, [r0]
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020122EC: .4byte 0x0202CA4C
.L020122F0: .4byte 0x0202CA54

	thumb_func_start ApplySyncData
ApplySyncData: @ 0x020122F4
	push {r4, r7, lr}
	sub sp, #0xc
	mov r7, sp
	ldr r0, .L02012310 @ =0x0202CA54
	str r0, [r7]
	movs r0, #0
	str r0, [r7, #4]
.L02012302:
	ldr r0, .L02012314 @ =0x0202CA4C
	ldr r1, [r7, #4]
	ldr r0, [r0]
	cmp r1, r0
	blt .L02012318
	b .L0201239A
	.align 2, 0
.L02012310: .4byte 0x0202CA54
.L02012314: .4byte 0x0202CA4C
.L02012318:
	ldr r1, [r7]
	ldrh r0, [r1, #0xa]
	cmp r0, #1
	beq .L0201234A
	cmp r0, #1
	bgt .L0201232A
	cmp r0, #0
	beq .L02012330
	b .L0201238A
.L0201232A:
	cmp r0, #2
	beq .L02012364
	b .L0201238A
.L02012330:
	ldr r1, [r7]
	ldr r0, [r1]
	ldr r2, [r7]
	ldr r1, [r2, #4]
	ldr r2, [r7]
	ldrh r3, [r2, #8]
	lsrs r2, r3, #1
	adds r4, r2, #0
	lsls r3, r4, #0x10
	lsrs r2, r3, #0x10
	bl SwiCpuSet
	b .L0201238A
.L0201234A:
	ldr r1, [r7]
	ldr r0, [r1]
	ldr r2, [r7]
	ldr r1, [r2, #4]
	ldr r2, [r7]
	ldrh r3, [r2, #8]
	lsrs r2, r3, #2
	adds r4, r2, #0
	lsls r3, r4, #0x10
	lsrs r2, r3, #0x10
	bl SwiCpuFastSet
	b .L0201238A
.L02012364:
	ldr r0, [r7]
	ldr r1, [r0]
	str r1, [r7, #8]
	adds r0, r7, #0
	adds r0, #8
	ldr r2, [r7]
	ldr r1, [r2, #4]
	ldr r2, [r7]
	ldrh r3, [r2, #8]
	lsrs r2, r3, #2
	adds r4, r2, #0
	lsls r3, r4, #0x10
	lsrs r2, r3, #0x10
	movs r3, #0x80
	lsls r3, r3, #0x11
	orrs r2, r3
	bl SwiCpuFastSet
	b .L0201238A
.L0201238A:
	ldr r0, [r7]
	adds r1, r0, #0
	adds r1, #0xc
	str r1, [r7]
	ldr r0, [r7, #4]
	adds r1, r0, #1
	str r1, [r7, #4]
	b .L02012302
.L0201239A:
	bl ClearAsyncDataList
	add sp, #0xc
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start InitOam
InitOam: @ 0x020123A8
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012438 @ =0x03000020
	ldr r1, .L0201243C @ =0x03000400
	str r1, [r0]
	ldr r0, .L02012438 @ =0x03000020
	movs r1, #0xe0
	lsls r1, r1, #0x13
	str r1, [r0, #4]
	ldr r0, .L02012438 @ =0x03000020
	ldrh r1, [r0, #8]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r0, .L02012438 @ =0x03000020
	ldr r2, [r7]
	adds r1, r2, #0
	ldrh r2, [r0, #0xa]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #0xa]
	ldr r0, .L02012440 @ =0x03000010
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #3
	ldr r2, .L0201243C @ =0x03000400
	adds r1, r2, r1
	str r1, [r0]
	ldr r0, .L02012440 @ =0x03000010
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #3
	movs r3, #0xe0
	lsls r3, r3, #0x13
	adds r2, r1, r3
	str r2, [r0, #4]
	ldr r0, .L02012440 @ =0x03000010
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #3
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #8]
	ldr r0, .L02012440 @ =0x03000010
	ldr r2, [r7]
	adds r1, r2, #0
	movs r2, #0x80
	subs r1, r2, r1
	ldrh r2, [r0, #0xa]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0xa]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012438: .4byte 0x03000020
.L0201243C: .4byte 0x03000400
.L02012440: .4byte 0x03000010

	thumb_func_start GetOamSplice
GetOamSplice: @ 0x02012444
	push {r7, lr}
	mov r7, sp
	ldr r0, .L02012450 @ =0x03000020
	ldrh r1, [r0, #0xa]
	adds r0, r1, #0
	b .L02012454
	.align 2, 0
.L02012450: .4byte 0x03000020
.L02012454:
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start SyncHiOam
SyncHiOam: @ 0x0201245C
	push {r4, r7, lr}
	mov r7, sp
	ldr r1, .L020124A0 @ =0x03000010
	ldr r0, [r1]
	ldr r2, .L020124A0 @ =0x03000010
	ldr r1, [r2, #4]
	ldr r2, .L020124A0 @ =0x03000010
	ldrh r3, [r2, #0xa]
	adds r2, r3, #0
	lsls r3, r2, #1
	lsls r4, r3, #0xb
	lsrs r2, r4, #0xb
	bl SwiCpuFastSet
	ldr r1, .L020124A0 @ =0x03000010
	ldr r0, [r1]
	ldr r1, .L020124A0 @ =0x03000010
	ldrh r2, [r1, #0xa]
	adds r1, r2, #0
	bl ClearOam_thm
	ldr r0, .L020124A4 @ =0x03000A00
	ldr r1, .L020124A0 @ =0x03000010
	ldr r2, [r1]
	str r2, [r0]
	ldr r0, .L020124A8 @ =0x03001414
	ldr r1, .L020124AC @ =0x03000400
	str r1, [r0]
	ldr r0, .L020124B0 @ =0x030003F4
	movs r1, #0
	strh r1, [r0]
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020124A0: .4byte 0x03000010
.L020124A4: .4byte 0x03000A00
.L020124A8: .4byte 0x03001414
.L020124AC: .4byte 0x03000400
.L020124B0: .4byte 0x030003F4

	thumb_func_start SyncLoOam
SyncLoOam: @ 0x020124B4
	push {r4, r7, lr}
	mov r7, sp
	ldr r0, .L020124C4 @ =0x03000020
	ldrh r1, [r0, #0xa]
	cmp r1, #0
	bne .L020124C8
	b .L020124F6
	.align 2, 0
.L020124C4: .4byte 0x03000020
.L020124C8:
	ldr r1, .L020124FC @ =0x03000020
	ldr r0, [r1]
	ldr r2, .L020124FC @ =0x03000020
	ldr r1, [r2, #4]
	ldr r2, .L020124FC @ =0x03000020
	ldrh r3, [r2, #0xa]
	adds r2, r3, #0
	lsls r3, r2, #1
	lsls r4, r3, #0xb
	lsrs r2, r4, #0xb
	bl SwiCpuFastSet
	ldr r1, .L020124FC @ =0x03000020
	ldr r0, [r1]
	ldr r1, .L020124FC @ =0x03000020
	ldrh r2, [r1, #0xa]
	adds r1, r2, #0
	bl ClearOam_thm
	ldr r0, .L02012500 @ =0x03000340
	ldr r1, .L020124FC @ =0x03000020
	ldr r2, [r1]
	str r2, [r0]
.L020124F6:
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020124FC: .4byte 0x03000020
.L02012500: .4byte 0x03000340

	thumb_func_start SetObjAffine
SetObjAffine: @ 0x02012504
	push {r4, r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	adds r4, r1, #0
	adds r1, r3, #0
	ldr r0, [r7, #0x18]
	adds r3, r7, #4
	strh r4, [r3]
	adds r3, r7, #6
	strh r2, [r3]
	adds r2, r7, #0
	adds r2, #8
	strh r1, [r2]
	adds r1, r7, #0
	adds r1, #0xa
	strh r0, [r1]
	ldr r0, .L020125C8 @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #3
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #4
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L020125C8 @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #7
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #6
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L020125C8 @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #0
	adds r2, #0xb
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #0
	adds r1, #8
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L020125C8 @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #0
	adds r2, #0xf
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #0
	adds r1, #0xa
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	add sp, #0xc
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020125C8: .4byte 0x03000400

	thumb_func_start PutUnkSprite
PutUnkSprite: @ 0x020125CC
	push {r4, r7, lr}
	sub sp, #0x14
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
.L020125D8:
	b .L020125DC
.L020125DA:
	b .L02012650
.L020125DC:
	ldr r0, [r7]
	ldr r1, [r0]
	cmp r1, #1
	beq .L020125F8
	ldr r0, .L020125F0 @ =0x03000A00
	ldr r1, [r0]
	ldr r0, .L020125F4 @ =0x03000500
	cmp r1, r0
	bhs .L020125F8
	b .L020125FA
	.align 2, 0
.L020125F0: .4byte 0x03000A00
.L020125F4: .4byte 0x03000500
.L020125F8:
	b .L02012650
.L020125FA:
	ldr r0, [r7]
	movs r2, #6
	ldrsh r1, [r0, r2]
	ldr r2, [r7, #4]
	adds r0, r1, r2
	lsls r1, r0, #0x17
	lsrs r0, r1, #0x17
	str r0, [r7, #0xc]
	ldr r0, [r7]
	movs r2, #8
	ldrsh r1, [r0, r2]
	ldr r2, [r7, #8]
	adds r0, r1, r2
	movs r1, #0xff
	ands r0, r1
	str r0, [r7, #0x10]
	ldr r0, .L0201264C @ =0x03000A00
	ldr r1, [r0]
	ldr r2, [r7]
	ldr r4, [r7, #0xc]
	lsls r3, r4, #0x10
	ldr r4, [r2]
	adds r2, r3, #0
	orrs r2, r4
	ldr r3, [r7, #0x10]
	orrs r2, r3
	str r2, [r1]
	adds r1, #4
	str r1, [r0]
	ldr r0, .L0201264C @ =0x03000A00
	ldr r1, [r0]
	ldr r2, [r7]
	ldrh r3, [r2, #4]
	strh r3, [r1]
	adds r1, #4
	str r1, [r0]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r1, #0xc
	str r1, [r7]
	b .L020125D8
	.align 2, 0
.L0201264C: .4byte 0x03000A00
.L02012650:
	add sp, #0x14
	pop {r4, r7}
	pop {r0}
	bx r0

	thumb_func_start InitRamFuncs
InitRamFuncs: @ 0x02012658
	push {r4, r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r0, .L020126A0 @ =0x02010474
	ldr r1, .L020126A4 @ =ArmCodeStart
	subs r0, r0, r1
	str r0, [r7]
	ldr r0, .L020126A4 @ =ArmCodeStart
	ldr r1, .L020126A8 @ =0x03000A10
	ldr r2, [r7]
	asrs r3, r2, #0x1f
	lsrs r4, r3, #0x1f
	adds r3, r2, r4
	asrs r2, r3, #1
	lsls r3, r2, #0xb
	lsrs r2, r3, #0xb
	bl SwiCpuSet
	ldr r0, .L020126AC @ =0x030003F8
	ldr r1, .L020126B0 @ =func_020103C8
	ldr r2, .L020126A4 @ =ArmCodeStart
	subs r1, r1, r2
	ldr r2, .L020126A8 @ =0x03000A10
	adds r1, r2, r1
	str r1, [r0]
	ldr r0, .L020126B4 @ =0x03001410
	ldr r1, .L020126B8 @ =func_02010468
	ldr r2, .L020126A4 @ =ArmCodeStart
	subs r1, r1, r2
	ldr r2, .L020126A8 @ =0x03000A10
	adds r1, r2, r1
	str r1, [r0]
	add sp, #4
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020126A0: .4byte 0x02010474
.L020126A4: .4byte ArmCodeStart
.L020126A8: .4byte 0x03000A10
.L020126AC: .4byte 0x030003F8
.L020126B0: .4byte func_020103C8
.L020126B4: .4byte 0x03001410
.L020126B8: .4byte func_02010468

	thumb_func_start DrawGlyphRam
DrawGlyphRam: @ 0x020126BC
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start DecodeStringRam
DecodeStringRam: @ 0x020126D4
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start PutOamHiRam
PutOamHiRam: @ 0x020126E8
	push {r4, r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r0, .L02012710 @ =0x030003F8
	ldr r1, [r7, #4]
	ldr r2, [r7, #8]
	ldr r3, [r7, #0xc]
	ldr r4, [r0]
	ldr r0, [r7]
	bl _call_via_r4
	add sp, #0x10
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012710: .4byte 0x030003F8

	thumb_func_start PutOamLoRam
PutOamLoRam: @ 0x02012714
	push {r4, r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r0, .L0201273C @ =0x03001410
	ldr r1, [r7, #4]
	ldr r2, [r7, #8]
	ldr r3, [r7, #0xc]
	ldr r4, [r0]
	ldr r0, [r7]
	bl _call_via_r4
	add sp, #0x10
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L0201273C: .4byte 0x03001410

	thumb_func_start MapFloodCoreStepRam
MapFloodCoreStepRam: @ 0x02012740
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start MapFloodCoreRam
MapFloodCoreRam: @ 0x02012754
	push {r7, lr}
	mov r7, sp
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start InitProcs
InitProcs: @ 0x02012760
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	movs r0, #0
	str r0, [r7, #4]
.L0201276A:
	ldr r0, [r7, #4]
	cmp r0, #7
	ble .L02012772
	b .L02012810
.L02012772:
	ldr r0, [r7, #4]
	movs r1, #0x6c
	muls r0, r1, r0
	ldr r1, .L02012808 @ =0x0202CBD4
	adds r0, r1, r0
	str r0, [r7]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #4]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #8]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0xc]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x10]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x14]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x18]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x1c]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x20]
	ldr r0, [r7]
	ldrh r1, [r0, #0x24]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0x24]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x26
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x27
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x28
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, .L0201280C @ =0x0202CF34
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, [r7]
	str r1, [r0]
	ldr r0, [r7, #4]
	adds r1, r0, #1
	str r1, [r7, #4]
	b .L0201276A
	.align 2, 0
.L02012808: .4byte 0x0202CBD4
.L0201280C: .4byte 0x0202CF34
.L02012810:
	ldr r0, .L02012828 @ =0x0202CF34
	movs r1, #0
	str r1, [r0, #0x20]
	ldr r0, .L0201282C @ =0x0202CF58
	ldr r1, .L02012828 @ =0x0202CF34
	str r1, [r0]
	movs r0, #0
	str r0, [r7, #4]
.L02012820:
	ldr r0, [r7, #4]
	cmp r0, #7
	ble .L02012830
	b .L0201284C
	.align 2, 0
.L02012828: .4byte 0x0202CF34
.L0201282C: .4byte 0x0202CF58
.L02012830:
	ldr r0, .L02012848 @ =0x0202CF5C
	ldr r1, [r7, #4]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	movs r1, #0
	str r1, [r0]
	ldr r0, [r7, #4]
	adds r1, r0, #1
	str r1, [r7, #4]
	b .L02012820
	.align 2, 0
.L02012848: .4byte 0x0202CF5C
.L0201284C:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start SpawnProc
SpawnProc: @ 0x02012854
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	bl AllocProc
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r7]
	str r1, [r0]
	ldr r0, [r7, #8]
	ldr r1, [r7]
	str r1, [r0, #4]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #8]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0xc]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0x14]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0x18]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0x1c]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0x20]
	ldr r0, [r7, #8]
	ldrh r1, [r0, #0x24]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0, #0x24]
	ldr r0, [r7, #8]
	adds r1, r0, #0
	adds r0, #0x26
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #0
	adds r0, #0x28
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7, #8]
	adds r1, r0, #0
	adds r0, #0x27
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #8
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7, #4]
	cmp r0, #7
	bgt .L020128E8
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	bl InsertRootProc
	b .L020128F0
.L020128E8:
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	bl InsertProc
.L020128F0:
	ldr r1, [r7, #8]
	adds r0, r1, #0
	bl StepProcScr
	ldr r0, [r7, #8]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	adds r2, #0x27
	ldrb r1, [r2]
	movs r2, #0xf7
	ands r1, r2
	adds r2, r0, #0
	adds r0, #0x27
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r1, [r7, #8]
	adds r0, r1, #0
	b .L02012920
.L02012920:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start SpawnProcLocking
SpawnProcLocking: @ 0x02012928
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl SpawnProc
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r0]
	cmp r1, #0
	bne .L02012948
	movs r0, #0
	b .L0201299C
.L02012948:
	ldr r0, [r7, #8]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	adds r2, #0x27
	ldrb r1, [r2]
	movs r2, #2
	orrs r1, r2
	adds r2, r0, #0
	adds r0, #0x27
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7, #8]
	ldr r1, [r0, #0x14]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r2, [r7, #8]
	ldr r0, [r2, #0x14]
	ldr r1, [r7, #8]
	ldr r2, [r1, #0x14]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	adds r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r1, [r7, #8]
	adds r0, r1, #0
	b .L0201299C
.L0201299C:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start ClearProc
ClearProc: @ 0x020129A4
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	cmp r1, #0
	beq .L020129BE
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	adds r0, r1, #0
	bl ClearProc
.L020129BE:
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L020129D0
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	adds r0, r1, #0
	bl ClearProc
.L020129D0:
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x27
	ldrb r0, [r1]
	movs r1, #1
	ands r0, r1
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L020129E8
	b .L02012A70
.L020129E8:
	ldr r0, [r7]
	ldr r1, [r0, #8]
	cmp r1, #0
	beq .L020129FA
	ldr r0, [r7]
	ldr r1, [r0, #8]
	ldr r0, [r7]
	bl _call_via_r1
.L020129FA:
	ldr r0, [r7]
	bl FreeProc
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0xc]
	ldr r0, [r7]
	ldr r2, [r7]
	adds r1, r2, #0
	adds r2, #0x27
	ldrb r1, [r2]
	movs r2, #1
	orrs r1, r2
	adds r2, r0, #0
	adds r0, #0x27
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x27
	ldrb r0, [r1]
	movs r1, #2
	ands r0, r1
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02012A70
	ldr r0, [r7]
	ldr r1, [r0, #0x14]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r2, [r7]
	ldr r0, [r2, #0x14]
	ldr r1, [r7]
	ldr r2, [r1, #0x14]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	subs r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
.L02012A70:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_End
Proc_End: @ 0x02012A78
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	cmp r0, #0
	bne .L02012A8C
	b .L02012A9A
.L02012A8C:
	ldr r1, [r7, #4]
	adds r0, r1, #0
	bl UnlinkProc
	ldr r0, [r7]
	bl ClearProc
.L02012A9A:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start AllocProc
AllocProc: @ 0x02012AA4
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r1, .L02012AC4 @ =0x0202CF58
	ldr r0, [r1]
	ldr r1, [r0]
	str r1, [r7]
	ldr r1, .L02012AC4 @ =0x0202CF58
	ldr r0, .L02012AC4 @ =0x0202CF58
	ldr r1, .L02012AC4 @ =0x0202CF58
	ldr r2, [r1]
	adds r1, r2, #4
	str r1, [r0]
	ldr r1, [r7]
	adds r0, r1, #0
	b .L02012AC8
	.align 2, 0
.L02012AC4: .4byte 0x0202CF58
.L02012AC8:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start FreeProc
FreeProc: @ 0x02012AD0
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, .L02012AF4 @ =0x0202CF58
	ldr r0, .L02012AF4 @ =0x0202CF58
	ldr r1, .L02012AF4 @ =0x0202CF58
	ldr r2, [r1]
	subs r1, r2, #4
	str r1, [r0]
	ldr r1, .L02012AF4 @ =0x0202CF58
	ldr r0, [r1]
	ldr r1, [r7]
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012AF4: .4byte 0x0202CF58

	thumb_func_start InsertRootProc
InsertRootProc: @ 0x02012AF8
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	lsls r0, r1, #2
	ldr r1, .L02012B40 @ =0x0202CF5C
	adds r0, r1, r0
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r0]
	cmp r1, #0
	beq .L02012B2A
	ldr r0, [r7, #8]
	ldr r1, [r0]
	ldr r0, [r7]
	str r0, [r1, #0x1c]
	ldr r0, [r7]
	ldr r1, [r7, #8]
	ldr r2, [r1]
	str r2, [r0, #0x20]
.L02012B2A:
	ldr r0, [r7]
	ldr r1, [r7, #4]
	str r1, [r0, #0x14]
	ldr r0, [r7, #8]
	ldr r1, [r7]
	str r1, [r0]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012B40: .4byte 0x0202CF5C

	thumb_func_start InsertProc
InsertProc: @ 0x02012B44
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7, #4]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L02012B66
	ldr r0, [r7, #4]
	ldr r1, [r0, #0x18]
	ldr r0, [r7]
	str r0, [r1, #0x1c]
	ldr r0, [r7]
	ldr r1, [r7, #4]
	ldr r2, [r1, #0x18]
	str r2, [r0, #0x20]
.L02012B66:
	ldr r0, [r7, #4]
	ldr r1, [r7]
	str r1, [r0, #0x18]
	ldr r0, [r7]
	ldr r1, [r7, #4]
	str r1, [r0, #0x14]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start UnlinkProc
UnlinkProc: @ 0x02012B7C
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #0x1c]
	cmp r1, #0
	beq .L02012B96
	ldr r1, [r7]
	ldr r0, [r1, #0x1c]
	ldr r1, [r7]
	ldr r2, [r1, #0x20]
	str r2, [r0, #0x20]
.L02012B96:
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	cmp r1, #0
	beq .L02012BA8
	ldr r1, [r7]
	ldr r0, [r1, #0x20]
	ldr r1, [r7]
	ldr r2, [r1, #0x1c]
	str r2, [r0, #0x1c]
.L02012BA8:
	ldr r0, [r7]
	ldr r1, [r0, #0x14]
	cmp r1, #8
	ble .L02012BC8
	ldr r0, [r7]
	ldr r1, [r0, #0x14]
	ldr r0, [r1, #0x18]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02012BC6
	ldr r1, [r7]
	ldr r0, [r1, #0x14]
	ldr r1, [r7]
	ldr r2, [r1, #0x20]
	str r2, [r0, #0x18]
.L02012BC6:
	b .L02012BE8
.L02012BC8:
	ldr r0, [r7]
	ldr r1, [r0, #0x14]
	adds r0, r1, #0
	lsls r1, r0, #2
	ldr r0, .L02012BFC @ =0x0202CF5C
	adds r1, r0, r1
	str r1, [r7, #4]
	ldr r0, [r7, #4]
	ldr r1, [r0]
	ldr r0, [r7]
	cmp r1, r0
	bne .L02012BE8
	ldr r0, [r7, #4]
	ldr r1, [r7]
	ldr r2, [r1, #0x20]
	str r2, [r0]
.L02012BE8:
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x1c]
	ldr r0, [r7]
	movs r1, #0
	str r1, [r0, #0x20]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02012BFC: .4byte 0x0202CF5C

	thumb_func_start RunProcCore
RunProcCore: @ 0x02012C00
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	cmp r1, #0
	beq .L02012C1A
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	adds r0, r1, #0
	bl RunProcCore
.L02012C1A:
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x28
	ldrb r0, [r1]
	cmp r0, #0
	bne .L02012C3E
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x27
	ldrb r0, [r1]
	movs r1, #8
	ands r0, r1
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	bne .L02012C3E
	b .L02012C40
.L02012C3E:
	b .L02012C78
.L02012C40:
	ldr r0, [r7]
	ldr r1, [r0, #0xc]
	cmp r1, #0
	bne .L02012C4E
	ldr r0, [r7]
	bl StepProcScr
.L02012C4E:
	ldr r0, [r7]
	ldr r1, [r0, #0xc]
	cmp r1, #0
	beq .L02012C60
	ldr r0, [r7]
	ldr r1, [r0, #0xc]
	ldr r0, [r7]
	bl _call_via_r1
.L02012C60:
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x27
	ldrb r0, [r1]
	movs r1, #1
	ands r0, r1
	adds r2, r0, #0
	lsls r1, r2, #0x18
	lsrs r0, r1, #0x18
	cmp r0, #0
	beq .L02012C78
	b .L02012C8A
.L02012C78:
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L02012C8A
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	adds r0, r1, #0
	bl RunProcCore
.L02012C8A:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_Run
Proc_Run: @ 0x02012C94
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	cmp r0, #0
	beq .L02012CA8
	ldr r0, [r7]
	bl RunProcCore
.L02012CA8:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_Break
Proc_Break: @ 0x02012CB0
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	movs r1, #0
	str r1, [r0, #0xc]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start FindProc
FindProc: @ 0x02012CCC
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012CE4 @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012CDC:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012CE8
	b .L02012D08
	.align 2, 0
.L02012CE4: .4byte 0x0202CBD4
.L02012CE8:
	ldr r0, [r7, #4]
	ldr r1, [r0]
	ldr r0, [r7]
	cmp r1, r0
	bne .L02012CF8
	ldr r1, [r7, #4]
	adds r0, r1, #0
	b .L02012D0C
.L02012CF8:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012CDC
.L02012D08:
	movs r0, #0
	b .L02012D0C
.L02012D0C:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start FindActiveProc
FindActiveProc: @ 0x02012D14
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012D2C @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012D24:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012D30
	b .L02012D5C
	.align 2, 0
.L02012D2C: .4byte 0x0202CBD4
.L02012D30:
	ldr r0, [r7, #4]
	ldr r1, [r0]
	ldr r0, [r7]
	cmp r1, r0
	bne .L02012D4C
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x28
	ldrb r0, [r1]
	cmp r0, #0
	bne .L02012D4C
	ldr r1, [r7, #4]
	adds r0, r1, #0
	b .L02012D60
.L02012D4C:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012D24
.L02012D5C:
	movs r0, #0
	b .L02012D60
.L02012D60:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start FindMarkedProc
FindMarkedProc: @ 0x02012D68
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012D80 @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012D78:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012D84
	b .L02012DB0
	.align 2, 0
.L02012D80: .4byte 0x0202CBD4
.L02012D84:
	ldr r0, [r7, #4]
	ldr r1, [r0]
	cmp r1, #0
	beq .L02012DA0
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x26
	ldrb r0, [r1]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02012DA0
	ldr r1, [r7, #4]
	adds r0, r1, #0
	b .L02012DB4
.L02012DA0:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012D78
.L02012DB0:
	movs r0, #0
	b .L02012DB4
.L02012DB4:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start Proc_Goto
Proc_Goto: @ 0x02012DBC
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r0]
	str r1, [r7, #0xc]
.L02012DD0:
	ldr r0, [r7, #0xc]
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0
	bne .L02012DDC
	b .L02012E0A
.L02012DDC:
	ldr r0, [r7, #0xc]
	movs r2, #0
	ldrsh r1, [r0, r2]
	cmp r1, #0xb
	bne .L02012E00
	ldr r0, [r7, #0xc]
	movs r2, #2
	ldrsh r1, [r0, r2]
	ldr r0, [r7, #4]
	cmp r1, r0
	bne .L02012E00
	ldr r0, [r7, #8]
	ldr r1, [r7, #0xc]
	str r1, [r0, #4]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0xc]
	b .L02012E0A
.L02012E00:
	ldr r0, [r7, #0xc]
	adds r1, r0, #0
	adds r1, #8
	str r1, [r7, #0xc]
	b .L02012DD0
.L02012E0A:
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_GotoScript
Proc_GotoScript: @ 0x02012E14
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	str r1, [r0, #4]
	ldr r0, [r7, #8]
	movs r1, #0
	str r1, [r0, #0xc]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_Mark
Proc_Mark: @ 0x02012E38
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r1, [r7, #8]
	ldr r2, [r7, #4]
	adds r0, r2, #0
	adds r2, r1, #0
	adds r1, #0x26
	ldrb r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strb r2, [r1]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_SetEndFunc
Proc_SetEndFunc: @ 0x02012E68
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	str r1, [r0, #8]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_ForAll
Proc_ForAll: @ 0x02012E84
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012E9C @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012E94:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012EA0
	b .L02012EC0
	.align 2, 0
.L02012E9C: .4byte 0x0202CBD4
.L02012EA0:
	ldr r0, [r7, #4]
	ldr r1, [r0]
	cmp r1, #0
	beq .L02012EB0
	ldr r0, [r7, #4]
	ldr r1, [r7]
	bl _call_via_r1
.L02012EB0:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012E94
.L02012EC0:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_ForEach
Proc_ForEach: @ 0x02012EC8
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, .L02012EE4 @ =0x0202CBD4
	str r0, [r7, #8]
	movs r0, #0
	str r0, [r7, #0xc]
.L02012EDA:
	ldr r0, [r7, #0xc]
	cmp r0, #7
	ble .L02012EE8
	b .L02012F0A
	.align 2, 0
.L02012EE4: .4byte 0x0202CBD4
.L02012EE8:
	ldr r0, [r7, #8]
	ldr r1, [r0]
	ldr r0, [r7]
	cmp r1, r0
	bne .L02012EFA
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	bl _call_via_r1
.L02012EFA:
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
	ldr r0, [r7, #8]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #8]
	b .L02012EDA
.L02012F0A:
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_ForEachMarked
Proc_ForEachMarked: @ 0x02012F14
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, .L02012F30 @ =0x0202CBD4
	str r0, [r7, #8]
	movs r0, #0
	str r0, [r7, #0xc]
.L02012F26:
	ldr r0, [r7, #0xc]
	cmp r0, #7
	ble .L02012F34
	b .L02012F5A
	.align 2, 0
.L02012F30: .4byte 0x0202CBD4
.L02012F34:
	ldr r1, [r7, #8]
	adds r0, r1, #0
	adds r1, #0x26
	ldrb r0, [r1]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02012F4A
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	bl _call_via_r1
.L02012F4A:
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
	ldr r0, [r7, #8]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #8]
	b .L02012F26
.L02012F5A:
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_LockEachMarked
Proc_LockEachMarked: @ 0x02012F64
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012F7C @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012F74:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012F80
	b .L02012FC4
	.align 2, 0
.L02012F7C: .4byte 0x0202CBD4
.L02012F80:
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x26
	ldrb r0, [r1]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02012FB4
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r0, [r7, #4]
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	adds r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
.L02012FB4:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012F74
.L02012FC4:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_ReleaseEachMarked
Proc_ReleaseEachMarked: @ 0x02012FCC
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02012FE4 @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02012FDC:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02012FE8
	b .L0201302C
	.align 2, 0
.L02012FE4: .4byte 0x0202CBD4
.L02012FE8:
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x26
	ldrb r0, [r1]
	ldr r1, [r7]
	cmp r0, r1
	bne .L0201301C
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r0, [r7, #4]
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	subs r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
.L0201301C:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02012FDC
.L0201302C:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_EndEachMarked
Proc_EndEachMarked: @ 0x02013034
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, .L0201304C @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
.L02013044:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L02013050
	b .L02013076
	.align 2, 0
.L0201304C: .4byte 0x0202CBD4
.L02013050:
	ldr r1, [r7, #4]
	adds r0, r1, #0
	adds r1, #0x26
	ldrb r0, [r1]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02013066
	ldr r1, [r7, #4]
	adds r0, r1, #0
	bl Proc_End
.L02013066:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02013044
.L02013076:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start EndProc
EndProc: @ 0x02013080
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	bl Proc_End
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_EndEach
Proc_EndEach: @ 0x02013098
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, .L020130B0 @ =EndProc
	ldr r0, [r7]
	bl Proc_ForEach
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020130B0: .4byte EndProc

	thumb_func_start BreakProc
BreakProc: @ 0x020130B4
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	bl Proc_Break
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_BreakEach
Proc_BreakEach: @ 0x020130CC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, .L020130E4 @ =BreakProc
	ldr r0, [r7]
	bl Proc_ForEach
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020130E4: .4byte BreakProc

	thumb_func_start WalkProcSubtree
WalkProcSubtree: @ 0x020130E8
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	cmp r1, #0
	beq .L02013108
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkProcSubtree
.L02013108:
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl _call_via_r1
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L02013126
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkProcSubtree
.L02013126:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_ForSubtree
Proc_ForSubtree: @ 0x02013130
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	bl _call_via_r1
	ldr r0, [r7, #8]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L0201315C
	ldr r0, [r7, #8]
	ldr r1, [r0, #0x18]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkProcSubtree
.L0201315C:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start ProcCmd_End
ProcCmd_End: @ 0x02013164
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	bl Proc_End
	movs r0, #0
	b .L02013176
.L02013176:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start ProcCmd_Name
ProcCmd_Name: @ 0x02013180
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	ldr r1, [r2, #4]
	str r1, [r0, #0x10]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L020131A4
.L020131A4:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020131AC
func_020131AC: @ 0x020131AC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r0, [r1, #4]
	str r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl _call_via_r1
	movs r0, #1
	b .L020131D6
.L020131D6:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_020131E0
func_020131E0: @ 0x020131E0
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r0, [r1, #4]
	str r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl _call_via_r1
	lsls r2, r0, #0x18
	asrs r1, r2, #0x18
	adds r0, r1, #0
	b .L0201320E
.L0201320E:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013218
func_02013218: @ 0x02013218
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	adds r0, r7, #0
	adds r0, #8
	ldr r1, [r7]
	ldr r2, [r1, #4]
	ldrh r1, [r2, #2]
	strh r1, [r0]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r0, [r1, #4]
	str r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	adds r0, r7, #0
	adds r0, #8
	movs r2, #0
	ldrsh r1, [r0, r2]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	ldr r1, [r7]
	bl _call_via_r2
	lsls r2, r0, #0x18
	asrs r1, r2, #0x18
	adds r0, r1, #0
	b .L0201325C
.L0201325C:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_02013264
func_02013264: @ 0x02013264
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r0, [r1, #4]
	str r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl _call_via_r1
	lsls r1, r0, #0x18
	asrs r0, r1, #0x18
	cmp r0, #1
	bne .L020132A4
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	subs r1, #8
	str r1, [r0, #4]
	movs r0, #0
	b .L020132A8
.L020132A4:
	movs r0, #1
	b .L020132A8
.L020132A8:
	add sp, #8
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020132B0
func_020132B0: @ 0x020132B0
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	ldr r1, [r2, #4]
	str r1, [r0, #0xc]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #0
	b .L020132D4
.L020132D4:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020132DC
func_020132DC: @ 0x020132DC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	ldr r0, [r7]
	adds r1, r2, #0
	bl Proc_SetEndFunc
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013304
.L02013304:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_0201330C
func_0201330C: @ 0x0201330C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	adds r0, r2, #0
	ldr r1, [r7]
	bl SpawnProc
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013334
.L02013334:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_0201333C
func_0201333C: @ 0x0201333C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	adds r0, r2, #0
	ldr r1, [r7]
	bl SpawnProcLocking
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #0
	b .L02013364
.L02013364:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_0201336C
func_0201336C: @ 0x0201336C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r0, [r1, #4]
	ldr r1, [r7]
	movs r3, #0x24
	ldrsh r2, [r1, r3]
	adds r1, r2, #0
	bl SpawnProc
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013398
.L02013398:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020133A0
func_020133A0: @ 0x020133A0
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	adds r0, r2, #0
	bl FindProc
	adds r1, r0, #0
	movs r0, #0
	cmp r1, #0
	beq .L020133BE
	movs r0, #1
.L020133BE:
	cmp r0, #1
	bne .L020133C6
	movs r0, #0
	b .L020133D8
.L020133C6:
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L020133D8
.L020133D8:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020133E0
func_020133E0: @ 0x020133E0
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	adds r0, r2, #0
	bl Proc_EndEach
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013406
.L02013406:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013410
func_02013410: @ 0x02013410
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	adds r0, r2, #0
	bl Proc_BreakEach
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013436
.L02013436:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013440
func_02013440: @ 0x02013440
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L0201345A
.L0201345A:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013464
func_02013464: @ 0x02013464
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	ldr r2, [r1, #4]
	ldr r0, [r7]
	adds r1, r2, #0
	bl Proc_GotoScript
	movs r0, #1
	b .L0201347E
.L0201347E:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013488
func_02013488: @ 0x02013488
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	movs r0, #2
	ldrsh r2, [r1, r0]
	ldr r0, [r7]
	adds r1, r2, #0
	bl Proc_Goto
	movs r0, #1
	b .L020134A4
.L020134A4:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020134AC
func_020134AC: @ 0x020134AC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldrh r2, [r1, #0x24]
	subs r1, r2, #1
	ldrh r2, [r0, #0x24]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x24]
	ldr r0, [r7]
	movs r2, #0x24
	ldrsh r1, [r0, r2]
	cmp r1, #0
	bne .L020134DE
	ldr r0, [r7]
	bl Proc_Break
.L020134DE:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_020134E8
func_020134E8: @ 0x020134E8
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #4]
	movs r2, #2
	ldrsh r0, [r1, r2]
	cmp r0, #0
	beq .L0201351A
	ldr r0, [r7]
	ldr r2, [r7]
	ldr r1, [r2, #4]
	ldrh r2, [r0, #0x24]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1, #2]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #0x24]
	ldr r0, [r7]
	ldr r1, .L0201352C @ =func_020134AC
	str r1, [r0, #0xc]
.L0201351A:
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #0
	b .L02013530
	.align 2, 0
.L0201352C: .4byte func_020134AC
.L02013530:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_02013538
func_02013538: @ 0x02013538
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r2, [r0, #4]
	ldrh r3, [r2, #2]
	adds r0, r3, #0
	adds r2, r1, #0
	adds r1, #0x26
	ldrb r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strb r2, [r1]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L0201356E
.L0201356E:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013578
func_02013578: @ 0x02013578
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013592
.L02013592:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_0201359C
func_0201359C: @ 0x0201359C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	movs r0, #0
	b .L020135A8
.L020135A8:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_020135B0
func_020135B0: @ 0x020135B0
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	ldr r0, .L020135CC @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
	movs r0, #0
	str r0, [r7, #0xc]
.L020135C4:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L020135D0
	b .L020135F2
	.align 2, 0
.L020135CC: .4byte 0x0202CBD4
.L020135D0:
	ldr r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r0]
	ldr r1, [r1]
	cmp r0, r1
	bne .L020135E2
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
.L020135E2:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L020135C4
.L020135F2:
	ldr r0, [r7, #0xc]
	cmp r0, #1
	ble .L02013602
	ldr r0, [r7]
	bl Proc_End
	movs r0, #0
	b .L02013614
.L02013602:
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013614
.L02013614:
	add sp, #0x10
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start func_0201361C
func_0201361C: @ 0x0201361C
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	ldr r0, .L02013638 @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
	movs r0, #0
	str r0, [r7, #0xc]
.L02013630:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L0201363C
	b .L0201366C
	.align 2, 0
.L02013638: .4byte 0x0202CBD4
.L0201363C:
	ldr r0, [r7, #4]
	ldr r1, [r7]
	cmp r0, r1
	bne .L02013646
	b .L0201365C
.L02013646:
	ldr r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r0]
	ldr r1, [r1]
	cmp r0, r1
	bne .L0201365C
	ldr r1, [r7, #4]
	adds r0, r1, #0
	bl Proc_End
	b .L0201366C
.L0201365C:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L02013630
.L0201366C:
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L0201367E
.L0201367E:
	add sp, #0x10
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02013688
func_02013688: @ 0x02013688
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	ldr r0, .L020136A4 @ =0x0202CBD4
	str r0, [r7, #4]
	movs r0, #0
	str r0, [r7, #8]
	movs r0, #0
	str r0, [r7, #0xc]
.L0201369C:
	ldr r0, [r7, #8]
	cmp r0, #7
	ble .L020136A8
	b .L020136CA
	.align 2, 0
.L020136A4: .4byte 0x0202CBD4
.L020136A8:
	ldr r0, [r7, #4]
	ldr r1, [r7]
	ldr r0, [r0]
	ldr r1, [r1]
	cmp r0, r1
	bne .L020136BA
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
.L020136BA:
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	ldr r0, [r7, #4]
	adds r1, r0, #0
	adds r1, #0x6c
	str r1, [r7, #4]
	b .L0201369C
.L020136CA:
	ldr r0, [r7, #0xc]
	cmp r0, #1
	ble .L020136D0
.L020136D0:
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L020136E2
.L020136E2:
	add sp, #0x10
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_020136EC
func_020136EC: @ 0x020136EC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r2, [r7]
	adds r1, r2, #0
	adds r2, #0x27
	ldrb r1, [r2]
	movs r2, #4
	orrs r1, r2
	adds r2, r0, #0
	adds r0, #0x27
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r1, [r7]
	ldr r0, [r7]
	ldr r1, [r7]
	ldr r2, [r1, #4]
	adds r1, r2, #0
	adds r1, #8
	str r1, [r0, #4]
	movs r0, #1
	b .L02013728
.L02013728:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start StepProcScr
StepProcScr: @ 0x02013730
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0]
	cmp r1, #0
	bne .L02013742
	b .L0201378C
.L02013742:
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x28
	ldrb r0, [r1]
	cmp r0, #0
	beq .L02013750
	b .L0201378C
.L02013750:
	ldr r0, [r7]
	ldr r1, [r0, #0xc]
	cmp r1, #0
	beq .L0201375A
	b .L0201378C
.L0201375A:
	ldr r0, .L0201377C @ =.L02017CFC
	ldr r1, [r7]
	ldr r2, [r1, #4]
	movs r3, #0
	ldrsh r1, [r2, r3]
	adds r2, r1, #0
	lsls r1, r2, #2
	adds r0, r0, r1
	ldr r1, [r0]
	ldr r0, [r7]
	bl _call_via_r1
	lsls r1, r0, #0x18
	asrs r0, r1, #0x18
	cmp r0, #0
	bne .L02013780
	b .L0201378C
	.align 2, 0
.L0201377C: .4byte .L02017CFC
.L02013780:
	ldr r0, [r7]
	ldr r1, [r0]
	cmp r1, #0
	bne .L0201378A
	b .L0201378C
.L0201378A:
	b .L0201375A
.L0201378C:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start PrintProcInfo
PrintProcInfo: @ 0x02013794
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, [r0, #0x10]
	cmp r1, #0
	beq .L020137A6
	b .L020137A6
.L020137A6:
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start WalkPrintProcInfo
WalkPrintProcInfo: @ 0x020137B0
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	cmp r1, #0
	beq .L020137D0
	ldr r0, [r7]
	ldr r1, [r0, #0x20]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkPrintProcInfo
.L020137D0:
	ldr r0, [r7]
	bl PrintProcInfo
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L02013800
	ldr r0, [r7, #4]
	ldr r1, [r7, #4]
	ldr r2, [r1]
	adds r1, r2, #2
	str r1, [r0]
	ldr r0, [r7]
	ldr r1, [r0, #0x18]
	ldr r2, [r7, #4]
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkPrintProcInfo
	ldr r0, [r7, #4]
	ldr r1, [r7, #4]
	ldr r2, [r1]
	subs r1, r2, #2
	str r1, [r0]
.L02013800:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_PrintSubtreeInfo
Proc_PrintSubtreeInfo: @ 0x02013808
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	str r0, [r7, #8]
	movs r0, #4
	str r0, [r7, #4]
	ldr r1, [r7, #8]
	adds r0, r1, #0
	bl PrintProcInfo
	ldr r0, [r7, #8]
	ldr r1, [r0, #0x18]
	cmp r1, #0
	beq .L02013842
	ldr r0, [r7, #4]
	adds r1, r0, #2
	str r1, [r7, #4]
	ldr r0, [r7, #8]
	ldr r1, [r0, #0x18]
	adds r2, r7, #4
	adds r0, r1, #0
	adds r1, r2, #0
	bl WalkPrintProcInfo
	ldr r0, [r7, #4]
	subs r1, r0, #2
	str r1, [r7, #4]
.L02013842:
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_0201384C
func_0201384C: @ 0x0201384C
	push {r7, lr}
	mov r7, sp
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_SetRepeatFunc
Proc_SetRepeatFunc: @ 0x02013858
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	ldr r1, [r7, #4]
	str r1, [r0, #0xc]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start Proc_Lock
Proc_Lock: @ 0x02013874
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r0, [r7]
	ldr r2, [r7]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	adds r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start Proc_Release
Proc_Release: @ 0x020138AC
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x28
	ldr r0, [r7]
	ldr r2, [r7]
	adds r1, r2, #0
	adds r2, #0x28
	ldrb r3, [r2]
	subs r1, r3, #1
	adds r2, r0, #0
	adds r0, #0x28
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start DebugInitBg
DebugInitBg: @ 0x020138E4
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7, #4]
	cmp r0, #0
	bne .L020138FA
	movs r0, #0xb0
	lsls r0, r0, #7
	str r0, [r7, #4]
.L020138FA:
	ldr r0, [r7]
	movs r1, #0
	bl SetBgChrOffset
	ldr r0, [r7]
	movs r1, #0
	bl SetBgScreenSize
	ldr r0, .L02013994 @ =.L02017D64
	ldr r1, [r7, #4]
	lsls r3, r1, #0xf
	lsrs r2, r3, #0xf
	movs r3, #0xc0
	lsls r3, r3, #0x13
	adds r1, r2, r3
	movs r2, #0x80
	lsls r2, r2, #4
	bl AsyncDataMove
	ldr r0, .L02013998 @ =0x0202A620
	ldrh r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02013998 @ =0x0202A620
	ldrh r1, [r0, #4]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	ldr r3, .L0201399C @ =0x00007FFF
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #4]
	bl EnablePalSync
	ldr r0, [r7]
	bl GetBgTilemap
	adds r1, r0, #0
	adds r0, r1, #0
	movs r1, #0
	bl TmFill
	ldr r0, .L020139A0 @ =0x0202CF7C
	ldr r2, [r7]
	adds r1, r2, #0
	ldrh r2, [r0, #4]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #4]
	ldr r0, .L020139A0 @ =0x0202CF7C
	ldr r1, [r7, #4]
	str r1, [r0]
	ldr r1, [r7, #4]
	ldr r0, [r7]
	bl GetBgChrId
	adds r1, r0, #0
	ldr r0, .L020139A0 @ =0x0202CF7C
	ldrh r2, [r0, #6]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #6]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013994: .4byte .L02017D64
.L02013998: .4byte 0x0202A620
.L0201399C: .4byte 0x00007FFF
.L020139A0: .4byte 0x0202CF7C

	thumb_func_start DebugPutStr
DebugPutStr: @ 0x020139A4
	push {r4, r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
.L020139AE:
	ldr r0, [r7, #4]
	ldrb r1, [r0]
	cmp r1, #0
	bne .L020139B8
	b .L02013A0C
.L020139B8:
	ldr r0, [r7]
	ldr r1, [r7, #4]
	ldrb r2, [r1]
	cmp r2, #0x60
	bls .L020139E0
	ldr r1, [r7, #4]
	ldrb r2, [r1]
	adds r1, r2, #0
	ldr r2, .L020139D8 @ =0x0202CF7C
	ldrh r3, [r2, #6]
	ldr r4, .L020139DC @ =0x0000FFC0
	adds r2, r3, r4
	adds r3, r2, #0
	adds r2, r1, r3
	adds r1, r2, #0
	b .L020139F4
	.align 2, 0
.L020139D8: .4byte 0x0202CF7C
.L020139DC: .4byte 0x0000FFC0
.L020139E0:
	ldr r2, [r7, #4]
	ldrb r3, [r2]
	adds r1, r3, #0
	ldr r2, .L02013A04 @ =0x0202CF7C
	ldrh r3, [r2, #6]
	ldr r4, .L02013A08 @ =0x0000FFE0
	adds r2, r3, r4
	adds r3, r2, #0
	adds r2, r1, r3
	adds r1, r2, #0
.L020139F4:
	strh r1, [r0]
	ldr r0, [r7]
	adds r1, r0, #2
	str r1, [r7]
	ldr r0, [r7, #4]
	adds r1, r0, #1
	str r1, [r7, #4]
	b .L020139AE
	.align 2, 0
.L02013A04: .4byte 0x0202CF7C
.L02013A08: .4byte 0x0000FFE0
.L02013A0C:
	ldr r0, .L02013A20 @ =0x0202CF7C
	movs r2, #4
	ldrsh r1, [r0, r2]
	adds r0, r1, #0
	bl EnableBgSyncById
	add sp, #8
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013A20: .4byte 0x0202CF7C

	thumb_func_start DebugPutFmt
DebugPutFmt: @ 0x02013A24
	push {r1, r2, r3}
	push {r7, lr}
	sub sp, #0x108
	mov r7, sp
	str r0, [r7]
	movs r1, #0x8a
	lsls r1, r1, #1
	adds r0, r7, r1
	adds r1, r7, #0
	movs r1, #0x82
	lsls r1, r1, #1
	adds r2, r7, r1
	str r0, [r2]
	adds r1, r7, #4
	ldr r0, [r7]
	bl DebugPutStr
	add sp, #0x108
	pop {r7}
	pop {r3}
	add sp, #0xc
	bx r3

	thumb_func_start DebugScreenInit
DebugScreenInit: @ 0x02013A50
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	movs r0, #0
	str r0, [r7]
.L02013A5A:
	ldr r0, [r7]
	cmp r0, #0xff
	ble .L02013A62
	b .L02013A8C
.L02013A62:
	ldr r0, .L02013A88 @ =0x0202CF7C
	ldr r1, [r7]
	movs r2, #0xff
	ands r1, r2
	adds r2, r1, #0
	lsls r1, r2, #5
	adds r2, r0, #0
	adds r2, #0x14
	adds r0, r2, r1
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #1
	str r1, [r7]
	b .L02013A5A
	.align 2, 0
.L02013A88: .4byte 0x0202CF7C
.L02013A8C:
	ldr r0, .L02013AB0 @ =0x0202CF7C
	movs r1, #0
	str r1, [r0, #8]
	ldr r0, .L02013AB0 @ =0x0202CF7C
	movs r1, #0
	str r1, [r0, #0xc]
	ldr r1, .L02013AB4 @ =0x0202BA20
	adds r0, r1, #0
	movs r1, #0
	bl TmFill
	movs r0, #4
	bl EnableBgSync
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013AB0: .4byte 0x0202CF7C
.L02013AB4: .4byte 0x0202BA20

	thumb_func_start DebugPrintFmt
DebugPrintFmt: @ 0x02013AB8
	push {r0, r1, r2, r3}
	push {r7, lr}
	sub sp, #0x104
	mov r7, sp
	movs r1, #0x88
	lsls r1, r1, #1
	adds r0, r7, r1
	adds r1, r7, #0
	movs r1, #0x80
	lsls r1, r1, #1
	adds r2, r7, r1
	str r0, [r2]
	adds r1, r7, #0
	adds r0, r1, #0
	bl DebugPrintStr
	add sp, #0x104
	pop {r7}
	pop {r3}
	add sp, #0x10
	bx r3
	.align 2, 0

	thumb_func_start ClearNumberStr
ClearNumberStr: @ 0x02013AE4
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r0, .L02013B14 @ =0x0202EF90
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, .L02013B18 @ =0x20202020
	str r1, [r0]
	adds r0, #4
	str r0, [r7]
	ldr r0, [r7]
	ldr r1, .L02013B18 @ =0x20202020
	str r1, [r0]
	ldr r0, .L02013B14 @ =0x0202EF90
	ldrb r1, [r0, #8]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0, #8]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013B14: .4byte 0x0202EF90
.L02013B18: .4byte 0x20202020

	thumb_func_start GenNumberStr
GenNumberStr: @ 0x02013B1C
	push {r4, r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	bl ClearNumberStr
	movs r0, #7
	str r0, [r7, #4]
.L02013B2C:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02013B34
	b .L02013B7C
.L02013B34:
	ldr r0, .L02013B70 @ =0x0202EF90
	ldr r1, [r7, #4]
	adds r4, r0, r1
	ldr r1, [r7]
	adds r0, r1, #0
	movs r1, #0xa
	bl _modsi3
	adds r1, r0, #0
	adds r0, r1, #0
	adds r0, #0x30
	ldrb r1, [r4]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	adds r1, r2, #0
	orrs r1, r0
	adds r0, r1, #0
	strb r0, [r4]
	ldr r1, [r7]
	adds r0, r1, #0
	movs r1, #0xa
	bl _divsi3
	str r0, [r7]
	ldr r0, [r7]
	cmp r0, #0
	bne .L02013B74
	b .L02013B7C
	.align 2, 0
.L02013B70: .4byte 0x0202EF90
.L02013B74:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L02013B2C
.L02013B7C:
	add sp, #8
	pop {r4, r7}
	pop {r0}
	bx r0

	thumb_func_start GenNumberOrBlankStr
GenNumberOrBlankStr: @ 0x02013B84
	push {r4, r7, lr}
	sub sp, #4
	mov r7, sp
	str r0, [r7]
	bl ClearNumberStr
	ldr r0, [r7]
	cmp r0, #0xff
	beq .L02013BA0
	ldr r0, [r7]
	movs r1, #1
	cmn r0, r1
	beq .L02013BA0
	b .L02013BD0
.L02013BA0:
	ldr r0, .L02013BCC @ =0x0202EF90
	ldr r1, .L02013BCC @ =0x0202EF90
	ldrb r2, [r1, #7]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	movs r4, #0x3a
	adds r2, r3, #0
	orrs r2, r4
	adds r3, r2, #0
	strb r3, [r1, #7]
	ldrb r1, [r0, #6]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #0x3a
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strb r2, [r0, #6]
	b .L02013BD6
	.align 2, 0
.L02013BCC: .4byte 0x0202EF90
.L02013BD0:
	ldr r0, [r7]
	bl GenNumberStr
.L02013BD6:
	add sp, #4
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start DebugPrintNumber
DebugPrintNumber: @ 0x02013BE0
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	bl GenNumberStr
	ldr r0, .L02013C04 @ =0x0202EF98
	ldr r2, [r7, #4]
	subs r1, r0, r2
	adds r0, r1, #0
	bl DebugPrintStr
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013C04: .4byte 0x0202EF98

	thumb_func_start GenNumberHexStr
GenNumberHexStr: @ 0x02013C08
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	bl ClearNumberStr
	movs r0, #7
	str r0, [r7, #4]
.L02013C18:
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02013C20
	b .L02013C60
.L02013C20:
	ldr r0, .L02013C50 @ =0x0202EF90
	ldr r1, [r7, #4]
	adds r0, r0, r1
	ldr r1, .L02013C54 @ =.L020172B0
	ldr r2, [r7]
	movs r3, #0xf
	ands r2, r3
	adds r1, r1, r2
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r0, [r7]
	asrs r1, r0, #4
	str r1, [r7]
	ldr r0, [r7]
	cmp r0, #0
	bne .L02013C58
	b .L02013C60
	.align 2, 0
.L02013C50: .4byte 0x0202EF90
.L02013C54: .4byte .L020172B0
.L02013C58:
	ldr r0, [r7, #4]
	subs r1, r0, #1
	str r1, [r7, #4]
	b .L02013C18
.L02013C60:
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0

	thumb_func_start DebugPrintNumberHex
DebugPrintNumberHex: @ 0x02013C68
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	bl GenNumberHexStr
	ldr r0, .L02013C8C @ =0x0202EF98
	ldr r2, [r7, #4]
	subs r1, r0, r2
	adds r0, r1, #0
	bl DebugPrintStr
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013C8C: .4byte 0x0202EF98

	thumb_func_start DebugPrintStr
DebugPrintStr: @ 0x02013C90
	push {r4, r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
.L02013C98:
	ldr r0, [r7]
	ldrb r1, [r0]
	cmp r1, #0
	bne .L02013CA2
	b .L02013D30
.L02013CA2:
	adds r0, r7, #4
	ldr r1, [r7]
	ldrb r2, [r1]
	strb r2, [r0]
	ldr r0, .L02013CBC @ =0x0202CF7C
	ldr r1, [r0, #8]
	cmp r1, #0x30
	bne .L02013CC0
	adds r0, r7, #4
	movs r1, #0
	strb r1, [r0]
	b .L02013CC6
	.align 2, 0
.L02013CBC: .4byte 0x0202CF7C
.L02013CC0:
	ldr r0, [r7]
	adds r1, r0, #1
	str r1, [r7]
.L02013CC6:
	adds r0, r7, #4
	ldrb r1, [r0]
	cmp r1, #0xa
	bne .L02013CD4
	adds r0, r7, #4
	movs r1, #0
	strb r1, [r0]
.L02013CD4:
	ldr r0, .L02013D2C @ =0x0202CF7C
	ldr r1, .L02013D2C @ =0x0202CF7C
	ldr r2, .L02013D2C @ =0x0202CF7C
	ldr r3, [r2, #0xc]
	movs r4, #0xff
	adds r2, r3, #0
	ands r2, r4
	adds r3, r2, #0
	lsls r2, r3, #5
	ldr r3, [r1, #8]
	adds r1, r2, r3
	adds r2, r0, #0
	adds r2, #0x14
	adds r0, r2, r1
	adds r1, r7, #4
	ldrb r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrb r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strb r1, [r0]
	ldr r1, .L02013D2C @ =0x0202CF7C
	ldr r0, .L02013D2C @ =0x0202CF7C
	ldr r1, .L02013D2C @ =0x0202CF7C
	ldr r2, [r1, #8]
	adds r1, r2, #1
	str r1, [r0, #8]
	adds r0, r7, #4
	ldrb r1, [r0]
	cmp r1, #0
	bne .L02013D2A
	ldr r0, .L02013D2C @ =0x0202CF7C
	movs r1, #0
	str r1, [r0, #8]
	ldr r1, .L02013D2C @ =0x0202CF7C
	ldr r0, .L02013D2C @ =0x0202CF7C
	ldr r1, .L02013D2C @ =0x0202CF7C
	ldr r2, [r1, #0xc]
	adds r1, r2, #1
	str r1, [r0, #0xc]
.L02013D2A:
	b .L02013C98
	.align 2, 0
.L02013D2C: .4byte 0x0202CF7C
.L02013D30:
	ldr r0, .L02013D54 @ =0x0202CF7C
	ldr r1, .L02013D54 @ =0x0202CF7C
	ldr r2, [r1, #0x10]
	adds r1, r2, #0
	adds r1, #0x14
	ldr r0, [r0, #0xc]
	cmp r0, r1
	bls .L02013D4C
	ldr r0, .L02013D54 @ =0x0202CF7C
	ldr r1, .L02013D54 @ =0x0202CF7C
	ldr r2, [r1, #0xc]
	adds r1, r2, #0
	subs r1, #0x14
	str r1, [r0, #0x10]
.L02013D4C:
	add sp, #8
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013D54: .4byte 0x0202CF7C

	thumb_func_start DebugPutScreen
DebugPutScreen: @ 0x02013D58
	push {r4, r7, lr}
	sub sp, #0x10
	mov r7, sp
	ldr r1, .L02013D74 @ =0x0202BA20
	adds r0, r1, #0
	movs r1, #0
	bl TmFill
	movs r0, #0
	str r0, [r7, #0xc]
.L02013D6C:
	ldr r0, [r7, #0xc]
	cmp r0, #0x13
	ble .L02013D78
	b .L02013E2C
	.align 2, 0
.L02013D74: .4byte 0x0202BA20
.L02013D78:
	ldr r1, [r7, #0xc]
	lsls r0, r1, #5
	adds r1, r0, #0
	lsls r0, r1, #1
	ldr r1, .L02013DAC @ =0x0202BA20
	adds r0, r1, r0
	str r0, [r7]
	movs r0, #0
	str r0, [r7, #8]
.L02013D8A:
	ldr r0, .L02013DB0 @ =0x0202CF7C
	ldr r1, .L02013DB0 @ =0x0202CF7C
	ldr r2, [r7, #0xc]
	ldr r3, [r1, #0x10]
	adds r1, r2, r3
	movs r2, #0xff
	ands r1, r2
	adds r2, r1, #0
	lsls r1, r2, #5
	ldr r2, [r7, #8]
	adds r1, r1, r2
	adds r0, #0x14
	adds r1, r0, r1
	ldrb r0, [r1]
	cmp r0, #0
	bne .L02013DB4
	b .L02013E24
	.align 2, 0
.L02013DAC: .4byte 0x0202BA20
.L02013DB0: .4byte 0x0202CF7C
.L02013DB4:
	adds r0, r7, #4
	ldr r1, .L02013DF0 @ =0x0202CF7C
	ldr r2, .L02013DF0 @ =0x0202CF7C
	ldr r3, [r7, #0xc]
	ldr r4, [r2, #0x10]
	adds r2, r3, r4
	movs r3, #0xff
	ands r2, r3
	adds r3, r2, #0
	lsls r2, r3, #5
	ldr r3, [r7, #8]
	adds r2, r2, r3
	adds r1, #0x14
	adds r2, r1, r2
	ldrb r1, [r2]
	adds r2, r1, #0
	strh r2, [r0]
	adds r0, r7, #4
	ldrh r1, [r0]
	cmp r1, #0x60
	bls .L02013DF4
	adds r0, r7, #4
	adds r1, r7, #4
	ldrh r2, [r1]
	adds r1, r2, #0
	subs r1, #0x40
	adds r2, r1, #0
	strh r2, [r0]
	b .L02013E02
	.align 2, 0
.L02013DF0: .4byte 0x0202CF7C
.L02013DF4:
	adds r0, r7, #4
	adds r1, r7, #4
	ldrh r2, [r1]
	adds r1, r2, #0
	subs r1, #0x20
	adds r2, r1, #0
	strh r2, [r0]
.L02013E02:
	ldr r0, [r7]
	adds r1, r7, #4
	ldr r2, .L02013E20 @ =0x0202CF7C
	ldrh r1, [r1]
	ldrh r2, [r2, #6]
	adds r1, r1, r2
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #2
	str r1, [r7]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L02013D8A
	.align 2, 0
.L02013E20: .4byte 0x0202CF7C
.L02013E24:
	ldr r0, [r7, #0xc]
	adds r1, r0, #1
	str r1, [r7, #0xc]
	b .L02013D6C
.L02013E2C:
	movs r0, #4
	bl EnableBgSync
	add sp, #0x10
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start DebugUpdateScreen
DebugUpdateScreen: @ 0x02013E3C
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	adds r2, r0, #0
	adds r0, r1, #0
	adds r1, r7, #0
	strh r2, [r1]
	adds r1, r7, #2
	strh r0, [r1]
	adds r0, r7, #2
	ldrh r1, [r0]
	movs r2, #2
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	lsrs r0, r1, #0x10
	cmp r0, #0
	beq .L02013E66
	movs r0, #0
	b .L02013EF4
.L02013E66:
	bl DebugPutScreen
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, [r0, #0xc]
	ldr r2, .L02013EF0 @ =0xFFFFFF00
	adds r0, r1, r2
	str r0, [r7, #4]
	ldr r0, [r7, #4]
	cmp r0, #0
	bge .L02013E7E
	movs r0, #0
	str r0, [r7, #4]
.L02013E7E:
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, [r0, #0xc]
	adds r0, r1, #0
	subs r0, #0x14
	str r0, [r7, #8]
	ldr r0, [r7, #8]
	cmp r0, #0
	bge .L02013E92
	movs r0, #0
	str r0, [r7, #8]
.L02013E92:
	adds r0, r7, #0
	ldrh r1, [r0]
	movs r2, #0x40
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	lsrs r0, r1, #0x10
	cmp r0, #0
	beq .L02013EBC
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, [r7, #4]
	ldr r0, [r0, #0x10]
	cmp r1, r0
	bhs .L02013EBC
	ldr r1, .L02013EEC @ =0x0202CF7C
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, .L02013EEC @ =0x0202CF7C
	ldr r2, [r1, #0x10]
	subs r1, r2, #1
	str r1, [r0, #0x10]
.L02013EBC:
	adds r0, r7, #0
	ldrh r1, [r0]
	movs r2, #0x80
	adds r0, r1, #0
	ands r0, r2
	adds r2, r0, #0
	lsls r1, r2, #0x10
	lsrs r0, r1, #0x10
	cmp r0, #0
	beq .L02013EE6
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, [r7, #8]
	ldr r0, [r0, #0x10]
	cmp r1, r0
	bls .L02013EE6
	ldr r1, .L02013EEC @ =0x0202CF7C
	ldr r0, .L02013EEC @ =0x0202CF7C
	ldr r1, .L02013EEC @ =0x0202CF7C
	ldr r2, [r1, #0x10]
	adds r1, r2, #1
	str r1, [r0, #0x10]
.L02013EE6:
	movs r0, #1
	b .L02013EF4
	.align 2, 0
.L02013EEC: .4byte 0x0202CF7C
.L02013EF0: .4byte 0xFFFFFF00
.L02013EF4:
	add sp, #0xc
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start DebugInitObj
DebugInitObj: @ 0x02013EFC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	ldr r0, [r7]
	cmp r0, #0
	bge .L02013F12
	movs r0, #0xc0
	lsls r0, r0, #6
	str r0, [r7]
.L02013F12:
	ldr r0, [r7]
	lsls r1, r0, #0x10
	lsrs r0, r1, #0x10
	str r0, [r7]
	ldr r0, .L02013FC8 @ =0x0202EF9C
	ldr r2, [r7]
	adds r1, r2, #0
	cmp r1, #0
	bge .L02013F26
	adds r1, #0x1f
.L02013F26:
	asrs r1, r1, #5
	str r1, [r0]
	ldr r0, .L02013FCC @ =0x0202EFA0
	ldr r1, [r7, #4]
	movs r2, #0xf
	ands r1, r2
	adds r2, r1, #0
	lsls r1, r2, #0xc
	str r1, [r0]
	ldr r0, .L02013FD0 @ =.L02017D64
	ldr r2, [r7]
	movs r3, #0x80
	lsls r3, r3, #9
	adds r1, r2, r3
	lsls r3, r1, #0xf
	lsrs r2, r3, #0xf
	movs r3, #0xc0
	lsls r3, r3, #0x13
	adds r1, r2, r3
	movs r2, #0x80
	lsls r2, r2, #4
	bl AsyncDataMove
	ldr r0, .L02013FD4 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r1, #0x10
	adds r2, r1, #0
	lsls r1, r2, #5
	adds r0, r0, r1
	ldrh r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02013FD4 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r1, #0x10
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #1
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	ldrh r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	movs r3, #0xf8
	lsls r3, r3, #7
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	ldr r0, .L02013FD4 @ =0x0202A620
	ldr r2, [r7, #4]
	adds r1, r2, #0
	adds r1, #0x10
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #2
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	ldrh r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	ldr r3, .L02013FD8 @ =0x00007FFF
	adds r1, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0]
	bl EnablePalSync
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02013FC8: .4byte 0x0202EF9C
.L02013FCC: .4byte 0x0202EFA0
.L02013FD0: .4byte .L02017D64
.L02013FD4: .4byte 0x0202A620
.L02013FD8: .4byte 0x00007FFF

	thumb_func_start DebugPutObjStr
DebugPutObjStr: @ 0x02013FDC
	push {r4, r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
.L02013FE8:
	ldr r0, [r7, #8]
	ldrb r1, [r0]
	cmp r1, #0
	bne .L02013FF2
	b .L02014050
.L02013FF2:
	adds r0, r7, #0
	adds r0, #0xc
	ldr r1, [r7, #8]
	ldrb r2, [r1]
	cmp r2, #0x60
	bls .L0201400A
	ldr r1, [r7, #8]
	ldrb r2, [r1]
	adds r3, r2, #0
	subs r3, #0x40
	adds r1, r3, #0
	b .L02014014
.L0201400A:
	ldr r2, [r7, #8]
	ldrb r3, [r2]
	adds r2, r3, #0
	subs r2, #0x20
	adds r1, r2, #0
.L02014014:
	strb r1, [r0]
	ldr r1, [r7, #4]
	ldr r2, .L02014044 @ =.L02018564
	adds r3, r7, #0
	adds r3, #0xc
	ldrb r0, [r3]
	ldr r3, .L02014048 @ =0x0202EF9C
	ldr r4, [r3]
	adds r0, r0, r4
	ldr r3, .L0201404C @ =0x0202EFA0
	ldr r4, [r3]
	adds r3, r0, r4
	ldr r0, [r7]
	bl PutOamHiRam
	ldr r0, [r7]
	adds r1, r0, #0
	adds r1, #8
	str r1, [r7]
	ldr r0, [r7, #8]
	adds r1, r0, #1
	str r1, [r7, #8]
	b .L02013FE8
	.align 2, 0
.L02014044: .4byte .L02018564
.L02014048: .4byte 0x0202EF9C
.L0201404C: .4byte 0x0202EFA0
.L02014050:
	add sp, #0x10
	pop {r4, r7}
	pop {r0}
	bx r0

	thumb_func_start DebugPutObjNumber
DebugPutObjNumber: @ 0x02014058
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r1, [r7, #8]
	adds r0, r1, #0
	bl GenNumberStr
	ldr r1, [r7, #4]
	ldr r0, .L02014084 @ =0x0202EF98
	ldr r3, [r7, #0xc]
	subs r2, r0, r3
	ldr r0, [r7]
	bl DebugPutObjStr
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014084: .4byte 0x0202EF98

	thumb_func_start DebugPutObjNumberHex
DebugPutObjNumberHex: @ 0x02014088
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r1, [r7, #8]
	adds r0, r1, #0
	bl GenNumberHexStr
	ldr r1, [r7, #4]
	ldr r0, .L020140B4 @ =0x0202EF98
	ldr r3, [r7, #0xc]
	subs r2, r0, r3
	ldr r0, [r7]
	bl DebugPutObjStr
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020140B4: .4byte 0x0202EF98

	thumb_func_start PutSpriteAffine
PutSpriteAffine: @ 0x020140B8
	push {r4, r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	adds r4, r1, #0
	adds r1, r3, #0
	ldr r0, [r7, #0x18]
	adds r3, r7, #4
	strh r4, [r3]
	adds r3, r7, #6
	strh r2, [r3]
	adds r2, r7, #0
	adds r2, #8
	strh r1, [r2]
	adds r1, r7, #0
	adds r1, #0xa
	strh r0, [r1]
	ldr r0, .L0201417C @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #3
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #4
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L0201417C @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #7
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #6
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L0201417C @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #0
	adds r2, #0xb
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #0
	adds r1, #8
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	ldr r0, .L0201417C @ =0x03000400
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r2, r1, #0
	adds r2, #0xf
	adds r1, r2, #0
	lsls r2, r1, #1
	adds r0, r0, r2
	adds r1, r7, #0
	adds r1, #0xa
	ldrh r2, [r0]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	ldrh r1, [r1]
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0]
	add sp, #0xc
	pop {r4, r7}
	pop {r0}
	bx r0
	.align 2, 0
.L0201417C: .4byte 0x03000400

	thumb_func_start ClearSprites
ClearSprites: @ 0x02014180
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	movs r0, #0xf
	str r0, [r7]
.L0201418A:
	ldr r0, [r7]
	cmp r0, #0
	bge .L02014192
	b .L020141C8
.L02014192:
	ldr r0, .L020141C0 @ =0x0202F7A4
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r0, r0, r1
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	ldr r2, .L020141C4 @ =0x0202F7B4
	adds r1, r2, r1
	str r1, [r0]
	ldr r0, .L020141C0 @ =0x0202F7A4
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r0, #0xc
	adds r1, r0, r1
	movs r0, #0
	str r0, [r1]
	ldr r0, [r7]
	subs r1, r0, #1
	str r1, [r7]
	b .L0201418A
	.align 2, 0
.L020141C0: .4byte 0x0202F7A4
.L020141C4: .4byte 0x0202F7B4
.L020141C8:
	ldr r1, .L020141EC @ =0x0202F7A4
	adds r0, r1, #0
	adds r1, #0xf0
	movs r0, #0
	str r0, [r1]
	ldr r1, .L020141EC @ =0x0202F7A4
	adds r0, r1, #0
	adds r1, #0xc0
	movs r0, #0
	str r0, [r1]
	ldr r0, .L020141F0 @ =0x03001C20
	ldr r1, .L020141F4 @ =0x0202EFA4
	str r1, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020141EC: .4byte 0x0202F7A4
.L020141F0: .4byte 0x03001C20
.L020141F4: .4byte 0x0202EFA4

	thumb_func_start PutSprite
PutSprite: @ 0x020141F8
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, [r1]
	ldr r1, .L02014298 @ =0x0202F7A4
	ldr r2, [r7]
	adds r3, r2, #0
	lsls r2, r3, #4
	adds r1, r1, r2
	ldr r2, [r1]
	str r2, [r0]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #4]
	adds r1, r2, #0
	lsls r2, r1, #0x17
	lsrs r1, r2, #0x17
	ldrh r2, [r0, #4]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #4]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	movs r2, #0xff
	ands r1, r2
	ldrh r2, [r0, #6]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	adds r2, r3, #0
	orrs r2, r1
	adds r1, r2, #0
	strh r1, [r0, #6]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #0x18]
	adds r1, r2, #0
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, [r1]
	ldr r1, [r7, #0xc]
	str r1, [r0, #0xc]
	ldr r0, .L02014298 @ =0x0202F7A4
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r0, r0, r1
	ldr r1, .L02014294 @ =0x03001C20
	ldr r2, [r1]
	str r2, [r0]
	ldr r1, .L02014294 @ =0x03001C20
	ldr r0, .L02014294 @ =0x03001C20
	ldr r1, .L02014294 @ =0x03001C20
	ldr r2, [r1]
	adds r1, r2, #0
	adds r1, #0x10
	str r1, [r0]
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014294: .4byte 0x03001C20
.L02014298: .4byte 0x0202F7A4

	thumb_func_start PutSpriteExt
PutSpriteExt: @ 0x0201429C
	push {r7, lr}
	sub sp, #0x10
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, [r1]
	ldr r1, .L02014330 @ =0x0202F7A4
	ldr r2, [r7]
	adds r3, r2, #0
	lsls r2, r3, #4
	adds r1, r1, r2
	ldr r2, [r1]
	str r2, [r0]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #4]
	adds r1, r2, #0
	ldrh r2, [r0, #4]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #4]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #8]
	adds r1, r2, #0
	ldrh r2, [r0, #6]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #6]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, [r1]
	ldr r2, [r7, #0x18]
	adds r1, r2, #0
	ldrh r2, [r0, #8]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r1, r3
	adds r2, r1, #0
	strh r2, [r0, #8]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, [r1]
	ldr r1, [r7, #0xc]
	str r1, [r0, #0xc]
	ldr r0, .L02014330 @ =0x0202F7A4
	ldr r1, [r7]
	adds r2, r1, #0
	lsls r1, r2, #4
	adds r0, r0, r1
	ldr r1, .L0201432C @ =0x03001C20
	ldr r2, [r1]
	str r2, [r0]
	ldr r1, .L0201432C @ =0x03001C20
	ldr r0, .L0201432C @ =0x03001C20
	ldr r1, .L0201432C @ =0x03001C20
	ldr r2, [r1]
	adds r1, r2, #0
	adds r1, #0x10
	str r1, [r0]
	add sp, #0x10
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L0201432C: .4byte 0x03001C20
.L02014330: .4byte 0x0202F7A4

	thumb_func_start PutSpriteLayerOam
PutSpriteLayerOam: @ 0x02014334
	push {r4, r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	ldr r0, [r7]
	adds r1, r0, #0
	lsls r0, r1, #4
	ldr r1, .L02014350 @ =0x0202F7A4
	adds r0, r1, r0
	str r0, [r7, #4]
.L02014348:
	ldr r0, [r7, #4]
	cmp r0, #0
	bne .L02014354
	b .L02014384
	.align 2, 0
.L02014350: .4byte 0x0202F7A4
.L02014354:
	ldr r0, [r7, #4]
	ldr r1, [r0, #0xc]
	cmp r1, #0
	bne .L02014364
	ldr r0, [r7, #4]
	ldr r1, [r0]
	str r1, [r7, #4]
	b .L02014348
.L02014364:
	ldr r1, [r7, #4]
	movs r2, #4
	ldrsh r0, [r1, r2]
	ldr r2, [r7, #4]
	movs r3, #6
	ldrsh r1, [r2, r3]
	ldr r3, [r7, #4]
	ldr r2, [r3, #0xc]
	ldr r4, [r7, #4]
	ldrh r3, [r4, #8]
	bl PutOamHiRam
	ldr r0, [r7, #4]
	ldr r1, [r0]
	str r1, [r7, #4]
	b .L02014348
.L02014384:
	add sp, #8
	pop {r4, r7}
	pop {r0}
	bx r0

	thumb_func_start SpriteRefresher_Loop
SpriteRefresher_Loop: @ 0x0201438C
	push {r4, r5, r7, lr}
	sub sp, #8
	add r7, sp, #4
	str r0, [r7]
	ldr r1, [r7]
	adds r0, r1, #0
	adds r1, #0x50
	movs r2, #0
	ldrsh r0, [r1, r2]
	ldr r2, [r7]
	ldr r1, [r2, #0x2c]
	ldr r3, [r7]
	ldr r2, [r3, #0x30]
	ldr r4, [r7]
	ldr r3, [r4, #0x54]
	ldr r5, [r7]
	adds r4, r5, #0
	adds r5, #0x52
	ldrh r4, [r5]
	str r4, [sp]
	bl PutSprite
	add sp, #8
	pop {r4, r5, r7}
	pop {r0}
	bx r0

	thumb_func_start StartSpriteRefresher
StartSpriteRefresher: @ 0x020143C0
	push {r7, lr}
	sub sp, #0x14
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	str r3, [r7, #0xc]
	ldr r0, [r7]
	cmp r0, #0
	beq .L020143E8
	ldr r1, .L020143E4 @ =.L020185F4
	adds r0, r1, #0
	ldr r1, [r7]
	bl SpawnProc
	str r0, [r7, #0x10]
	b .L020143F4
	.align 2, 0
.L020143E4: .4byte .L020185F4
.L020143E8:
	ldr r1, .L0201443C @ =.L020185F4
	adds r0, r1, #0
	movs r1, #3
	bl SpawnProc
	str r0, [r7, #0x10]
.L020143F4:
	ldr r0, [r7, #0x10]
	ldr r1, [r7, #8]
	str r1, [r0, #0x2c]
	ldr r0, [r7, #0x10]
	ldr r1, [r7, #0xc]
	str r1, [r0, #0x30]
	ldr r1, [r7, #0x10]
	ldr r2, [r7, #4]
	adds r0, r2, #0
	adds r2, r1, #0
	adds r1, #0x50
	ldrh r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strh r2, [r1]
	ldr r0, [r7, #0x10]
	ldr r1, [r7, #0x1c]
	str r1, [r0, #0x54]
	ldr r1, [r7, #0x10]
	ldr r2, [r7, #0x20]
	adds r0, r2, #0
	adds r2, r1, #0
	adds r1, #0x52
	ldrh r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strh r2, [r1]
	ldr r1, [r7, #0x10]
	adds r0, r1, #0
	b .L02014440
	.align 2, 0
.L0201443C: .4byte .L020185F4
.L02014440:
	add sp, #0x14
	pop {r7}
	pop {r1}
	bx r1

	thumb_func_start MoveSpriteRefresher
MoveSpriteRefresher: @ 0x02014448
	push {r7, lr}
	sub sp, #0xc
	mov r7, sp
	str r0, [r7]
	str r1, [r7, #4]
	str r2, [r7, #8]
	ldr r0, [r7]
	cmp r0, #0
	bne .L02014464
	ldr r1, .L02014478 @ =.L020185F4
	adds r0, r1, #0
	bl FindProc
	str r0, [r7]
.L02014464:
	ldr r0, [r7]
	ldr r1, [r7, #4]
	str r1, [r0, #0x2c]
	ldr r0, [r7]
	ldr r1, [r7, #8]
	str r1, [r0, #0x30]
	add sp, #0xc
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014478: .4byte .L020185F4

	thumb_func_start OnVBlank
OnVBlank: @ 0x0201447C
	push {r7, lr}
	mov r7, sp
	ldr r0, .L020144B8 @ =0x03007FF8
	movs r1, #1
	strh r1, [r0]
	bl IncGameTime
	ldr r0, .L020144BC @ =0x0202CF5C
	ldr r1, [r0]
	adds r0, r1, #0
	bl Proc_Run
	bl SyncLoOam
	ldr r0, .L020144C0 @ =0x03000030
	movs r1, #0
	ldrsb r1, [r0, r1]
	cmp r1, #0
	beq .L020144B2
	bl SyncDispIo
	bl SyncBgsAndPal
	bl ApplySyncData
	bl SyncHiOam
.L020144B2:
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L020144B8: .4byte 0x03007FF8
.L020144BC: .4byte 0x0202CF5C
.L020144C0: .4byte 0x03000030

	thumb_func_start OnMain
OnMain: @ 0x020144C4
	push {r7, lr}
	mov r7, sp
	ldr r0, .L02014518 @ =gKeySt
	ldr r1, [r0]
	adds r0, r1, #0
	bl RefreshKeySt
	bl ClearSprites
	ldr r0, .L0201451C @ =0x0202CF5C
	ldr r1, [r0, #4]
	adds r0, r1, #0
	bl Proc_Run
	ldr r0, .L0201451C @ =0x0202CF5C
	ldr r1, [r0, #8]
	adds r0, r1, #0
	bl Proc_Run
	ldr r0, .L0201451C @ =0x0202CF5C
	ldr r1, [r0, #0xc]
	adds r0, r1, #0
	bl Proc_Run
	ldr r0, .L0201451C @ =0x0202CF5C
	ldr r1, [r0, #0x14]
	adds r0, r1, #0
	bl Proc_Run
	ldr r0, .L0201451C @ =0x0202CF5C
	ldr r1, [r0, #0x10]
	adds r0, r1, #0
	bl Proc_Run
	ldr r0, .L02014520 @ =0x03000030
	movs r1, #1
	strb r1, [r0]
	bl SwiVBlankIntrWait
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014518: .4byte gKeySt
.L0201451C: .4byte 0x0202CF5C
.L02014520: .4byte 0x03000030

	thumb_func_start StartMainProc
StartMainProc: @ 0x02014524
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r1, .L02014580 @ =OnMain
	adds r0, r1, #0
	bl SetMainFunc
	ldr r1, .L02014584 @ =OnVBlank
	adds r0, r1, #0
	bl SetOnVBlank
	ldr r1, .L02014588 @ =.L02018604
	adds r0, r1, #0
	movs r1, #3
	bl SpawnProc
	str r0, [r7]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x29
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x2a
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	ldr r0, [r7]
	adds r1, r0, #0
	adds r0, #0x2b
	ldrb r1, [r0]
	movs r2, #0
	ands r1, r2
	adds r2, r1, #0
	strb r2, [r0]
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014580: .4byte OnMain
.L02014584: .4byte OnVBlank
.L02014588: .4byte .L02018604

	thumb_func_start GetMainProc
GetMainProc: @ 0x0201458C
	push {r7, lr}
	mov r7, sp
	ldr r1, .L020145A0 @ =.L02018604
	adds r0, r1, #0
	bl FindProc
	adds r1, r0, #0
	adds r0, r1, #0
	b .L020145A4
	.align 2, 0
.L020145A0: .4byte .L02018604
.L020145A4:
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_020145AC
func_020145AC: @ 0x020145AC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	bl GetMainProc
	str r0, [r7, #4]
	ldr r1, [r7, #4]
	ldr r2, [r7]
	adds r0, r2, #0
	adds r2, r1, #0
	adds r1, #0x29
	ldrb r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strb r2, [r1]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_020145DC
func_020145DC: @ 0x020145DC
	push {r7, lr}
	sub sp, #8
	mov r7, sp
	str r0, [r7]
	bl GetMainProc
	str r0, [r7, #4]
	ldr r1, [r7, #4]
	ldr r2, [r7]
	adds r0, r2, #0
	adds r2, r1, #0
	adds r1, #0x2a
	ldrb r2, [r1]
	movs r3, #0
	ands r2, r3
	adds r3, r2, #0
	orrs r0, r3
	adds r2, r0, #0
	strb r2, [r1]
	add sp, #8
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0

	thumb_func_start func_0201460C
func_0201460C: @ 0x0201460C
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	bl GetMainProc
	str r0, [r7]
	movs r0, #0
	ldr r2, [r7]
	adds r1, r2, #0
	adds r2, #0x2a
	ldrb r1, [r2]
	cmp r1, #0
	beq .L02014628
	movs r0, #1
.L02014628:
	b .L0201462A
.L0201462A:
	add sp, #4
	pop {r7}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start func_02014634
func_02014634: @ 0x02014634
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r1, .L02014660 @ =.L02018604
	adds r0, r1, #0
	bl Proc_EndEach
	ldr r1, .L02014660 @ =.L02018604
	adds r0, r1, #0
	movs r1, #3
	bl SpawnProc
	str r0, [r7]
	ldr r0, [r7]
	movs r1, #5
	bl Proc_Goto
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014660: .4byte .L02018604

	thumb_func_start func_02014664
func_02014664: @ 0x02014664
	push {r7, lr}
	sub sp, #4
	mov r7, sp
	ldr r1, .L02014690 @ =.L02018604
	adds r0, r1, #0
	bl Proc_EndEach
	ldr r1, .L02014690 @ =.L02018604
	adds r0, r1, #0
	movs r1, #3
	bl SpawnProc
	str r0, [r7]
	ldr r0, [r7]
	movs r1, #6
	bl Proc_Goto
	add sp, #4
	pop {r7}
	pop {r0}
	bx r0
	.align 2, 0
.L02014690: .4byte .L02018604

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
	ldr r1, .L020146F4 @ =0x03002ED0
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
.L020146F4: .4byte 0x03002ED0
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
	ldr r5, .L020147F0 @ =.L02018644
	ldr r1, [r5]
	ldr r4, .L020147F4 @ =0x000070F4
	adds r1, r1, r4
	mov r0, sp
	movs r2, #4
	bl WriteSramFast
	ldr r2, .L020147F8 @ =0x03002ED0
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
.L020147F0: .4byte .L02018644
.L020147F4: .4byte 0x000070F4
.L020147F8: .4byte 0x03002ED0
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
	ldr r6, .L02014850 @ =.L02018644
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
.L02014850: .4byte .L02018644
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
	ldr r1, .L020148E0 @ =0x03002ED0
	ldr r0, .L020148E4 @ =.L02018644
	ldr r0, [r0]
	ldr r3, [r1]
	adds r1, r4, #0
	movs r2, #0x20
	bl _call_via_r3
	ldr r1, .L020148E8 @ =.L0201736C
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
.L020148E0: .4byte 0x03002ED0
.L020148E4: .4byte .L02018644
.L020148E8: .4byte .L0201736C
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
	ldr r0, .L02014920 @ =.L02018644
	ldr r1, [r0]
	adds r0, r4, #0
	movs r2, #0x20
	bl func_02014810
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014920: .4byte .L02018644

	thumb_func_start WriteGlobalSaveInfoNoChecksum
WriteGlobalSaveInfoNoChecksum: @ 0x02014924
	push {lr}
	ldr r1, .L02014934 @ =.L02018644
	ldr r1, [r1]
	movs r2, #0x20
	bl func_02014810
	pop {r0}
	bx r0
	.align 2, 0
.L02014934: .4byte .L02018644

	thumb_func_start InitGlobalSaveInfo
InitGlobalSaveInfo: @ 0x02014938
	push {lr}
	sub sp, #0x20
	bl WipeSram
	ldr r1, .L020149A8 @ =.L0201736C
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
.L020149A8: .4byte .L0201736C
.L020149AC: .4byte 0x00011217
.L020149B0: .4byte 0x0000200A

	thumb_func_start SramOffsetToAddr
SramOffsetToAddr: @ 0x020149B4
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	ldr r1, .L020149C4 @ =.L02018644
	ldr r1, [r1]
	adds r1, r1, r0
	adds r0, r1, #0
	bx lr
	.align 2, 0
.L020149C4: .4byte .L02018644

	thumb_func_start SramAddrToOffset
SramAddrToOffset: @ 0x020149C8
	ldr r1, .L020149D4 @ =.L02018644
	ldr r1, [r1]
	subs r0, r0, r1
	lsls r0, r0, #0x10
	lsrs r0, r0, #0x10
	bx lr
	.align 2, 0
.L020149D4: .4byte .L02018644

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
	ldr r2, .L02014A14 @ =0x03002ED0
	ldr r0, .L02014A18 @ =.L02018644
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
.L02014A14: .4byte 0x03002ED0
.L02014A18: .4byte .L02018644
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
	ldr r1, .L02014B4C @ =0x03002ED0
	ldr r3, [r1]
	adds r1, r4, #0
	movs r2, #0x20
	bl _call_via_r3
	pop {r4}
	pop {r0}
	bx r0
	.align 2, 0
.L02014B4C: .4byte 0x03002ED0

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
	ldr r1, .L02014B84 @ =0x03001CD0
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
.L02014B84: .4byte 0x03001CD0

	thumb_func_start ReadGameSavePackedUnit
ReadGameSavePackedUnit: @ 0x02014B88
	push {r4, r5, lr}
	sub sp, #0x28
	adds r4, r1, #0
	ldr r1, .L02014C90 @ =0x03002ED0
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
.L02014C90: .4byte 0x03002ED0

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
	bl SetIrqFunc
	movs r0, #0
	adds r1, r4, #0
	bl SetIrqFunc
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
	bl SetIrqFunc
	movs r0, #0
	movs r1, #0
	bl SetIrqFunc
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
	bl ApplySyncData
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
	ldr r3, .L020153F8 @ =0x03000350
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
.L020153F8: .4byte 0x03000350
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
	bl _umodsi3
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
	bl _divsi3
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
	ldr r5, .L02016414 @ =0x02028000
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
	bl _divsi3
	adds r1, r4, #0
	adds r1, #0x3b
	strb r0, [r1]
	b .L0201645C
	.align 2, 0
.L02016414: .4byte 0x02028000
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
	bl _divsi3
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
	bl _udivsi3
	adds r0, #1
	lsls r0, r0, #0x10
	lsrs r5, r0, #0x10
	adds r0, r4, #0
	movs r1, #0x7a
	bl _umodsi3
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
	ldr r6, .L020166B4 @ =0x02028000
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
.L020166B4: .4byte 0x02028000

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

	thumb_func_start SwiCpuFastSet
SwiCpuFastSet: @ 0x02016A9C
	svc #0xc
	bx lr

	thumb_func_start SwiCpuSet
SwiCpuSet: @ 0x02016AA0
	svc #0xb
	bx lr

	thumb_func_start SwiHuffUnCompReadNormal
SwiHuffUnCompReadNormal: @ 0x02016AA4
	svc #0x13
	bx lr

	thumb_func_start SwiLZ77UnCompReadNormalWrite16bit
SwiLZ77UnCompReadNormalWrite16bit: @ 0x02016AA8
	svc #0x12
	bx lr

	thumb_func_start SwiLZ77UnCompReadNormalWrite8bit
SwiLZ77UnCompReadNormalWrite8bit: @ 0x02016AAC
	svc #0x11
	bx lr

	thumb_func_start SwiRLUnCompReadNormalWrite16bit
SwiRLUnCompReadNormalWrite16bit: @ 0x02016AB0
	svc #0x15
	bx lr

	thumb_func_start SwiRLUnCompReadNormalWrite8bit
SwiRLUnCompReadNormalWrite8bit: @ 0x02016AB4
	svc #0x14
	bx lr

	thumb_func_start SwiSoftReset
SwiSoftReset: @ 0x02016AB8
	ldr r3, .L02016AC8 @ =0x04000208
	movs r2, #0
	strb r2, [r3]
	ldr r1, .L02016ACC @ =0x03007F00
	mov sp, r1
	svc #1
	svc #0
	movs r0, r0
	.align 2, 0
.L02016AC8: .4byte 0x04000208
.L02016ACC: .4byte 0x03007F00

	thumb_func_start SwiSoundBiasReset
SwiSoundBiasReset: @ 0x02016AD0
	movs r0, #0
	svc #0x19
	bx lr
	.align 2, 0

	thumb_func_start SwiSoundBiasSet
SwiSoundBiasSet: @ 0x02016AD8
	movs r0, #1
	svc #0x19
	bx lr
	.align 2, 0

	thumb_func_start SwiVBlankIntrWait
SwiVBlankIntrWait: @ 0x02016AE0
	movs r2, #0
	svc #5
	bx lr
	.align 2, 0

	thumb_func_start ReadSramFastFunc
ReadSramFastFunc: @ 0x02016AE8
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r1, #0
	adds r3, r2, #0
	ldr r2, .L02016B20 @ =0x04000204
	ldrh r0, [r2]
	ldr r1, .L02016B24 @ =0x0000FFFC
	ands r0, r1
	movs r1, #3
	orrs r0, r1
	strh r0, [r2]
	subs r3, #1
	movs r0, #1
	rsbs r0, r0, #0
	cmp r3, r0
	beq .L02016B18
	adds r1, r0, #0
.L02016B0A:
	ldrb r0, [r5]
	strb r0, [r4]
	adds r5, #1
	adds r4, #1
	subs r3, #1
	cmp r3, r1
	bne .L02016B0A
.L02016B18:
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016B20: .4byte 0x04000204
.L02016B24: .4byte 0x0000FFFC

	thumb_func_start WriteSramFast
WriteSramFast: @ 0x02016B28
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r1, #0
	adds r3, r2, #0
	ldr r2, .L02016B60 @ =0x04000204
	ldrh r0, [r2]
	ldr r1, .L02016B64 @ =0x0000FFFC
	ands r0, r1
	movs r1, #3
	orrs r0, r1
	strh r0, [r2]
	subs r3, #1
	movs r0, #1
	rsbs r0, r0, #0
	cmp r3, r0
	beq .L02016B58
	adds r1, r0, #0
.L02016B4A:
	ldrb r0, [r5]
	strb r0, [r4]
	adds r5, #1
	adds r4, #1
	subs r3, #1
	cmp r3, r1
	bne .L02016B4A
.L02016B58:
	pop {r4, r5}
	pop {r0}
	bx r0
	.align 2, 0
.L02016B60: .4byte 0x04000204
.L02016B64: .4byte 0x0000FFFC

	thumb_func_start VerifySramFastFunc
VerifySramFastFunc: @ 0x02016B68
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r1, #0
	adds r3, r2, #0
	ldr r2, .L02016B9C @ =0x04000204
	ldrh r0, [r2]
	ldr r1, .L02016BA0 @ =0x0000FFFC
	ands r0, r1
	movs r1, #3
	orrs r0, r1
	strh r0, [r2]
	subs r3, #1
	movs r0, #1
	rsbs r0, r0, #0
	cmp r3, r0
	beq .L02016BAA
	adds r2, r0, #0
.L02016B8A:
	ldrb r1, [r4]
	ldrb r0, [r5]
	adds r5, #1
	adds r4, #1
	cmp r1, r0
	beq .L02016BA4
	subs r0, r4, #1
	b .L02016BAC
	.align 2, 0
.L02016B9C: .4byte 0x04000204
.L02016BA0: .4byte 0x0000FFFC
.L02016BA4:
	subs r3, #1
	cmp r3, r2
	bne .L02016B8A
.L02016BAA:
	movs r0, #0
.L02016BAC:
	pop {r4, r5}
	pop {r1}
	bx r1
	.align 2, 0

	thumb_func_start SetSramFastFunc
SetSramFastFunc: @ 0x02016BB4
	ldr r2, .L02016BC8 @ =ReadSramFastFunc
	movs r0, #1
	eors r2, r0
	ldr r3, .L02016BCC @ =0x030002C0
	ldr r0, .L02016BD0 @ =WriteSramFast
	ldr r1, .L02016BC8 @ =ReadSramFastFunc
	subs r0, r0, r1
	lsls r0, r0, #0xf
	b .L02016BE0
	.align 2, 0
.L02016BC8: .4byte ReadSramFastFunc
.L02016BCC: .4byte 0x030002C0
.L02016BD0: .4byte WriteSramFast
.L02016BD4:
	ldrh r0, [r2]
	strh r0, [r3]
	adds r2, #2
	adds r3, #2
	subs r0, r1, #1
	lsls r0, r0, #0x10
.L02016BE0:
	lsrs r1, r0, #0x10
	cmp r1, #0
	bne .L02016BD4
	ldr r1, .L02016C00 @ =0x03002ED0
	ldr r0, .L02016C04 @ =0x030002C1
	str r0, [r1]
	ldr r2, .L02016C08 @ =VerifySramFastFunc
	movs r0, #1
	eors r2, r0
	ldr r3, .L02016C0C @ =0x03000220
	ldr r0, .L02016C10 @ =SetSramFastFunc
	ldr r1, .L02016C08 @ =VerifySramFastFunc
	subs r0, r0, r1
	lsls r0, r0, #0xf
	b .L02016C20
	.align 2, 0
.L02016C00: .4byte 0x03002ED0
.L02016C04: .4byte 0x030002C1
.L02016C08: .4byte VerifySramFastFunc
.L02016C0C: .4byte 0x03000220
.L02016C10: .4byte SetSramFastFunc
.L02016C14:
	ldrh r0, [r2]
	strh r0, [r3]
	adds r2, #2
	adds r3, #2
	subs r0, r1, #1
	lsls r0, r0, #0x10
.L02016C20:
	lsrs r1, r0, #0x10
	cmp r1, #0
	bne .L02016C14
	ldr r1, .L02016C3C @ =0x03002ED4
	ldr r0, .L02016C40 @ =0x03000221
	str r0, [r1]
	ldr r2, .L02016C44 @ =0x04000204
	ldrh r0, [r2]
	ldr r1, .L02016C48 @ =0x0000FFFC
	ands r0, r1
	movs r1, #3
	orrs r0, r1
	strh r0, [r2]
	bx lr
	.align 2, 0
.L02016C3C: .4byte 0x03002ED4
.L02016C40: .4byte 0x03000221
.L02016C44: .4byte 0x04000204
.L02016C48: .4byte 0x0000FFFC

	thumb_func_start WriteAndVerifySramFast
WriteAndVerifySramFast: @ 0x02016C4C
	push {r4, r5, r6, r7, lr}
	adds r6, r0, #0
	adds r5, r1, #0
	adds r4, r2, #0
	movs r7, #0
	b .L02016C5E
.L02016C58:
	adds r0, r7, #1
	lsls r0, r0, #0x18
	lsrs r7, r0, #0x18
.L02016C5E:
	cmp r7, #2
	bhi .L02016C80
	adds r0, r6, #0
	adds r1, r5, #0
	adds r2, r4, #0
	bl WriteSramFast
	ldr r0, .L02016C88 @ =0x03002ED4
	ldr r3, [r0]
	adds r0, r6, #0
	adds r1, r5, #0
	adds r2, r4, #0
	bl _call_via_r3
	adds r3, r0, #0
	cmp r3, #0
	bne .L02016C58
.L02016C80:
	adds r0, r3, #0
	pop {r4, r5, r6, r7}
	pop {r1}
	bx r1
	.align 2, 0
.L02016C88: .4byte 0x03002ED4
.L02016C8C:
	.byte 0x00, 0x47, 0xC0, 0x46

	thumb_func_start _call_via_r1
_call_via_r1: @ 0x02016C90
	bx r1
	nop

	thumb_func_start _call_via_r2
_call_via_r2: @ 0x02016C94
	bx r2
	nop

	thumb_func_start _call_via_r3
_call_via_r3: @ 0x02016C98
	bx r3
	nop

	thumb_func_start _call_via_r4
_call_via_r4: @ 0x02016C9C
	bx r4
	nop
.L02016CA0:
	.byte 0x28, 0x47, 0xC0, 0x46, 0x30, 0x47, 0xC0, 0x46, 0x38, 0x47, 0xC0, 0x46, 0x40, 0x47, 0xC0, 0x46
	.byte 0x48, 0x47, 0xC0, 0x46

	thumb_func_start _call_via_sl
_call_via_sl: @ 0x02016CB4
	bx sl
	nop
.L02016CB8:
	.byte 0x58, 0x47, 0xC0, 0x46, 0x60, 0x47, 0xC0, 0x46
	.byte 0x68, 0x47, 0xC0, 0x46, 0x70, 0x47, 0xC0, 0x46

	thumb_func_start _divsi3
_divsi3: @ 0x02016CC8
	cmp r1, #0
	beq .L02016D50
	push {r4}
	adds r4, r0, #0
	eors r4, r1
	mov ip, r4
	movs r3, #1
	movs r2, #0
	cmp r1, #0
	bpl .L02016CDE
	rsbs r1, r1, #0
.L02016CDE:
	cmp r0, #0
	bpl .L02016CE4
	rsbs r0, r0, #0
.L02016CE4:
	cmp r0, r1
	blo .L02016D42
	movs r4, #1
	lsls r4, r4, #0x1c
.L02016CEC:
	cmp r1, r4
	bhs .L02016CFA
	cmp r1, r0
	bhs .L02016CFA
	lsls r1, r1, #4
	lsls r3, r3, #4
	b .L02016CEC
.L02016CFA:
	lsls r4, r4, #3
.L02016CFC:
	cmp r1, r4
	bhs .L02016D0A
	cmp r1, r0
	bhs .L02016D0A
	lsls r1, r1, #1
	lsls r3, r3, #1
	b .L02016CFC
.L02016D0A:
	cmp r0, r1
	blo .L02016D12
	subs r0, r0, r1
	orrs r2, r3
.L02016D12:
	lsrs r4, r1, #1
	cmp r0, r4
	blo .L02016D1E
	subs r0, r0, r4
	lsrs r4, r3, #1
	orrs r2, r4
.L02016D1E:
	lsrs r4, r1, #2
	cmp r0, r4
	blo .L02016D2A
	subs r0, r0, r4
	lsrs r4, r3, #2
	orrs r2, r4
.L02016D2A:
	lsrs r4, r1, #3
	cmp r0, r4
	blo .L02016D36
	subs r0, r0, r4
	lsrs r4, r3, #3
	orrs r2, r4
.L02016D36:
	cmp r0, #0
	beq .L02016D42
	lsrs r3, r3, #4
	beq .L02016D42
	lsrs r1, r1, #4
	b .L02016D0A
.L02016D42:
	adds r0, r2, #0
	mov r4, ip
	cmp r4, #0
	bpl .L02016D4C
	rsbs r0, r0, #0
.L02016D4C:
	pop {r4}
	mov pc, lr
.L02016D50:
	push {lr}
	bl __div0
	movs r0, #0
	pop {pc}
	.align 2, 0

	thumb_func_start __div0
__div0: @ 0x02016D5C
	mov pc, lr
	.align 2, 0

	thumb_func_start _modsi3
_modsi3: @ 0x02016D60
	movs r3, #1
	cmp r1, #0
	beq .L02016E24
	bpl .L02016D6A
	rsbs r1, r1, #0
.L02016D6A:
	push {r4}
	push {r0}
	cmp r0, #0
	bpl .L02016D74
	rsbs r0, r0, #0
.L02016D74:
	cmp r0, r1
	blo .L02016E18
	movs r4, #1
	lsls r4, r4, #0x1c
.L02016D7C:
	cmp r1, r4
	bhs .L02016D8A
	cmp r1, r0
	bhs .L02016D8A
	lsls r1, r1, #4
	lsls r3, r3, #4
	b .L02016D7C
.L02016D8A:
	lsls r4, r4, #3
.L02016D8C:
	cmp r1, r4
	bhs .L02016D9A
	cmp r1, r0
	bhs .L02016D9A
	lsls r1, r1, #1
	lsls r3, r3, #1
	b .L02016D8C
.L02016D9A:
	movs r2, #0
	cmp r0, r1
	blo .L02016DA2
	subs r0, r0, r1
.L02016DA2:
	lsrs r4, r1, #1
	cmp r0, r4
	blo .L02016DB4
	subs r0, r0, r4
	mov ip, r3
	movs r4, #1
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016DB4:
	lsrs r4, r1, #2
	cmp r0, r4
	blo .L02016DC6
	subs r0, r0, r4
	mov ip, r3
	movs r4, #2
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016DC6:
	lsrs r4, r1, #3
	cmp r0, r4
	blo .L02016DD8
	subs r0, r0, r4
	mov ip, r3
	movs r4, #3
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016DD8:
	mov ip, r3
	cmp r0, #0
	beq .L02016DE6
	lsrs r3, r3, #4
	beq .L02016DE6
	lsrs r1, r1, #4
	b .L02016D9A
.L02016DE6:
	movs r4, #0xe
	lsls r4, r4, #0x1c
	ands r2, r4
	beq .L02016E18
	mov r3, ip
	movs r4, #3
	rors r3, r4
	tst r2, r3
	beq .L02016DFC
	lsrs r4, r1, #3
	adds r0, r0, r4
.L02016DFC:
	mov r3, ip
	movs r4, #2
	rors r3, r4
	tst r2, r3
	beq .L02016E0A
	lsrs r4, r1, #2
	adds r0, r0, r4
.L02016E0A:
	mov r3, ip
	movs r4, #1
	rors r3, r4
	tst r2, r3
	beq .L02016E18
	lsrs r4, r1, #1
	adds r0, r0, r4
.L02016E18:
	pop {r4}
	cmp r4, #0
	bpl .L02016E20
	rsbs r0, r0, #0
.L02016E20:
	pop {r4}
	mov pc, lr
.L02016E24:
	push {lr}
	bl __div0
	movs r0, #0
	pop {pc}
	.align 2, 0

	thumb_func_start _udivsi3
_udivsi3: @ 0x02016E30
	cmp r1, #0
	beq .L02016E9E
	movs r3, #1
	movs r2, #0
	push {r4}
	cmp r0, r1
	blo .L02016E98
	movs r4, #1
	lsls r4, r4, #0x1c
.L02016E42:
	cmp r1, r4
	bhs .L02016E50
	cmp r1, r0
	bhs .L02016E50
	lsls r1, r1, #4
	lsls r3, r3, #4
	b .L02016E42
.L02016E50:
	lsls r4, r4, #3
.L02016E52:
	cmp r1, r4
	bhs .L02016E60
	cmp r1, r0
	bhs .L02016E60
	lsls r1, r1, #1
	lsls r3, r3, #1
	b .L02016E52
.L02016E60:
	cmp r0, r1
	blo .L02016E68
	subs r0, r0, r1
	orrs r2, r3
.L02016E68:
	lsrs r4, r1, #1
	cmp r0, r4
	blo .L02016E74
	subs r0, r0, r4
	lsrs r4, r3, #1
	orrs r2, r4
.L02016E74:
	lsrs r4, r1, #2
	cmp r0, r4
	blo .L02016E80
	subs r0, r0, r4
	lsrs r4, r3, #2
	orrs r2, r4
.L02016E80:
	lsrs r4, r1, #3
	cmp r0, r4
	blo .L02016E8C
	subs r0, r0, r4
	lsrs r4, r3, #3
	orrs r2, r4
.L02016E8C:
	cmp r0, #0
	beq .L02016E98
	lsrs r3, r3, #4
	beq .L02016E98
	lsrs r1, r1, #4
	b .L02016E60
.L02016E98:
	adds r0, r2, #0
	pop {r4}
	mov pc, lr
.L02016E9E:
	push {lr}
	bl __div0
	movs r0, #0
	pop {pc}

	thumb_func_start _umodsi3
_umodsi3: @ 0x02016EA8
	cmp r1, #0
	beq .L02016F5E
	movs r3, #1
	cmp r0, r1
	bhs .L02016EB4
	mov pc, lr
.L02016EB4:
	push {r4}
	movs r4, #1
	lsls r4, r4, #0x1c
.L02016EBA:
	cmp r1, r4
	bhs .L02016EC8
	cmp r1, r0
	bhs .L02016EC8
	lsls r1, r1, #4
	lsls r3, r3, #4
	b .L02016EBA
.L02016EC8:
	lsls r4, r4, #3
.L02016ECA:
	cmp r1, r4
	bhs .L02016ED8
	cmp r1, r0
	bhs .L02016ED8
	lsls r1, r1, #1
	lsls r3, r3, #1
	b .L02016ECA
.L02016ED8:
	movs r2, #0
	cmp r0, r1
	blo .L02016EE0
	subs r0, r0, r1
.L02016EE0:
	lsrs r4, r1, #1
	cmp r0, r4
	blo .L02016EF2
	subs r0, r0, r4
	mov ip, r3
	movs r4, #1
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016EF2:
	lsrs r4, r1, #2
	cmp r0, r4
	blo .L02016F04
	subs r0, r0, r4
	mov ip, r3
	movs r4, #2
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016F04:
	lsrs r4, r1, #3
	cmp r0, r4
	blo .L02016F16
	subs r0, r0, r4
	mov ip, r3
	movs r4, #3
	rors r3, r4
	orrs r2, r3
	mov r3, ip
.L02016F16:
	mov ip, r3
	cmp r0, #0
	beq .L02016F24
	lsrs r3, r3, #4
	beq .L02016F24
	lsrs r1, r1, #4
	b .L02016ED8
.L02016F24:
	movs r4, #0xe
	lsls r4, r4, #0x1c
	ands r2, r4
	bne .L02016F30
	pop {r4}
	mov pc, lr
.L02016F30:
	mov r3, ip
	movs r4, #3
	rors r3, r4
	tst r2, r3
	beq .L02016F3E
	lsrs r4, r1, #3
	adds r0, r0, r4
.L02016F3E:
	mov r3, ip
	movs r4, #2
	rors r3, r4
	tst r2, r3
	beq .L02016F4C
	lsrs r4, r1, #2
	adds r0, r0, r4
.L02016F4C:
	mov r3, ip
	movs r4, #1
	rors r3, r4
	tst r2, r3
	beq .L02016F5A
	lsrs r4, r1, #1
	adds r0, r0, r4
.L02016F5A:
	pop {r4}
	mov pc, lr
.L02016F5E:
	push {lr}
	bl __div0
	movs r0, #0
	pop {pc}

	thumb_func_start memcpy
memcpy: @ 0x02016F68
	push {r4, r5, lr}
	adds r5, r0, #0
	adds r4, r5, #0
	adds r3, r1, #0
	cmp r2, #0xf
	bls .L02016FA8
	adds r0, r3, #0
	orrs r0, r5
	movs r1, #3
	ands r0, r1
	cmp r0, #0
	bne .L02016FA8
	adds r1, r5, #0
.L02016F82:
	ldm r3!, {r0}
	stm r1!, {r0}
	ldm r3!, {r0}
	stm r1!, {r0}
	ldm r3!, {r0}
	stm r1!, {r0}
	ldm r3!, {r0}
	stm r1!, {r0}
	subs r2, #0x10
	cmp r2, #0xf
	bhi .L02016F82
	cmp r2, #3
	bls .L02016FA6
.L02016F9C:
	ldm r3!, {r0}
	stm r1!, {r0}
	subs r2, #4
	cmp r2, #3
	bhi .L02016F9C
.L02016FA6:
	adds r4, r1, #0
.L02016FA8:
	subs r2, #1
	movs r0, #1
	rsbs r0, r0, #0
	cmp r2, r0
	beq .L02016FC2
	adds r1, r0, #0
.L02016FB4:
	ldrb r0, [r3]
	strb r0, [r4]
	adds r3, #1
	adds r4, #1
	subs r2, #1
	cmp r2, r1
	bne .L02016FB4
.L02016FC2:
	adds r0, r5, #0
	pop {r4, r5, pc}
	.align 2, 0

	thumb_func_start ClearOam_thm
ClearOam_thm: @ 0x02016FC8
	bx pc
	nop

	arm_func_start func_02016FCC
func_02016FCC: @ 0x02016FCC
	b ClearOam

	thumb_func_start Checksum32_thm
Checksum32_thm: @ 0x02016FD0
	bx pc
	nop

	arm_func_start func_02016FD4
func_02016FD4: @ 0x02016FD4
	b Checksum32

	.section ".rodata"

	.byte 0xC0, 0x03, 0x00, 0x03
	.byte 0xB1, 0x05, 0x01, 0x02, 0x3C, 0x00, 0x01, 0x02, 0x20, 0x14, 0x00, 0x03, 0xC0, 0x03, 0x00, 0x03
	.byte 0x04, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x03, 0x04, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03
	.byte 0x00, 0x00, 0x00, 0x03, 0x00, 0x00, 0x00, 0x03, 0x01, 0x00, 0x00, 0x03, 0x01, 0x00, 0x00, 0x03
	.byte 0x20, 0xA6, 0x02, 0x02, 0x50, 0x03, 0x00, 0x03, 0x54, 0x03, 0x00, 0x03, 0x5C, 0x03, 0x00, 0x03
	.byte 0x60, 0x03, 0x00, 0x03, 0x64, 0x03, 0x00, 0x03, 0x68, 0x03, 0x00, 0x03, 0x6C, 0x03, 0x00, 0x03
	.byte 0x70, 0x03, 0x00, 0x03, 0x74, 0x03, 0x00, 0x03, 0x78, 0x03, 0x00, 0x03, 0x7C, 0x03, 0x00, 0x03
	.byte 0x80, 0x03, 0x00, 0x03, 0x84, 0x03, 0x00, 0x03, 0x88, 0x03, 0x00, 0x03, 0x8C, 0x03, 0x00, 0x03
	.byte 0x94, 0x03, 0x00, 0x03, 0x96, 0x03, 0x00, 0x03, 0x98, 0x03, 0x00, 0x03, 0x9C, 0x03, 0x00, 0x03
	.byte 0xA0, 0x03, 0x00, 0x03, 0xA4, 0x03, 0x00, 0x03, 0xA8, 0x03, 0x00, 0x03, 0xAC, 0x03, 0x00, 0x03
	.byte 0xB0, 0x03, 0x00, 0x03, 0xB4, 0x03, 0x00, 0x03, 0x5C, 0x03, 0x00, 0x03, 0x60, 0x03, 0x00, 0x03
	.byte 0x64, 0x03, 0x00, 0x03, 0x68, 0x03, 0x00, 0x03, 0x20, 0xCA, 0x02, 0x02, 0x00, 0x00, 0x00, 0x03
	.byte 0x20, 0xAA, 0x02, 0x02, 0x20, 0xCA, 0x02, 0x02, 0x20, 0xB2, 0x02, 0x02, 0x20, 0xBA, 0x02, 0x02
	.byte 0x20, 0xC2, 0x02, 0x02, 0x01, 0x00, 0x00, 0x03, 0x20, 0xA6, 0x02, 0x02, 0x50, 0x03, 0x00, 0x03
	.byte 0x50, 0x03, 0x00, 0x03, 0x50, 0x03, 0x00, 0x03, 0x30, 0xCA, 0x02, 0x02, 0x30, 0xCA, 0x02, 0x02
	.byte 0x50, 0x03, 0x00, 0x03, 0x08, 0x00, 0x00, 0x03, 0x09, 0x00, 0x00, 0x03, 0x20, 0xAA, 0x02, 0x02
	.byte 0x08, 0x00, 0x00, 0x03, 0x09, 0x00, 0x00, 0x03, 0x00, 0xA0, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02
	.byte 0x20, 0xA0, 0x02, 0x02, 0x20, 0xA6, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02, 0x20, 0xA0, 0x02, 0x02
	.byte 0x00, 0xA0, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02, 0x20, 0xA0, 0x02, 0x02, 0x20, 0xA6, 0x02, 0x02
	.byte 0x00, 0xA0, 0x02, 0x02, 0x20, 0xA0, 0x02, 0x02, 0x20, 0xA6, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02
	.byte 0x20, 0xA0, 0x02, 0x02, 0x20, 0xA6, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02, 0x20, 0xA0, 0x02, 0x02
	.byte 0x20, 0xA6, 0x02, 0x02, 0x00, 0xA0, 0x02, 0x02, 0x20, 0xA0, 0x02, 0x02, 0x20, 0xA6, 0x02, 0x02
.L02017150:
	.byte 0x00, 0x00, 0x00, 0x60, 0x00, 0x00, 0x00, 0x00, 0x00, 0x68, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70
	.byte 0x00, 0x00, 0x00, 0x80, 0x00, 0x78, 0x00, 0x00, 0x50, 0x71, 0x01, 0x02, 0x5C, 0x03, 0x00, 0x03
	.byte 0x60, 0x03, 0x00, 0x03, 0x64, 0x03, 0x00, 0x03, 0x68, 0x03, 0x00, 0x03, 0x50, 0x03, 0x00, 0x03
	.byte 0x20, 0xA6, 0x02, 0x02, 0xEC, 0x7C, 0x01, 0x02, 0xE8, 0x7C, 0x01, 0x02, 0xFC, 0x03, 0x00, 0x03
	.byte 0x04, 0x0A, 0x00, 0x03, 0xFC, 0x03, 0x00, 0x03, 0x04, 0x0A, 0x00, 0x03, 0x50, 0x03, 0x00, 0x03
	.byte 0xCD, 0x1F, 0x01, 0x02, 0xFC, 0x03, 0x00, 0x03, 0x04, 0x0A, 0x00, 0x03, 0x4C, 0xCA, 0x02, 0x02
	.byte 0x54, 0xCA, 0x02, 0x02, 0x4C, 0xCA, 0x02, 0x02, 0x54, 0xCA, 0x02, 0x02, 0x4C, 0xCA, 0x02, 0x02
	.byte 0x54, 0xCA, 0x02, 0x02, 0x54, 0xCA, 0x02, 0x02, 0x4C, 0xCA, 0x02, 0x02, 0x20, 0x00, 0x00, 0x03
	.byte 0x00, 0x04, 0x00, 0x03, 0x10, 0x00, 0x00, 0x03, 0x20, 0x00, 0x00, 0x03, 0x10, 0x00, 0x00, 0x03
	.byte 0x00, 0x0A, 0x00, 0x03, 0x14, 0x14, 0x00, 0x03, 0x00, 0x04, 0x00, 0x03, 0xF4, 0x03, 0x00, 0x03
	.byte 0x20, 0x00, 0x00, 0x03, 0x40, 0x03, 0x00, 0x03, 0x00, 0x04, 0x00, 0x03, 0x00, 0x0A, 0x00, 0x03
	.byte 0x00, 0x05, 0x00, 0x03, 0x74, 0x04, 0x01, 0x02, 0x5C, 0x01, 0x01, 0x02, 0x10, 0x0A, 0x00, 0x03
	.byte 0xF8, 0x03, 0x00, 0x03, 0xC8, 0x03, 0x01, 0x02, 0x10, 0x14, 0x00, 0x03, 0x68, 0x04, 0x01, 0x02
	.byte 0xF8, 0x03, 0x00, 0x03, 0x10, 0x14, 0x00, 0x03, 0xD4, 0xCB, 0x02, 0x02, 0x34, 0xCF, 0x02, 0x02
	.byte 0x58, 0xCF, 0x02, 0x02, 0x5C, 0xCF, 0x02, 0x02, 0x58, 0xCF, 0x02, 0x02, 0x58, 0xCF, 0x02, 0x02
	.byte 0x5C, 0xCF, 0x02, 0x02, 0x5C, 0xCF, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02
	.byte 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02
	.byte 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0x81, 0x30, 0x01, 0x02
	.byte 0xB5, 0x30, 0x01, 0x02, 0xAD, 0x34, 0x01, 0x02, 0xD4, 0xCB, 0x02, 0x02, 0xD4, 0xCB, 0x02, 0x02
	.byte 0xD4, 0xCB, 0x02, 0x02, 0xFC, 0x7C, 0x01, 0x02, 0x64, 0x7D, 0x01, 0x02, 0x20, 0xA6, 0x02, 0x02
	.byte 0x7C, 0xCF, 0x02, 0x02, 0x7C, 0xCF, 0x02, 0x02, 0x7C, 0xCF, 0x02, 0x02, 0x20, 0xBA, 0x02, 0x02
	.byte 0x90, 0xEF, 0x02, 0x02, 0x90, 0xEF, 0x02, 0x02, 0x90, 0xEF, 0x02, 0x02, 0x98, 0xEF, 0x02, 0x02
.L020172B0:
	.byte 0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x41, 0x42, 0x43, 0x44, 0x45, 0x46
	.byte 0x00, 0x00, 0x00, 0x00, 0x90, 0xEF, 0x02, 0x02, 0xB0, 0x72, 0x01, 0x02, 0x98, 0xEF, 0x02, 0x02
	.byte 0x7C, 0xCF, 0x02, 0x02, 0x20, 0xBA, 0x02, 0x02, 0x7C, 0xCF, 0x02, 0x02, 0x7C, 0xCF, 0x02, 0x02
	.byte 0x9C, 0xEF, 0x02, 0x02, 0xA0, 0xEF, 0x02, 0x02, 0x64, 0x7D, 0x01, 0x02, 0x20, 0xA6, 0x02, 0x02
	.byte 0x64, 0x85, 0x01, 0x02, 0x9C, 0xEF, 0x02, 0x02, 0xA0, 0xEF, 0x02, 0x02, 0x98, 0xEF, 0x02, 0x02
	.byte 0x98, 0xEF, 0x02, 0x02, 0x00, 0x04, 0x00, 0x03, 0xA4, 0xF7, 0x02, 0x02, 0xB4, 0xF7, 0x02, 0x02
	.byte 0x20, 0x1C, 0x00, 0x03, 0xA4, 0xEF, 0x02, 0x02, 0x20, 0x1C, 0x00, 0x03, 0xA4, 0xF7, 0x02, 0x02
	.byte 0x20, 0x1C, 0x00, 0x03, 0xA4, 0xF7, 0x02, 0x02, 0xA4, 0xF7, 0x02, 0x02, 0xF4, 0x85, 0x01, 0x02
	.byte 0xF4, 0x85, 0x01, 0x02, 0x47, 0x41, 0x4D, 0x45, 0x43, 0x54, 0x52, 0x4C, 0x00, 0x00, 0x00, 0x00
	.byte 0x5C, 0xCF, 0x02, 0x02, 0x30, 0x00, 0x00, 0x03, 0xE8, 0x7C, 0x01, 0x02, 0x5C, 0xCF, 0x02, 0x02
	.byte 0x30, 0x00, 0x00, 0x03, 0xC5, 0x44, 0x01, 0x02, 0x7D, 0x44, 0x01, 0x02, 0x04, 0x86, 0x01, 0x02
	.byte 0x04, 0x86, 0x01, 0x02, 0x04, 0x86, 0x01, 0x02, 0x04, 0x86, 0x01, 0x02
.L0201736C:
	.byte 0x41, 0x47, 0x42, 0x2D
	.byte 0x46, 0x45, 0x36, 0x00
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
	.byte 0x53, 0x52, 0x41, 0x4D, 0x5F, 0x46, 0x5F, 0x56, 0x31, 0x30, 0x32, 0x00, 0xE9, 0x6A, 0x01, 0x02
	.byte 0xC0, 0x02, 0x00, 0x03, 0x29, 0x6B, 0x01, 0x02, 0xD0, 0x2E, 0x00, 0x03, 0xC1, 0x02, 0x00, 0x03
	.byte 0x69, 0x6B, 0x01, 0x02, 0x20, 0x02, 0x00, 0x03, 0xB5, 0x6B, 0x01, 0x02, 0xD4, 0x2E, 0x00, 0x03
	.byte 0x21, 0x02, 0x00, 0x03, 0xD4, 0x2E, 0x00, 0x03
	.global gKeySt
	.type gKeySt, object
gKeySt:
	.byte 0x38, 0xCA, 0x02, 0x02
.L02017CEC:
	.byte 0x20, 0xAA, 0x02, 0x02
	.byte 0x20, 0xB2, 0x02, 0x02, 0x20, 0xBA, 0x02, 0x02, 0x20, 0xC2, 0x02, 0x02
.L02017CFC:
	.byte 0x65, 0x31, 0x01, 0x02
	.byte 0x81, 0x31, 0x01, 0x02, 0xAD, 0x31, 0x01, 0x02, 0xB1, 0x32, 0x01, 0x02, 0xDD, 0x32, 0x01, 0x02
	.byte 0x0D, 0x33, 0x01, 0x02, 0x3D, 0x33, 0x01, 0x02, 0x6D, 0x33, 0x01, 0x02, 0xA1, 0x33, 0x01, 0x02
	.byte 0xE1, 0x33, 0x01, 0x02, 0x11, 0x34, 0x01, 0x02, 0x41, 0x34, 0x01, 0x02, 0x89, 0x34, 0x01, 0x02
	.byte 0x65, 0x34, 0x01, 0x02, 0xE9, 0x34, 0x01, 0x02, 0x39, 0x35, 0x01, 0x02, 0x9D, 0x35, 0x01, 0x02
	.byte 0xB1, 0x35, 0x01, 0x02, 0xED, 0x36, 0x01, 0x02, 0x79, 0x35, 0x01, 0x02, 0x65, 0x32, 0x01, 0x02
	.byte 0x89, 0x36, 0x01, 0x02, 0xE1, 0x31, 0x01, 0x02, 0x1D, 0x36, 0x01, 0x02, 0x19, 0x32, 0x01, 0x02
	.byte 0x41, 0x34, 0x01, 0x02
.L02017D64:
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00
	.byte 0x00, 0x22, 0x01, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x22, 0x00, 0x00
	.byte 0x00, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x02, 0x00
	.byte 0x00, 0x12, 0x12, 0x00, 0x00, 0x10, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x22, 0x00
	.byte 0x00, 0x22, 0x12, 0x01, 0x20, 0x12, 0x22, 0x00, 0x00, 0x22, 0x12, 0x01, 0x20, 0x12, 0x12, 0x00
	.byte 0x00, 0x11, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02
	.byte 0x00, 0x00, 0x22, 0x11, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x20, 0x02
	.byte 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00
	.byte 0x20, 0x02, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x22, 0x11, 0x00, 0x00
	.byte 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x20, 0x02, 0x22, 0x11, 0x00, 0x22, 0x12, 0x01, 0x20, 0x12, 0x22, 0x00, 0x22, 0x11, 0x20, 0x02
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00
	.byte 0x00, 0x20, 0x12, 0x00, 0x20, 0x22, 0x22, 0x02, 0x00, 0x21, 0x12, 0x11, 0x00, 0x20, 0x12, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x11, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02, 0x00, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x20, 0x12, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02
	.byte 0x00, 0x00, 0x22, 0x11, 0x00, 0x20, 0x12, 0x01, 0x00, 0x22, 0x11, 0x00, 0x20, 0x12, 0x01, 0x00
	.byte 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x20, 0x12, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00
	.byte 0x00, 0x22, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x22, 0x22, 0x00
	.byte 0x00, 0x10, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x10, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x11, 0x22, 0x11, 0x11, 0x01, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x10, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x11, 0x00, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11
	.byte 0x10, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x22, 0x00
	.byte 0x22, 0x01, 0x22, 0x01, 0x22, 0x01, 0x22, 0x01, 0x22, 0x22, 0x22, 0x02, 0x10, 0x11, 0x22, 0x11
	.byte 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x22, 0x11, 0x11, 0x11, 0x22, 0x22, 0x22, 0x00, 0x10, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11
	.byte 0x10, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x11, 0x01, 0x22, 0x22, 0x22, 0x00, 0x22, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x21, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12
	.byte 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x11, 0x22, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x20, 0x22, 0x22, 0x12, 0x00, 0x11, 0x21, 0x12, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x11, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x12, 0x00
	.byte 0x00, 0x00, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00
	.byte 0x00, 0x20, 0x12, 0x01, 0x00, 0x22, 0x11, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x22, 0x00
	.byte 0x00, 0x00, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x20, 0x22, 0x22, 0x02, 0x00, 0x11, 0x11, 0x11, 0x20, 0x22, 0x22, 0x02, 0x00, 0x11, 0x11, 0x11
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00
	.byte 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x20, 0x12, 0x01, 0x00, 0x22, 0x11, 0x00
	.byte 0x00, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x10, 0x21, 0x22, 0x11, 0x00, 0x00, 0x11, 0x01, 0x00, 0x20, 0x02, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x12, 0x22, 0x11, 0x21, 0x12, 0x22, 0x01, 0x20, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11, 0x22, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11
	.byte 0x10, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02
	.byte 0x22, 0x11, 0x11, 0x11, 0x22, 0x01, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02
	.byte 0x00, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x20, 0x12, 0x22, 0x22, 0x22, 0x11
	.byte 0x10, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x22, 0x11, 0x11, 0x11, 0x22, 0x22, 0x22, 0x00, 0x22, 0x11, 0x11, 0x01, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x11, 0x01, 0x22, 0x22, 0x02, 0x00, 0x22, 0x11, 0x11, 0x00, 0x22, 0x01, 0x00, 0x00
	.byte 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02
	.byte 0x22, 0x11, 0x11, 0x11, 0x22, 0x01, 0x22, 0x02, 0x22, 0x01, 0x20, 0x12, 0x20, 0x22, 0x22, 0x12
	.byte 0x00, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x01, 0x20, 0x12, 0x22, 0x22, 0x22, 0x12, 0x22, 0x11, 0x21, 0x12, 0x22, 0x01, 0x20, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00
	.byte 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02
	.byte 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x22, 0x00, 0x20, 0x12, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x01, 0x22, 0x11, 0x22, 0x22, 0x12, 0x01, 0x22, 0x11, 0x22, 0x00, 0x22, 0x01, 0x20, 0x02
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00
	.byte 0x22, 0x01, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x22, 0x01, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x02, 0x22, 0x12, 0x22, 0x22, 0x22, 0x12, 0x22, 0x21, 0x21, 0x12, 0x22, 0x01, 0x21, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x02, 0x20, 0x12, 0x22, 0x21, 0x20, 0x12, 0x22, 0x01, 0x22, 0x12, 0x22, 0x01, 0x20, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x20, 0x12, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11, 0x22, 0x11, 0x11, 0x01, 0x22, 0x01, 0x00, 0x00
	.byte 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x22, 0x11, 0x20, 0x22, 0x12, 0x02
	.byte 0x00, 0x11, 0x11, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x00
	.byte 0x22, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11, 0x22, 0x11, 0x21, 0x02, 0x22, 0x01, 0x20, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02
	.byte 0x22, 0x11, 0x11, 0x11, 0x20, 0x22, 0x22, 0x00, 0x00, 0x11, 0x21, 0x02, 0x22, 0x22, 0x22, 0x11
	.byte 0x10, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x22, 0x22, 0x02
	.byte 0x00, 0x21, 0x12, 0x11, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00, 0x00, 0x20, 0x12, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x20, 0x12, 0x22, 0x01, 0x20, 0x12, 0x20, 0x22, 0x22, 0x11
	.byte 0x00, 0x11, 0x11, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x01, 0x20, 0x12, 0x20, 0x02, 0x22, 0x11, 0x00, 0x22, 0x12, 0x01, 0x00, 0x20, 0x11, 0x00
	.byte 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x22, 0x21, 0x20, 0x12, 0x22, 0x22, 0x22, 0x12, 0x22, 0x12, 0x22, 0x12, 0x22, 0x11, 0x20, 0x12
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x20, 0x02
	.byte 0x20, 0x02, 0x22, 0x11, 0x00, 0x22, 0x12, 0x01, 0x20, 0x12, 0x22, 0x00, 0x22, 0x11, 0x20, 0x02
	.byte 0x10, 0x01, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x20, 0x02
	.byte 0x20, 0x12, 0x20, 0x12, 0x00, 0x22, 0x22, 0x11, 0x00, 0x20, 0x12, 0x01, 0x00, 0x20, 0x12, 0x00
	.byte 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x22, 0x11, 0x00, 0x22, 0x12, 0x01, 0x20, 0x12, 0x11, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x11, 0x11, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x12, 0x00
	.byte 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00
	.byte 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00
	.byte 0x00, 0x22, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x22, 0x00, 0x00, 0x00, 0x20, 0x02
	.byte 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x00, 0x00, 0x20, 0x02, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00
	.byte 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00, 0x00, 0x12, 0x00, 0x00
	.byte 0x20, 0x12, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x00, 0x00, 0x22, 0x02, 0x00
	.byte 0x20, 0x12, 0x22, 0x00, 0x00, 0x11, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x22, 0x22, 0x22, 0x02
	.byte 0x10, 0x11, 0x11, 0x11
.L02018564:
	.byte 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x40, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0xC0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80
	.byte 0x00, 0x80, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80, 0x00, 0xC0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x40
	.byte 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x40, 0x00, 0x80, 0x00, 0x00, 0x01, 0x00, 0x00, 0x40
	.byte 0x00, 0xC0, 0x00, 0x00, 0x01, 0x00, 0x00, 0x40, 0x00, 0x40, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80
	.byte 0x00, 0x40, 0x00, 0x00, 0x01, 0x00, 0x00, 0x40, 0x00, 0x60, 0x00, 0x00, 0x01, 0x00, 0x00, 0x80
	.byte 0x00, 0x10, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x30, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00
	.byte 0x00, 0x60, 0x00, 0x00
.L020185F4:
	.byte 0x03, 0x00, 0x00, 0x00, 0x8D, 0x43, 0x01, 0x02, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018604:
	.byte 0x01, 0x00, 0x00, 0x00, 0x34, 0x73, 0x01, 0x02, 0x0F, 0x00, 0x0B, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x15, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, 0x00
	.byte 0x75, 0x6A, 0x01, 0x02, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0B, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
	.byte 0x00, 0x00, 0x00, 0x00
.L02018644:
	.byte 0x00, 0x00, 0x00, 0x0E
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
