#!/bin/bash
export REAPR_HOME=$PWD
# create a virtual env if one doesn't exist already
if [ ! -d "virt" ]; then
	# force usage of python3
    virtualenv virt -p python3
    source virt/bin/activate
    # install jinja2 for template rendering
    pip install jinja2
else
    # if virtual env already exists, just activate it
    source virt/bin/activate
fi
