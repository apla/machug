export MACOSX_DEPLOYMENT_TARGET=10.5
export ARCHFLAGS="-arch ppc -arch ppc64 -arch i386 -arch x86_64"
export CFLAGS="$ARCHFLAGS -g -O3  -pipe -no-cpp-precomp"
export CCFLAGS="$ARCHFLAGS -g -O3  -pipe" 
export CXXFLAGS="$ARCHFLAGS -g -O3  -pipe"
export LDFLAGS="$ARCHFLAGS -bind_at_load"

NAME=image-lib

PREFIX=/usr/local
INSTPREFIX=/tmp/destroot

purge

rm -rf $INSTPREFIX/$NAME

PWDDD=`pwd`

INSTALLDIRS=

install_dirs () {
	INSTALLDIRS="prefix=$INSTPREFIX$1$PREFIX \
	exec_prefix=$INSTPREFIX$1$PREFIX \
	bindir=$INSTPREFIX$1$PREFIX/bin \
	sbindir=$INSTPREFIX$1$PREFIX/sbin \
	sysconfdir=$INSTPREFIX$1/private/etc \
	datadir=$INSTPREFIX$1$PREFIX/share \
	includedir=$INSTPREFIX$1$PREFIX/include \
	libdir=$INSTPREFIX$1$PREFIX/lib \
	libexecdir=$INSTPREFIX$1$PREFIX/libexec \
	localstatedir=$INSTPREFIX$1/private/var/$NAME \
	mandir=$INSTPREFIX$1$PREFIX/share/man \
	infodir=$INSTPREFIX$1$PREFIX/share/info"

}

install_dirs "/$NAME"
#make $INSTALLDIRS install


#rm -rf freetype-2.3.9
#tar -xjf freetype-2.3.9.tar.bz2

cd freetype-2.3.9

FLAGS="--with-fsspec=no --with-fsref=no --with-quickdraw-toolbox=no --with-quickdraw-carbon=no"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD

rm -rf jpeg-6b
tar -xzf jpegsrc.v6b.tar.gz
cd jpeg-6b

cp /usr/share/libtool/config.sub .
cp /usr/share/libtool/config.guess .
./configure --enable-shared
make -j3
sudo mkdir -p $INSTPREFIX/$NAME$PREFIX/include
sudo mkdir -p $INSTPREFIX/$NAME$PREFIX/bin
sudo mkdir -p $INSTPREFIX/$NAME$PREFIX/lib
sudo mkdir -p $INSTPREFIX/$NAME$PREFIX/man/man1
sudo make $INSTALLDIRS install
sudo cp -R $INSTPREFIX/$NAME$PREFIX/man $INSTPREFIX/$NAME$PREFIX/share/
sudo rm -rf $INSTPREFIX/$NAME$PREFIX/man

cd $PWDDD

rm -rf giflib-4.1.6
tar -xjf giflib-4.1.6.tar.bz2
cd giflib-4.1.6

FLAGS="--disable-dependency-tracking"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD


rm -rf libpng-1.2.36
tar -xjf libpng-1.2.36.tar.bz2 
cd libpng-1.2.36

#	sed -E -i '' -e "s,typedef unsigned long png_uint_32;,typedef unsigned int png_uint_32;," \
#		-e "s,typedef long png_int_32;,typedef int png_int_32;," \
#		pngconf.h

FLAGS="--disable-dependency-tracking"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD


rm -rf jasper-1.900.1
unzip jasper-1.900.1.zip
cd jasper-1.900.1

FLAGS="--disable-dependency-tracking --enable-shared"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD

rm -rf tiff-3.8.2
tar -xzf tiff-3.8.2.tar.gz
cd tiff-3.8.2

FLAGS="--disable-dependency-tracking --disable-cxx --with-apple-opengl-framework --with-jpeg-include-dir=/usr/local/include --with-jpeg-lib-dir=/usr/local/lib"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD

rm -rf gd-2.0.35
tar -xjf gd-2.0.35.tar.bz2
cd gd-2.0.35

FLAGS="--disable-dependency-tracking"
./configure $FLAGS && make -j3 && sudo make $INSTALLDIRS install

cd $PWDDD


