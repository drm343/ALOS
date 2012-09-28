INCBIN "./source/boot.bin"
INCBIN "./source/mode.bin"
times 2*1024 - ($-$$) db 0
