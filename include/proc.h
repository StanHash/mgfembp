#ifndef PROC_H
#define PROC_H

#include "prelude.h"

// magical proc types
typedef void AnyProc;
typedef void ProcFunc(AnyProc * proc);

struct ProcScr
{
    i16 cmd;
    i16 imm;
    void const * ptr;
};

enum
{
    PROC_CMD_END,
    PROC_CMD_NAME,
    PROC_CMD_CALL,
    PROC_CMD_REPEAT,
    PROC_CMD_ONEND,
    PROC_CMD_START_CHILD,
    PROC_CMD_START_CHILD_BLOCKING,
    PROC_CMD_START_BUGGED,
    PROC_CMD_WHILE_EXISTS,
    PROC_CMD_END_EACH,
    PROC_CMD_BREAK_EACH,
    PROC_CMD_LABEL,
    PROC_CMD_GOTO,
    PROC_CMD_GOTO_SCR,
    PROC_CMD_SLEEP,
    PROC_CMD_MARK,
    PROC_CMD_BLOCK,
    PROC_CMD_END_IF_DUP,
    PROC_CMD_SET_FLAG2,
    PROC_CMD_13,
    PROC_CMD_WHILE,
    PROC_CMD_15,
    PROC_CMD_CALL_2,
    PROC_CMD_END_DUPS,
    PROC_CMD_CALL_ARG,
    PROC_CMD_19,
};

// clang-format seems to suck for macros

#define PROC_END                                                                                                       \
    {                                                                                                                  \
        PROC_CMD_END, 0, 0                                                                                             \
    }

#define PROC_NAME(nameStr)                                                                                             \
    {                                                                                                                  \
        PROC_CMD_NAME, 0, (nameStr)                                                                                    \
    }

#define PROC_CALL(func)                                                                                                \
    {                                                                                                                  \
        PROC_CMD_CALL, 0, (func)                                                                                       \
    }

#define PROC_REPEAT(func)                                                                                              \
    {                                                                                                                  \
        PROC_CMD_REPEAT, 0, (func)                                                                                     \
    }

#define PROC_ONEND(func)                                                                                               \
    {                                                                                                                  \
        PROC_CMD_ONEND, 0, (func)                                                                                      \
    }

#define PROC_START_CHILD(procscr)                                                                                      \
    {                                                                                                                  \
        PROC_CMD_START_CHILD, 0, (procscr)                                                                             \
    }

#define PROC_START_CHILD_LOCKING(procscr)                                                                              \
    {                                                                                                                  \
        PROC_CMD_START_CHILD_BLOCKING, 1, (procscr)                                                                    \
    }

#define PROC_START_BUGGED(procscr)                                                                                     \
    {                                                                                                                  \
        PROC_CMD_START_BUGGED, 0, (procscr)                                                                            \
    }

#define PROC_WHILE_EXISTS(procscr)                                                                                     \
    {                                                                                                                  \
        PROC_CMD_WHILE_EXISTS, 0, (procscr)                                                                            \
    }

#define PROC_END_EACH(procscr)                                                                                         \
    {                                                                                                                  \
        PROC_CMD_END_EACH, 0, (procscr)                                                                                \
    }

#define PROC_BREAK_EACH(procscr)                                                                                       \
    {                                                                                                                  \
        PROC_CMD_BREAK_EACH, 0, (procscr)                                                                              \
    }

#define PROC_LABEL(label)                                                                                              \
    {                                                                                                                  \
        PROC_CMD_LABEL, (label), 0                                                                                     \
    }

#define PROC_GOTO(label)                                                                                               \
    {                                                                                                                  \
        PROC_CMD_GOTO, (label), 0                                                                                      \
    }

#define PROC_GOTO_SCR(procscr)                                                                                         \
    {                                                                                                                  \
        PROC_CMD_GOTO_SCR, 0, (procscr)                                                                                \
    }

#define PROC_SLEEP(duration)                                                                                           \
    {                                                                                                                  \
        PROC_CMD_SLEEP, (duration), 0                                                                                  \
    }

#define PROC_MARK(mark)                                                                                                \
    {                                                                                                                  \
        PROC_CMD_MARK, (mark), 0                                                                                       \
    }

#define PROC_BLOCK                                                                                                     \
    {                                                                                                                  \
        PROC_CMD_BLOCK, 0, 0                                                                                           \
    }

#define PROC_END_IF_DUP                                                                                                \
    {                                                                                                                  \
        PROC_CMD_END_IF_DUP, 0, 0                                                                                      \
    }

#define PROC_SET_FLAG2                                                                                                 \
    {                                                                                                                  \
        PROC_CMD_SET_FLAG2, 0, 0                                                                                       \
    }

#define PROC_13                                                                                                        \
    {                                                                                                                  \
        PROC_CMD_13, 0, 0                                                                                              \
    }

