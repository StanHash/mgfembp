#ifndef ATTRIBUTES_H
#define ATTRIBUTES_H

#define NAKEDFUNC __attribute__((naked))
#define SECTION(s) __attribute__((section(s)))
#define ALIGNED(n) __attribute__((aligned(n)))

#define EWRAM_DATA SECTION(".ewram_data")
#define COMMON_DATA(name) SECTION(".common." #name)

#define SHOULD_BE_CONST
#define SHOULD_BE_STATIC

#endif // ATTRIBUTES_H
