#!/bin/sh

# this variable defines build type: for package or local machine install
# for packaging use syntax './build.sh package'
PACKAGE=$1

INSTPREFIX_BASE=/tmp/postgresql-stageroot
PREFIX=/usr
VERSION=8.3.6
WD=`pwd`
NAME=pgsql

[ -e postgresql-$VERSION.tar.bz2 ] || curl -O ftp://ftp9.de.postgresql.org/unix/databases/postgresql/source/v$VERSION/postgresql-$VERSION.tar.bz2
rm -rf postgresql-$VERSION
tar -xjf postgresql-$VERSION.tar.bz2
cd postgresql-$VERSION

mkdir $INSTPREFIX_BASE
rm -rf $INSTPREFIX_BASE/*

INSTPREFIX=$INSTPREFIX_BASE

INSTALLDIRS=

CONFIGUREDIRS=`$WD/dirs.pl -- '' $PREFIX $NAME`

CONFIGUREARGS="--without-docdir
--enable-integer-datetimes \
--with-system-tzdata=/usr/share/zoneinfo \
--with-perl \
--with-python \
--with-tcl \
--with-pam \
--with-openssl \
--enable-thread-safety \
--with-krb5 \
--with-ldap \
--with-tclconfig=/usr/lib/ \
$CONFIGUREDIRS" # --with-libxml --with-libxslt"

# now we compile for 32 bit archs only
ARCH='i386'
ARCHFLAGS="-arch ${ARCH} -arch ppc7400"
BUILDHOST="--build=${ARCH}-apple-darwin --host=${ARCH}-apple-darwin"

LD="$WD/uld $ARCHFLAGS" CFLAGS=$ARCHFLAGS LDFLAGS=$ARCHFLAGS ./configure $CONFIGUREARGS $BUILDHOST

make -j 3 distprep

# install_dirs '/core'
INSTALLDIRS=`$WD/dirs.pl '' $INSTPREFIX/core $PREFIX $NAME`
make $INSTALLDIRS install

POSTFIX='.32bit'
find "$INSTPREFIX/core$PREFIX/bin" -type f -exec $WD/mv_arch.sh {} $POSTFIX \;
find "$INSTPREFIX/core$PREFIX/lib" -type f -exec $WD/mv_arch.sh {} $POSTFIX \;
#find "$INSTPREFIX/contrib$PREFIX/bin" -type f -exec $WD/mv_arch.sh {} $POSTFIX \;
#find "$INSTPREFIX/contrib$PREFIX/lib" -type f -exec $WD/mv_arch.sh {} $POSTFIX \;

make clean

# and now, we compile for 64 bit archs and link 32 bit archs
ARCH='x86_64'
ARCHFLAGS="-arch ${ARCH} -arch ppc64"
BUILDHOST="--build=${ARCH}-apple-darwin --host=${ARCH}-apple-darwin"

LD="$WD/uld $ARCHFLAGS" CFLAGS=$ARCHFLAGS LDFLAGS=$ARCHFLAGS ./configure $CONFIGUREARGS $BUILDHOST

make -j 3 distprep

# install_dirs '/core'
INSTALLDIRS=`$WD/dirs.pl '' $INSTPREFIX/core $PREFIX $NAME`
make $INSTALLDIRS install

# lipo
POSTFIX='.64bit'
find "$INSTPREFIX/core$PREFIX/bin" -type f ! -name '*.32bit' -exec $WD/mv_arch.sh {} $POSTFIX \;
find "$INSTPREFIX/core$PREFIX/lib" -type f ! -name '*.32bit' -exec $WD/mv_arch.sh {} $POSTFIX \;
#find "$INSTPREFIX/contrib$PREFIX/bin" -type f ! -name '*.32bit' -exec $WD/mv_arch.sh {} $POSTFIX \;
#find "$INSTPREFIX/contrib$PREFIX/lib" -type f ! -name '*.32bit' -exec $WD/mv_arch.sh {} $POSTFIX \;

sudo chown -R root:wheel $INSTPREFIX_BASE

exit

(cd $INSTPREFIX$PREFIX/pgsql/share && mkdir java && cd java && curl -O http://jdbc.postgresql.org/download/postgresql-8.2-506.jdbc3.jar && ln -s postgresql-*.jar postgresql.jar)


cd $WD
open PostgreSQL.pmproj 

