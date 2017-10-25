#!/bin/bash

set -e

# Specify path to python3 executable.
export REAPR_HOME=$PWD
# create a virtual env if one doesn't exist already
if [ ! -d "virt" ]; then
    # NOTE: the following command is ONLY compatible with python3.6+
    # If you do not have a python3.6+ installation, please install it locally.
    # The Jinja2 library for python3 requires python3.6+.
    python3 -m venv virt
    source virt/bin/activate
    # install jinja2 for template rendering
    pip install jinja2
    deactivate

    echo "REAPR successfully configured!"

    echo "To permanently add REAPR environment settings to your shell, add the following lines to your ~/.bashrc file:"
    echo "    export REAPR_HOME=$REAPR_HOME"
    echo "    alias reapr_python=\"$REAPR_HOME/virt/bin/python3\""
fi
# make a custom command for REAPR's python installation
alias reapr_python="$REAPR_HOME/virt/bin/python3"

set +e
