#include "save_data.h"

#include "game_structs.h"

bool IsNotFirstPlaythrough(void);

bool IsNotFirstPlaythrough_2(void)
{
    return IsNotFirstPlaythrough();
}

#if NONMATCHING

bool CheckHasCompletedSave(void)
{
    int i;
    struct PlaySt play_st;

    for (i = 0; i < 3; i++)
    {
        // reads were dummied

        if ((play_st.flags & PLAY_FLAG_COMPLETE) != 0)
            return TRUE;
    }

    return FALSE;
}

#else

NAKEDFUNC
bool CheckHasCompletedSave(void)
{
    asm(".syntax unified\n\
        sub sp, #0x20\n\
        movs r2, #0\n\
        mov r0, sp\n\
        ldrb r1, [r0, #0x14]\n\
        movs r0, #0x20\n\
        ands r0, r1\n\
        lsls r0, r0, #0x18\n\
        lsrs r0, r0, #0x18\n\
    .L02014AF8:\n\
        cmp r0, #0\n\
        beq .L02014B00\n\
        movs r0, #1\n\
        b .L02014B08\n\
    .L02014B00:\n\
        adds r2, #1\n\
        cmp r2, #2\n\
        ble .L02014AF8\n\
        movs r0, #0\n\
    .L02014B08:\n\
        add sp, #0x20\n\
        bx lr\n\
        .syntax divided\n\
    ");
}

#endif

/*

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

*/
