#!/bin/sh

RES=`lipo -info $1 && mv $1 $1$2`

if [ "x$RES" != "x" -a "x$2" = "x.64bit" ] ; then 
	lipo -create -output $1 $1.32bit $1$2
	rm $1.32bit
	rm $1$2
fi
