all: boot.bin mode.bin kernel.bin
	@nasm hd.s -o hd.img -l hd.lst
	@mv hd.lst debug

kernel.exe:
	@gcc ../kernel/kernel.c -ffreestanding
	@mv a.exe source/kernel.exe

%.bin:
	@nasm ../$*/$*.s -f bin -o $*.bin -l $*.lst
	@mv $*.lst debug
	@mv $*.bin source

.PHONY: clean
clean:
	-rm *~
	-rm *lst
	-rm debug/*
	-rm source/*
	-rm *img