#define PROC_WHILE(func)                                                                                               \
    {                                                                                                                  \
        PROC_CMD_WHILE, 0, (func)                                                                                      \
    }

#define PROC_15                                                                                                        \
    {                                                                                                                  \
        PROC_CMD_15, 0, 0                                                                                              \
    }

#define PROC_CALL_2(func)                                                                                              \
    {                                                                                                                  \
        PROC_CMD_CALL_2, 0, (func)                                                                                     \
    }

#define PROC_END_DUPS                                                                                                  \
    {                                                                                                                  \
        PROC_CMD_END_DUPS, 0, 0                                                                                        \
    }

#define PROC_CALL_ARG(func, arg)                                                                                       \
    {                                                                                                                  \
        PROC_CMD_CALL_ARG, (arg), (func)                                                                               \
    }

#define PROC_19                                                                                                        \
    {                                                                                                                  \
        PROC_CMD_19, 0, 0                                                                                              \
    }

#define PROC_HEADER                                                                                                    \
    /* 00 */ struct ProcScr const * proc_script;    /* pointer to proc script */                                       \
    /* 04 */ struct ProcScr const * proc_script_pc; /* pointer to currently executing script command */                \
    /* 08 */ ProcFunc * proc_end_func;              /* callback to run upon delegint the process */                    \
    /* 0C */ ProcFunc * proc_repeat_func;           /* callback to run once each frame. */                             \
                                                    /* disables script execution when not null */                      \
    /* 10 */ char const * proc_name;                                                                                   \
    /* 14 */ AnyProc * proc_parent; /* pointer to parent proc. If this proc is a root proc, */                         \
                                    /* this member is an integer which is the root index. */                           \
    /* 18 */ AnyProc * proc_child;  /* pointer to most recently added child */                                         \
    /* 1C */ AnyProc * proc_next;   /* next sibling */                                                                 \
    /* 20 */ AnyProc * proc_prev;   /* previous sibling */                                                             \
    /* 24 */ i16 proc_sleep_clock;                                                                                     \
    /* 26 */ u8 proc_mark;                                                                                             \
    /* 27 */ u8 proc_flags;                                                                                            \
    /* 28 */ u8 proc_lock_cnt; /* wait semaphore. Process execution */                                                 \
                               /* is blocked when this is nonzero. */

#define PROC_TREE_VSYNC ((AnyProc *)0)
#define PROC_TREE_1 ((AnyProc *)1)
#define PROC_TREE_2 ((AnyProc *)2)
#define PROC_TREE_3 ((AnyProc *)3)
#define PROC_TREE_4 ((AnyProc *)4)
#define PROC_TREE_5 ((AnyProc *)5)
#define PROC_TREE_6 ((AnyProc *)6)
#define PROC_TREE_7 ((AnyProc *)7)

enum
{
    PROC_MARK_1 = 1,
    PROC_MARK_2 = 2,
    PROC_MARK_MU = 4,
    PROC_MARK_5 = 5,
    PROC_MARK_6 = 6,
    PROC_MARK_7 = 7,
    PROC_MARK_8 = 8,
    PROC_MARK_10 = 10,
    PROC_MARK_GAMECTRL = 11,
};

extern AnyProc * gProcTreeRoots[8];

void InitProcs(void);
AnyProc * SpawnProc(struct ProcScr const * scr, AnyProc * parent);
AnyProc * SpawnProcLocking(struct ProcScr const * scr, AnyProc * parent);
void Proc_End(AnyProc * proc);
void Proc_Run(AnyProc * proc);
void Proc_Break(AnyProc * proc);
AnyProc * FindProc(struct ProcScr const * script);
AnyProc * FindActiveProc(struct ProcScr const * script);
AnyProc * FindMarkedProc(int mark);
void Proc_Goto(AnyProc * proc, int label);
void Proc_GotoScript(AnyProc * proc, struct ProcScr const * script);
void Proc_Mark(AnyProc * proc, int mark);
void Proc_SetEndFunc(AnyProc * proc, ProcFunc * func);
void Proc_ForAll(ProcFunc * func);
void Proc_ForEach(struct ProcScr const * script, ProcFunc * func);
void Proc_ForEachMarked(int mark, ProcFunc * func);
void Proc_LockEachMarked(int mark);
void Proc_ReleaseEachMarked(int mark);
void Proc_EndEachMarked(int mark);
void Proc_EndEach(struct ProcScr const * script);
void Proc_BreakEach(struct ProcScr const * script);
void Proc_ForSubtree(AnyProc * proc, ProcFunc * func);
void Proc_PrintSubtreeInfo(AnyProc * proc);
void Proc_SetRepeatFunc(AnyProc * proc, ProcFunc * func);
void Proc_Lock(AnyProc * proc);
void Proc_Release(AnyProc * proc);

#define Proc_Exists(script) (FindProc((script)) != NULL ? TRUE : FALSE)

#endif // PROC_H
