     1                                  %define BOOT_ADDRESS 0x07c0
     2                                  %define FIRST_DISK 0x80
     3                                  %define DISK_READ_COM 0x42
     4                                  %define UNUSED_MEMORY 0x0500
     5                                  
     6                                  [bits 16]
     7                                  [ORG 0]
     8                                  
     9 00000000 EA[1100]C007            jmp BOOT_ADDRESS:START
    10                                  
    11                                  LBA:
    12 00000005 10                        .SIZE     db 0x10
    13 00000006 00                        .RESERVED db 0x0
    14 00000007 0100                      .COUNT    dw 0x1
    15 00000009 0005                      .SEGOFF   dw UNUSED_MEMORY
    16 0000000B 0000                      .SEG      dw 0x0
    17 0000000D 0100                      .NUMBER1  dw 1
    18 0000000F 0000                      .NUMBER2  dw 0
    19                                  
    20                                  START:
    21 00000011 8CC8                      mov ax, cs
    22 00000013 8ED8                      mov ds, ax
    23 00000015 8EC0                      mov es, ax
    24                                  
    25 00000017 E80500                    call LOAD
    26 0000001A EA00050000                jmp 0:UNUSED_MEMORY
    27                                  
    28                                  
    29                                  LOAD:
    30 0000001F B442                      mov ah, DISK_READ_COM
    31 00000021 B280                      mov dl, FIRST_DISK
    32 00000023 BE[0500]                  mov SI, LBA
    33 00000026 CD13                      int 13h
    34 00000028 72F5                      jc  LOAD
    35 0000002A C3                        ret
    36                                  
    37 0000002B 00<rept>                times 510 - ($ - $$) db 0
    38 000001FE 55AA                    DW 0xAA55
