# -*- coding: utf-8 -*-
"""
@author: VinhDang
"""

import sys
import math

report_count = int(sys.argv[1])
ddr_banks    = int(sys.argv[2])
io_test      = int(sys.argv[3])

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

if (io_test == 0):
    output_file=open('io_global_bandwidth_real.cpp','w')
else:
    output_file=open('io_global_bandwidth.cpp','w')

code_string="""/**********
Copyright (c) 2017, Xilinx, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice,
this list of conditions and the following disclaimer in the documentation
and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/
/*****************************************************************************************
*  GUI Flow :
*      
*  By default this example supports 1DDR execution in GUI mode for 
*  all the DSAs. To make this example to work with multi DDR DSAs
*  please follow steps mentioned below.
*
*  Note : "bandwidth" in map_connect options below is the kernel name defined in kernel.cl   
*
*  ***************************************************************************************
*  DSA  (2DDR):
*              
*  1.<SDx Project> > Properties > C/C++ Build > Settings > SDx XOCC Kernel Compiler 
*                  > Miscellaneous > Other flags
*  2.In "Other flags" box enter following
*     a. --max_memory_ports all 
*     b. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM0.core.OCL_REGION_0.M00_AXI
*     c. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM1.core.OCL_REGION_0.M01_AXI 
*  3.<SDx Project> > Properties > C/C++ Build > Settings > SDx XOCC Kernel Linker
*                  > Miscellaneous > Other flags
*  4.Repeat step 2 above
*
* *****************************************************************************************
*  DSA  (4DDR):
*              
*  1.<SDx Project> > Properties > C/C++ Build > Settings > SDx XOCC Kernel Compiler 
*                  > Miscellaneous > Other flags
*  2.In "Other flags" box enter following
*     a. --max_memory_ports all 
*     b. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM0.core.OCL_REGION_0.M00_AXI
*     c. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM1.core.OCL_REGION_0.M01_AXI 
*     d. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM2.core.OCL_REGION_0.M02_AXI 
*     e. --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM3.core.OCL_REGION_0.M03_AXI 
*  3.<SDx Project> > Properties > C/C++ Build > Settings > SDx XOCC Kernel Linker
*                  > Miscellaneous > Other flags
*  4.Repeat step 2 above
*  5.Define NUM_BANKS_4 macro in kernel "#define NUM_BANKS_4" at the top of kernel.cl 
* 
* *****************************************************************************************
*
*  CLI Flow:
*
*  In CLI flow makefile detects the DDR of a device and based on that
*  automatically it adds all the flags that are necessary. This example can be
*  used similar to other examples in CLI flow, extra setup is not needed.
*
*********************************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <sys/time.h>
#include <sys/stat.h>

#include "xcl.h"
#include <CL/cl_ext.h>
#include "copy_kernel.h"

/////////////////////////////////////////////////////////////////////////////////
size_t getFilesize(const char* filename) {
    struct stat st;
    if(stat(filename, &st) != 0) {
        return 0;
    }
    return st.st_size;   
}
/////////////////////////////////////////////////////////////////////////////////
uint8_t get_ddr_banks(xcl_world world) {
    char* ddr_loc = strstr(world.device_name, "ddr");

    /* if the ddr identifier is at the front of the string or NULL is returned
     * then reading the previous char is dangerous so just assume 1 bank */
    if(ddr_loc == NULL || ddr_loc == world.device_name) {
        return 1;
    }

    /* The letter before contains the number of banks */
    ddr_loc--;

    /* Subtract from '0' to find the number of banks in uint8_t */
    return (uint8_t) *ddr_loc - (uint8_t) '0';
}

int main(int argc, char** argv) {

"""
if (io_test == 0):
    code_string=code_string+"""    if(argc != 2) {
        printf("Usage: %s input_file_name\\n", argv[0]);
        return EXIT_FAILURE;
    }
	
    xcl_world world = xcl_world_single();
    cl_program program = xcl_import_binary(world, "bandwidth");
    cl_kernel krnl = xcl_get_kernel(program, "bandwidth");

    int err;

    size_t globalbuffersize  = DATA_SIZE;\n"""
else:
    code_string=code_string+"""    if(argc != 1) {
        printf("Usage: %s\\n", argv[0]);
        return EXIT_FAILURE;
    }
	
    xcl_world world = xcl_world_single();
    cl_program program = xcl_import_binary(world, "bandwidth");
    cl_kernel krnl = xcl_get_kernel(program, "bandwidth");

    int err;

    size_t globalbuffersize  = DATA_SIZE;\n"""

