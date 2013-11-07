;/********************************
;* description: transfer from real mode to protection mode
;*
;* filename: realmode.asm
;* author: Book Chen
;* date: 2009.11.04
;*********************************
;*/

%define REALMODE_SEGMENT       0x1000     ;real mode segment         
%define REALMODE_IMAGE_SIZE    0x0200     ;real mode code size 
%define REALMODE_STCAK_POINTER 0x1fe      ;real mode stack pointer
%define PROTECTIONMODE_START   0x00010200 ;protection mode code address
%define KERNEL_ADDRESS         0x00010400 ;
%define KERNEL_STACK_POINTER   0x000103fe ;initial value for esp register after enter protection mode
%define CHANGEMODE_SIZE        0x0400     ;
%define CODE_SEGMENT           0x08
%define DATA_SEGMENT           0x10
%define GRAPH_SEGMENT          0x18

[bits 16]
[org 0x0000]
RealModeStart:                     ;range of realinit is [0x1000:0x0000]~[0x1000:0x03FF]
    jmp L_RealModeInitial
times (3-($-$$)) db 0x00          ;make sure this address is at 0x03 
RealModeMessage: db "realmode",0  ;string of realmode
RealModeVariable:                 ;this line should be at 0x0001000C
VideoMode: db 0x00
VideoWidth: dw 0x00
VideoHeight: dw 0x00
VideoMemory: dd 0x00

L_RealModeInitial:
    mov ax,REALMODE_SEGMENT      ;ax=0x1000
    mov ds,ax                    ;data segment 0x1000
    mov es,ax                    ;extra segment 0x1000
    mov ss,ax                    ;stack segment 0x1000
    mov sp,REALMODE_STCAK_POINTER ;stack pointer [ss:sp]
                                 ;prepare to enter protected mode.
                                 
    jmp L_GraphicModeVga
    ;mov ax,0x9000                ;[0100:0000] buffer address for 512 bytes vbe data
    ;mov es,ax                    ;[0100:0000] buffer address for 512 bytes vbe data
    ;mov di,0x00                  ;[0100:0000] buffer address for 512 bytes vbe data
    ;mov ax,0x4f00                ;get vbe info
    ;int 0x10                     ;bios video serive interrupt
    ;cmp ax,0x004f                ;if success,ax==0x004f
    ;jne L_GraphicModeVga         ;if fail,enable vga mode only.
    ;mov ax,[es:di+4]
    ;cmp ax,0x0200
    ;jb  L_GraphicModeVga         ;if ax<0x200
    ;mov cx,0x105
    ;mov ax,0x4f01
    ;int 0x10
    ;cmp ax,0x004f
    ;jne L_GraphicModeVga         ;int 10 fail
    ;cmp byte[es:di+0x19],8       ;color number 2**8
    ;jne L_GraphicModeVga         
    ;cmp byte[es:di+0x1b],4       ;color plate must be 4
    ;jne L_GraphicModeVga
    ;mov ax,[es:di+0x00]          ;bit 7 of byte 0 must be 1
    ;and ax,0x0080
    ;jz L_GraphicModeVga
    mov bx,0x4105
    mov ax,0x4f02
    int 0x10
    mov byte [VideoMode],2
    mov ax,[es:di+0x12]
    mov [VideoWidth],ax
    mov ax,[es:di+0x14]
    mov [VideoHeight],ax
    mov eax,[es:di+0x28]
    mov [VideoMemory],eax
    jmp L_EnterProtectionMode
    
L_GraphicModeVga:
    mov ah,0x00                  ;set video mode
    mov al,0x13                  ;video mode...13h=G..40x25..8x8..320x200.. 256/256K..A000..VGA,MCGA,ATI VIP
    int 0x10                     ;video service system call 
    mov byte [VideoMode],1
    mov word [VideoWidth],320
    mov word [VideoHeight],200
    mov dword [VideoMemory],0x000a0000
    
