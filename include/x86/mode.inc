%define SEGMENT_G     0x8000
%define SEGMENT_BG_32 0x4000
%define SEGMENT_L_64  0x2000

%define SEGMENT_P     0x0080

%define SEGMENT_DPL0  0x0000
%define SEGMENT_DPL1  0x0020
%define SEGMENT_DPL2  0x0040
%define SEGMENT_DPL3  0x0060

%define SYSTEM_OR_NOT 0x0010

%define DATA_W        0x02
%define DATA_NOT_W    0x00
%define STACK_W       0x06
%define STACK_NOT_W   0x04

%define CODE_NC_NOT_R 0x08
%define CODE_NC_R     0x0a
%define CODE_NOT_R    0x0c
%define CODE_R        0x0e


%define Init_GDT GDT_SEGMENT 0x0, 0x0, 0x0

%macro GDT_SEGMENT 3
  dw %2
  dw %1
  db (%1 >> 16)
  dw ((%2 & 0xf00) | %3)
  db (%1 >> 24)
%endmacro
;%1:
;.SEGMENT:
;  .GDT_LOW_LIMIT          dw 0x0
;  .GDT_LOW_BASE_ADDRESS   dw 0x0
;  .GDT_HIGH_BASE_ADDRESS1 db 0x0
;  .GDT_ACCESS_BYTE        db 0x0
;  .GDT_LIMIT_AND_GLAGS    db 0x0
;  .GDT_HIGH_BASE_ADDRESS2 db 0x0

%define GDT_SELETOR(x) (x - SEGMENT_NULL)

%macro GDTR 2
  dw %2; address limit
  dd %1; address base
%endmacro
