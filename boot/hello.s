[bits 16]
[ORG 0]

start:
  mov ax, cs
  mov ds, ax
  mov es, ax

  mov ax, 0x0500 + msg
  call Disp
  jmp $

Disp:
  mov bp, ax
  mov cx, 5
  mov ax, 0x1301
  mov bx, 0x000c
  mov dl, 0
  int 10h
  ret

msg: db 'hello'

times 512 - ($ - $$) db 0
