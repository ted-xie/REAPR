# -*- coding: utf-8 -*-
"""
@author: VinhDang
"""

import sys
import math

common_repo_path = sys.argv[1]
report_count = int(sys.argv[2])
ddr_banks    = int(sys.argv[3])
io_test      = int(sys.argv[4])

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

output_file=open('./rtl_prj/Makefile','w')

code_string="""# io_global Application
COMMON_REPO:="""+common_repo_path+'\n\n'

if (io_test == 0):
    code_string=code_string+"""include $(COMMON_REPO)/utility/boards.mk
include $(COMMON_REPO)/libs/xcl/xcl.mk
include $(COMMON_REPO)/libs/opencl/opencl.mk

# io_global Host Application
io_global_SRCS=../io_global_bandwidth_real.cpp $(xcl_SRCS)
io_global_HDRS=$(xcl_HDRS)
io_global_CXXFLAGS=-DUSE_NDDR $(xcl_CXXFLAGS) $(opencl_CXXFLAGS)
io_global_LDFLAGS=$(opencl_LDFLAGS)

EXES=io_global

bandwidth_KERNEL := bandwidth

# RTL Kernel Sources
bandwidth_HDLSRCS=../vv_prj/kernel.xml\\
                  ../vv_prj/package_kernel.tcl\\
                  ../vv_prj/gen_xo.tcl\\
                  ../vv_prj/hdl/*.v\\
                  ../vv_prj/hdl/*.vhd
bandwidth_TCL=../vv_prj/gen_xo.tcl

CLFLAGS+=
LDCLFLAGS+= \\
    --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM0.core.OCL_REGION_0.M00_AXI \\
"""
else:
    code_string=code_string+"""include $(COMMON_REPO)/utility/boards.mk
include $(COMMON_REPO)/libs/xcl/xcl.mk
include $(COMMON_REPO)/libs/opencl/opencl.mk

# io_global Host Application
io_global_SRCS=../io_global_bandwidth.cpp $(xcl_SRCS)
io_global_HDRS=$(xcl_HDRS)
io_global_CXXFLAGS=-DUSE_NDDR $(xcl_CXXFLAGS) $(opencl_CXXFLAGS)
io_global_LDFLAGS=$(opencl_LDFLAGS)

EXES=io_global

bandwidth_KERNEL := bandwidth

# RTL Kernel Sources
bandwidth_HDLSRCS=../vv_prj/kernel.xml\\
                  ../vv_prj/package_kernel.tcl\\
                  ../vv_prj/gen_xo.tcl\\
                  ../vhls_prj/test_io/solution1/impl/verilog/*.v
bandwidth_TCL=../vv_prj/gen_xo.tcl

CLFLAGS+=
LDCLFLAGS+= \\
    --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM0.core.OCL_REGION_0.M00_AXI \\
"""

for i in range(0,numa+numb):
    code_string=code_string+'    --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM'+str(i+1)+'.core.OCL_REGION_0.M0'+str((i+1)%ddr_banks)+'_AXI'
    if (i<numa+numb-1):
        code_string=code_string+' \\'
    code_string=code_string+'\n'

code_string=code_string+"""
RTLXOS=bandwidth

# Kernel
bandwidth_XOS=bandwidth
bandwidth_NTARGETS=sw_emu

XCLBINS=bandwidth
EXTRA_CLEAN=tmp_kernel_pack* packaged_kernel* $(bandwidth_KERNEL).xo

# check
check_EXE=io_global
check_XCLBINS=bandwidth
check_NTARGETS=$(bandwidth_NTARGETS)

CHECKS=check

#Reporting warning if targeting for sw_emu
ifneq (,$(findstring sw_emu,$(TARGETS)))
$(warning WARNING:RTL Kernels do not support sw_emu TARGETS. Please use hw_emu for running RTL kernel Emulation)
endif

include $(COMMON_REPO)/utility/rules.mk
"""

output_file.write(code_string)
output_file.close()
