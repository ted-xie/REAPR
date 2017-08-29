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

output_file=open('copy_kernel.h','w')
code_string=            '#ifndef COPY_KERNEL_H\n'
code_string=code_string+'#define COPY_KERNEL_H\n\n'

code_string=code_string+'#define DATA_SIZE '+str(max_datasize)+'*1024*1024\n\n'
code_string=code_string+'//'+str(numa)+'*512+'+str(factorb*8)+' = '+str(numa*512+factorb*8)+' reporting states (actual: '+ str(report_count)+')\n'

if (factora!=0):
    code_string=code_string+'#define FACTORA '+str(factora)+'\n'

if (factorb!=0):
    code_string=code_string+'#define FACTORB '+str(factorb)+'\n'
code_string=code_string+'\n'

if (factora!=0):
    code_string=code_string+'#define OUTPUT_SIZEA DATA_SIZE*FACTORA\n'
    code_string=code_string+'#define OUTPUT_SIZEA_ALL DATA_SIZE*FACTORA*'+str(numa)+'L\n'
if (factorb!=0):
    code_string=code_string+'#define OUTPUT_SIZEB DATA_SIZE*FACTORB\n'
code_string=code_string+'\n'

if (factora!=0):
    code_string=code_string+'typedef struct {\n'
    code_string=code_string+'    unsigned char data[FACTORA];\n'
    code_string=code_string+'} doutA_t;\n\n'
if (factorb!=0):
    code_string=code_string+'typedef struct {\n'
    code_string=code_string+'    unsigned char data[FACTORB];\n'
    code_string=code_string+'} doutB_t;\n\n'

code_string=code_string+'void bandwidth(unsigned char *input_port'
if (factora!=0):
    for i in range(0,numa):
        code_string=code_string+', doutA_t *output_port'+str(i)
if (factorb!=0):
    code_string=code_string+', doutB_t *output_port'+str(numa)
code_string=code_string+');\n\n'
code_string=code_string+'#endif\n'

output_file.write(code_string)
output_file.close()
