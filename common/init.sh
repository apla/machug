#!/bin/bash

MACOSX_VERSION=`sw_vers -productVersion | cut -f 1,2 -d '.'`

export MACOSX_DEPLOYMENT_TARGET=$MACOSX_VERSION

# for ARCH in `lipo -info /usr/lib/libSystem.dylib | cut -f 3 -d :`  ; do ARCHFLAGS="$ARCHFLAGS -arch $ARCH" ; done ; echo $ARCHFLAGS
ARCHS=`lipo -info /usr/lib/libSystem.dylib | cut -f 3 -d :`
ARCHFLAGS=''
ARCH_LIBTOOL=""
for ARCH in $ARCHS ; do
	ARCHFLAGS="$ARCHFLAGS -arch $ARCH"
	ARCH_LIBTOOL="$ARCH_LIBTOOL -Wl,-arch -Wl,$ARCH -Wc,-arch -Wc,$ARCH"
done

export ARCHFLAGS=$ARCHFLAGS
export CFLAGS="$ARCHFLAGS -g -O3  -pipe -no-cpp-precomp"
export CCFLAGS="$ARCHFLAGS -g -O3  -pipe" 
export CXXFLAGS="$ARCHFLAGS -g -O3  -pipe"
export LDFLAGS="$ARCHFLAGS -bind_at_load"

INSTPREFIX=/tmp/destroot

INSTALLDIRS=

CURL='curl -O -#'

PWDDD=`pwd`

machug_fetch () {
	cd $PWDDD/src
	if [ "x$FORMAT" = "x" ] ; then FORMAT='tar.bz2' ; fi
	if [ "x$FILENAME" = "x" ] ; then FILENAME="$NAME-$VERSION.$FORMAT" ; else FILENAME=`eval echo $FILENAME` ; fi
	if [ ! -f $FILENAME ] ; then
		REAL_URI=`eval echo $URI`
		echo ">>> fetching $NAME from $REAL_URI"
		$CURL $REAL_URI
	else
		echo ">>> using already downloaded $FILENAME"
	fi
	cd $PWDDD
}

machug_prepare () {
	DESTDIR="$INSTPREFIX/$NAME"

	DESTPREFIX="$DESTDIR$PREFIX"

	CONFIGUREDIRS="--prefix=$PREFIX \
	--exec-prefix=$PREFIX \
	--bindir=$PREFIX/bin \
	--sbindir=$PREFIX/sbin \
	--sysconfdir=/private/etc \
	--datadir=$PREFIX/share \
	--includedir=$PREFIX/include \
	--libdir=$PREFIX/lib \
	--libexecdir=$PREFIX/libexec \
	--localstatedir=/private/var/$NAME \
	--mandir=$PREFIX/share/man \
	--infodir=$PREFIX/share/info"

	rm -rf $DESTDIR

	if [ ! -d $PWDDD/log ] ; then
		mkdir $PWDDD/log
	fi

	INSTALLDIRS="INSTALL_ROOT=$DESTDIR DESTDIR=$DESTDIR "
}

_mv_arch () {
	ARCH=$2
	CONSOLIDATE=$3

	if [ "x$ARCH" = "xppc" ] ; then ARCH='ppc7400' ; fi

	RES=`lipo $1 -verify_arch $ARCH 2>/dev/null && echo 'ok'`

	if [ "x$RES" != "x" ] ; then
		`lipo $1 -thin $ARCH -output $1.$ARCH.tmp 2>/dev/null && mv $1.$ARCH.tmp $1.$ARCH && rm $1`

		if [ ! -f $1.$ARCH ] ; then mv $1 $1.$ARCH ; fi

		if [ "x$CONSOLIDATE" != "x" ] ; then 
			lipo -create -output $1 $1.i386 $1.ppc7400 $1.x86_64
			rm $1.i386 $1.ppc7400 $1.x86_64
		fi

	fi
}


