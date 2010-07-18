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

#machug_build_destroot "$CONFIGUREDIRS \
#	--disable-dependency-tracking \
#	--disable-cxx \
#	--with-apple-opengl-framework \
#	--with-jpeg-include-dir=$JPEG_DESTPREFIX/include \
#	--with-jpeg-lib-dir=$JPEG_DESTPREFIX/lib"

machug_build_destroot "$CONFIGUREDIRS \
	--disable-dependency-tracking \
	--disable-cxx \
	--with-apple-opengl-framework \
	--with-jpeg-include-dir=/usr/include \
	--with-jpeg-lib-dir=/usr/lib"

#exit;

#chmod -R g-w $DESTROOT
#chown -R root:admin $DESTROOT

/Developer/usr/bin/packagemaker --doc formats.pmdoc --out ../img-formats.pkg

