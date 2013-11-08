all:
	@./run build all

boot:
	@./run build boot

img:
	@./run build img

.PHONY: clean test
clean:
	@./run clean all

test:
	@qemuctl build/hd_img.img
