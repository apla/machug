#!/bin/bash

. ../common/init.sh

PREFIX=/usr

NAME=mysql
VERSION=5.1.50
FORMAT=tar.gz
URL='http://gd.tuwien.ac.at/db/mysql/Downloads/MySQL-5.1/$FILENAME'

machug_fetch

machug_prepare

machug_build_destroot \
	"$CONFIGUREDIRS \
	--with-ssl=/usr \
	--with-zlib-dir=/usr \
	--with-charset=utf8 \
	--with-extra-charsets=all \
	--enable-assembler \
	--enable-profiling \
	--with-unix-socket-path=/private/tmp/mysql.sock \
	--enable-thread-safe-client \
	--with-plugins=all \
	--with-mysqld-user=_mysql \
	--without-debug \
	--localstatedir=/private/var/mysql \
	--disable-dependency-tracking"


mv "$DESTPREFIX/mysql-test" "$DESTPREFIX/share/mysql-test"
mv "$DESTPREFIX/sql-bench" "$DESTPREFIX/share/sql-bench"

chown -R root:wheel "$DESTPREFIX"
chmod -R g-w "$DESTPREFIX"

mkdir -p $DESTDIR/Library/LaunchDaemons
cp $PWDDD/files/mysql-launchd.plist $DESTDIR/Library/LaunchDaemons/com.mysql.mysqld.plist

mkdir -p $DESTDIR/private/etc
cp $PWDDD/files/mysql-my.conf $DESTDIR/private/etc/my.cnf

cd $PWDDD

/Developer/usr/bin/packagemaker --doc $PWDDD/$NAME.pmdoc --out $PWDDD/../$NAME-$VERSION.pkg
