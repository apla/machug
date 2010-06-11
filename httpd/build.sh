#!/bin/sh

. ../common/init.sh

PREFIX=/usr
NAME=nginx

rm -rf $INSTPREFIX/$NAME

PWDDD=`pwd`

mkdir $PWDDD/log

install_dirs "/$NAME"

DESTROOT="$INSTPREFIX/$NAME$PREFIX"

DESTDIR=$DESTROOT

# apple suxx
if [ ! -f '/usr/include/pcre.h' ] ; then
	cp $PWDDD/files/pcre.h /usr/include/pcre.h
fi

configure_build_destroot nginx \
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


mkdir -p $INSTPREFIX/$NAME/Library/LaunchDaemons
cp $PWDDD/files/net.nginx.plist $INSTPREFIX/$NAME/Library/LaunchDaemons/net.nginx.plist

rm $INSTPREFIX/$NAME/Library/WebServer/html/*
rmdir $INSTPREFIX/$NAME/Library/WebServer/html/

rmdir $INSTPREFIX/$NAME/private/var/run

chown www:www $INSTPREFIX/$NAME/private/var/log/nginx

/bin/mkdir -p $INSTPREFIX/$NAME/usr/libexec/apache2

CONFIGURE_CMD="echo"
MAKE_CMD="/usr/sbin/apxs $ARCH_LIBTOOL -c -o mod_rpaf-2.0.so mod_rpaf-2.0.c"
MAKE_INSTALL_CMD="/bin/cp .libs/mod_rpaf-2.0.so $INSTPREFIX/$NAME/usr/libexec/apache2/"

configure_build_destroot mod_rpaf ""

/bin/mkdir -p $INSTPREFIX/$NAME/private/etc/apache2/other/
/bin/cp files/rpaf.conf $INSTPREFIX/$NAME/private/etc/apache2/other/


/Developer/usr/bin/packagemaker --doc nginx.pmdoc --out ../nginx.pkg
