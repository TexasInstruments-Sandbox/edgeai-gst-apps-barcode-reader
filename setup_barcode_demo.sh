#!/bin/bash

echo "Setup Zbar"
./scripts/setup_zbar.sh
if [ "$?" -ne "0" ]; then
    exit_setup
fi


echo "Setup Model"
./scripts/setup_model.sh
if [ "$?" -ne "0" ]; then
    exit_setup
fi


ldconfig

echo "Build C++ apps"
./scripts/compile_cpp_apps.sh $*
if [ "$?" -ne "0" ]; then
    exit_setup
fi

echo "Setup webserver for python"

PROXY_INFO=""
#PROXY_INFO= " --proxy http://webproxy.ext.ti.com:80 "
pip3   --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org $PROXY_INFO install flask flask-socketio "python-socketio[client]" python-engineio


ldconfig 
sync

