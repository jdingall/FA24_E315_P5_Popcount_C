////////////////////////////////////////////////////////////
//    
//    Example popcount with FPGA and MMIO support
//    Requires to access /dev/uio0
//
//    Build for Indiana University's E315 class
//
//    @author:  Andrew Lukefahr <lukefahr@iu.edu>
//    @author:  Michael Mitsch <mfmitsch@iu.edu>
//    @date:  20200331
//
////////////////////////////////////////////////////////////
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>


int main(int argc, char **argv)
{

    int user_mem_fd = -1;
    void * vaddr_base;

	// check for input file
	if (argc != 2) {
		fprintf(stderr, "Usage: %s input_filename\n", argv[0]);
		exit(1);
	}

    //Mapping user-space I/O
    user_mem_fd = open("/dev/uio0", O_RDWR|O_SYNC);
    if (user_mem_fd < 0) { perror("open() /dev/uio0"); return 1; }

    // Map 1KB of physical memory starting at 0x40000000
    // to 1KB of virtual memory starting at vaddr_base
	vaddr_base = mmap(0, 1024, PROT_READ|PROT_WRITE,
			MAP_SHARED, user_mem_fd, 0x0); // not 0x40000000
	if (vaddr_base == MAP_FAILED) { perror("mmap()"); return 1; }
    
    //TO DO: define registers

    //TO DO: open the input file

  
    //TO DO: use reset_reg to reset popcount


    //TO DO: read file into buffer and pass to popcount
    

    //TO DO: close input file
    
    
    // Read the bit count result
	printf("Counted %u ones\n", *count_reg);
	
	if (munmap(vaddr_base, 1024) != 0) { perror("munmap()"); }
    if (close(user_mem_fd) != 0) { perror("close()"); }
    user_mem_fd = -1;

    return 0;
}



