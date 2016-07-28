%define BOOT_ADDRESS 0x07c0
%define FIRST_DISK 0x80
%define DISK_READ_COM 0x42
%define JMP_TO_HERE 0x0050

[bits 16]
  org BOOT_ADDRESS
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ss, ax

READ:
  call DispStr1
  mov bx, 0x7E00
  mov es, bx
  mov bx, 0x0000

  mov ah, 0x02
  mov al, 0x01
  mov ch, 0x00
  mov cl, 0x02
  mov dh, 0x00
  mov dl, FIRST_DISK
  int 0x13
  jc READ
  jmp RUN

RUN:
  call DispStr2
  jmp 0x7E00:0x0

DispStr1:
  mov ax, BOOT_ADDRESS * 0x0F + MSG1
  mov bp, ax
  mov cx, MSG1Len
  mov ax, 0x1301
  mov bx, 0x000c
  mov dl, 0
  int 0x10
  ret

DispStr2:
  mov ax, cs
  mov es, ax

  mov ax, BOOT_ADDRESS * 0x0F + MSG2
  mov bp, ax
  mov cx, MSG2Len
  mov ax, 0x1301
  mov bx, 0x000c
  mov dl, 0
  mov dh, 1
  int 0x10
  ret

MSG1: db "Hello os"
MSG1Len equ $-MSG1

dw 0

MSG2: db "load ok"
MSG2Len equ $-MSG2

times 510 - ($ - $$) DB 0
DW 0xAA55
