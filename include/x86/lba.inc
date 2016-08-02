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
