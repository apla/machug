#!/bin/bash

DSCL='sudo dscl . '

MAX_GID=`$DSCL -list /Groups PrimaryGroupID | cut -c 32-34 | sort -g | tail -n 1`
let MAX_GID++

# echo $MAX_GID

MAX_UID=`$DSCL -list /Users UniqueID | cut -c 20-22 | sort -g | tail -n 1`
let MAX_UID++

# echo $MAX_UID
PG_NAMES=(postgres postgresql pgsql)

for NAME in "postgres" "postgresql" "pgsql" ; do 
	PGID=`id $NAME`
	RETCODE=$?
	
	echo $RETCODE
	if [ $RETCODE -eq 0 ] ; then
		echo $NAME;
		exit;
	fi
done

PG='postgres'

PLACE="/Groups/_$PG"

$DSCL -create $PLACE
$DSCL -create $PLACE PrimaryGroupID $MAX_GID
$DSCL -append $PLACE RecordName $PG
#$DSCL -append $PLACE RecordName _$PG

PLACE="/Users/_$PG"

$DSCL -create $PLACE
$DSCL -create $PLACE UniqueID $MAX_UID
$DSCL -create $PLACE PrimaryGroupID $MAX_GID
$DSCL -create $PLACE UserShell /usr/bin/false
$DSCL -create $PLACE RealName "PostgreSQL Server"
#$ sudo dscl . -create /Users/_postgres NFSHomeDirectory /usr/local/pgsql
$DSCL -append $PLACE RecordName $PG
#$DSCL -append $PLACE RecordName _postgres
