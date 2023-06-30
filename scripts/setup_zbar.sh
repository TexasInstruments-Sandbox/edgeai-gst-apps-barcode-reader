#!/bin/bash

#  Copyright (C) 2021 Texas Instruments Incorporated - http://www.ti.com/
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions
#  are met:
#
#    Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#    Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the
#    distribution.
#
#    Neither the name of Texas Instruments Incorporated nor the names of
#    its contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
#  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
#https://github.com/mchehab/zbar/blob/master/INSTALL.md
autoreconf -vfi
./configure
make

echo "install zbar"
make install

cd python
python3 setup.py install

echo "Copy installed zbar to /usr/lib"
# copy to /usr/lib from /usr/local/lib. Otherwise, paths need to be added for the linker/LD to find.
cp /usr/local/lib/libzbar.so.0.3.0 /usr/lib
cp /usr/local/lib/libzbar.la /usr/lib
cp /usr/local/lib/libzbar.a /usr/lib
cp /usr/local/lib/pkgconfig/zbar.pc /usr/lib/pkgconfig/zbar.pc
cp /usr/local/lib/python3.8/site-packages/zbar.* /usr/lib/python3.8/site-packages/

ln -s /usr/lib/libzbar.so.0.3.0 /usr/lib/libzbar.so.0

ldconfig