NASM_SRC=src/boot/x86
LIB=lib
OBJ=obj

all:
	nasm $(NASM_SRC)/lba.s -o $(LIB)/lba
	nasm $(NASM_SRC)/test.s -o $(LIB)/test
	qemu-img create $(OBJ)/hello.img -f raw 1.44M
	dd if=$(LIB)/lba of=$(OBJ)/new.bin bs=512 count=1 conv=notrunc
	dd if=$(LIB)/test of=$(OBJ)/new.bin bs=512 count=1 seek=1 conv=notrunc
	dd if=$(OBJ)/new.bin of=$(OBJ)/hello.img bs=512 count=2 conv=notrunc
	qemu-kvm -drive file=$(OBJ)/hello.img,media=disk,format=raw