temp_string= '    size_t globaloutputsize  = '
if (factora!=0):
    code_string=code_string+'    size_t globaloutputsizeA = OUTPUT_SIZEA;\n'
    code_string=code_string+'    size_t globaloutputsizeA_all = OUTPUT_SIZEA_ALL;\n'
    temp_string=temp_string+'globaloutputsizeA_all + '
else:
    temp_string=temp_string+'0 + '
if (factorb!=0):
    code_string=code_string+'    size_t globaloutputsizeB = OUTPUT_SIZEB;\n'
    temp_string=temp_string+'globaloutputsizeB;\n'
else:
    temp_string=temp_string+'0;\n'
code_string=code_string+temp_string+'\n'

if (io_test == 0):
    code_string=code_string+'    unsigned int total_bytes = getFilesize(argv[1]); printf("Input file %s has %d bytes,\\n", argv[1], total_bytes);\n\n'

code_string=code_string+"""    //variables for profiling
    struct timeval start_tin, end_tin, start_tout, end_tout, start_t1, end_t1, start_t2, end_t2;
    float tin, tout, t1, t2;
	
    /* Input buffer */
    unsigned char *input_host = ((unsigned char *)malloc(globalbuffersize));
    if(input_host==NULL) {
        printf("Error: Failed to allocate host side copy of OpenCL source buffer of size %ld\\n",globalbuffersize);
        return EXIT_FAILURE;
    }
    else
        printf("Allocated host side copy of OpenCL source buffer of size %ld\\n",globalbuffersize);

	//output buffer
    unsigned char *output_host = ((unsigned char *)malloc(globaloutputsize));
    if(output_host==NULL) {
        printf("Error: Failed to allocate host side copy of OpenCL output buffer of size %ld\\n",globaloutputsize);
        return EXIT_FAILURE;
    }
    else
        printf("Allocated host side copy of OpenCL output buffer of size %ld\\n",globaloutputsize);
	
    unsigned int i;
"""
if (io_test == 0):
    code_string=code_string+"""
    FILE *fp;
    fp = fopen(argv[1],"r");
    char char_temp;
    for(i=0; i<total_bytes; i++){
        char_temp = (char)fgetc(fp);
        input_host[i] = (unsigned char)char_temp;
    }
    fclose(fp);
"""
else:
    code_string=code_string+"""
    for(i=0; i<globalbuffersize; i++){
		unsigned int imod = i%9;
		switch(imod)
		{
			case 0:
			    input_host[i]='a';
				break;
			case 1:
			    input_host[i]='b';
				break;
			case 2:
			    input_host[i]='a';
				break;
			case 3:
			    input_host[i]='a';
				break;
			case 4:
			    input_host[i]='b';
				break;
			case 5:
			    input_host[i]='e';
				break;
			case 6:
			    input_host[i]='a';
				break;
			case 7:
			    input_host[i]='b';
				break;
			default:
			    input_host[i]='v';
		}
    }
"""
code_string=code_string+"""
    short ddr_banks = get_ddr_banks(world); printf("Total_DDR_Banks = %d\\n", ddr_banks);
 
    cl_mem input_buffer;
#ifdef USE_NDDR
    cl_mem_ext_ptr_t input_buffer_ext;
    input_buffer_ext.flags = XCL_MEM_DDR_BANK0;
    input_buffer_ext.obj = NULL;
    input_buffer_ext.param = 0;

    input_buffer = clCreateBuffer(world.context,
                                  CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX,
                                  globalbuffersize,
                                  &input_buffer_ext,
                                  &err);
    if(err != CL_SUCCESS) {
        printf("Error: Failed to allocate OpenCL source buffer of size %ld on bank %d\\n", globalbuffersize, XCL_MEM_DDR_BANK0);
        return EXIT_FAILURE;
    }
    else
        printf("Allocated OpenCL source buffer of size %ld on bank %d\\n", globalbuffersize, XCL_MEM_DDR_BANK0);
#else
    input_buffer = clCreateBuffer(world.context,
                                  CL_MEM_READ_WRITE,
                                  globalbuffersize,
                                  NULL,
                                  &err);
    if(err != CL_SUCCESS) {
        printf("Error: Failed to allocate OpenCL source buffer of size %ld\\n", globalbuffersize);
        return EXIT_FAILURE;
    }
    else
        printf("Allocated OpenCL source buffer of size %ld\\n", globalbuffersize);
#endif

    //output buffer
    cl_mem"""

