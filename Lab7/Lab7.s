.equ SWI_PrStr, 0x69 @ Write a null-ending string
.equ SWI_PrInt,0x6b @ Write an Integer
.equ SWI_PrChr, 0x0
.equ Stdout, 1 @ Set output mode to be Output View
.equ SWI_Exit, 0x11 @ Stop execution

.data
inputStr: .asciz "    ABAB baba  test WBEbeB A123"
outputStr: .skip 10
newL: .ascii "\n"

.text
.global _start

_start:

mov r0, #Stdout
ldr r1, =inputStr
swi SWI_PrStr

ldr r0,=newL
ldrb r0,[r0]
swi SWI_PrChr

ldr r2, =inputStr @ str array
mov r3, #0		  @ cur char
skip_space:	
	ldrb r4, [r2, r3]
	cmp r4, #' '
	beq is_space
	bne not_space
	is_space:
		add r3, r3, #1
		b skip_space
not_space:
skip_word:
	ldrb r4, [r2, r3]
	cmp r4, #' '
	bne is_word
	beq not_word
	is_word:
		cmp r4, #0
		beq end_of_line
		add r3, r3, #1
		b skip_word
not_word: 

ldr r6, =outputStr
mov r5, #0 @ new str idx
strcpy:
	ldrb r4, [r2, r3]
	cmp r4, #0
	beq end_of_line
	strb r4, [r6, r5]
	add r5, r5, #1
	add r3, r3, #1
	bne strcpy

end_of_line:
mov r4, #'\n'
strb r4, [r6, r5]
add r5, r5, #1
mov r4, #0
strb r4, [r6, r5]

mov r0, #Stdout
ldr r1, =outputStr
swi SWI_PrStr


mov r3, #0
to_lowercase:
	ldrb r4, [r2, r3]
	cmp r4, #0
	beq fin
	mov r5, #'A'
	cmp r4, r5
	blt skip_char
	mov r5, #'Z'
	cmp r5, r4
	blt skip_char
	mov r5, #32
	add r4, r4, r5
	strb r4, [r2, r3]
	skip_char:
		add r3, r3, #1
		b to_lowercase
fin:
	mov r0, #Stdout
	ldr r1, =inputStr
	swi SWI_PrStr
swi SWI_Exit

