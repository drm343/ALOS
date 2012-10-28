[bits 32]

[section .text]
_EntryStart:
    mov dword [0xb8000] , 0x07690748
    jmp $
    times ( 512 * 800 ) - ($-$$) db 0x00