for i in range(0,numa+numb):
    if (i==0):
        code_string=code_string+' output_buffer'+str(i)
    else:
        code_string=code_string+', output_buffer'+str(i)
code_string=code_string+';\n'

code_string=code_string+"""#ifdef USE_NDDR
    cl_mem_ext_ptr_t""" 

for i in range(0,numa+numb):
    if (i==0):
        code_string=code_string+' output_buffer'+str(i)+'_ext'
    else:
        code_string=code_string+', output_buffer'+str(i)+'_ext'
code_string=code_string+';\n'

for i in range(0,numa+numb):
    temp_string1='    output_buffer'+str(i)+'_ext.'
    temp_string2='XCL_MEM_DDR_BANK'+str((i+1)%ddr_banks)+';\n'
    code_string=code_string+temp_string1+'flags = '+temp_string2
    code_string=code_string+temp_string1+'obj = NULL;\n'
    code_string=code_string+temp_string1+'param = 0;\n\n'

for i in range(0,numa+numb):
    code_string=code_string+'    output_buffer'+str(i)+""" = clCreateBuffer(world.context,
                                   CL_MEM_READ_WRITE | CL_MEM_EXT_PTR_XILINX,\n"""
    if (numa==0):
        temp_string='globaloutputsizeB'
    elif (numb==0):
        temp_string='globaloutputsizeA'
    elif (i==numa+numb-1):
        temp_string='globaloutputsizeB'
    else:
        temp_string='globaloutputsizeA'
    code_string=code_string+'                                   '+temp_string+""",
                                   &output_buffer"""
    code_string=code_string+str(i)+"""_ext,
                                   &err);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to allocate OpenCL output buffer of size %ld on bank %d\\n", """
    code_string=code_string+temp_string+', XCL_MEM_DDR_BANK'+str((i+1)%ddr_banks)+""");
        return EXIT_FAILURE;
    }
    else
        printf("Allocated OpenCL output buffer of size %ld on bank %d\\n", """
    code_string=code_string+temp_string+', XCL_MEM_DDR_BANK'+str((i+1)%ddr_banks)+');\n\n'

code_string=code_string+'#else\n'

for i in range(0,numa+numb):
    code_string=code_string+'    output_buffer'+str(i)+""" = clCreateBuffer(world.context,
                                   CL_MEM_READ_WRITE,\n"""
    if (numa==0):
        temp_string='globaloutputsizeB'
    elif (numb==0):
        temp_string='globaloutputsizeA'
    elif (i==numa+numb-1):
        temp_string='globaloutputsizeB'
    else:
        temp_string='globaloutputsizeA'
    code_string=code_string+'                                   '+temp_string+""",
                                   NULL,
                                   &err);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to allocate OpenCL output buffer of size %ld\\n", """
    code_string=code_string+temp_string+""");
        return EXIT_FAILURE;
    }
    else
        printf("Allocated OpenCL output buffer of size %ld\\n", """
    code_string=code_string+temp_string+');\n\n'
code_string=code_string+'#endif\n\n'

code_string=code_string+"""    //cl_ulong num_blocks = globalbuffersize/64;
    double dbytes = globalbuffersize;
    double dmbytes = dbytes / (((double)1024) * ((double)1024));
    printf("Starting kernel to read/write %.0lf MB bytes from/to global memory... \\n", dmbytes);

    gettimeofday(&start_tin, NULL);
	
    /* Write input buffer */
    /* Map input buffer for PCIe write */
    unsigned char *map_input_buffer;
    map_input_buffer = (unsigned char *) clEnqueueMapBuffer(world.command_queue,
                                                             input_buffer,
                                                             CL_FALSE,
                                                             CL_MAP_WRITE_INVALIDATE_REGION,
                                                             0,
                                                             globalbuffersize,
                                                             0,
                                                             NULL,
                                                             NULL,
                                                             &err);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to clEnqueueMapBuffer OpenCL buffer\\n");
        return EXIT_FAILURE;
    } else {
        printf("SUCCESS: Allocated input buffer memory.\\n");
    }
    clFinish(world.command_queue);

    /* prepare data to be written to the device */
    memcpy(map_input_buffer, input_host, globalbuffersize);

    err = clEnqueueUnmapMemObject(world.command_queue,
                                  input_buffer,
                                  map_input_buffer,
                                  0,
                                  NULL,
                                  NULL);
    if (err != CL_SUCCESS) {
        printf("Error: Failed to copy input dataset to OpenCL buffer\\n");
        return EXIT_FAILURE;
    } else {
        printf("SUCCESS: Copied input data to input buffer.\\n");
    }
    clFinish(world.command_queue);

    gettimeofday(&end_tin, NULL);
	
    /* Execute kernel */
    int arg_index = 0;

    xcl_set_kernel_arg(krnl, arg_index++, sizeof(cl_mem), &input_buffer);\n"""
