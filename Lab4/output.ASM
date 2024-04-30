format PE Console

entry start

include 'win32a.inc'

section '.data' data readable writeable

        struct flight
            dest db 50 dup(0)
            depat db 50 dup(0)
            date db 50 dup(0)
            cost dd 0
        ends
        flights flight ?, ?, ?, ?
                flight ?, ?, ?, ?
                flight ?, ?, ?, ?
                flight ?, ?, ?, ?
                flight ?, ?, ?, ?

        structf db '%-11s  %-15s  %7s  %d', 10, 0 ; struct print format
        scount dd 5                               ; structs count
        ssizeof dd 154                            ; struct size
        ssizeofall dd 0                           ; size of all structs
        scur dd 0                                 ; current struct (in loop)

        delim db 46 dup('-'), 10, 0               ; delimeter between structs

        fname_r db 'flights.struct',0             ; read file name
        fname_w db 'flights.struct',0             ; write file name

        fmode_r db 'r',0                          ; read mode code
        fmode_w db 'w',0                          ; write mode code
        
        fdesc_r dd 0                              ; read file descriptor
        fdesc_w dd 0                              ; write file descriptor
        
        loopn db 1                                ; loop number for continue label


section '.code' code readable writeable executable

start:
        invoke fopen, fname_r, fmode_r
        mov [fdesc_r], eax
        mov eax, [scount]
        imul [ssizeof]
        mov [ssizeofall], eax
              
        invoke fread, flights, 1, eax, [fdesc_r]
        invoke fclose, [fdesc_r]             

        mov [scur], 0
        firstp:
                mov eax, [scur]
                imul [ssizeof]
                
                call print_struct
                
            continue1:
                mov eax, 99
                add eax, [esi]
                mov [esi], eax
                
                inc [scur]
                mov edx, [scur]
                cmp edx, [scount]
                jne firstp        

        invoke printf, delim
        
        inc [loopn]
        
        mov [scur], 0
        secondp:        
                mov eax, [scur]
                imul [ssizeof]

                call print_struct
                
            continue2:
                inc [scur]
                mov edx, [scur]
                cmp edx, [scount]
                jne secondp

        invoke fopen, fname_w, fmode_w      
        mov [fdesc_w], eax
        invoke fwrite, flights, 1, [ssizeofall], [fdesc_w]
        invoke fclose, [fdesc_w]

        invoke getch
        invoke ExitProcess, 0 


proc print_struct
        mov ebx, eax
        add ebx, flights.dest
        mov ecx, eax
        add ecx, flights.depat       
        mov edx, eax
        add edx, flights.date
        mov esi, eax
        add esi, flights.cost        
        invoke printf, structf, ebx, ecx, edx, [esi]
        ;ret
        cmp [loopn], 1
        je continue1
        jmp continue2  
endp


section '.idata' data import readable

  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf',\
          getch, '_getch', scanf, 'scanf', fopen, 'fopen',\
          fwrite, 'fwrite', fclose, 'fclose', fread, 'fread'