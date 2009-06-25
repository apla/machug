#!/usr/bin/perl

use Class::Easy;
use IO::Easy::Dir;

my @dirs = @ARGV;

my $place = IO::Easy::Dir->new ('/opt/ora');

my $types = {
	bin => {
		genezi  => [],
		sqlplus => [],
		'glogin.sql' => 1,
	},
	lib => {
		'libclntsh.dylib.10.1' => [],
		'libnnz10.dylib'       => [],
		'libocci.dylib.10.1'   => [],
		'libociicus.dylib'     => [],
		'libocijdbc10.dylib'   => [],
		'libocijdbc10.jnilib'  => [],
		'libsqlplus.dylib'     => [],
		'libsqlplusic.dylib'   => [],
		'classes12.jar'        => 1,
		'ojdbc14.jar'          => 1,
	},
	'' => {
		BASIC_LITE_README => 1,
		BASIC_README      => 1,
		SQLPLUS_README    => 1,
	},
	
};

sub place_file {
	my $file = shift;
	
	my $lipo = `lipo -info $file 2>&1`;
	my $arch = (split /: /, $lipo, 3)[2];
	chomp $arch;
	
	if ($arch =~ /^i386|x86_64$/) {
		# warn "$file has $arch\n";
	} else {
		$arch = '';
		# warn "$file has no arch\n";
	}
	
	my $processed = 0;
	
	foreach my $dir (keys %$types) {
		next unless exists $types->{$dir}->{$file->name};
		
		$processed = 1;
		
		if (ref $types->{$dir}->{$file->name} eq 'ARRAY') {
			push (@{$types->{$dir}->{$file->name}}, [$arch, $file]);
		} else {
			warn "storing $file\n";
			$place->append ($dir, $file->name)->as_file->store (
				$file->contents
			);
		}
	}
	
	die "$file unprocessed\n"
		unless $processed;
}


foreach (@dirs) {
	my $dir = IO::Easy::Dir->new ($_);
	$dir->scan_tree (sub {
		my $file = shift;
		place_file ($file);
	});
	
}

foreach my $dir (keys %$types) {
	IO::Easy::Dir->new ($place)->append ($dir)->as_dir->create;
	foreach my $file (sort keys %{$types->{$dir}}) {
		next if ref $types->{$dir}->{$file} ne 'ARRAY';
		
		my $file_1 = $types->{$dir}->{$file}->[0]->[1];
		
		# warn "processing $dir/$file\n";
		
		# use Data::Dumper;
		# warn Dumper $types->{$dir}->{$file};
		my $arch = join ' ', map {"-arch $_->[0] $_->[1]"} @{$types->{$dir}->{$file}};

		my $file_name  = $file_1->name; # . ($arch eq '' ? '' : ".$arch");
		my $file_place = $place->append ($dir, $file_name)->as_file;
		
		warn "we place $file_1 to $file_place\n";
		# warn "command: lipo $arch -create -output $file_place\n";
		`lipo $arch -create -output $file_place`;
		
		if ($file_name =~ /(.*)\.10\.1$/) {
			symlink ($file_name, $file_place->updir->append ($1)->path);
		}
	}
}
