#!/bin/sh

. ../common/init.sh

PWDDD=`pwd`

mkdir src
cd src

echo "mysql   "
$CURL http://gd.tuwien.ac.at/db/mysql/Downloads/MySQL-5.1/mysql-5.1.46.tar.gz

cd $PWDDD
