;/*************
;*this image is for hard disk bootup use
;*size is 1008k
;*cylinders 2
;*heads 16
;*sectors per track 63
;
;this image size and parameters are from c:\bochs\bximage.exe
;1.execute beximage.exe in c:\bochs
;2.choose hd 
;3.flat
;4.1 mb
;5.hd.img
;then you would get
;cyl=2
;heads=16
;sector per track=63
;total sector=0.98 megabytes
;**************/
INCBIN "..\boot\boot.bin"
INCBIN "..\mode\mode.bin"
