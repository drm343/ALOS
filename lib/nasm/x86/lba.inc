%define FIRST_DISK 0x80
%define DISK_READ_COM 0x42

LBA:
  jmp .LOAD
  nop

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
