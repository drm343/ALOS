%define BootUpAdress 0x07c0
%define OS_Image     0x1000
%define Disk_Read    0x02
%define Bios_Read    0x13
%define Disk_1       0x80

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
    mov ax , BootMessage
    call Disprint
    call LoadOs
    jmp OS_Image:0

Disprint:
    mov bp , ax
    mov cx , 11
    mov ax , 0x1301
    mov bx , 0x000f
    mov dx , 0x0000
    int 0x10
    ret

LoadOs:
    push es
    mov  ax , OS_Image
    mov  es , ax
    mov  bx , 0
    xor  cx , cx
LoadOsing:
    mov  ah , Disk_Read
    mov  al , 0x02
    mov  ch , byte [CurrentCylintor]
    mov  cl , byte [CurrentSector]
    mov  dh , byte [CurrentHead]
    mov  dl , Disk_1
    int  Bios_Read
    pop  es
    ret

BootMessage db "Hello world" , 0
CurrentSector:   db 0x02
CurrentHead:     db 0x00
CurrentCylintor: db 0x00
times 510-($-$$) db 0
dw    0xaa55
