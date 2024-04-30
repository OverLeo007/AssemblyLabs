;"Дана матрица, найти максимальное значение среди минимальных по строкам."
.globl __start


.data
  asize:            .word 0
  N:                .word 0  ; cols
  M:                .word 0  ; strs
  curMax:           .word 0
  curMin:           .word 101


.bss
  array:            .zero 1024


.rodata
  O_READONLY:       .word 0b0000001
  path:             .string "D:/Edu/ASM/Lab6/array.bin"
  new_line:         .asciz "\n"
  space:            .asciz " "
  n_is:             .asciz "N = "
  m_is:             .asciz "M = "
  asize_is:         .asciz "Array size = "
  min_is:           .asciz "| Min = "
  max_is:           .asciz "| Max of mins = "
  delimiter:        .asciz "----------------------------\n"


.text


open_file:
  li a0, 13
  la a1, path
  lw a2, O_READONLY 
  ecall
  ret


load_size:
  li a0, 14 ; load N
  mv a1, s0
  la a2, N  
  li a3, 1
  ecall
  
  li a0, 14 ;  load M
  mv a1, s0
  la a2, M
  li a3, 2
  ecall
  
  la t0, N
  lw a0, 0(t0)
  
  la t1, M
  lw a1, 0(t1)
  
  mul s1, a0, a1
  
  la t0, asize ; calc N * M
  sw s1, 0(t0)
  ret
  
load_array:
  li a0, 14
  mv a1, s0
  la a2, array
  la t0, asize
  
  lw a3, 2(t0)
  ecall
  ret




find_max:
  ; t0 - tmp for load
  ; t1 - cur elem val
  ; t2 - value of s4 + 1 % s3
  ; t3 - tmp for s4 + 1
  ; t4 - tmp for curMin
  ; t5 - tmp for curMax
  count_loop:
    
    mv t0, s1
    add t0, t0, s4
    lb t1, 0(t0)
    
    li a0, 1
    mv a1, t1
    ecall
    
    la t0, curMin
    lw t4, 0(t0)
    blt t1, t4, c_find_new_min
    j c_end_of_find_min
    c_find_new_min:
      sw t1, 0(t0)
    
    c_end_of_find_min:
    
    ; --- count if end of line
    mv t3, s4
    addi t3, t3, 1
    rem t2, t3, s3
    ; ---
    
    beq t2, zero, c_end_of_line
      li a0, 4
      la a1, space
      ecall
    j c_end_of_check
    c_end_of_line:
    
        li a0, 4
        la a1, space
        ecall
        
        li a0, 4
        la a1, min_is
        ecall
        
        li a0, 1
        la t0, curMin
        lw a1, 0(t0)
        ecall 
        
        lw t4, 0(t0) ; store curMin value
        
        li t6, 101
        sw t6, 0(t0) ; reset curMin
        
        la t0, curMax
        lw t5, 0(t0) ; store curMax value
        
        bgt t4, t5, c_find_new_max
        j c_end_of_find_max
        c_find_new_max:
          sw t4, 0(t0)
        
        c_end_of_find_max:
        li a0, 4
        la a1, new_line
        ecall
    c_end_of_check:
    
    addi s4, s4, 1
    blt s4, s2, count_loop
        
  li s4, 0
  ret


print_del:
  li a0, 4
  la a1, delimiter
  ecall
  ret


print_array:  
  print_loop:
    mv t0, s1
    add t0, t0, s4
    
    lb t1, 0(t0)
    li a0, 1
    mv a1, t1
    ecall
    
    mv t4, s4
    addi t4, t4, 1
    rem t2, t4, s3
  
    beq t2, zero, end_of_line
      li a0, 4
      la a1, space
      ecall
    j end_of_check
    end_of_line:
        li a0, 4
        la a1, new_line
        ecall
    end_of_check:
    
    addi s4, s4, 1
    
    blt s4, s2, print_loop
  
  li s4, 0
  ret



print_params:

  li a0, 4
  la a1, n_is
  ecall        ; N = 
  
  li a0, 1
  la t0, N
  lw a1, 0(t0)
  ecall        ; N_val

  li a0, 4
  la a1, space
  ecall
  
  li a0, 4
  la a1, m_is
  ecall        ; M = 
  
  li a0, 1
  la t0, M
  lw a1, 0(t0)
  ecall        ; M_val
  
  li a0, 4
  la a1, new_line
  ecall
  
  li a0, 4
  la a1, asize_is
  ecall        ; Array size = 
  
  li a0, 1
  la t0, asize
  lw a1, 0(t0)
  ecall        ; asize_val

  li a0, 4
  la a1, new_line
  ecall
  
  ret

__start:
 
; ------------------- INITIALIZATION -------------------

  call open_file
  mv s0, a0     ; s0 - file descriptor | const

  call load_size
  call load_array
  
  la s1, array  ;  s1 elems | const
  la t0, asize
  lw s2, 0(t0)  ;  s2 - elems count | const
  
  la t0, M
  lw s3, 0(t0)  ;  s3 - cols count | const
  
  li s4, 0      ;  s4 - cur elem | ОБНУЛИТЬ ПОСЛЕ ЦИКЛА

; ------------------- PRINTING ------------------------

  call print_params
  call print_del
  call print_array
  call print_del

; ------------------- COUNTING ------------------------

  call find_max
  
  la t0, curMax
  lw t5, 0(t0)
  
  li t0, 2
  mul s5, s3, t0
  add s5, s5, s3
  li t1, 0
  spacing:
    li a0, 4
    la a1, space
    ecall
    addi t1, t1, 1
    blt t1, s5, spacing
  
  li a0, 4
  la a1, max_is
  ecall
  
  li a0, 1
  mv a1, t5
  ecall
  
; -------------------- FINAL --------------------------

  li a0, 16  ; close file
  mv a1, s0
  ecall
  
  li a0, 10
  ecall