#!/bin/sh
#
# This is a wrapper for xz to compress the kernel image using appropriate
# compression options depending on the architecture.
#
# Author: Lasse Collin <lasse.collin@tukaani.org>
#
# This file has been put into the public domain.
# You can do whatever you want with this file.
#
# lc=2(3)4  dict=16MiB  lb=0-4 pb=0(2)4  mf=hc3-4/bt2-4   nice=2-273

BCJ=
LZMA2OPTS=

case $SRCARCH in
	x86)            BCJ=--x86 ;;
	powerpc)        BCJ=--powerpc ;;
	ia64)           BCJ=--ia64; LZMA2OPTS=pb=4 ;;
	arm)            BCJ=--arm ;;
	sparc)          BCJ=--sparc ;;
esac

exec xz --check=crc32 $BCJ --lzma2=$LZMA2OPTS,dict=8MiB
