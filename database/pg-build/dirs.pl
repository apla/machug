#!/usr/bin/perl

use strict;

my $param_prefix = $ARGV[0];
my $inst_prefix  = $ARGV[1];
my $prefix       = $ARGV[2];
my $name         = $ARGV[3];

my $params = {
	prefix => "$inst_prefix$prefix",
	exec_prefix => "$inst_prefix$prefix",
	bindir => "$inst_prefix$prefix/bin",
	sbindir => "$inst_prefix$prefix/sbin",
	sysconfdir => "$inst_prefix/private/etc",
	datadir => "$inst_prefix$prefix/share/$name",
	includedir => "$inst_prefix$prefix/include",
	libdir => "$inst_prefix$prefix/lib",
	libexecdir => "$inst_prefix$prefix/libexec",
	localstatedir => "$inst_prefix/private/var",
	sharedstatedir => "$inst_prefix$prefix/com",
	mandir => "$inst_prefix$prefix/share/man",
	infodir => "$inst_prefix$prefix/share/info",
};

my $result = [];

foreach my $k (keys %$params) {
	my $v = $params->{$k};
	$k =~ s/_/-/
		if $k =~ /exec_prefix/ and $param_prefix eq '--';
	push @$result, "$param_prefix$k=$v";
}

print join ' ', @$result, "\n";

exit;

