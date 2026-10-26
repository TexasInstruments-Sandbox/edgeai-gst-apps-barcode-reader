#!/bin/bash

echo "Setup Zbar"
./scripts/setup_zbar.sh
if [ "$?" -ne "0" ]; then
    exit_setup
fi


ldconfig

echo "Skipping C++ rebuild; this has not been verified in 11.1 SDK"
#./scripts/compile_cpp_apps.sh $*
#if [ "$?" -ne "0" ]; then
#    exit_setup
#fi

