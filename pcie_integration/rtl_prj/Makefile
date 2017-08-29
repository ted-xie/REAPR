# io_global Application
COMMON_REPO:=/net/af5/vqd8a/Xilinx-SDAccel/SDAccel_Examples

include $(COMMON_REPO)/utility/boards.mk
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
bandwidth_HDLSRCS=../vv_prj/kernel.xml\
                  ../vv_prj/package_kernel.tcl\
                  ../vv_prj/gen_xo.tcl\
                  ../vv_prj/hdl/*.v\
                  ../vv_prj/hdl/*.vhd
bandwidth_TCL=../vv_prj/gen_xo.tcl

CLFLAGS+=
LDCLFLAGS+= \
    --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM0.core.OCL_REGION_0.M00_AXI \
    --xp misc:map_connect=add.kernel.bandwidth_1.M_AXI_GMEM1.core.OCL_REGION_0.M01_AXI

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
