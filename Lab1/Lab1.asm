global main
 
extern scanf
extern printf
 
section .data
    message1: db "Enter the first number: ", 10, 0
    message2: db "Enter the second number: ", 10, 0
    formatin: db "%f", 0
    formatout: db "Task: %d --> %f", 10, 0
    X: times 4 db 0
    Y: times 4 db 0
    tmp: dd 0
 
section .text  
scanNumbers:
    push message1
    call printf
    add esp, 4 ; remove parameters
 
    push X
    push formatin
    call scanf
    add esp, 8
 
    push message2
    call printf
    add esp, 4
 
    push Y
    push formatin
    call scanf
    add esp, 8
    ret
 
 
 printNumber:
    sub esp, 8
    fstp qword [esp]
    push eax
    push formatout    
    call printf
    add esp, 16
    ret
 

 calc1:
    ; 16.Z = - X/Y+Y^2 +3;
    fld dword [X]
    fdiv dword [Y]
    fchs
    
    fld dword [Y]
    fld dword [Y]
    fmul
    mov dword [tmp], 3
    fild dword [tmp]
    fadd
    fadd
    mov eax, 16
    call printNumber
    ret
    
calc2:
    ; 17.Z = Y^2 + XY + X/Y;
    fld dword [Y]
    fmul dword [Y]
    
    fld dword [X]
    fmul dword [Y]
    
    fld dword [X]
    fdiv dword [Y]
    
    fadd
    fadd
    
    mov eax, 17
    call printNumber
    ret
 
calc3:
    ; 18.Z = (1 + X * Y )/2;
    
    fld1
    fld dword [X]
    fmul dword [Y]
    fadd
    
    mov dword [tmp], 2
    fild dword [tmp]
    fdivp st1, st0
    
    mov eax, 18
    call printNumber
    ret

calc4:
    ; 19.Z = -(1-Y)/(1+X);

    fld1
    fchs
    fld dword [Y]
    fadd
    
    fld1
    fld dword [X]
    fadd
    
    fdivp st1, st0

    mov eax, 19
    call printNumber
    ret

 calc5:
    ; 20.Z = -X*(1-XY);
    fld dword [X]
    fchs
    fld1
    fld dword [X]
    fmul dword [Y]
    fsubp st1, st0
    fmul
    mov eax, 20
    call printNumber
    ret
  
 
main:
    mov ebp, esp; for correct debugging
    finit
    call scanNumbers
    call calc1
    call calc2
    call calc3
    call calc4
    call calc5    
    ret