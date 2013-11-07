     1                                  [bits 16]
     2                                  [ORG 0]
     3                                  
     4                                  start:
     5 00000000 8CC8                      mov ax, cs
     6 00000002 8ED8                      mov ds, ax
     7 00000004 8EC0                      mov es, ax
     8                                  
     9 00000006 B8[1E05]                  mov ax, 0x0500 + msg
    10 00000009 E80200                    call Disp
    11 0000000C EBFE                      jmp $
    12                                  
    13                                  Disp:
    14 0000000E 89C5                      mov bp, ax
    15 00000010 B90500                    mov cx, 5
    16 00000013 B80113                    mov ax, 0x1301
    17 00000016 BB0C00                    mov bx, 0x000c
    18 00000019 B200                      mov dl, 0
    19 0000001B CD10                      int 10h
    20 0000001D C3                        ret
    21                                  
    22 0000001E 68656C6C6F              msg: db 'hello'
    23                                  
    24 00000023 00<rept>                times 512 - ($ - $$) db 0
