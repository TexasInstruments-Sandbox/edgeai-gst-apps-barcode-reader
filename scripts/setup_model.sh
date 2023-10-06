#!/bin/bash

#URL_8_6="https://software-dl.ti.com/jacinto7/esd/edgeai-marketplace/barcode-reader/barcode-modelartifacts.tar.gz"
URL="https://software-dl.ti.com/jacinto7/esd/edgeai-marketplace/barcode-reader/09_00_00/barcode-modelartifacts.tar.gz"

if [  -f barcode-modelartifacts.tar.gz ] ; then 
    echo "model already downloaded"
else 
    wget $URL
    if [ "$?" -ne "0" ]; then
        wget $URL --proxy off

        if [ "$?" -ne "0" ]; then
            echo "Failed to download model; check proxy settings/environment variables. Alternatively, download the model on a PC and transfer to this directory"
        fi
    fi
fi

mkdir -p /opt/model_zoo/barcode-modelartifacts
tar -xf barcode-modelartifacts.tar.gz -C /opt/model_zoo/barcode-modelartifacts --warning=no-timestamp
