#!/bin/bash

. ../common/init.sh

PREFIX=/usr
NAME=mysql

rm -rf $INSTPREFIX/$NAME

PWDDD=`pwd`

mkdir $PWDDD/log

install_dirs "/$NAME"

DESTROOT="$INSTPREFIX/$NAME$PREFIX"

configure_build_destroot mysql \
	"$USR_PREFIX \
	--with-ssl=/usr \
	--with-zlib-dir=/usr \
	--with-charset=utf8 \
	--with-extra-charsets=all \
	--enable-assembler \
	--enable-profiling \
	--with-unix-socket-path=/private/tmp/mysql.sock \
	--enable-thread-safe-client \
	--with-plugins=all \
	--with-mysqld-user=_mysql \
	--without-debug \
	--localstatedir=/private/var/mysql \
	--disable-dependency-tracking"


mv "$DESTROOT/mysql-test" "$DESTROOT/share/mysql-test"
mv "$DESTROOT/sql-bench" "$DESTROOT/share/sql-bench"

chown root:wheel "$DESTROOT"

mkdir -p $INSTPREFIX/$NAME/Library/LaunchDaemons
mkdir -p $INSTPREFIX/$NAME/etc

cat > $INSTPREFIX/$NAME/Library/LaunchDaemons/com.mysql.mysqld.plist <<InputComesFromHERE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.mysql.mysqld</string>
	<key>OnDemand</key>
	<false/>
	<key>RunAtLoad</key>
	<true/>
	<key>UserName</key>
	<string>_mysql</string>
	<key>WorkingDirectory</key>
	<string>/usr</string>
	<key>ProgramArguments</key>
	<array>
		<string>/usr/bin/mysqld_safe</string>
	</array>
	<key>SoftResourceLimits</key>
	<dict>
		<key>NumberOfFiles</key>
		<integer>65536</integer>
	</dict>
	<key>HardResourceLimits</key>
	<dict>
		<key>NumberOfFiles</key>
		<integer>65536</integer>
	</dict>
	
	<key>ServiceDescription</key>
	<string>Mysql 5.1 Database Server</string>
</dict>
</plist>
InputComesFromHERE

cat > $INSTPREFIX/$NAME/etc/my.cnf <<InputComesFromHERE
# Example MySQL config file for large systems.
#
# This is for a large system with memory = 512M where the system runs mainly
# MySQL.
#
# You can copy this file to
# /etc/my.cnf to set global options,
# mysql-data-dir/my.cnf to set server-specific options (in this
# installation this directory is /private/var/mysql) or
# ~/.my.cnf to set user-specific options.
#
# In this file, you can use all long options that a program supports.
# If you want to know which options a program supports, run the program
# with the "--help" option.

# The following options will be passed to all MySQL clients
[client]
#password	= your_password
port		= 3306
socket		= /tmp/mysql.sock


[mysqld]

#general_log = 1
#general_log_file = '/var/log/mysql/query.log'

log-error=/var/log/mysql/error.log

slow_query_log = 1
slow_query_log_file=/var/log/mysql/slow.log

port            = 3306
socket          = /tmp/mysql.sock
skip-locking

key_buffer = 128M
max_allowed_packet = 1M
table_cache = 256
sort_buffer_size = 1M
read_buffer_size = 1M
read_rnd_buffer_size = 4M
myisam_sort_buffer_size = 64M
thread_cache_size = 8
query_cache_size= 16M
# Try number of CPU's*2 for thread_concurrency
thread_concurrency = 8

# Don't listen on a TCP/IP port at all. This can be a security enhancement,
# if all processes that need to connect to mysqld run on the same host.
# All interaction with mysqld must be made via Unix sockets or named pipes.
# Note that using this option without enabling named pipes on Windows
# (via the "enable-named-pipe" option) will render mysqld useless!
# 
#skip-networking

# Disable Federated by default
skip-federated

# Uncomment the following if you are using InnoDB tables
#innodb_data_home_dir = /private/var/mysql/
#innodb_data_file_path = ibdata1:10M:autoextend
#innodb_log_group_home_dir = /private/var/mysql/
#innodb_log_arch_dir = /private/var/mysql/
# You can set .._buffer_pool_size up to 50 - 80 %
# of RAM but beware of setting memory usage too high
#innodb_buffer_pool_size = 256M
#innodb_additional_mem_pool_size = 20M
# Set .._log_file_size to 25 % of buffer pool size
#innodb_log_file_size = 64M
#innodb_log_buffer_size = 8M
#innodb_flush_log_at_trx_commit = 1
#innodb_lock_wait_timeout = 50

[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash
# Remove the next comment character if you are not familiar with SQL
#safe-updates

[isamchk]
key_buffer = 128M
sort_buffer_size = 128M
read_buffer = 2M
write_buffer = 2M

[myisamchk]
key_buffer = 128M
sort_buffer_size = 128M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout

InputComesFromHERE

cd $PWDDD

/Developer/usr/bin/packagemaker --doc mysql-5.1.pmdoc --out ../mysql-5.1.34.pkg
