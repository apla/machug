#!/bin/bash

. ../common/init.sh

PREFIX=/usr

NAME=postgresql
VERSION=9.0.1
URL='ftp://ftp9.de.postgresql.org/unix/databases/postgresql/source/v$VERSION/$FILENAME'

machug_fetch 

machug_prepare

MAKE_CMD="make -j4 distprep"

machug_build_destroot_every_arch "
	$CONFIGUREDIRS \
	--enable-integer-datetimes \
	--enable-thread-safety \
	--disable-rpath \
	--enable-dtrace \
	--with-system-tzdata=/usr/share/zoneinfo \
	--with-tcl \
	--with-tclconfig=/usr/lib/ \
	--with-perl \
	--with-python \
	--with-gssapi \
	--with-krb5 \
	--with-pam \
	--with-ldap \
	--with-bonjour \
	--with-openssl \
	--with-libxml --with-libxslt \
"

MAKE_CMD=''

chown -R root:wheel $DESTPREFIX
chmod -R g-w $DESTPREFIX

mkdir -p $DESTDIR/Library/LaunchDaemons

cp $PWDDD/files/org.postgresql.plist $DESTDIR/Library/LaunchDaemons/

cd $PWDDD

/Developer/usr/bin/packagemaker --doc $PWDDD/$NAME.pmdoc --out $PWDDD/../$NAME-$VERSION.pkg