for i in range(0,numa+numb):
    code_string=code_string+'    xcl_set_kernel_arg(krnl, arg_index++, sizeof(cl_mem), &output_buffer'+str(i)+');\n'
code_string=code_string+'\n'	

if (io_test == 0):
    code_string=code_string+"""    gettimeofday(&start_t1, NULL);
   
    unsigned long nsduration1 = xcl_run_kernel3d(world, krnl, 1, 1, 1);

    gettimeofday(&end_t1, NULL);
	
    gettimeofday(&start_t2, NULL);

    unsigned long nsduration2 = 0;

    gettimeofday(&end_t2, NULL);

    gettimeofday(&start_tout, NULL);
   
    /* Copy results back from OpenCL buffer */
    unsigned char"""
else:
    code_string=code_string+"""    gettimeofday(&start_t1, NULL);
   
    unsigned long nsduration1 = xcl_run_kernel3d(world, krnl, 1, 1, 1);

    gettimeofday(&end_t1, NULL);
	
    gettimeofday(&start_t2, NULL);
   
    unsigned long nsduration2 = xcl_run_kernel3d(world, krnl, 1, 1, 1);

    gettimeofday(&end_t2, NULL);

    gettimeofday(&start_tout, NULL);
   
    /* Copy results back from OpenCL buffer */
    unsigned char"""

for i in range(0,numa+numb):
    if (i==0):
        code_string=code_string+' *map_output_buffer'+str(i)
    else:
        code_string=code_string+', *map_output_buffer'+str(i)
code_string=code_string+';\n'

for i in range(0,numa+numb):
    code_string=code_string+'    map_output_buffer'+str(i)+' = (unsigned char *)clEnqueueMapBuffer(world.command_queue,\n'
    code_string=code_string+'                                                             output_buffer'+str(i)+""",
                                                             CL_FALSE,
                                                             CL_MAP_READ,
                                                             0,
                                                             """
    if (numa==0):
        temp_string='globaloutputsizeB'
    elif (numb==0):
        temp_string='globaloutputsizeA'
    elif (i==numa+numb-1):
        temp_string='globaloutputsizeB'
    else:
        temp_string='globaloutputsizeA'
    code_string=code_string+temp_string+""",
                                                             0,
                                                             NULL,
                                                             NULL,
                                                             &err);\n"""
code_string=code_string+"""    if (err != CL_SUCCESS) {
        printf("ERROR: Failed to read output size buffer %d\\n", err);
        return EXIT_FAILURE;
    } else {
        printf("SUCCESS: Read output buffer.\\n");
    }
    clFinish(world.command_queue);\n\n"""

for i in range(0,numa+numb):
    if (numa==0):
        temp_string='globaloutputsizeB'
    elif (numb==0):
        temp_string='globaloutputsizeA'
    elif (i==numa+numb-1):
        temp_string='globaloutputsizeB'
    else:
        temp_string='globaloutputsizeA'
    
    if (i==0):
        code_string=code_string+'    memcpy(output_host, map_output_buffer'+str(i)+', '+temp_string+');\n'
    else:
        code_string=code_string+'    memcpy(output_host + '+str(i)+'*globaloutputsizeA, map_output_buffer'+str(i)+', '+temp_string+');\n'
code_string=code_string+'\n'

for i in range(0,numa+numb):		
    code_string=code_string+"""    err = clEnqueueUnmapMemObject(world.command_queue,
                                  output_buffer"""+str(i)+""",
                                  map_output_buffer"""+str(i)+""",
                                  0,
                                  NULL,
                                  NULL);\n"""

