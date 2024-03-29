#!/bin/sh

#########################################
###    Author: Yuanjun.Li
###    Email:  yourchanges@gmail.com 
#########################################


cdir=`pwd`

#clean
rm -rf ssh_*
rm -rf openssh
rm -rf zlib-1.2.5
rm -rf openssl-1.0.0a
rm -rf openssh-5.6p1
mkdir -p openssh

#download package
#wget http://www.zlib.net/zlib-1.2.5.tar.gz
#wget http://www.openssl.org/source/openssl-1.0.0a.tar.gz
#wget http://mirror.mcs.anl.gov/openssh/portable/openssh-5.6p1.tar.gz


#unzip
tar xvfz zlib-1.2.5.tar.gz
tar xvfz openssl-1.0.0a.tar.gz
tar xvfz openssh-5.6p1.tar.gz

#set env for building zlib
export CC=arm-linux-gcc
export AR=ar
#build zlib
cd zlib-1.2.5
make clean
./configure --prefix=$cdir/openssh/zlib
make
make install
cd -



#build openssl
cd openssl-1.0.0a
make clean
./config no-asm shared --prefix=$cdir/openssh/openssl

#set env for building openssl
export CC=arm-linux-gcc
export CFLAG="-fPIC -DOPENSSL_PIC -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAV E_DLFCN_H -DL_ENDIAN -DTERMIO -O3 -fomit-frame-pointer -Wall"
export DEPFLAG="-DOPENSSL_NO_GMP -DOPENSSL_NO_JPAKE -DOPENSSL_NO_MD2 -DOPENSSL_NO_R    C5 -DOPENSSL_NO_RFC3779 -DOPENSSL_NO_STORE"
export PEX_LIBS=
export EX_LIBS="-ldl"
export EXE_EXT=
export ARFLAGS=
#AR= ar $(ARFLAGS) r
export AR="arm-linux-ar $ARFLAGS r"
#RANLIB=/usr/bin/ranlib
export RANLIB=arm-linux-ranlib
#NM=nm
export NM=arm-linux-nm
export PERL="/usr/bin/perl"
export TAR=tar
export TARFLAGS="--no-recursion"
export MAKEDEPPROG=gcc
export LIBDIR=lib

make
make install
cd -

#build openssh
cd openssh-5.6p1
make clean
./configure --host=arm-linux --with-libs --with-zlib=$cdir/openssh/zlib --with-ssl-dir=$cdir/openssh/openssl --disable-etc-default-login CC=arm-linux-gcc AR=arm-linux-ar
make
cd -

#generate ssh-key
ssh-keygen -t rsa1 -f ssh_host_key -N ""
ssh-keygen -t rsa -f ssh_host_rsa_key -N ""
ssh-keygen -t dsa -f ssh_host_dsa_key -N ""

