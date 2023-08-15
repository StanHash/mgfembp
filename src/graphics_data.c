#include "prelude.h"

u32 const Img_Unk_02017374[] = {
#if !defined(VER_FINAL)
#include "embed/message_gfx_nonfinal.4bpp.lz.u32"
#else
#include "embed/message_gfx.4bpp.lz.u32"
#endif
};

u32 const Tm_Unk_02017908[] = {
#include "embed/message_tm_1.bin.lz.u32"
};

#if defined(VER_FINAL)
u32 const Tm_Unk_020179D8[] = {
#include "embed/message_tm_2.bin.lz.u32"
};
#endif

u32 const Tm_Unk_02017AA8[] = {
#include "embed/message_tm_3.bin.lz.u32"
};

u16 const Pal_Unk_02017C74[] = {
#include "embed/message_gfx.gbapal.u16"
};
