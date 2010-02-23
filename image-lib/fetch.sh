#!/bin/sh

. ../common/init.sh

PWDDD=`pwd`

mkdir src
cd src

echo "libgd   "
$CURL http://www.libgd.org/releases/gd-2.0.35.tar.bz2
echo "tiff    "
$CURL ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.9.2.tar.gz
echo "jasper  "
$CURL http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
echo "giflib  "
$CURL http://switch.dl.sourceforge.net/project/giflib/giflib%204.x/giflib-4.1.6/giflib-4.1.6.tar.bz2
echo "libpng  "
$CURL http://switch.dl.sourceforge.net/project/libpng/01-libpng-master/1.4.0/libpng-1.4.0.tar.bz2
echo "libjpeg "
$CURL http://www.ijg.org/files/jpegsrc.v8.tar.gz
echo "freetype"
$CURL http://switch.dl.sourceforge.net/project/freetype/freetype2/2.3.12/freetype-2.3.12.tar.bz2
echo "imagemagick"
$CURL ftp://gd.tuwien.ac.at/pub/graphics/ImageMagick/ImageMagick.tar.bz2

cd $PWDDD
