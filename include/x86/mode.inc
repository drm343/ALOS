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


%define GDT_SELETOR(x) (x - NULL_GDT)

; name -> base -> limit -> attr -> void
%macro GDT_SEGMENT 4
%1:
    dw (%3 & 0xffff)
    dw (%2 & 0xffff)
    db ((%2 >> 16) & 0xff)
    dw (((%3 >> 8) & 0xf00) | (%4 & 0xf0ff))
    db (%3 >> 24)
%endmacro

;VIDEO_GDT:
;    dd 0x8000ffff
;    dd 0x0ac0920f
;    0xaffff 0x8000fff

%macro GDTR 3
%1:
  dw %3 ; address limit
  .Base:
  dd %2 ; address base
%endmacro
