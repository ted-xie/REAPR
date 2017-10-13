#!/bin/bash
export REAPR_HOME=$PWD
# create a virtual env if one doesn't exist already
if [ ! -d "virt" ]; then
    virtualenv virt
    source virt/bin/activate
    # install jinja2 for template rendering
    pip install jinja2

    # exit the virtual environment
    deactivate
fi
# make a custom command for REAPR's python installation
alias reapr_python="$REAPR_HOME/virt/bin/python3"

