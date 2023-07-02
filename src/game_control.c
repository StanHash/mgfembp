#include "game_control.h"

#include "async_upload.h"
#include "gbaio.h"
#include "gbasvc.h"
#include "hardware.h"
#include "oam.h"
#include "proc.h"
#include "sprite.h"

#include "unknowns.h"

// this padding could also be from oam, ramfunc, proc, debug_text or sprite
static u32 s_pad_0300002C;

static bool s_frame_ended;

// clang-format off

struct ProcScr SHOULD_BE_CONST ProcScr_Program[] =
{
    PROC_NAME("GAMECTRL"),
    PROC_MARK(PROC_MARK_GAMECTRL),
    PROC_15,
    PROC_CALL(func_common_02016A74),
    PROC_SLEEP(0),
PROC_LABEL(0),
    PROC_GOTO(0),
    PROC_END,
};

// clang-format on

void OnVBlank(void)
{
    INTR_CHECK = INTR_FLAG_VBLANK;

    IncGameTime();
    Proc_Run(gProcTreeRoots[0]);
    SyncLoOam();

    if (s_frame_ended)
    {
        SyncDispIo();
        SyncBgsAndPal();
        ApplyAsyncUploads();
        SyncHiOam();

#if BUGFIX
        s_frame_ended = FALSE;
#endif
    }
}

void OnMain(void)
{
    RefreshKeySt(gKeySt);
    ClearSprites();

    Proc_Run(gProcTreeRoots[1]);
    Proc_Run(gProcTreeRoots[2]);
    Proc_Run(gProcTreeRoots[3]);
    Proc_Run(gProcTreeRoots[5]);
    Proc_Run(gProcTreeRoots[4]);

    s_frame_ended = TRUE;
    SwiVBlankIntrWait();
}

void StartMainProc(void)
{
    struct ProgramProc * proc;

    SetMainFunc(OnMain);
    SetOnVBlank(OnVBlank);

    proc = SpawnProc(ProcScr_Program, PROC_TREE_3);

    proc->unk_29 = 0;
    proc->unk_2A = 0;
    proc->unk_2B = 0;
}

struct ProgramProc * GetMainProc(void)
{
    return FindProc(ProcScr_Program);
}

void func_020145AC(int unk_29)
{
    struct ProgramProc * proc = GetMainProc();
    proc->unk_29 = unk_29;
}

void func_020145DC(int unk_2A)
{
    struct ProgramProc * proc = GetMainProc();
    proc->unk_2A = unk_2A;
}

bool func_0201460C(void)
{
    struct ProgramProc * proc = GetMainProc();
    return proc->unk_2A != 0 ? TRUE : FALSE;
}

void func_02014634(void)
{
    struct ProgramProc * proc;

    Proc_EndEach(ProcScr_Program);

    proc = SpawnProc(ProcScr_Program, PROC_TREE_3);
    Proc_Goto(proc, 5); // label was dummied out, this is a no-op
}

void func_02014664(void)
{
    struct ProgramProc * proc;

    Proc_EndEach(ProcScr_Program);

    proc = SpawnProc(ProcScr_Program, PROC_TREE_3);
    Proc_Goto(proc, 6); // label was dummied out, this is a no-op
}
