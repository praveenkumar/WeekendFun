#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use LWP::Simple;
use JSON;
use JSON -support_by_pp;

my ($movieID, $movieTitle, $movieYear, $dataType, $plot, $tomatoes, $help, $url);

my %options = ( movieID 	=> \$movieID,
				movieTitle 	=> \$movieTitle,
				movieYear 	=> \$movieYear,
				plot 		=> \$plot,
				tomatoes 	=> \$tomatoes,
				help		=> \$help, 
			  );

GetOptions(\%options, 'movieID|i:s','movieTitle|t:s', 
						'movieYear|y:i', 'plot|p:s',
						'help|h!','tomatoes|m!') or pod2usage(2);

pod2usage(-verbose => 2) if ($help);

pod2usage(2) unless ($movieID or $movieTitle);

$url = 'http://www.omdbapi.com/?';

$url .= "i=${movieID}&" 	if($movieID);
$url .= "t=${movieTitle}&"  if($movieTitle);
$url .= "y=${movieYear}&" 	if($movieYear);
$url .= "plot=${plot}&" 	if($plot);
$url .= "tomatoes=true&"	if($tomatoes);

my $content = get($url);
my $imdbData = from_json($content);

if($imdbData->{Response} eq 'true') {
	foreach my $data (keys %{$imdbData}) {
		next if($data eq "Response");
		print "$data => $imdbData->{$data}\n";
	}
}
else {
	print "You provided wrong Movie ID or Title, Please verify once again\n\n";
	pod2usage(2);
}

=head1 NAME

imdb.pl - This script uses OMDB API(www.omdbapi.com) to fetch data from IMDB

=head1 SYNOPSIS

imdb.pl [options] [arguments]

movieID or movieTitle is required

Options:
	
	-help brief help message
	
	-i, --movieID 	
		string (optional) 	A valid IMDb movie id
	
	-t, --movieTitle
		string (optional) 	Valid title of a movie to search for

	-y, --year 	
		Integer (optional) 	year of the movie

	-p, --plot 	
		(short, full)   short or extended plot (short default)

	-m, --tomatoes 	
		(optional) 	Adds rotten tomatoes data

=head1 EXAMPLES
	
	./imdb.pl -i tt1403865

	./imdb.pl -t "Dark Knight Rises"

	./imdb.pl -t tt1403865 -p full -m
		Show you full plot and also rotton tomatoes data

=head1 AUTHOR
	
	Written by Praveen Kumar <kumarpraveen [AT] fedoraproject [DOT] org>
