#ifndef COMMON_H
#define COMMON_H

#include "attributes.h"
#include "types.h"

#if defined(MODERN) && MODERN
#define STRUCT_PAD(from, to)
#else
#define STRUCT_PAD(from, to) unsigned char _struct_pad_##from[(to) - (from)]
#endif

#if defined(MODERN) && MODERN
#define STATIC_ASSERT(expr) _Static_assert(expr)
#else
#define STATIC_ASSERT(expr)
#endif

#define ARRAY_COUNT(array) (sizeof(array) / sizeof((array)[0]))

#endif // COMMON_H
