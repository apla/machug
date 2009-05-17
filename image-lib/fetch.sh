CURL='curl -O -#'
echo "libgd   "
$CURL http://www.libgd.org/releases/gd-2.0.35.tar.bz2
echo "tiff    "
$CURL ftp://ftp.remotesensing.org/pub/libtiff/tiff-3.8.2.tar.gz
echo "jasper  "
$CURL http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
echo "giflib  "
$CURL http://switch.dl.sourceforge.net/sourceforge/giflib/giflib-4.1.6.tar.bz2
echo "libpng  "
$CURL http://switch.dl.sourceforge.net/sourceforge/libpng/libpng-1.2.36.tar.bz2
echo "libjpeg "
$CURL http://www.ijg.org/files/jpegsrc.v6b.tar.gz
echo "freetype"
$CURL http://ftp.twaren.net/Unix/NonGNU/freetype/freetype-2.3.9.tar.bz2
echo "imagemagick"
$CURL ftp://gd.tuwien.ac.at/pub/graphics/ImageMagick/ImageMagick.tar.bz2

