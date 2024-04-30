;Структура билет, содержит поля Пункт назначения, 
;Пункт вылета, Дата, Стоимость, прибавить к стоимости +99.
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
        
        flights flight 'London', 'New York', '2024-03-14', 500
                flight 'Paris', 'Tokyo', '2024-04-20', 700
                flight 'Los Angeles', 'Sydney', '2024-05-25', 900
                flight 'Moscow', 'Dubai', '2024-06-30', 600
                flight 'Rome', 'Rio de Janeiro', '2024-07-10', 800

        scount dd 5
        ssizeof dd 154

        fname db 'flights.struct',0
        fmode db 'w',0
        fdesc dd 0

section '.code' code readable writeable executable

start:
        invoke fopen, fname, fmode
        mov [fdesc], eax
        mov eax, [scount]
        imul [ssizeof]
        mov ecx, 1
        invoke fwrite, flights, ecx, eax, [fdesc]
        invoke fclose, [fdesc]

        invoke ExitProcess, 0


section '.idata' data import readable

  library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'
  
  import kernel,\
         ExitProcess, 'ExitProcess'

          
  import msvcrt,\
          printf, 'printf', getch, '_getch', scanf,\
          'scanf', fopen, 'fopen', fwrite, 'fwrite',\
          fclose, 'fclose'