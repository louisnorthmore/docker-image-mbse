#!/bin/sh

#darkhttpd
git clone https://github.com/ryanmjacobs/darkhttpd
cd darkhttpd
make
cp darkhttpd /usr/sbin/darkhttpd
cd ..


make clean
./configure
make
ln -sf /bin/true checkbasic
