%define BOOT_ADDRESS 0x0

[bits 16]
[org BOOT_ADDRESS]
  mov ax, cs
  mov ds, ax
  mov es, ax

  ;call Text.reset

  mov ax, Hello.msg
  mov cx, Hello.MSGLEN
  call Text

  call Text.newline
  mov ax, Loading.msg
  mov cx, Loading.MSGLEN
  call Text

  jmp $

Text:
  jmp .show

  .show:
    add ax, BOOT_ADDRESS * 0x0F
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


Hello:
  .msg DB 'hello'
  .MSGLEN equ $-.msg

Loading:
  .msg DB 'loading ok'
  .MSGLEN equ $-.msg

times 510 - ($ - $$) DB 0
DW 0xAA55
