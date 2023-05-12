    .syntax unified
    .text

    .macro arm_func_start name

        .arm
        .global \name
        .type \name , function

    .endm

    .macro thumb_func_start name

        .thumb
        .global \name
        .type \name , function

    .endm
