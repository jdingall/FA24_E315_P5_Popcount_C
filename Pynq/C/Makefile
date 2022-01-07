popcount_mmio_devmem: popcount_mmio_devmem.c
	gcc -O0 -g -o popcount_mmio_devmem popcount_mmio_devmem.c 

.PHONY:gdb
gdb: 
	sudo gdb --args ./popcount_mmio_devmem small.bin
.PHONY:clean
clean:
	rm -rf a.out popcount_mmio_devmem
