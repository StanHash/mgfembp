#include "proc.h"

// base game is 0x40
#define PROC_COUNT 8

enum
{
    PROC_FLAG_ENDED = (1 << 0),
    PROC_FLAG_BLOCKING = (1 << 1),
    PROC_FLAG_UNK2 = (1 << 2),
    PROC_FLAG_STARTING = (1 << 3),
};

struct ProcDummy
{
    /* 00 */ PROC_HEADER;

    // this is the space available for user members
    /* 2C */ u32 user[0x10];
};

struct ProcDummy EWRAM_DATA gProcs[PROC_COUNT] = { 0 };

struct ProcDummy * EWRAM_DATA gProcAllocList[PROC_COUNT + 1] = { 0 };
struct ProcDummy ** EWRAM_DATA gProcAllocHead = NULL;

AnyProc * EWRAM_DATA gProcTreeRoots[8] = { 0 };

static AnyProc * AllocProc(void);
static void FreeProc(AnyProc * proc);
static void InsertRootProc(struct ProcDummy * proc, int treenum);
static void InsertProc(struct ProcDummy *, struct ProcDummy *);
static void UnlinkProc(struct ProcDummy * proc);
static void StepProcScr(struct ProcDummy * proc);

void InitProcs(void)
{
    struct ProcDummy * proc;
    int i;

    for (i = 0; i < PROC_COUNT; ++i)
    {
        proc = gProcs + i;

        proc->proc_script = NULL;
        proc->proc_script_pc = NULL;
        proc->proc_end_func = NULL;
        proc->proc_repeat_func = NULL;
        proc->proc_name = NULL;
        proc->proc_parent = NULL;
        proc->proc_child = NULL;
        proc->proc_next = NULL;
        proc->proc_prev = NULL;
        proc->proc_sleep_clock = 0;
        proc->proc_mark = 0;
        proc->proc_flags = 0;
        proc->proc_lock_cnt = 0;

        gProcAllocList[i] = proc;
    }

    gProcAllocList[PROC_COUNT] = NULL;
    gProcAllocHead = gProcAllocList;

    for (i = 0; i < 8; i++)
        gProcTreeRoots[i] = NULL;
}

AnyProc * SpawnProc(struct ProcScr const * scr, AnyProc * parent)
{
    struct ProcDummy * proc = AllocProc();

    proc->proc_script = scr;
    proc->proc_script_pc = scr;
    proc->proc_end_func = NULL;
    proc->proc_repeat_func = NULL;
    proc->proc_parent = NULL;
    proc->proc_child = NULL;
    proc->proc_next = NULL;
    proc->proc_prev = NULL;
    proc->proc_sleep_clock = 0;
    proc->proc_mark = 0;
    proc->proc_lock_cnt = 0;

    proc->proc_flags = PROC_FLAG_STARTING;

    if ((int)parent < 8) // If this is an integer less than 8, then add a root proc
        InsertRootProc(proc, (int)parent);
    else
        InsertProc(proc, parent);

    StepProcScr(proc);

    proc->proc_flags &= ~PROC_FLAG_STARTING;

    return proc;
}

AnyProc * SpawnProcLocking(struct ProcScr const * scr, AnyProc * parent)
{
    struct ProcDummy * proc = SpawnProc(scr, parent);

    if (proc->proc_script == NULL)
        return NULL;

    proc->proc_flags |= PROC_FLAG_BLOCKING;
    ((struct ProcDummy *)proc->proc_parent)->proc_lock_cnt++;

    return proc;
}

static void ClearProc(struct ProcDummy * proc)
{
    if (proc->proc_prev)
        ClearProc(proc->proc_prev);

    if (proc->proc_child)
        ClearProc(proc->proc_child);

    if (proc->proc_flags & PROC_FLAG_ENDED)
        return;

    if (proc->proc_end_func)
        proc->proc_end_func(proc);

    FreeProc(proc);

    proc->proc_script = NULL;
    proc->proc_repeat_func = NULL;

    proc->proc_flags |= PROC_FLAG_ENDED;

    if (proc->proc_flags & PROC_FLAG_BLOCKING)
        ((struct ProcDummy *)proc->proc_parent)->proc_lock_cnt--;
}

