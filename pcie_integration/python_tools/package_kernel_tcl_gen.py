# -*- coding: utf-8 -*-
"""
@author: VinhDang
"""

import sys
import math

report_count = int(sys.argv[1])
io_test      = int(sys.argv[2])

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

output_file=open('./vv_prj/package_kernel.tcl','w')

code_string="""# /*******************************************************************************
# Copyright (c) 2017, Xilinx, Inc.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
# 
# 1. Redistributions of source code must retain the above copyright notice,
# this list of conditions and the following disclaimer.
# 
# 
# 2. Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
# 
# 
# 3. Neither the name of the copyright holder nor the names of its contributors
# may be used to endorse or promote products derived from this software
# without specific prior written permission.
# 
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,THE IMPLIED 
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, 
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, 
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY 
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING 
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
# EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# *******************************************************************************/
"""
if (io_test == 0):
    code_string=code_string+'set path_to_hdl "../vv_prj/hdl"\n'
else:
    code_string=code_string+'set path_to_hdl "../vhls_prj/test_io/solution1/impl/verilog/"\n'

code_string=code_string+"""set path_to_packaged "./packaged_kernel_${suffix}"
set path_to_tmp_project "./tmp_kernel_pack_${suffix}"

create_project -force kernel_pack $path_to_tmp_project
"""

if (io_test == 0):
    code_string=code_string+'add_files -norecurse [glob $path_to_hdl/*.v $path_to_hdl/*.vhd]\n'
else:
    code_string=code_string+'add_files -norecurse [glob $path_to_hdl/*.v]\n'

code_string=code_string+"""update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
ipx::package_project -root_dir $path_to_packaged -vendor xilinx.com -library RTLKernel -taxonomy /KernelIP -import_files -set_current false
ipx::unload_core $path_to_packaged/component.xml
ipx::edit_ip_in_project -upgrade true -name tmp_edit_project -directory $path_to_packaged $path_to_packaged/component.xml
set_property core_revision 2 [ipx::current_core]
foreach up [ipx::get_user_parameters] {
  ipx::remove_user_parameter [get_property NAME $up] [ipx::current_core]
}
ipx::create_xgui_files [ipx::current_core]\n"""
for i in range(0,1+numa+numb):
    code_string=code_string+'ipx::associate_bus_interfaces -busif m_axi_gmem'+str(i)+' -clock ap_clk [ipx::current_core]\n'
code_string=code_string+"""ipx::associate_bus_interfaces -busif s_axi_control -clock ap_clk [ipx::current_core]
set_property xpm_libraries {XPM_CDC XPM_MEMORY XPM_FIFO} [ipx::current_core]
set_property supported_families { } [ipx::current_core]
set_property auto_family_support_level level_2 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project -delete
"""
	
output_file.write(code_string)
output_file.close()