L_EnterProtectionMode:   
    in al,0x92
    or al,0x02
    out 0x92,al
    xor eax,eax                  ;clear eax
    mov ax,ds                    ;ax=0x1000...eax=0x1000
    shl eax,0x04                 ;eax=0x10000
    add eax,GdtTables            ;calculate line address of gdt content [0x10000+GdtTables]
    mov dword [GdtBase],eax      ;store line address value in GdtBase
    lgdt [GdtLoader]             ;load gdt table
    mov eax,cr0                  ;get cpu cr0 register
    or eax,0x01                  ;set the PE bit of CR0 register.
    mov cr0,eax                  ;enter the protected mode.
    jmp dword CODE_SEGMENT:PROTECTIONMODE_START  ;protected mode...run protect mode code
                                         ;0x08 is byte offset in GdtTables                      
                                         
times (REALMODE_IMAGE_SIZE-($-$$)) db 0x00   ; fill out the rest of 512 bytes with 0x00

[bits 32]
ProtectionModeStart:                    
    jmp L_ProtectionMode
ProtectionModeMessage: db "protectionmode",0 ;string of protection mode
L_ProtectionMode:
    mov ax,DATA_SEGMENT
    mov ds,ax                    ;data segment gdt entry is at 0x10 of GdtTables 
    mov ss,ax                    ;stack segment gdt entry is at 0x18 of GdtTables    
    mov esp,KERNEL_STACK_POINTER ;mov ss and mov esp must resides together
                                 ;stack pointer is [0x00000000:0x013ffff0]...20mb
    mov es,ax                    ;extra segment gdt entry is at 0x20 of GdtTable
    mov fs,ax                    ;flag segment is not used,set it to extra segment gdt entry is at 0x20 of GdtTable 
    mov ax,GRAPH_SEGMENT
    mov gs,ax                    ;graphics segment is not used,set it to extra segment gdt entry is at 0x28 of GdtTable
    jmp dword CODE_SEGMENT:KERNEL_ADDRESS
       
align 8                      ;align this to 8 bytes boundary address
SystemData:                  ;GDT,IDT,and some operating system variables.
GdtTables:                       
    NullGdt:             
        dd 0                 ;1st entry of GDT must be null.
        dd 0                 ;
                             
    CodeSegmentGdt:          ;gdt entry for code segment
        dd 0x0000ffff        ;segment length 0x000fffff,base address 0x00000000 
        dd 0x00cf9b00        ;G=1,segment length=4k~4g
                             ;D=1,32 bit
                             ;AVL=0,user define,no use now
                             ;P=1,memory present
                             ;DPL=00=0
                             ;S=1,code or data segment
                             ;TYPE=101=5...E=1,C=0,R=1
                             ; E=1,executable
                             ; C=0,neglect DPL priciple
                             ; R=1,readable
                             ;A=1,accessed

    DataSegmentGdt:          ;gdt entry for data segment
	    dd 0x0000ffff        ;segment length 0x000fffff,base address 0x00000000 
	    dd 0x00cf9300        ;G=1,segment length=4k~4g
                             ;D=1,32 bit
                             ;AVL=0,user define,no use now
                             ;P=1,memory present
                             ;DPL=00=0
                             ;S=1,code or data segment
                             ;TYPE=001=1...E=0,ED=0,W=1
                             ; E=0,not executable
                             ; ED=0,data grows from bottom to top
                             ; W=1,writable
                             ;A=1,accessed
                             
    GraphicSegmentGdt:       ;This segment is loaded to gs segment.
        dd 0x80000048        ;The segment's limit is 0x000048*0x00001000=288K
        dd 0x00c0930b        ;graphic segment base address=0x0b8000 
                             ;this segment 0x000b8000~0x000fffff countains the vag text mode buffer and graphic mode buffer.
align 4
GdtLoader:                 
GdtByteCount: dw (4*8-1)    ;The gdt content limit.
GdtBase:      dd 0x00000000 ;The gdt base linear address=cs(PM)+GdtTables=GdtTables

times (CHANGEMODE_SIZE-($-$$)) db 0x00   ; fill out the rest of 1024 bytes with 0x00    
