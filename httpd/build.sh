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



mkdir -p $INSTPREFIX/$NAME/Library/LaunchDaemons
cat > $INSTPREFIX/$NAME/Library/LaunchDaemons/net.nginx.plist <<InputComesFromHERE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>net.nginx</string>
	<key>OnDemand</key>
	<false/>
	<key>RunAtLoad</key>
	<true/>
	<key>Program</key>
	<string>/usr/sbin/nginx</string>
	<key>KeepAlive</key>
	<true/>
	<key>NetworkState</key>
	<true/>
	<key>StandardErrorPath</key>
	<string>/var/log/system.log</string>
	<key>LaunchOnlyOnce</key>
	<true/>
	<key>SoftResourceLimits</key>
	<dict>
		<key>NumberOfFiles</key>
		<integer>65536</integer>
	</dict>
	<key>HardResourceLimits</key>
	<dict>
		<key>NumberOfFiles</key>
		<integer>65536</integer>
	</dict>
	
	<key>ServiceDescription</key>
	<string>nginx httpd</string>

</dict>
</plist>

InputComesFromHERE


#/Developer/usr/bin/packagemaker --doc image-lib.pmdoc --out ../image-lib.pkg

