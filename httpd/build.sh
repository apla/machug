#!/bin/sh

. ../common/init.sh

PREFIX=/usr

################ wget for real scripting

NAME=wget
VERSION=1.12
URL='http://ftp.gnu.org/gnu/$NAME/$FILENAME'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS --disable-dependency-tracking"


################ mod_rpaf for apache2/nginx integration ####################

NAME=mod_rpaf
VERSION=0.6
FORMAT=tar.gz
URL='http://stderr.net/apache/rpaf/download/$FILENAME'

machug_fetch

machug_prepare

echo $ARCH_LIBTOOL

CONFIGURE_CMD="true"
MAKE_CMD="/usr/sbin/apxs $ARCH_LIBTOOL -c -o mod_rpaf-2.0.so mod_rpaf-2.0.c"
MAKE_INSTALL_CMD="/bin/cp .libs/mod_rpaf-2.0.so $DESTDIR/usr/libexec/apache2/"

/bin/mkdir -p $DESTDIR/usr/libexec/apache2

machug_build_destroot ""

/bin/mkdir -p $DESTDIR/private/etc/apache2/other/
/bin/cp files/rpaf.conf $DESTDIR/private/etc/apache2/other/

################ nginx ####################

NAME=nginx
VERSION=0.8.54
URL='http://nginx.org/download/$FILENAME'

machug_fetch

machug_prepare

# apple suxx
if [ ! -f '/usr/include/pcre.h' ] ; then
	cp $PWDDD/files/pcre.h /usr/include/pcre.h
fi

machug_build_destroot \
	"--prefix=/Library/WebServer \
	--sbin-path=/usr/sbin/nginx \
	--conf-path=/private/etc/nginx/nginx.conf \
	--error-log-path=/private/var/log/nginx/error_log \
	--pid-path=/private/var/run/nginx.pid \
	--lock-path=/private/var/lock/nginx\
	--http-log-path=/private/var/log/nginx/access_log \
	--http-client-body-temp-path=/private/var/tmp/nginx/body \
	--http-proxy-temp-path=/private/var/tmp/nginx/proxy \
	--http-fastcgi-temp-path=/private/var/tmp/nginx/fcgi \
	--with-http_ssl_module \
	--with-http_realip_module \
	--with-http_gzip_static_module \
	--with-http_flv_module \
	--with-http_dav_module \
	--with-http_addition_module \
	--with-http_xslt_module \
	--with-http_sub_module"


mkdir -p $DESTDIR/Library/LaunchDaemons
cp $PWDDD/files/net.nginx.plist $DESTDIR/Library/LaunchDaemons/net.nginx.plist

rm $DESTDIR/Library/WebServer/html/*
rmdir $DESTDIR/Library/WebServer/html/

rmdir $DESTDIR/private/var/run

chown www:www $DESTDIR/private/var/log/nginx

/Developer/usr/bin/packagemaker --doc $PWDDD/$NAME.pmdoc --out $PWDDD/../$NAME-$VERSION.pkg
