#!/bin/bash
#Common paths
#Ted's Python tool
ANML2HDL_PATH=/net/af5/vqd8a/Xilinx-SDAccel/Codes/AutomataProcessingEngine/anml2hdl_github
#
TOOL_PATH=/net/af5/vqd8a/Xilinx-SDAccel/Codes/AutomataProcessingEngine/python_tools
SDACCEL_REPO_PATH=/net/af5/vqd8a/Xilinx-SDAccel/SDAccel_Examples

PROJ_PATH=$(dirname $PWD)

#Application-specific and FPGA board settings
ANML=Examples/brill.anml
OUTFILE=Brill.vhd
ENTITY=Brill
TARGET=logic
REPORT_SIZE=218
MAX_DATASIZE_MB=10
DDR_BANKS=4
DEVICE_NAME="xcku115-flvb2104-2-e"
CLK_FREQ_MHZ=300
#IO_TEST: Set to 1 if running I/O kernel only, otherwise set to 0 for automata module hooking
IO_TEST=0

#
set -e

#Generate automata processing RTL module
if [ $IO_TEST = 0 ]; then
    echo "1.Generate automata processing RTL module"
    cd $ANML2HDL_PATH
    python anml2hdl.py -a $ANML -o $OUTFILE -e $ENTITY -t $TARGET
    cp OutputFiles/$OUTFILE $PROJ_PATH/vv_prj/hdl
    cp Resources/ste_sim.vhd $PROJ_PATH/vv_prj/hdl
fi

#Generate host application and I/O C kernel
cd $PROJ_PATH
echo "2.Generate host code (C)"
python $TOOL_PATH/host_gen.py $REPORT_SIZE $DDR_BANKS $IO_TEST

echo "3.Generate copy kernel header (C)"
python $TOOL_PATH/copy_kernel_h_gen.py $REPORT_SIZE $MAX_DATASIZE_MB

echo "4.Generate copy kernel (C)"
python $TOOL_PATH/copy_kernel_c_gen.py $REPORT_SIZE $MAX_DATASIZE_MB

#Generate AXI I/O template kernel (RTL)
echo "5.Generate I/O template script"
python $TOOL_PATH/iotemplatescript_gen.py $DEVICE_NAME $CLK_FREQ_MHZ

cd $PROJ_PATH/vhls_prj
echo "6.Generate I/O template kernel (RTL)"
vivado_hls -f test_io/solution1/iotemplate_script.tcl

if [ $IO_TEST = 0 ]; then
    #Hook automata module to the IO kernel
    echo "7.Hook automata module to the IO kernel"
    python $TOOL_PATH/automatahook.py $REPORT_SIZE test_io/solution1/impl/verilog/bandwidth.v $ENTITY > bandwidth.v
    #Update the IO kernel in the vivado project 
    mv test_io/solution1/impl/verilog/bandwidth.v test_io/solution1/impl/verilog/bandwidth.v_ORIG 
    cp bandwidth.v test_io/solution1/impl/verilog/
    cp test_io/solution1/impl/verilog/*.v $PROJ_PATH/vv_prj/hdl
else
    cp test_io/solution1/impl/verilog/*.v $PROJ_PATH/vv_prj/hdl
fi

#Generate kernel description XML file
cd $PROJ_PATH
echo "8.Generate kernel.xml"
python $TOOL_PATH/kernel_xml_gen.py $REPORT_SIZE

#Generate IP generation script
echo "9.Generate package_kernel.tcl"
python $TOOL_PATH/package_kernel_tcl_gen.py $REPORT_SIZE $IO_TEST

#Generate Makefile
echo "10.Generate Makefile"
python $TOOL_PATH/makefile_gen.py $SDACCEL_REPO_PATH $REPORT_SIZE $DDR_BANKS $IO_TEST

#Compile the project using SDAccel (including generating IP and XO files from the RTL kernel)
echo "11.Compile"
cd $PROJ_PATH/rtl_prj
nohup make all TARGETS=hw