void Proc_End(AnyProc * proc)
{
    struct ProcDummy * casted = proc;

    if (casted == NULL)
        return;

    UnlinkProc(casted);
    ClearProc(proc);
}

static AnyProc * AllocProc(void)
{
    AnyProc * proc = *gProcAllocHead;
    gProcAllocHead++;

    return proc;
}

static void FreeProc(AnyProc * proc)
{
    gProcAllocHead--;
    *gProcAllocHead = proc;
}

static void InsertRootProc(struct ProcDummy * proc, int treenum)
{
    struct ProcDummy ** root = NULL;

    root = (struct ProcDummy **)gProcTreeRoots + treenum;

    if (*root)
    {
        (*root)->proc_next = proc;
        proc->proc_prev = *root;
    }

    proc->proc_parent = (AnyProc *)treenum;
    *root = proc;
}

static void InsertProc(struct ProcDummy * proc, struct ProcDummy * parent)
{
    if (parent->proc_child != NULL)
    {
        ((struct ProcDummy *)parent->proc_child)->proc_next = proc;
        proc->proc_prev = parent->proc_child;
    }

    parent->proc_child = proc;
    proc->proc_parent = parent;
}

static void UnlinkProc(struct ProcDummy * proc)
{
    if (proc->proc_next != NULL)
        ((struct ProcDummy *)proc->proc_next)->proc_prev = proc->proc_prev;

    if (proc->proc_prev != NULL)
        ((struct ProcDummy *)proc->proc_prev)->proc_next = proc->proc_next;

    if ((int)proc->proc_parent > 8)
    {
        if (((struct ProcDummy *)proc->proc_parent)->proc_child == proc)
            ((struct ProcDummy *)proc->proc_parent)->proc_child = proc->proc_prev;
    }
    else
    {
        struct ProcDummy ** root = (struct ProcDummy **)gProcTreeRoots + (int)proc->proc_parent;

        if (*root == proc)
            *root = proc->proc_prev;
    }

    proc->proc_next = NULL;
    proc->proc_prev = NULL;
}

static void RunProcCore(struct ProcDummy * proc)
{
    if (proc->proc_prev != NULL)
        RunProcCore(proc->proc_prev);

    if (proc->proc_lock_cnt != 0 || (proc->proc_flags & PROC_FLAG_STARTING))
        goto skip_exec;

    if (proc->proc_repeat_func == NULL)
        StepProcScr(proc);

    if (proc->proc_repeat_func != NULL)
        proc->proc_repeat_func(proc);

    if (proc->proc_flags & PROC_FLAG_ENDED)
        return;

skip_exec:
    if (proc->proc_child != NULL)
        RunProcCore(proc->proc_child);
}

void Proc_Run(AnyProc * proc)
{
    if (proc != NULL)
        RunProcCore(proc);
}

void Proc_Break(AnyProc * proc)
{
    struct ProcDummy * casted = proc;
    casted->proc_repeat_func = NULL;
}

AnyProc * FindProc(struct ProcScr const * script)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_script == script)
            return proc;
    }

    return NULL;
}

AnyProc * FindActiveProc(struct ProcScr const * script)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_script == script && proc->proc_lock_cnt == 0)
            return proc;
    }

    return NULL;
}

AnyProc * FindMarkedProc(int mark)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_script != NULL && proc->proc_mark == mark)
            return proc;
    }

    return NULL;
}

void Proc_Goto(AnyProc * proc, int label)
{
    struct ProcDummy * casted = proc;
    struct ProcScr const * scr;

    for (scr = casted->proc_script; scr->cmd != PROC_CMD_END; scr++)
    {
        if (scr->cmd == PROC_CMD_LABEL && scr->imm == label)
        {
            casted->proc_script_pc = scr;
            casted->proc_repeat_func = NULL;

            return;
        }
    }
}

