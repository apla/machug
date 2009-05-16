export ARCHFLAGS="-arch ppc -arch ppc64 -arch i386 -arch x86_64"
MACOSX_DEPLOYMENT_TARGET=10.5 \
CFLAGS="$ARCHFLAGS -g -O3 -pipe -no-cpp-precomp" \
CCFLAGS="$ARCHFLAGS -g -O3 -pipe" \
CXXFLAGS="$ARCHFLAGS -g -O3 -pipe" \
LDFLAGS="$ARCHFLAGS -bind_at_load" \
./configure --quiet \
--with-ssl=/usr \
--with-zlib-dir=/usr \
--with-charset=utf8 \
--with-extra-charsets=all \
--enable-assembler \
--enable-profiling \
--with-unix-socket-path=/private/tmp/mysql.sock \
--enable-thread-safe-client \
--with-plugins=all \
--sysconfdir=/private/etc \
--mandir=/usr/share/man \
--infodir=/usr/share/info \
--with-mysqld-user=_mysql \
--without-debug \
--localstatedir=/private/var/mysql \
--prefix=/usr \
--disable-dependency-tracking 
#--without-libedit 
#--without-readline

#--without-bench \
#--without-tests \

