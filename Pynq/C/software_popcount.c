#define BUF_SIZE 1028
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char **argv){
    unsigned int count = 0;
    FILE *input_fp;
    size_t numbers_read = -1;
    unsigned int buffer[BUF_SIZE];
    int n,w,i;
    if (argc != 2){
        fprintf(stderr,"Usage: %s input_filename\n",argv[0]);
        exit(1);
    }
    input_fp=fopen(argv[1],"rb");
    if(input_fp<0){
        fprintf(stderr, "Error opening binary file");
		exit(1);
    }
    while(numbers_read!=0){
        numbers_read = fread(buffer,4,BUF_SIZE,input_fp);
        for(i=0;i<numbers_read;i++){
            w = 0;
            n = buffer[i];
            while(n){
                w += 1;
                n &= n - 1;
            }
            count += w;
        }
    }
    fclose(input_fp);
    printf("Count = %d\n",count);
    return count;
}
