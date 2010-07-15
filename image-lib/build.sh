#!/bin/sh

. ../common/init.sh

PREFIX=/usr

###################################################################

NAME=jpeg
VERSION=8b
URL='http://www.ijg.org/files/jpegsrc.v$VERSION.tar.gz'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking --enable-shared --enable-static"

JPEG_DESTPREFIX=$DESTPREFIX

###################################################################

NAME=giflib
VERSION=4.1.6
URL='http://citylan.dl.sourceforge.net/project/$NAME/$NAME%204.x/$NAME-$VERSION/$NAME-$VERSION.tar.bz2'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking"

###################################################################

NAME=jasper
VERSION=1.900.1
URL='http://www.ece.uvic.ca/~mdadams/$NAME/software/$NAME-$VERSION.zip'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking --enable-shared --enable-static"


###################################################################

NAME=tiff
VERSION=3.9.4
URL='http://download.osgeo.org/libtiff/$NAME-$VERSION.tar.gz'

machug_fetch

machug_prepare

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking \
	--disable-cxx \
	--with-apple-opengl-framework \
	--with-jpeg-include-dir=$JPEG_DESTPREFIX/include \
	--with-jpeg-lib-dir=$JPEG_DESTPREFIX/lib"


exit;

configure_build_destroot jpeg \
	"--enable-shared --enable-static --disable-dependency-tracking" 

configure_build_destroot freetype \
	"--with-fsspec=no \
	--with-fsref=no \
	--with-quickdraw-toolbox=no \
	--with-quickdraw-carbon=no"

configure_build_destroot libpng \
	"--disable-dependency-tracking"

#DIR_BEFORE_CONFIGURE='ext/gd'
#
#configure_build_destroot php \
#	"--enable-gd-native-ttf \
#	--enable-gd-jis-conv \
#	--disable-fast-install \
#	--with-jpeg-dir=/usr/local \
#	--with-png-dir=/usr/local \
#	--with-xpm-dir=/usr/X11R6 \
#	--with-freetype-dir=/usr/local \
#	--with-zlib-dir=/usr" \
#	"sudo phpize"
#
#DIR_BEFORE_CONFIGURE=

configure_build_destroot giflib \
	"--disable-dependency-tracking"

configure_build_destroot jasper \
	"--disable-dependency-tracking \
	--enable-shared"

configure_build_destroot tiff \
	"--disable-dependency-tracking \
	--disable-cxx \
	--with-apple-opengl-framework \
	--with-jpeg-include-dir=$DESTROOT/include \
	--with-jpeg-lib-dir=$DESTROOT/lib"

configure_build_destroot gd \
	"--disable-dependency-tracking"

configure_build_destroot ImageMagick \
	"--without-x \
	--enable-hdri \
	--with-xml \
	--with-wmf \
	--without-magick-plus-plus \
	--disable-dependency-tracking"


chmod -R g-w $DESTROOT
chown -R root:admin $DESTROOT

/Developer/usr/bin/packagemaker --doc image-lib.pmdoc --out ../image-lib.pkg

