NASM_SRC=src/boot/x86
C_SRC=src/kernel
LIB=lib
OBJ=obj

COUNT=0

all: $(OBJ) $(LIB)
	nasm $(NASM_SRC)/boot.s -o $(LIB)/boot
	nasm $(NASM_SRC)/hello.s -o $(LIB)/hello
	nasm $(C_SRC)/kernel.s -o $(LIB)/kernel
	qemu-img create $(OBJ)/hello.img -f raw 1.44M
	-rm $(OBJ)/new.bin
	dd if=$(LIB)/boot of=$(OBJ)/new.bin conv=notrunc
	dd if=$(LIB)/hello of=$(OBJ)/new.bin oflag=append conv=notrunc
	dd if=$(LIB)/kernel of=$(OBJ)/new.bin oflag=append conv=notrunc
	dd if=$(OBJ)/new.bin of=$(OBJ)/hello.img conv=notrunc
	qemu-kvm -drive file=$(OBJ)/hello.img,media=disk,format=raw

$(OBJ):
	mkdir -p $(OBJ)

$(LIB):
	mkdir -p $(LIB)

debug:
	ndisasm -o 0x7c00 $(LIB)/hello > a.h; vim a.h

clean:
	-rm -r $(OBJ)/* $(LIB)/*
