[bits 16]

InStart:
    jmp Start
Start:
    mov ax , cs
    mov ds , ax
    mov ss , ax
    mov es , ax
    mov ax , HelloMessage
    call ModePrint
    jmp $

ModePrint:
    mov bp , ax
    mov cx , 11
    mov ax , 0x1301
    mov bx , 0x000f
    mov dx , 0x0100
    int 0x10
    ret

HelloMessage db "hahahahaha" , 0
times (1024-($-$$)) db 0
