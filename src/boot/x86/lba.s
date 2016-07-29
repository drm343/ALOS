%define BOOT_ADDRESS 0x07c0
%define LOADER_ADDRESS 0x7E00
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
  mov bx, LOADER_ADDRESS
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
  jmp LOADER_ADDRESS:0x0

times 510 - ($ - $$) DB 0
DW 0xAA55