void Proc_GotoScript(AnyProc * proc, struct ProcScr const * script)
{
    struct ProcDummy * casted = proc;

    casted->proc_script_pc = script;
    casted->proc_repeat_func = NULL;
}

void Proc_Mark(AnyProc * proc, int mark)
{
    struct ProcDummy * casted = proc;

    casted->proc_mark = mark;
}

void Proc_SetEndFunc(AnyProc * proc, ProcFunc * func)
{
    struct ProcDummy * casted = proc;

    casted->proc_end_func = func;
}

void Proc_ForAll(ProcFunc * func)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_script)
            func(proc);
    }
}

void Proc_ForEach(struct ProcScr const * script, ProcFunc * func)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_script == script)
            func(proc);
    }
}

void Proc_ForEachMarked(int mark, ProcFunc * func)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_mark == mark)
            func(proc);
    }
}

void Proc_LockEachMarked(int mark)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_mark == mark)
            proc->proc_lock_cnt++;
    }
}

void Proc_ReleaseEachMarked(int mark)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_mark == mark)
            proc->proc_lock_cnt--;
    }
}

void Proc_EndEachMarked(int mark)
{
    struct ProcDummy * proc = gProcs;
    int i;

    for (i = 0; i < PROC_COUNT; i++, proc++)
    {
        if (proc->proc_mark == mark)
            Proc_End(proc);
    }
}

static void EndProc(AnyProc * proc)
{
    Proc_End(proc);
}

void Proc_EndEach(struct ProcScr const * script)
{
    Proc_ForEach(script, EndProc);
}

static void BreakProc(AnyProc * proc)
{
    Proc_Break(proc);
}

void Proc_BreakEach(struct ProcScr const * script)
{
    Proc_ForEach(script, BreakProc);
}

static void WalkProcSubtree(struct ProcDummy * proc, ProcFunc * func)
{
    if (proc->proc_prev)
        WalkProcSubtree(proc->proc_prev, func);

    func(proc);

    if (proc->proc_child)
        WalkProcSubtree(proc->proc_child, func);
}

void Proc_ForSubtree(AnyProc * proc, ProcFunc * func)
{
    struct ProcDummy * casted = proc;

    func(casted);

    if (casted->proc_child)
        WalkProcSubtree(casted->proc_child, func);
}

static bool ProcCmd_End(struct ProcDummy * proc)
{
    Proc_End(proc);
    return FALSE;
}

