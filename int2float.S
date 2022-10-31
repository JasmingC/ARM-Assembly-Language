@this is comment

@this is code section
@note, we must have the main function for the simulator's linker script
    .syntax unified
    .text
    .align 2
    .global main
main:
    stmfd sp!,{r4-r10,fp,lr}
    mov r4,#0
    ldr r5,[r1,#4]

print_info:
    ldrb r0,[r5],#1 @ store argv[1][r4]
    cmp r0, #'N'    @ check if it's minus or not
    beq print_negative
    bne print_positive

string_to_number:
    ldrb r0,[r5],#1 @ store argv[1][r4]
    cmp r0,#0       @ check if it's the end of string
    @moveq r6,#28
    beq exponent
    sub r0,r0,#'0'
    mov r1,#10
    mul r2,r4,r1
    mov r4,r2
    add r4,r4,r0
    b string_to_number

print_negative:
    stmfd sp!,{r0-r3,lr}
    ldr r0,=negative_string
    mov r1,r5
    bl printf
    ldmfd sp!,{r0-r3,lr}
    b string_to_number

print_positive:
    stmfd sp!,{r0-r3,lr}
    ldr r0,=positive_string
    sub r5,r5,#1
    mov r1,r5
    bl printf
    ldmfd sp!,{r0-r3,lr}
    b string_to_number

exponent:
    mov r5,#31

find_first_one:
    mov r0,r4
    mov r0,r0,lsr r5
    bic r0,r0,#0xfffffffe
    cmp r0,#1
    subne r5,r5,#1
    bne find_first_one
    add r5,r5,#127
    mov r7,r5
    mov r6,#7

print_exponent:
    mov r5,r7
    mov r5,r5,lsr r6
    bic r0,r5,#0xfffffffe
    add r0,r0,#'0'
    bl putchar
    sub r6,r6,#1
    cmp r6,#0
    bge print_exponent
    blt fraction

fraction:
    @ldr r0,=#' '
    @bl putchar
    mov r6,#23
    sub r5,r7,#128
    @rsb r5,r7,#32

print_fraction:
    mov r0,r4
    mov r0,r0,lsr r5
    bic r0,r0,#0xfffffffe
    add r0,r0,#'0'
    bl putchar
    sub r5,r5,#1
    sub r6,r6,#1
    cmp r5,#0
    bge print_fraction
    cmp r6,#0
    bgt print_zero
    b exit

print_zero:
    ldrge r0,=#'0'
    bl putchar
    sub r6,r6,#1
    cmp r6,#0
    bgt print_zero
    b exit

print_binary:
    mov r1,r4
    mov r1,r1,lsr r6
    bic r1,r1,#0xfffffff0
    cmp r1,#10
    addlt r0,r1,#'0'
    subge r1,r1,#10
    addge r0,r1,#'a'
    bl putchar
    sub r6,r6,#4
    cmp r6,#0
    bge print_binary
    b exit

exit:
    ldmfd sp!,{r4-r10,fp,lr}
    bx lr

one_string:
    .asciz "1"
    .align 2

zero_string:
    .asciz "0"
    .align 2

positive_string:
    .asciz "%s is coded by 0"

negative_string:
    .asciz "-%s is coded by 1"
