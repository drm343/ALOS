%define BootUpAdress 0x07c0

[bits 16]
[org 0x0000]

BootSectorAt07c0:
    cli
    jmp BootUpAdress:BootStart
BootStart:
    mov ax , cs
    mov ds , ax
    mov ss , ax
    mov es , ax
    mov sp , 0x3fe
    call Disprint
    jmp $

Disprint:
    mov ax , BootMessage
    mov bp , ax
    mov cx , 11
    mov ax , 0x1301
    mov bx , 0x000f
    mov dx , 0x0000
    int 0x10
    ret

BootMessage db "Hello world" , 0
times 510-($-$$) db 0
dw    0xaa55
