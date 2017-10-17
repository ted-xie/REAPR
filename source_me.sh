#!/bin/bash
export REAPR_HOME=$PWD
# create a virtual env if one doesn't exist already
if [ ! -d "virt" ]; then
	# force usage of python3
    virtualenv virt -p python3
    source virt/bin/activate
    # install jinja2 for template rendering
    pip install jinja2
    deactivate
fi
# make a custom command for REAPR's python installation
alias reapr_python="$REAPR_HOME/virt/bin/python3"

