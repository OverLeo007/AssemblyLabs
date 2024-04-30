global main
 
extern scanf
extern printf
 
section .data
    message1: db "Enter A: ", 10, 0
    message2: db "Enter X: ", 10, 0
    formatin: db "%f", 0
    formatout: db "Y=%f | ",  0
    X: times 4 db 0
    A: times 4 db 0
    Y1: dq 0
    Y2: dq 0
    Y: dd 0
    tmp: dd 0
    
    printX: db "X=%f", 10, 0
 
section .text
scanNumber:
    push message1
    call printf
    add esp, 4 ; remove parameters
 
    push A
    push formatin
    call scanf
    add esp, 8
 
    push message2
    call printf
    add esp, 4
 
    push X
    push formatin
    call scanf
    add esp, 8
    ret
 
  printNumber:
    sub esp, 8
    fstp qword [esp]
    push formatout    
    call printf
    add esp, 12
    ret
 
 calcY1:
    fld dword [A]
    fcom dword [X]
    fstsw ax
    fwait
    sahf
    
    jb xGreaterA
    mov dword [tmp], 2   ; if x <= a
    fild dword [tmp] 
    fmul
    fsub dword [X]
    fstp qword [Y1]    
    ret
    xGreaterA: 
        fadd dword [X] ; if x > a
        fstp qword [Y1]
        ret
        
    
    fld dword [A]
    fadd dword [X]
    ret
 
 calcY2:
    fld dword [X]
    mov dword [tmp], 10
    fild dword [tmp] 
    fcomp
    fstsw ax
    fwait
    sahf
    
    jb xGreater10
    fstp qword [Y2] ; if x <= 10
    ret
    xGreater10: 
        fmul dword [A]
        fstp qword [Y2]
        ret
        
    fld dword [A]
    fadd dword [X]
    ret
    
calcY:
    fld qword [Y1]
    fld qword [Y2]
    fadd
    ret
 
 main:
    mov ebp, esp; for correct debugging
    finit
    call scanNumber

    
    mov ecx, 10
    mainloop: 
   
        push ecx
        call calcY1
        call calcY2
        call calcY
        call printNumber        
        sub esp, 8
        fld dword [X]
        fst qword [esp]
        push dword printX
        call printf
        add esp, 12
        fld1
        fadd
        fstp dword [X]
        pop ecx     
    loopne mainloop
    
exit:   
    ret