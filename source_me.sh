#!/bin/bash
export REAPR_HOME=$PWD
# create a virtual env if one doesn't exist already
if [ ! -d "virt" ]; then
    virtualenv virt
    source virt/bin/activate
    # install jinja2 for template rendering
    pip install jinja2
fi
