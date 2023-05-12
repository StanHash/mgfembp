#ifndef GBADMA_H
#define GBADMA_H

#include "gbasvc.h"

#define CPU_FILL(value, dest, size, bit)                                                                               \
    {                                                                                                                  \
        u##bit volatile tmp = (u##bit volatile)(value);                                                                \
        SwiCpuSet((void *)&tmp, dest, CPU_SET_##bit##BIT | CPU_SET_SRC_FIXED | ((size) / (bit / 8) & 0x1FFFFF));       \
    }

#define CpuFill16(value, dest, size) CPU_FILL(value, dest, size, 16)
#define CpuFill32(value, dest, size) CPU_FILL(value, dest, size, 32)

#define CPU_COPY(src, dest, size, bit) SwiCpuSet(src, dest, CPU_SET_##bit##BIT | ((size) / (bit / 8) & 0x1FFFFF))

#define CpuCopy16(src, dest, size) CPU_COPY(src, dest, size, 16)
#define CpuCopy32(src, dest, size) CPU_COPY(src, dest, size, 32)

#define CpuFastFill(value, dest, size)                                                                                 \
    {                                                                                                                  \
        u32 volatile tmp = (u32 volatile)(value);                                                                      \
        SwiCpuFastSet((void *)&tmp, dest, CPU_SET_SRC_FIXED | ((size) / (32 / 8) & 0x1FFFFF));                         \
    }

#define CpuFastFill16(value, dest, size) CpuFastFill(((value) << 16) | (value), (dest), (size))

#define CpuFastCopy(src, dest, size) SwiCpuFastSet(src, dest, ((size) / (32 / 8) & 0x1FFFFF))

#define DmaSet(dma_num, src, dest, control)                                                                            \
    {                                                                                                                  \
        u32 volatile * dma_regs = (u32 volatile *)&REG_DMA##dma_num##SAD;                                              \
        dma_regs[0] = (u32 volatile)(src);                                                                             \
        dma_regs[1] = (u32 volatile)(dest);                                                                            \
        dma_regs[2] = (u32 volatile)(control);                                                                         \
        dma_regs[2];                                                                                                   \
    }

#define DMA_FILL(dma_num, value, dest, size, bit)                                                                      \
    {                                                                                                                  \
        u##bit volatile tmp = (u##bit volatile)(value);                                                                \
        DmaSet(                                                                                                        \
            dma_num, &tmp, dest,                                                                                       \
            (DMA_ENABLE | DMA_START_NOW | DMA_##bit##BIT | DMA_SRC_FIXED | DMA_DEST_INC) << 16 |                       \
                ((size) / (bit / 8)));                                                                                 \
    }

#define DmaFill16(dma_num, value, dest, size) DMA_FILL(dma_num, value, dest, size, 16)
#define DmaFill32(dma_num, value, dest, size) DMA_FILL(dma_num, value, dest, size, 32)

#endif // GBADMA_H
