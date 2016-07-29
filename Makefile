NASM_SRC=src/boot/x86
LIB=lib
OBJ=obj

COUNT=0

all:
	nasm $(NASM_SRC)/lba.s -o $(LIB)/lba
	nasm $(NASM_SRC)/hello.s -o $(LIB)/hello
	qemu-img create $(OBJ)/hello.img -f raw 1.44M
	rm $(OBJ)/new.bin
	dd if=$(LIB)/lba of=$(OBJ)/new.bin conv=notrunc
	dd if=$(LIB)/hello of=$(OBJ)/new.bin oflag=append conv=notrunc
	dd if=$(OBJ)/new.bin of=$(OBJ)/hello.img conv=notrunc
	qemu-kvm -drive file=$(OBJ)/hello.img,media=disk,format=raw

debug:
	ndisasm -o 0x7c00 $(OBJ)/hello.img > a.h; vim a.h
