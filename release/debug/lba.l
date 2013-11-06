     1                                  %define BOOT_ADDRESS 0x07c0
     2                                  %define FIRST_DISK 0x80
     3                                  %define DISK_READ_COM 0x42
     4                                  %define UNUSED_MEMORY 0x0500
     5                                  
     6                                  [bits 16]
     7                                  [ORG 0]
     8                                  
     9 00000000 EA[1500]C007            jmp BOOT_ADDRESS:START
    10                                  
    11                                  LBA:
    12 00000005 10                        .SIZE     db 0x10
    13 00000006 00                        .RESERVED db 0x0
    14 00000007 0100                      .COUNT    dw 0x1
    15 00000009 0005                      .SEG_OFF  dw UNUSED_MEMORY
    16 0000000B 0000                      .SEG      dw 0x0
    17 0000000D 0100000000000000          .NUMBER   dq 1
    18                                  
    19                                  START:
    20 00000015 8CC8                      mov ax, cs
    21 00000017 8ED8                      mov ds, ax
    22 00000019 8EC0                      mov es, ax
    23                                  
    24 0000001B E80500                    call LOAD
    25 0000001E EA00050000                jmp 0:UNUSED_MEMORY
    26                                  
    27                                  
    28                                  LOAD:
    29 00000023 B442                      mov ah, DISK_READ_COM
    30 00000025 B280                      mov dl, FIRST_DISK
    31 00000027 BE[0500]                  mov SI, LBA
    32 0000002A CD13                      int 13h
    33 0000002C 72F5                      jc  LOAD
    34 0000002E C3                        ret
    35                                  
    36 0000002F 00<rept>                times 510 - ($ - $$) db 0
    37 000001FE 55AA                    DW 0xAA55
