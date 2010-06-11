#!/usr/bin/sh

. ../common/init.sh

PWDDD=`pwd`

mkdir src
cd src

#$CURL ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.6.tar.bz2 
$CURL http://nginx.org/download/nginx-0.8.40.tar.gz
#$CURL http://nginx.org/download/nginx-0.7.65.tar.gz
$CURL http://stderr.net/apache/rpaf/download/mod_rpaf-0.6.tar.gz

cd $PWDDD
