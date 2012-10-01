all: boot.bin mode.bin
	@nasm hd.s -o hd.img -l hd.lst
	@mv hd.lst debug

%.bin:
	@nasm ../$*/$*.s -f bin -o $*.bin -l $*.lst
	@mv $*.lst debug
	@mv $*.bin source

.PHONY: clean
clean:
	-rm *~
	-rm *lst
