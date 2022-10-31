@the information that tells arm-none-eabi-as what arch. to assemble to
        .cpu arm926ej-s
        .fpu softvfp

@this is code section
@note, we must have the main function for the simulator's linker script
        .text
        .align  2   @align 4 byte
        .global main
main:
    @prologue
        stmfd   sp!, {r0, r5, r6, r7, fp, lr}
        add     fp, sp, #4

    @code body
        ldr r0, [r1] @print execute prog name
        ldr r6, [r1,#4] @r0 store argc; r1 store command line

        @bl printf
        adr r0, label @print result:
        bl printf
	mov r7,#0
        mov r7, r6
        mov r5, #-1
		
@countFirst
loop1:
        ldrb r3, [r6] ,#1
        cmp r3, #0
        addne r5, r5, #1
        bne loop1

loop2:
        ldrb r3, [r7,r5]
        cmp r5,#0
	blt end
		
        cmp r3, #'A' @not a letter
        blt stor
        cmpge r3, #'Z' @change to lowercase
        ble case

stor:   
	mov r0,r3
	bl putchar
 
        sub r5, r5, #1
        b loop2
end:


        @epilogue
        sub     sp, fp, #4
        ldmfd   sp!, {r0, r5, r6, r7, fp, lr}
        bx      lr

@change to lowercase
case:
        add r3, r3, #32 @by Ascii
        b stor

@data section
label:
        .ascii " reversed result:\0"
