all:
	@./run build all

boot:
	@./run build boot

img:
	@./run build img

.PHONY: clean
clean:
	@./run clean all
