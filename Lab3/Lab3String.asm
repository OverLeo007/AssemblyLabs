global main

extern scanf
extern printf
extern puts

section .bss
    line resb 256
    resWord resb 256

section .data
    formatin: db "%[]", 0
    formatout: db "%s", 0
    errorout: db "No words in string((", 0
    index: dd 10000
    minLength: dd 10000

section .text
getString: 
    push line
    push formatin
    call scanf
    add esp, 8
    ret

printString:
    push resWord
    push formatout
    call printf
    add esp, 8
    ret
    
getMinimalWordIndex:
    mov edi, 0 ; last idx
    mov edx, 0 ; first idx
    zero:
        movzx eax, byte [line + edi]
        cmp eax, 0
        je space
        cmp eax, 32
        je space
        
        movzx esi, byte [line + edi + 1]
        cmp esi, 0
        je before_space
        cmp esi, 32
        jne after_space
        
        before_space:
            push edi
            sub edi, edx
            
            cmp [minLength], edi
            jbe hold_old_word
            
            inc edi
            mov [minLength], edi
            pop edi
            
            mov [index], edx
            jmp after_space
            
            hold_old_word:
                pop edi
        
        jmp after_space
        
        space:
            mov edx, edi
            inc edx

        after_space:
            inc edi
            cmp eax, 0
            jne zero
            
    cmp dword [minLength], 10000
    je noWords
    mov ecx, dword [minLength]
    mov edi, 0
    mov esi, [index]
    printLoop:
        movzx eax, byte [line + esi + edi]
        mov [resWord + edi], eax
        inc edi
        loop printLoop
        ret
    noWords:
        push errorout
        call puts
        add esp, 4
    ret
    
main:
    mov ebp, esp; for correct debugging
    call getString
    call getMinimalWordIndex
    call printString
    ret