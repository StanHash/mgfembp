#ifndef COMMON_H
#define COMMON_H

#include "attributes.h"
#include "types.h"

#define STRUCT_PAD(from, to) unsigned char _struct_pad_##from[(to) - (from)];

#endif // COMMON_H
