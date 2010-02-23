#!/bin/bash

export MACOSX_DEPLOYMENT_TARGET=10.5

# for ARCH in `lipo -info /usr/lib/libSystem.dylib | cut -f 3 -d :`  ; do ARCHFLAGS="$ARCHFLAGS -arch $ARCH" ; done ; echo $ARCHFLAGS
ARCHS=`lipo -info /usr/lib/libSystem.dylib | cut -f 3 -d :`
ARCHFLAGS=''
for ARCH in $ARCHS ; do
	ARCHFLAGS="$ARCHFLAGS -arch $ARCH"
done

export ARCHFLAGS=$ARCHFLAGS
export CFLAGS="$ARCHFLAGS -g -O3  -pipe -no-cpp-precomp"
export CCFLAGS="$ARCHFLAGS -g -O3  -pipe" 
export CXXFLAGS="$ARCHFLAGS -g -O3  -pipe"
export LDFLAGS="$ARCHFLAGS -bind_at_load"
INSTPREFIX=/tmp/destroot

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
	infodir=$INSTPREFIX$1$PREFIX/share/info
	INSTALL_ROOT=$INSTPREFIX$1"

}

configure_build_destroot () {
	SRC_PACK=$1
	#unzip -t jasper-1.900.1.zip | head -n 2 | tail -n 1
	CONF_FLAGS=$2

	BEFORE_CONFIGURE=$3
	
	SRC_ARCHIVE=`ls -1 $SRC_PACK*{zip,tar.bz2,tar.gz} 2>/dev/null | sort -g | tail -n 1`
	
	SRC_PATH=''

	echo '*********************************************************'
	echo '*** building' $SRC_PACK from $SRC_ARCHIVE
	echo '*********************************************************'
	
	UNARCH_CMD=''

	case ${SRC_ARCHIVE##*.} in
		'bz2')
			SRC_FILE=`tar -tjf $SRC_ARCHIVE | head -n 1`
			UNARCH_CMD='tar -xjf'
		;;
		'gz')
			SRC_FILE=`tar -tzf $SRC_ARCHIVE | head -n 1`
			UNARCH_CMD='tar -xzf'
		;;
		'zip')
			SRC_FILE=`unzip -t $SRC_ARCHIVE | head -n 2 | tail -n 1| cut -c 14-`
			UNARCH_CMD='unzip -qq'
		;;
	esac

	SRC_PATH=${SRC_FILE%%/*}
	
	if [ "x$DIR_BEFORE_CONFIGURE" != "x" ] ; then
		SRC_PATH="$SRC_PATH/$DIR_BEFORE_CONFIGURE"
	fi
	
	echo ">>> unarchived to: $SRC_PATH"

	if [ -d $SRC_PATH ] ; then
		cd $SRC_PATH
		make distclean &>/dev/null # probably failed
		make clean &>/dev/null
	else 
		`$UNARCH_CMD $SRC_ARCHIVE`
		cd $SRC_PATH
	fi

	if [ -f $PWDDD/patches/$SRC_PACK-configure.patch ] ; then
		echo '>>> patching before configure' $SRC_PACK

		patch -p0 <$PWDDD/patches/$SRC_PACK-configure.patch
	fi

	#rm -rf $SRC_PATH
	#`$UNARCH_CMD $SRC_ARCHIVE`
	
#	./configure --quiet $CONF_FLAGS && \
#		make -j3 2>1 1>"$PWDDD/log/build_$SRC_PACK" && \
#		sudo make -j3 $INSTALLDIRS install 2>1 1>"$PWDDD/log/install_$SRC_PACK"
	`$BEFORE_CONFIGURE`
	BUILD_STAGE='configure'
	echo ">>> configure" && \
		./configure $CONF_FLAGS &>$PWDDD/log/configure_$SRC_PACK && \
		if [ -f $PWDDD/patches/$SRC_PACK-make.patch ] ; then echo ">>> patching before build"; \
			patch -p0 <$PWDDD/patches/$SRC_PACK-make.patch; fi && \
		echo ">>> build" && export BUILD_STAGE='build' && \
		make -j3 &>$PWDDD/log/build_$SRC_PACK && \
		echo ">>> destroot" && export BUILD_STAGE='destroot' && \
		sudo make -j3 $INSTALLDIRS install &>$PWDDD/log/destroot_$SRC_PACK && \
		export BUILD_STAGE='done'
	
	if [ "x$BUILD_STAGE" != 'xdone' ] ; then
		echo "!!! build failed. additional information at $PWDDD/log/${BUILD_STAGE}_$SRC_PACK"
	else
		echo ">>> build ok"
	fi

	cd $PWDDD
}

CURL='curl -O -#'

USR_PREFIX="--sysconfdir=/private/etc --localstatedir=/private/var --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man"
