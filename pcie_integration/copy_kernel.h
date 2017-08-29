#ifndef COPY_KERNEL_H
#define COPY_KERNEL_H

#define DATA_SIZE 10*1024*1024

//0*512+256 = 256 reporting states (actual: 218)
#define FACTORB 32

#define OUTPUT_SIZEB DATA_SIZE*FACTORB

typedef struct {
    unsigned char data[FACTORB];
} doutB_t;

void bandwidth(unsigned char *input_port, doutB_t *output_port0);

#endif