static bool ProcCmd_Name(struct ProcDummy * proc)
{
    proc->proc_name = proc->proc_script_pc->ptr;
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_Call(struct ProcDummy * proc)
{
    ProcFunc * func = proc->proc_script_pc->ptr;

    proc->proc_script_pc++;
    func(proc);

    return TRUE;
}

static bool ProcCmd_CallRet(struct ProcDummy * proc)
{
    bool (*func)(AnyProc * proc) = proc->proc_script_pc->ptr;

    proc->proc_script_pc++;
    return func(proc);
}

static bool ProcCmd_CallArg(struct ProcDummy * proc)
{
    bool (*func)(short arg, AnyProc * proc);
    short arg;

    arg = proc->proc_script_pc->imm;
    func = proc->proc_script_pc->ptr;

    proc->proc_script_pc++;
    return func(arg, proc);
}

static bool ProcCmd_While(struct ProcDummy * proc)
{
    bool (*func)(AnyProc *) = proc->proc_script_pc->ptr;

    proc->proc_script_pc++;

    if (func(proc) == TRUE)
    {
        proc->proc_script_pc--;
        return FALSE;
    }

    return TRUE;
}

static bool ProcCmd_Repeat(struct ProcDummy * proc)
{
    proc->proc_repeat_func = proc->proc_script_pc->ptr;
    proc->proc_script_pc++;

    return FALSE;
}

static bool ProcCmd_SetEndFunc(struct ProcDummy * proc)
{
    Proc_SetEndFunc(proc, proc->proc_script_pc->ptr);
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_SpawnChild(struct ProcDummy * proc)
{
    SpawnProc(proc->proc_script_pc->ptr, proc);
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_SpawnLockChild(struct ProcDummy * proc)
{
    SpawnProcLocking(proc->proc_script_pc->ptr, proc);
    proc->proc_script_pc++;

    return FALSE;
}

static bool ProcCmd_SpawnBugged(struct ProcDummy * proc)
{
    // It is very much bugged
    // As it uses the proc's sleep timer to choose the tree in which to put the new proc
    // Which makes no sense

    SpawnProc(proc->proc_script_pc->ptr, (AnyProc *)(int)proc->proc_sleep_clock);
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_WhileExists(struct ProcDummy * proc)
{
    if (Proc_Exists(proc->proc_script_pc->ptr) == TRUE)
        return FALSE;

    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_EndEach(struct ProcDummy * proc)
{
    Proc_EndEach(proc->proc_script_pc->ptr);
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_BreakEach(struct ProcDummy * proc)
{
    Proc_BreakEach(proc->proc_script_pc->ptr);
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_Nop(struct ProcDummy * proc)
{
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_GotoScript(struct ProcDummy * proc)
{
    Proc_GotoScript(proc, proc->proc_script_pc->ptr);

    return TRUE;
}

static bool ProcCmd_Goto(struct ProcDummy * proc)
{
    Proc_Goto(proc, proc->proc_script_pc->imm);

    return TRUE;
}

static void SleepRepeatFunc(AnyProc * proc)
{
    ((struct ProcDummy *)proc)->proc_sleep_clock--;

    if (((struct ProcDummy *)proc)->proc_sleep_clock == 0)
        Proc_Break(proc);
}

static bool ProcCmd_Sleep(struct ProcDummy * proc)
{
    if (proc->proc_script_pc->imm != 0)
    {
        proc->proc_sleep_clock = proc->proc_script_pc->imm;
        proc->proc_repeat_func = SleepRepeatFunc;
    }

    proc->proc_script_pc++;

    return FALSE;
}

static bool ProcCmd_Mark(struct ProcDummy * proc)
{
    proc->proc_mark = proc->proc_script_pc->imm;
    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_Nop2(struct ProcDummy * proc)
{
    proc->proc_script_pc++;
    return TRUE;
}

static bool ProcCmd_Block(struct ProcDummy * proc)
{
    return FALSE;
}

static bool ProcCmd_EndIfDup(struct ProcDummy * proc)
{
    struct ProcDummy * it = gProcs;
    int i, count;

    for (i = 0, count = 0; i < PROC_COUNT; i++, it++)
    {
        if (it->proc_script == proc->proc_script)
            count++;
    }

    if (count > 1)
    {
        Proc_End(proc);
        return FALSE;
    }

    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_EndDups(struct ProcDummy * proc)
{
    struct ProcDummy * it = gProcs;
    int i, count;

    for (i = 0, count = 0; i < PROC_COUNT; i++, it++)
    {
        if (it == proc)
            continue;

        if (it->proc_script == proc->proc_script)
        {
            Proc_End(it);
            break;
        }
    }

    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_Nop3(struct ProcDummy * proc)
{
    // yoo there's an skeleton of an implementation of this here
    // this is completely dummied out in fe6
    // (it still doesn't do anything)

    struct ProcDummy * it = gProcs;
    int i, count;

    for (i = 0, count = 0; i < PROC_COUNT; i++, it++)
    {
        if (it->proc_script == proc->proc_script)
            count++;
    }

    if (count > 1)
    {
    }

    proc->proc_script_pc++;

    return TRUE;
}

static bool ProcCmd_SetFlag2(struct ProcDummy * proc)
{
    proc->proc_flags |= PROC_FLAG_UNK2;
    proc->proc_script_pc++;

    return TRUE;
}

static void StepProcScr(struct ProcDummy * proc)
{
    static bool (*cmd_func_table[])(struct ProcDummy *) = {
        [PROC_CMD_END] = ProcCmd_End,
        [PROC_CMD_NAME] = ProcCmd_Name,
        [PROC_CMD_CALL] = ProcCmd_Call,
        [PROC_CMD_REPEAT] = ProcCmd_Repeat,
        [PROC_CMD_ONEND] = ProcCmd_SetEndFunc,
        [PROC_CMD_START_CHILD] = ProcCmd_SpawnChild,
        [PROC_CMD_START_CHILD_BLOCKING] = ProcCmd_SpawnLockChild,
        [PROC_CMD_START_BUGGED] = ProcCmd_SpawnBugged,
        [PROC_CMD_WHILE_EXISTS] = ProcCmd_WhileExists,
        [PROC_CMD_END_EACH] = ProcCmd_EndEach,
        [PROC_CMD_BREAK_EACH] = ProcCmd_BreakEach,
        [PROC_CMD_LABEL] = ProcCmd_Nop,
        [PROC_CMD_GOTO] = ProcCmd_Goto,
        [PROC_CMD_GOTO_SCR] = ProcCmd_GotoScript,
        [PROC_CMD_SLEEP] = ProcCmd_Sleep,
        [PROC_CMD_MARK] = ProcCmd_Mark,
        [PROC_CMD_BLOCK] = ProcCmd_Block,
        [PROC_CMD_END_IF_DUP] = ProcCmd_EndIfDup,
        [PROC_CMD_SET_FLAG2] = ProcCmd_SetFlag2,
        [PROC_CMD_13] = ProcCmd_Nop2,
        [PROC_CMD_WHILE] = ProcCmd_While,
        [PROC_CMD_15] = ProcCmd_Nop3,
        [PROC_CMD_CALL_2] = ProcCmd_CallRet,
        [PROC_CMD_END_DUPS] = ProcCmd_EndDups,
        [PROC_CMD_CALL_ARG] = ProcCmd_CallArg,
        [PROC_CMD_19] = ProcCmd_Nop,
    };

    if (proc->proc_script == NULL)
        return;

    if (proc->proc_lock_cnt > 0)
        return;

    if (proc->proc_repeat_func != NULL)
        return;

    while (cmd_func_table[proc->proc_script_pc->cmd](proc))
    {
        if (proc->proc_script == NULL)
            return;
    }
}

static void PrintProcInfo(struct ProcDummy * proc)
{
    if (proc->proc_name != NULL)
    {
        // print name?
        return;
    }
}

static void WalkPrintProcInfo(struct ProcDummy * proc, int * indent)
{
    if (proc->proc_prev != NULL)
        WalkPrintProcInfo(proc->proc_prev, indent);

    PrintProcInfo(proc);

    if (proc->proc_child != NULL)
    {
        *indent += 2;
        WalkPrintProcInfo(proc->proc_child, indent);
        *indent -= 2;
    }
}

void Proc_PrintSubtreeInfo(AnyProc * proc)
{
    int indent;
    struct ProcDummy * casted = proc;

    indent = 4;

    PrintProcInfo(casted);

    if (casted->proc_child != NULL)
    {
        indent += 2;
        WalkPrintProcInfo(casted->proc_child, &indent);
        indent -= 2;
    }
}

void func_0201384C(void)
{
}

void Proc_SetRepeatFunc(AnyProc * proc, ProcFunc * func)
{
    struct ProcDummy * casted = proc;

    casted->proc_repeat_func = func;
}

void Proc_Lock(AnyProc * proc)
{
    ((struct ProcDummy *)proc)->proc_lock_cnt++;
}

void Proc_Release(AnyProc * proc)
{
    ((struct ProcDummy *)proc)->proc_lock_cnt--;
}
