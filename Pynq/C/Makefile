
CC		:=gcc
DBG_FLAGS	:= -g -O0 -Wall
OPT_FLAGS	:= -O3 -DNODEBUG

all:  software user_mmio

software:  software.c
	$(CC) $(OPT_FLAGS) -o software software.c

user_mmio: user_mmio.c	
	$(CC) $(OPT_FLAGS) -o user_mmio user_mmio.c

.PHONY: clean
clean:  
	rm -rf software sudo_mmio user_mmio user_dma user_dma.debug 
