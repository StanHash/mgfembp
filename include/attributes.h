#ifndef ATTRIBUTES_H
#define ATTRIBUTES_H

#define NAKEDFUNC __attribute__((naked))
#define SECTION(s) __attribute__((section((s))))

#define SHOULD_BE_CONST
#define SHOULD_BE_STATIC

#endif // ATTRIBUTES_H
