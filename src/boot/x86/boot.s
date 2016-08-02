%define BOOT_ADDRESS 0x07c0
%define LOADER_ADDRESS 0x07E0
%define KERNEL_ADDRESS 0x0800
%define FIRST_DISK 0x80
%define DISK_READ_COM 0x42
%define JMP_TO_HERE 0x0050

[bits 16]
  org BOOT_ADDRESS
  jmp short START

START:
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ss, ax

READ:
  mov bx, LOADER_ADDRESS
  call HARDDISK.SetAddress

  mov bx, 2
  call HARDDISK.SetReadNumber

  mov bx, 1
  call HARDDISK.SetReadFrom

  call HARDDISK.Read

;KERNEL:
;  mov bx, KERNEL_ADDRESS
;  call HARDDISK.SetAddress
;
;  mov bx, 2
;  call HARDDISK.SetReadNumber
;
;  mov bx, 2
;  call HARDDISK.SetReadFrom
;
;  call HARDDISK.Read

RUN:
  jmp LOADER_ADDRESS:0x0


HARDDISK:
  jmp .Read

  ; bx -> void
  .SetAddress:
    mov [BOOT_ADDRESS * 0xf + .Struct + 6], bx
    ret

  ; bx -> void
  .SetReadNumber:
    mov [BOOT_ADDRESS * 0xf + .Struct + 2], bx
    ret

  ; bx -> void
  .SetReadFrom:
    mov [BOOT_ADDRESS * 0xf + .Struct + 8], bx
    ret

  .Read:
    mov si, BOOT_ADDRESS * 0xf + .Struct
    mov ah, 0x42
    mov dl, FIRST_DISK
    int 0x13
    jc .Read
    ret

    nop

  .Struct:
    db 10h
    db 0
    dw 0x0 ; read number
    dw 0x0 ; loading offset
    dw 0x0 ; loading segment
    dq 0x0 ; read from harddisk number

    nop

times 510 - ($ - $$) DB 0
DW 0xAA55
