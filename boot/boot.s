%define BOOTUP_SEC 0x7c00

[bits 16]
[org BOOTUP_SEC]

BootSectorAt07c0:
    cli
    mov ax , cs
    mov ds , ax
    mov ss , ax
    mov es , ax
    call DispStr
    jmp $

DispStr:
    mov ax , BootMessage
    mov bp , ax
    mov cx , 11
    mov ax , 01301h
    mov bx , 0000Ch
    mov dx , 0x0000
    int 10h
    ret

BootMessage db "Hello world" , 0
times 510-($-$$) db 0
dw    0xaa55