machug_build_destroot_every_arch () {
	
	CONFIGUREARGS=$1

	OLDCFLAGS=$CFLAGS
	OLDLDFLAGS=$LDFLAGS
	OLDARCHFLAGS=$ARCHFLAGS
	
	ARCH_LIST=($ARCHS)
	ARCH_LEN=${#ARCH_LIST[@]}

	#echo "!!!!!!!!!!!!!!! $ARCH_LIST !!!!!!!!!!!!!!!! $ARCH_LEN  !!!!!!!!!!!!!!!!!!!";

	((ARCH_LEN--))

	for (( i=0; i<=${ARCH_LEN}; i++ )) ; do
		
		ARCH=${ARCH_LIST[$i]}

		ARCHFLAGS="-arch ${ARCH}"
		BUILDHOST="--build=${ARCH}-apple-darwin --host=${ARCH}-apple-darwin"
		if [ "x$ARCH" = "xppc7400" ] ; then BUILDHOST="--build=powerpc-apple-darwin --host=powerpc-apple-darwin" ; fi

		CFLAGS="$ARCHFLAGS -O3"
		LDFLAGS=$ARCHFLAGS
	
		echo ">>> arch: $ARCH"
		
		machug_build_destroot "$CONFIGUREARGS $BUILDHOST"
		
		CONSOLIDATE=''

		if [ "x$i" = "x$ARCH_LEN" ] ; then
			echo ">>> consolidation of universal binaries"
			CONSOLIDATE=1
		fi
		
		for BINARY in `find "$DESTPREFIX" -type f -print` ; do
			_mv_arch $BINARY $ARCH $CONSOLIDATE
		done


	done

	CFLAGS=$OLDCFLAGS
	LDFLAGS=$OLDLDFLAGS
	ARCHFLAGS=$OLDARCHFLAGS

}


machug_build_destroot () {
	SRC_PACK=$NAME
	#unzip -t jasper-1.900.1.zip | head -n 2 | tail -n 1
	CONF_FLAGS=$1

	BEFORE_CONFIGURE=$2
	
	cd src

	SRC_ARCHIVE=`ls -1 $SRC_PACK*{zip,tar.bz2,tar.gz} 2>/dev/null | sort -g | tail -n 1`
	
	SRC_PATH=''

	echo '>>> building' $SRC_PACK from $SRC_ARCHIVE destdir $DESTDIR
	
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
	
	echo ">>> unpacking into: $SRC_PATH"

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
	
	if [ "x$CONFIGURE_CMD" = "x" ] ; then
		CONFIGURE_CMD="./configure $CONF_FLAGS"
	fi

	if [ "x$MAKE_CMD" = "x" ] ; then
		MAKE_CMD="make -j4"
	fi

	if [ "x$MAKE_INSTALL_CMD" = "x" ] ; then
		MAKE_INSTALL_CMD="sudo make -j4 $INSTALLDIRS install"
	fi


#	./configure --quiet $CONF_FLAGS && \
#		make -j3 2>1 1>"$PWDDD/log/build_$SRC_PACK" && \
#		sudo make -j3 $INSTALLDIRS install 2>1 1>"$PWDDD/log/install_$SRC_PACK"
	`$BEFORE_CONFIGURE`
	CURRENT_STATUS=''
	BUILD_STAGE='configure'
	echo ">>> configure" && $CONFIGURE_CMD &>$PWDDD/log/configure_$SRC_PACK && export CURRENT_STATUS='ok'
	
	_check_status
	
	#if [ -f $PWDDD/patches/$SRC_PACK-make.patch ] ; then echo ">>> patching before build"; \
	#	patch -p0 <$PWDDD/patches/$SRC_PACK-make.patch; fi && \

	echo ">>> build" && export BUILD_STAGE='build' && $MAKE_CMD &>$PWDDD/log/build_$SRC_PACK && export CURRENT_STATUS='ok'
	
	_check_status

	echo ">>> destroot" && export BUILD_STAGE='destroot' && $MAKE_INSTALL_CMD &>$PWDDD/log/destroot_$SRC_PACK && \
	export CURRENT_STATUS='ok'
	
	_check_status

	echo ">>> build ok"

	cd $PWDDD
}



_check_status () {
	if [ "x$CURRENT_STATUS" != "xok" ] ; then
		echo "!!! $BUILD_STAGE failed. additional information at log/${BUILD_STAGE}_$SRC_PACK"
		cd $PWDDD
		exit
	fi
	CURRENT_STATUS=''
}


USR_PREFIX="--sysconfdir=/private/etc --localstatedir=/private/var --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man"
