INCBIN "./source/boot.bin"
times 1024 - ($-$$) db 0x00
INCBIN "./source/mode.bin"
times 2*1024 - ($-$$) db 0
