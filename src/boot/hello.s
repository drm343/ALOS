[bits 16]
org 0x0700

jmp START

START:
  mov ax, cs
  mov ds, ax
  mov es, ax

  mov ax, Text.msg
  call Text
  jmp $

Text:
  jmp .show

  .msg DB 'hello'

  .show:
    mov bp, ax
    mov cx, 5
    mov ax, 0x1301
    mov bx, 0x000c
    mov dl, 0
    int 10h
    ret

times 512 - ($ - $$) DB 0
