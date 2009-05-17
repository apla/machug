#!/bin/sh

. ../common/init.sh

PREFIX=/usr
NAME=nginx

purge

rm -rf $INSTPREFIX/$NAME

PWDDD=`pwd`

mkdir $PWDDD/log

install_dirs "/$NAME"

DESTROOT="$INSTPREFIX/$NAME$PREFIX"

configure_build_destroot pcre \
	"$USR_PREFIX \
	--enable-utf8 \
	--disable-dependency-tracking  \
	--enable-unicode-properties \
	--enable-pcregrep-libz \
	--enable-pcregrep-libbz2 \
	--enable-pcretest-libreadline \
	--disable-cpp "

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


#/Developer/usr/bin/packagemaker --doc image-lib.pmdoc --out ../image-lib.pkg

