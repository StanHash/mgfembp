#include "prelude.h"

u8 const Img_Unk_02017374[] = {
#if !defined(VER_FINAL)
#include "embed/message_gfx_nonfinal.4bpp.lz.u8"
#else
#include "embed/message_gfx.4bpp.lz.u8"
#endif
};

u8 const Tm_Unk_02017908[] = {
#include "embed/message_tm_1.bin.lz.u8"
};

#if defined(VER_FINAL)
u8 const Tm_Unk_020179D8[] = {
#include "embed/message_tm_2.bin.lz.u8"
};
#endif

u8 const Tm_Unk_02017AA8[] = {
#include "embed/message_tm_3.bin.lz.u8"
};

u16 const Pal_Unk_02017C74[] = {
#include "embed/message_gfx.gbapal.u16"
};
