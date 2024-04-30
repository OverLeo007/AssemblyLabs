# y=y1 mod y2
# y1= { 10 + x,  if x > 1
#     { |x| + a, if x <= 1
# y2= { 2,       if x > 4
#     { x,       if x <= 4
.global __start 

.data
enterX:		.asciz "Enter X\n"
enterA:         .asciz "Enter A\n" 
printX:         .asciz " x = "
printY1:        .asciz " y1 = "
printY2:        .asciz " y2 = "
printY:         .asciz " y = "
printI:         .asciz "i = "
newline:        .asciz "\n"


.text

getNums:
        li a0, 4
        la a1, enterX 
        ecall
        
        # s0=x
        li a0, 5
        ecall
        mv s0, a0
        
        li a0, 4
        la a1, enterA 
        ecall        
        
        # s1=a
        li a0, 5
        ecall
        mv s1, a0
        ret

countY1:
        # y1= { 10 + x,  if x > 1
        #     { |x| + a, if x <= 1
        mv a2, s0 
        li t3, 1           
        ble a2, t3, elseY1 # if X <= 1
            
        # s3 = Y1 = 10 + x
        li t3, 10
        add s3, a2, t3
        j endifY1
          
        elseY1:    
          # s3 = Y1 = |x| + a
          bltz a2, is_neg
          is_neg:
            neg a2, a2
          add s3, a2, s1
          
        endifY1:
          ret
          
countY2:
        # y2= { 2,       if x > 4
        #     { x,       if x <= 4
        mv a2, s0
        li t3, 4
        ble a2, t3, elseY2 # if x <= 4
        
        # s4 = Y2 = 2
        li s4, 2
        j endifY2
        
        elseY2:
          mv s4, a2
        
        endifY2:
          ret

countY:
        rem s5, s3, s4
        ret          
        
printStr:
        li a0, 4
        ecall
        ret

printNum:
        li a0, 1
        ecall
        ret

__start:
        call getNums
        
        li t0, 0
        
        mainloop:
          li t1, 1
          add s0, s0, t1
          call countY1
          call countY2
          call countY
          
          # print i = 
          la a1, printI
          call printStr
                   
          # print i
          mv a1, t0
          call printNum
          
          # print x = 
          la a1, printX
          call printStr
          
          # print x
          mv a1, s0
          call printNum
          
          # print y1 = 
          la a1, printY1
          call printStr

          # print y1
          mv a1, s3
          call printNum

          # print y2 =           
          la a1, printY2
          call printStr
          
          # print y2          
          mv a1, s4
          call printNum
          
          # print y =
          la a1, printY
          call printStr

          # print y          
          mv a1, s5
          call printNum
                      
          # print \n
          la a1, newline
          call printStr
                
          addi t0, t0, 1
          li x4, 10
          blt t0, x4, mainloop
        

        li a0, 10 # stop code
        ecall     
            