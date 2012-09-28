%define BootUpAdress 0x07c0
%define OS_Image     0x1000
%define Disk_Read    0x02
%define Bios_Read    0x13
%define Disk_1       0x00

[bits 16]
[org 0x0000]

BootSectorAt07c0:
    jmp  BootUpAdress:BootStart
BootStart:
    mov  ax , BootUpAdress
    mov  ds , ax
    mov  ss , ax
    mov  es , ax
    mov  sp , 0x3fe
    call LoadOs
    jmp OS_Image

LoadOs:
    mov  ax , OS_Image
    mov  es , ax
    mov  bx , 0
    xor  cx , cx
reset:
    mov  ah , 0x00
    int  Bios_Read
    or   ah , ah
    jnz  reset
LoadOsing:
    mov  ah , Disk_Read
    mov  al , 0x02
    mov  ch , 0
    mov  cl , 0x02
    mov  dh , 0
    mov  dl , Disk_1
    int  Bios_Read
    or   ah , ah
    jnz  LoadOsing
    ret

times 510-($-$$) db 0
dw    0xaa55
