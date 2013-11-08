%define BOOT_ADDRESS 0x07c0
%define FIRST_DISK 0x80
%define DISK_READ_COM 0x42
%define RELOCATION_TABLE 0x0500
%define LOAD_TO_HERE 0x0700
%define JMP_TO_HERE 0x0070

[bits 16]
[ORG 0]

jmp BOOT_ADDRESS:START

START:
  mov ax, cs
  mov ds, ax
  mov es, ax
  mov ss, ax

  mov word [RELOCATION_TABLE], LOAD_TO_HERE
  mov word [LBA.SEGOFF], LOAD_TO_HERE
  call LBA

  jmp JMP_TO_HERE:0

LBA:
  jmp .LOAD

  .SIZE     DB 0x10
  .RESERVED DB 0x0
  .COUNT    DW 0x1
  .SEGOFF   DW 0x0
  .SEG      DW 0x0
  .NUMBER1  DW 1
  .NUMBER2  DW 0
  .NUMBER3  DW 0
  .NUMBER4  DW 0

  .LOAD:
    mov ah, DISK_READ_COM
    mov dl, FIRST_DISK
    mov SI, .SIZE
    int 13h
    jc  .LOAD
    ret

times 510 - ($ - $$) DB 0
DW 0xAA55
