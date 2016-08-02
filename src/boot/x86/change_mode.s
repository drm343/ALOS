%define BOOT_ADDRESS 0x0
%define KERNEL_ADDRESS 0x0800

%include "mode.inc"

%macro CALCULAS_ADDRESS 0
  xor eax, eax
  mov ax, cs
  shl eax, 0x04
  mov bx, ax
%endmacro

[bits 16]
[org BOOT_ADDRESS]

jmp START

GDT_SEGMENT NULL_GDT, 0x0, 0x0, 0x0
GDT_SEGMENT CODE32_GDT, 0x0, Code32Len - 1, 0xc09b
GDT_SEGMENT VIDEO_GDT, 0xa0000, 0xffff, 0xc092

GDTLen equ $ - NULL_GDT
GDTR GDTPtr, 0x0, (GDTLen - 1)

SelectorCode32 equ CODE32_GDT - NULL_GDT
SelectorVideo equ VIDEO_GDT - NULL_GDT

nop

START:
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ss, ax
  mov fs, ax
  mov gs, ax

  mov ax, Hello.msg
  mov cx, Hello.MSGLEN
  call Text

  call Text.newline
  mov ax, Loading.msg
  mov cx, Loading.MSGLEN
  call Text

  call GRAPH.vga

  mov ax, 0xa000
  mov es, ax
  ; Offset 0
  xor di, di
  ; Colorword red red
  mov ax, 0x2727
  ; Looplength (320*200)/2 = 7d00
  mov cx, 0x7d00
  ; Draw pixels, one word at a time
  rep stosw

PREPARE_CODE32:
  CALCULAS_ADDRESS

  add eax, START_CODE32
  mov word [CODE32_GDT + 2], ax
  shr eax, 16
  mov byte [CODE32_GDT + 4], al
  mov byte [CODE32_GDT + 7], ah

PREPARE_PROTECT_MODE:
  CALCULAS_ADDRESS

  add eax, NULL_GDT
  mov dword [GDTPtr.Base], eax

  lgdt [GDTPtr]

ENABLE_A20:
  cli

  in al, 0x92
  or al, 0x02
  out 0x92, al

ENABLE_PROTECT_MODE:
  mov eax, cr0
  or eax, 0x01
  mov cr0, eax

DONE:
  jmp dword SelectorCode32:0

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

  .clearScreen:
    pusha

    mov ax, 0x0700
    mov bh, 0x07
    mov cx, 0x0000
    mov dx, 0x184f
    int 0x10

    popa
    ret

GRAPH:
  jmp .vga

  .text:
    mov ax, 0x3
    int 0x10
    ret

  .vga:
    mov ah, 0x0
    mov al, 0x13
    int 0x10
    ret

Hello:
  .msg DB 'hello'
  .MSGLEN equ $-.msg

Loading:
  .msg DB 'loading ok'
  .MSGLEN equ $-.msg

[bits 32]
align 32

START_CODE32:
  mov ax, cs
  mov ds, ax
  mov es, ax
;  mov ss, ax
  mov fs, ax
  mov gs, ax

  cli

  jmp $

SHOW_MSG equ 0xb8000
MSG: db "start kernal"

Code32Len equ $ - START_CODE32

times 1022 - ($ - $$) DB 0
DW 0xAA55