code_string=code_string+"""    if (err != CL_SUCCESS) {
        printf("Error: Failed to copy output from OpenCL buffer\\n");
        return EXIT_FAILURE;
    } else {
        printf("SUCCESS: Copied output data into local memory.\\n");
    }
    clFinish(world.command_queue);

    gettimeofday(&end_tout, NULL);
"""
if (io_test == 0):
    code_string=code_string+"""   
    /* Check the results */
   /*for(i=0; i<50; i++){
		printf("Cycle %d, Symbol %c, Result vector%d:\\n", i+1, input_host[i], output_host[i]);
		printf("       Matched rules: ");
		for(unsigned int offset=0; offset<8; offset++){
		   unsigned char val = (output_host[i] >> offset) & (0x01);
	       if (val)
	          printf("%d  ", offset+1);
        }
		printf("\\n");
    }*/
    /*for(i=0; i<2624; i++){//first 2624 bytes (or cycles)
        bool match = false;
        for(unsigned int k=0; k<FACTORB; k++){
            if (output_host[i*FACTORB + k] != 0) {match = true; break;}
        }
        if (match) {
            printf("Cycle %d, input %c:\\n", i, input_host[i]);
            printf("        Rules: ");
            for(unsigned int k=0; k<FACTORB; k++){
                for(unsigned int offset=0; offset<8; offset++) {
                    unsigned char val = (output_host[i*FACTORB + k] >> offset) & (0x01);
                    if(val) printf("%d  ", k*8 + offset+1);
                }
            }
            printf("\\n");
        }
    }*/
"""
code_string=code_string+"""	
    /* Profiling information */
    double dnsduration1 = ((double)nsduration1);
    double dsduration1 = dnsduration1 / ((double) 1000000000);

    double bpersec1 = (dbytes/dsduration1);
    double mbpersec1 = bpersec1 / ((double) 1024*1024 );

    double dnsduration2 = ((double)nsduration2);
    double dsduration2 = dnsduration2 / ((double) 1000000000);

    double bpersec2 = (dbytes/dsduration2);
    double mbpersec2 = bpersec2 / ((double) 1024*1024 );
	
    t1 = (end_t1.tv_sec + end_t1.tv_usec/(double)(1000000)) - (start_t1.tv_sec + start_t1.tv_usec/(double)(1000000));
    t2 = (end_t2.tv_sec + end_t2.tv_usec/(double)(1000000)) - (start_t2.tv_sec + start_t2.tv_usec/(double)(1000000));
	
    double bpersec1_ = (dbytes/t1);
    double mbpersec1_ = bpersec1_ / ((double) 1024*1024 );
    double bpersec2_ = (dbytes/t2);
    double mbpersec2_ = bpersec2_ / ((double) 1024*1024 );
	
    printf("Kernel completed read/write %.0lf MB bytes from/to global memory.\\n", dmbytes);
    printf("clGetEventProfilingInfo - Execution time = %f (sec), %f (sec)\\n", dsduration1, dsduration2);
    printf("clGetEventProfilingInfo - Concurrent Read and Write Throughput = %f (MB/sec), %f (MB/sec)\\n", mbpersec1, mbpersec2);
    printf("\\n");
    printf("gettimeofday - Execution time = %f (sec), %f (sec)\\n", t1, t2);
    printf("gettimeofday - Concurrent Read and Write Throughput = %f (MB/sec), %f (MB/sec)\\n", mbpersec1_, mbpersec2_);
    printf("\\n");
    printf("Overhead of kernel call = %f(sec), %f(sec)\\n", t1 - dsduration1, t2 - dsduration2 );

    tin = (end_tin.tv_sec  + end_tin.tv_usec/(double)(1000000))  - (start_tin.tv_sec  + start_tin.tv_usec/(double)(1000000));
    tout= (end_tout.tv_sec + end_tout.tv_usec/(double)(1000000)) - (start_tout.tv_sec + start_tout.tv_usec/(double)(1000000));

    double bpersec_in = (dbytes/tin);
    double mbpersec_in = bpersec_in / ((double) 1024*1024 );
    double bpersec_out = (dbytes/tout);
    double mbpersec_out = bpersec_out / ((double) 1024*1024 );

    printf("\\n");
    printf("gettimeofday - Transfer_in time = %f (sec); Transfer_out time = %f (sec) \\n", tin, tout);
    printf("gettimeofday - Transfer_in Throughput = %f (MB/sec); Transfer_out Throughput = %f (MB/sec) \\n", mbpersec_in, mbpersec_out);
	
	clReleaseMemObject(input_buffer);\n"""

for i in range(0,numa+numb):		
    code_string=code_string+'    clReleaseMemObject(output_buffer'+str(i)+');\n'

code_string=code_string+"""    clReleaseKernel(krnl);
    clReleaseProgram(program);
    xcl_release_world(world);
    
    free(input_host);
    free(output_host);
	
    return EXIT_SUCCESS;
}
"""
	
output_file.write(code_string)
output_file.close()
