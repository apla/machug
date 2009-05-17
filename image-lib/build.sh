#!/bin/sh

. ../common/init.sh

PREFIX=/usr/local
NAME=image-lib

purge

rm -rf $INSTPREFIX/$NAME

PWDDD=`pwd`

mkdir $PWDDD/log

install_dirs "/$NAME"

DESTROOT="$INSTPREFIX/$NAME$PREFIX"

mkdir -p $DESTROOT/{share,lib,bin,include,man/man1}

configure_build_destroot jpeg \
	"--enable-shared" \
	"cp /usr/share/libtool/config.sub /usr/share/libtool/config.guess ."

sudo cp -R $DESTROOT/man $DESTROOT/share/
sudo rm -rf $DESTROOT/man

configure_build_destroot freetype \
	"--with-fsspec=no \
	--with-fsref=no \
	--with-quickdraw-toolbox=no \
	--with-quickdraw-carbon=no"

configure_build_destroot giflib \
	"--disable-dependency-tracking"

configure_build_destroot libpng \
	"--disable-dependency-tracking"

configure_build_destroot tiff \
	"--disable-dependency-tracking \
	--disable-cxx \
	--with-apple-opengl-framework \
	--with-jpeg-include-dir=/usr/local/include \
	--with-jpeg-lib-dir=/usr/local/lib"

configure_build_destroot jasper \
	"--disable-dependency-tracking \
	--enable-shared"

configure_build_destroot gd \
	"--disable-dependency-tracking"

configure_build_destroot ImageMagick \
	"--without-x \
	--enable-hdri \
	--with-xml \
	--with-wmf \
	--without-magick-plus-plus \
	--disable-dependency-tracking"

/Developer/usr/bin/packagemaker --doc image-lib.pmdoc --out ../image-lib.pkg

