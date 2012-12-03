#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;

my $help;

GetOptions("help|h!" => \$help);

pod2usage(-verbose => 2) if ($help);

# Create bugdata.txt manually and put particular catagory data into it.
open my $bugfile, '<', 'bugdata.txt' or die("Not able to open bugdata.txt $!");
my @buglist;
my ($statusIcon, $package, $description, $status, $comment);

# Extract bugs and description from manual created txt file
while(<$bugfile>) {
	if(/(.*)?(\[(.*)?\s+(.*)?\])\s*(-|\s+)\s*(.*)/) {
		push @buglist, [$2, $4, $6];
	}
}

# Open file to write wiki list data.
open my $wishList, '>', 'wishlist.txt' or die ("Can't create wishlist.txt $!");
print $wishList "{|\n! Status icon !! Package !! Description !! Status !! Comment\n";

# start query using bugzilla-cli
foreach my $element (@buglist) {
	($statusIcon, $package, $description, $status, $comment) = ('','','','','');
	$package = $element->[0];
	$description = $element->[2];
	my $queryPackage = lc($element->[1]);
	my @result = `bugzilla query -s $queryPackage -l $queryPackage`;
	foreach (@result) {
		if(/Review Request/) {
			($status, $comment) = (split / /,$_,2);
		}
	}
	my $budhiResult = `bodhi -L $queryPackage`;
	if($budhiResult) {
		$statusIcon = '{{check}}';
		$status = "{{package|$queryPackage}}";
	}
	print $wishList "|-\n| $statusIcon || $package || $description || $status || $comment\n";
}

print $wishList "|}\n";
close $wishList;

=head1 NAME

bugzilla.pl - This script use for Fedora package wishList clean process.

=head1 SYNOPSIS

bugzilla.pl [options] [arguments]

Options:
	
	-h, --help 
		Get help

=head1 EXAMPLES
	
	Before Executing script you need to create bugdata.txt manually and put a
	particular category data. Data format in the file should be like below.
	
	* [http://pear.php.net/package/MDB2_Driver_mysqli PEAR MDB2_Driver_mysqli] - PEAR mysqli MDB2 driver

=head1 AUTHOR
	
	Written by Praveen Kumar <kumarpraveen [AT] fedoraproject [DOT] org>

=head1 COPYRIGHT
	
	Copyright © 2012 Free Software Foundation, Inc.  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
	       This is free software: you are free to change and redistribute it.  There is NO WARRANTY, to the extent permitted by law.
