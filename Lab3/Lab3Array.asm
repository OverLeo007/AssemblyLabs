;"Дана матрица, найти максимальное значение среди минимальных по строкам."
global main        ;нужно продекларировать для использования gcc
   extern scanf
   extern printf
   extern puts
   extern time
   extern srand
   extern rand
 
section .bss
    array: resb 1024   ; массив из 1024-х 1-байтовых чисел
    strMins: resb 512
 
section .data
    message1: db "Enter N: ", 10, 0
    message2: db "Enter M: ", 10, 0
    formatin: db "%d", 0
    formatout: db "Result: %d",  10, 0
    fmaxOfminsOut: db "Result: %d", 10, 0
    farrelem: db "%3d ",  0
    curMax: db 0
    curMin: db 101
    randnum: db 0


    N: dd 0
    M: dd 0
    size: dd 1
    
    fenter: db 0



section .text

scanNumber:
    push message1
    call printf
    add esp, 4 ; remove parameters
 
    push N
    push formatin
    call scanf
    add esp, 8
 
    push message2
    call printf
    add esp, 4
 
    push M
    push formatin
    call scanf
    add esp, 8
    ret
 
 printNumber:
    push edx
    push formatout    
    call printf
    add esp, 8
    ret
  
 printArrElem:
    push edx
    push  farrelem
    call printf
    add esp, 8
    ret
 
printEnter:
    push fenter
    call puts
    add esp, 4
    ret
   
setRandom:
    push 0
    call time
    add esp, 4
    push eax
    call srand
    add esp, 4
    ret

getRandom: ;Херим edx, ecx
    call rand
    mov ecx, 90
    xor edx, edx
    div ecx
    add edx, 10
    mov [randnum], edx
    ret


setSize: ;Херим edi и eax 
    mov eax, [N]
    mul dword [M]
    mov [size], eax
    ret

setArray:
    mov ecx, [size]
    xor edi, edi
    setArrayLoop:
        push ecx
        push edi
        
        call getRandom
        mov ecx, [randnum]
        mov [array + edi], ecx

        pop edi
        inc edi
        pop ecx

        loop setArrayLoop
     ret

findMaxMin:
    mov ecx, [size]
    xor edi, edi
    mainArrayLoop:
        push ecx
        push edi
        movzx edx, byte [array + edi]
        movzx eax, byte [curMin]

        cmp edx, eax
        jg minCmpEnd
        mov [curMin], edx
        minCmpEnd:
        
        call printArrElem
        inc edi
        
        mov eax, edi
        mov ebx, dword [M]
        xor edx, edx
        div ebx
        cmp edx, 0
        
        jne finEndlineCmp
            
            movzx edx, byte [curMin]
            movzx eax, byte [curMax]
            
            cmp edx, eax
            jl maxCmpEnd
            mov [curMax], edx
            maxCmpEnd:
            call printArrElem
            call printEnter

            mov eax, 101
            mov [curMin], eax
            
        finEndlineCmp:
        pop edi
        inc edi
        pop ecx
        loop mainArrayLoop
        
        movzx edx, byte [curMax]
        push edx
        push  formatout
        call printf
        add esp, 8
     ret

printArray:
    mov ecx, [size]
    xor edi, edi
    printArrayLoop:
        push ecx
        push edi
        
        movzx edx, byte [array + edi]
               
        call printArrElem
        inc edi
        
        mov eax, edi
        mov ebx, dword [M]
        xor edx, edx
        div ebx
    
        cmp edx, 0
        je zero
        jne not_zero
        zero:
            call printEnter
        not_zero:
        pop edi
        inc edi
        pop ecx
       
        loop printArrayLoop
     ret

main:
    mov ebp, esp; for correct debugging
    call setRandom
    call scanNumber
    call setSize
    call setArray
    call printArray
    call printEnter
    call findMaxMin
    
    ret
