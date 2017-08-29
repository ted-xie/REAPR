# -*- coding: utf-8 -*-
"""
@author: VinhDang
"""

import sys
import math

report_count = int(sys.argv[1])
max_datasize = int(sys.argv[2])

if ((report_count%512)!=0):
    #if report_count is not evenly divided by 512, find the exponent of next higher power of 2 and calculate the next power of 2 
    #factorb = (int(math.pow(2, math.ceil(math.log(report_count%512, 2)))))/8
    tmpnum = int(math.pow(2, math.ceil(math.log(report_count%512, 2))))
    if (tmpnum < 8):
        factorb = 8/8
    else:
        factorb = tmpnum/8
    numb    = 1
else:
    #set to 0, otherwise
    factorb = 0
    numb    = 0

if ((report_count/512)!=0):
    #if report_count >= 512
    factora = 512/8
    numa    = report_count/512
else:
    #if report_count < 512
    factora = 0
    numa    = 0

output_file=open('copy_kernel.c','w')
code_string=            '#include <string.h>\n'
code_string=code_string+'#include <stdlib.h>\n'
code_string=code_string+'#include "copy_kernel.h"\n\n'

code_string=code_string+'void bandwidth(unsigned char *input_port'
if (factora!=0):
    for i in range(0,numa):
        code_string=code_string+', doutA_t *output_port'+str(i)
if (factorb!=0):
    code_string=code_string+', doutB_t *output_port'+str(numa)
code_string=code_string+'){\n\n'

##pragma HLS INTERFACE m_axi
code_string=code_string+'    #pragma HLS INTERFACE m_axi port=input_port offset=slave bundle=gmem0\n'
for i in range(0,numa+numb):
    code_string=code_string+'    #pragma HLS INTERFACE m_axi port=output_port'+str(i)+' offset=slave bundle=gmem'+str(i+1)+'\n'
code_string=code_string+'\n'

##pragma HLS INTERFACE s_axilite
code_string=code_string+'    #pragma HLS INTERFACE s_axilite port=input_port bundle=control\n'
for i in range(0,numa+numb):
    code_string=code_string+'    #pragma HLS INTERFACE s_axilite port=output_port'+str(i)+' bundle=control\n'
code_string=code_string+'\n'
code_string=code_string+'    #pragma HLS INTERFACE s_axilite port=return bundle=control\n\n'

##pragma HLS DATA_PACK
for i in range(0,numa+numb):
    code_string=code_string+'    #pragma HLS DATA_PACK variable=output_port'+str(i)+'\n'
code_string=code_string+'\n'

code_string=code_string+'    unsigned int i, k;\n\n'
code_string=code_string+'    L0:for (i = 0; i < DATA_SIZE; i++) {\n'
code_string=code_string+'        #pragma HLS pipeline II=1 // ensure that the iteration interval is just 1 cycle\n'
code_string=code_string+'        unsigned char loadAB   = input_port[i]; // look for "AB" in generated RTL\n'
code_string=code_string+'        unsigned char resultAB = 0xFA + loadAB;\n'
if (factora!=0):
    code_string=code_string+'        L0A:for(k=0; k<FACTORA; k++){\n'
    code_string=code_string+'            #pragma HLS UNROLL\n'
    for i in range(0,numa):
        code_string=code_string+'            output_port'+str(i)+'[i].data[k] = resultAB;// commit reports\n'
    code_string=code_string+'        }\n'
	
if (factorb!=0):
    code_string=code_string+'        L0B:for(k=0; k<FACTORB; k++){\n'
    code_string=code_string+'            #pragma HLS UNROLL\n'
    code_string=code_string+'            output_port'+str(numa)+'[i].data[k] = resultAB;// commit reports\n'
    code_string=code_string+'        }\n'
code_string=code_string+'    }\n'
code_string=code_string+'}\n'
	
output_file.write(code_string)
output_file.close()
