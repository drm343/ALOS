%define FLOPPY_A      0x00     ;Floopy 1
%define HD_1          0x80     ;Hard Disk 1
%define BIOS_READ     0x02     ;0x13 Ah
%define BIOS_COM      0x13     ;bios command
%define FLOPPY_SECTOR 18
%define FLOPPY_TRACK  80
%define FLOPPY_HEAD   2
%define BOOTUP        0x07c0
%define OS_ADDRESS    0x1000
%define MODE_SIZE     2
%define OS_SIZE       800
%define TOTAL_SIZE    (MODE_SIZE+OS_SIZE)

[bits 16]
[org 0x0000] 
Start:
    cli
    jmp  BOOTUP:BootStart
BootStart:
    mov  ax , BOOTUP           ;setting
    mov  ds , ax
    mov  ss , ax
    mov  es , ax
    mov  sp , 0x3fe
    mov  ax , 0x0600           ;clear screen
    mov  bx , 0x0700
    mov  cx , 0
    mov  dx , 0x184f
    int  10h
    mov  ah , 0x02
    mov  bh , 0x00
    mov  dh , 0x01
    mov  dl , 0x00
    int  10h
    call Load_Loader
    jmp  OS_ADDRESS:0          ;jump to mode change code

Load_Loader:                        
    push es
    mov  ax , OS_ADDRESS
    mov  es , ax
    mov  bx , 0
    xor  cx , cx               ;set cx 0
Load_Loop:
    mov  ah , BIOS_READ        ;read command
    mov  al , 0x02             ;2 sectors per read command
    mov  ch , byte [Track]
    mov  cl , byte [Sector]
    mov  dh , byte [Head]
    mov  dl , FLOPPY_A
    int  BIOS_COM
    jc   Load_Done             ;error if carry==1
    dec  word [TotalSector]    ;dec => i--
    dec  word [TotalSector]
    jz   Load_Done
Load_Buffer:
    cmp  bx , 63 * 2 * 512
    jae  Next_Segmant
    add  bx , 1024             ;2 sectors
    jmp  Next_Read
Next_Segmant:
    mov  bx , es
    add  bx , 4 * 1024
    mov  es , bx               ;update segment value
    xor  bx , bx               ;clear bx
Next_Read:
    inc byte [Sector]          ;inc => i++
    inc byte [Sector]
    cmp byte [Sector] , FLOPPY_SECTOR
    jae Next_Track
    jmp Load_Loop
Next_Track:
    cmp byte [Head] , 0x0      ;check if head==0 
    je  Next_Head1
Next_Head0:
    mov byte [Sector] , 0x01
    mov byte [Head]   , 0x00
    inc byte [Track]
    cmp byte [Track]  , FLOPPY_HEAD
    jae Load_Done
    jmp Load_Loop
Next_Head1:
    mov byte [Sector] , 0x01
    mov byte [Head]   , 0x01
    jmp Load_Loop
Load_Done:
    mov dx , 0x03f2            ;shut down floppy disk controller
    mov al , 0x00
    out dx , al
    pop es
    ret

LocalVariables:        
Sector:      db 0x03
Track:       db 0x00
Head:        db 0x00   
TotalSector: dw TOTAL_SIZE

times 510 - ($ - $$) db 0x00
dw 0xaa55

