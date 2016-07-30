[bits 16]
  org 0x0
  jmp short Start

Start:
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ss, ax

  mov ax, Kernel.msg
  mov cx, Kernel.MSGLEN
  call _Text
  jmp $

_Text:
  jmp .show

  .show:
    mov bp, ax
    mov ax, 0x1301
    mov bx, 0x000c
    mov dl, 0
    int 10h
    ret

  .reset:
    xor dx, dx
    ret

  .newline:
    add dh, 1
    ret

Kernel:
  .msg DB 'nice body'
  .MSGLEN equ $-.msg
  nop

times 1024 - ($ - $$) DB 0
