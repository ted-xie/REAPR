#!/bin/bash
vhdlan -work work -f files.txt
vcs -debug_all work.TB
./simv -gui
