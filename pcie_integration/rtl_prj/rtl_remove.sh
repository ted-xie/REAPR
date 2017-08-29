#!/bin/bash
#Get the parent directory
PROJ_PATH=$(dirname $PWD)
#
set -e
#
cd $PROJ_PATH
rm *.c *.cpp *.h

cd $PROJ_PATH/vv_prj
rm kernel.xml package_kernel.tcl hdl/*.v hdl/*.vhd

cd $PROJ_PATH/vhls_prj
rm *.*
cd $PROJ_PATH/vhls_prj/test_io
rm *.*
cd $PROJ_PATH/vhls_prj/test_io/solution1
rm solution1.*
rm iotemplate_script.tcl
rm -Rf .autopilot
rm -Rf impl
rm -Rf syn

cd $PROJ_PATH/rtl_prj
rm Makefile
