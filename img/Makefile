all: boot.bin mode.bin
	@nasm hd.s -o hd.img -l hd.lst
	@mv hd.lst debug

boot.bin:
	@nasm ../boot/boot.s -f bin -o boot.bin -l boot.lst
	@mv boot.lst debug
	@mv boot.bin source

mode.bin:
	@nasm ../mode/mode.s -f bin -o mode.bin -l mode.lst
	@mv mode.lst debug
	@mv mode.bin source

.PHONY: clean
clean:
	-rm *~
	-rm *lst
