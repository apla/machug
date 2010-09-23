#!/bin/sh

. ../common/init.sh

PREFIX=/usr

###################################################################

NAME=dovecot
VERSION=2.0.3
URL='http://dovecot.org/releases/2.0/$NAME-$VERSION.tar.gz'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking
	--with-gssapi=yes \
	--with-ldap=yes \
	--with-sql=yes \
	--with-pgsql \
	--with-mysql \
	--with-sqlite \
	--with-zlib \
	--with-bzlib \
	--with-sql-drivers \
	--sysconfdir=/private/etc/dovecot/ \
	--with-moduledir=/usr/libexec/dovecot/"


###################################################################

/Developer/usr/bin/packagemaker --doc $NAME.pmdoc --out $PWDDD/../$NAME-$VERSION.pkg

