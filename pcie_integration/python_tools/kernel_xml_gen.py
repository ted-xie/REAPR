# -*- coding: utf-8 -*-
"""
@author: VinhDang
"""

import sys
import math

report_count = int(sys.argv[1])

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

output_file=open('./vv_prj/kernel.xml','w')
code_string="""<?xml version="1.0" encoding="UTF-8"?>
<root versionMajor="1" versionMinor="5">
  <kernel name="bandwidth" language="ip" vlnv="xilinx.com:RTLKernel:bandwidth:1.0" attributes="" preferredWorkGroupSizeMultiple="1" workGroupSize="1" debug="true" compileOptions=" -g" profileType="none">
    <ports>\n"""

code_string=code_string+'      <port name="M_AXI_GMEM0" mode="master" range="0xFFFFFFFF" dataWidth="32" portType="addressable" base="0x0"/>\n'

for i in range(0,numa+numb):
    if (numa==0):
        temp_string=str(factorb*8)
    elif (numb==0):
        temp_string=str(factora*8)
    elif (i==numa+numb-1):
        temp_string=str(factorb*8)
    else:
        temp_string=str(factora*8)
    code_string=code_string+'      <port name="M_AXI_GMEM'+str(i+1)+'" mode="master" range="0xFFFFFFFF" dataWidth="'+temp_string+'" portType="addressable" base="0x0"/>\n'
code_string=code_string+"""      <port name="S_AXI_CONTROL" mode="slave" range="0x1000" dataWidth="32" portType="addressable" base="0x0"/>
    </ports>
    <args>
      <arg name="input_port" addressQualifier="1" id="0" port="M_AXI_GMEM0" size="0x8" offset="0x10" hostOffset="0x0" hostSize="0x8" type="uchar*"/>\n"""

tmp_num=28
for i in range(0,numa+numb):
    if (numa==0):
        temp_string='doutB_t*'
    elif (numb==0):
        temp_string='doutA_t*'
    elif (i==numa+numb-1):
        temp_string='doutB_t*'
    else:
        temp_string='doutA_t*'
    temp_string2=format(tmp_num+i*12,'02X')
    code_string=code_string+'      <arg name="output_port'+str(i)+'" addressQualifier="1" id="'+str(i+1)+'" port="M_AXI_GMEM'+str(i+1)+'" size="0x8" offset="0x'+temp_string2+'" hostOffset="0x0" hostSize="0x8" type="'+temp_string+'"/>\n'

code_string=code_string+"""    </args>
  </kernel>
</root>
""" 

output_file.write(code_string)
output_file.close()
