#!/bin/sh

. ../common/init.sh

PREFIX=/usr

###################################################################

NAME=gd
VERSION=2.0.35
URL='http://www.libgd.org/releases/$NAME-$VERSION.tar.bz2'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking"



###################################################################

NAME=ImageMagick
VERSION=6.6.3-0
URL='ftp://ftp.imagemagick.org/pub/$NAME/$NAME-$VERSION.tar.bz2'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--enable-hdri \
	--with-xml \
	--with-wmf \
	--without-magick-plus-plus \
	--with-modules \
	--disable-dependency-tracking"

###################################################################

exit;

/Developer/usr/bin/packagemaker --doc image-lib.pmdoc --out ../image-lib.pkg

