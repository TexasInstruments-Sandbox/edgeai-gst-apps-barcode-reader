#!/bin/bash

LOGFILE=scripts/zbar_install.log
echo "" > $LOGFILE

if [[ `arch` != "aarch64" ]]; then
  echo "This should only be run on the EVM! If need be, clone the repo and transfer locally and run following setup commands"
  return
fi

echo "Clone zbar"
if [[ ! -d ./zbar ]]; then
   git clone https://github.com/mchehab/zbar.git
fi

cd zbar

echo "Build zbar"
USE_OLD_BUILD_STEPS=0 #zbar from branch 0.23 or older
#https://github.com/mchehab/zbar/blob/master/INSTALL.md
if [[ "$USE_OLD_BUILD_STEPS" -eq 1 ]]; then 
    autoreconf -vfi 
    ./configure 
    make  

    echo "install zbar"
    make install >> $LOGFILE

    cd python
    python3 setup.py install >> $LOGFILE


else
    ##updated build for newer zbar library versions
    meson setup build -Dpython=python3
    meson compile -C build
    meson install -C build
fi 


echo "Copy installed zbar from /usr/local/lib to /usr/lib"
# copy to /usr/lib from /usr/local/lib. Otherwise, paths need to be added for the linker/LD to find.
cp /usr/local/lib/libzbar.* /usr/lib
cp /usr/local/lib/pkgconfig/zbar.pc /usr/lib/pkgconfig/zbar.pc
cp /usr/local/lib/python3.12/site-packages/zbar.* /usr/lib/python3.12/site-packages/

ln -sf /usr/lib/libzbar.so.0.3.0 /usr/lib/libzbar.so.0

ldconfig


