#include <string.h>
#include <stdlib.h>
#include "copy_kernel.h"

void bandwidth(unsigned char *input_port, doutB_t *output_port0){

    #pragma HLS INTERFACE m_axi port=input_port offset=slave bundle=gmem0
    #pragma HLS INTERFACE m_axi port=output_port0 offset=slave bundle=gmem1

    #pragma HLS INTERFACE s_axilite port=input_port bundle=control
    #pragma HLS INTERFACE s_axilite port=output_port0 bundle=control

    #pragma HLS INTERFACE s_axilite port=return bundle=control

    #pragma HLS DATA_PACK variable=output_port0

    unsigned int i, k;

    L0:for (i = 0; i < DATA_SIZE; i++) {
        #pragma HLS pipeline II=1 // ensure that the iteration interval is just 1 cycle
        unsigned char loadAB   = input_port[i]; // look for "AB" in generated RTL
        unsigned char resultAB = 0xFA + loadAB;
        L0B:for(k=0; k<FACTORB; k++){
            #pragma HLS UNROLL
            output_port0[i].data[k] = resultAB;// commit reports
        }
    }
}
