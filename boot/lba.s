%define BOOT_ADDRESS 0x07c0
%define FIRST_DISK 0x80
%define DISK_READ_COM 0x42
%define UNUSED_MEMORY 0x0500

[bits 16]
[ORG 0]

jmp BOOT_ADDRESS:START

LBA:
  .SIZE     db 0x10
  .RESERVED db 0x0
  .COUNT    dw 0x1
  .SEG_OFF  dw UNUSED_MEMORY
  .SEG      dw 0x0
  .NUMBER   dq 1

START:
  mov ax, cs
  mov ds, ax
  mov es, ax

  call LOAD
  jmp 0:UNUSED_MEMORY


LOAD:
  mov ah, DISK_READ_COM
  mov dl, FIRST_DISK
  mov SI, LBA
  int 13h
  jc  LOAD
  ret

times 510 - ($ - $$) db 0
DW 0xAA55
