package camelutils;

use File::Spec::Functions;
use File::stat;
use File::Path;
use File::Copy;
use File::Basename;
use Time::localtime;
use Config;

use Exporter;
our @ISA=('Exporter');
our @EXPORT=('getOSPath',
'getRand',
'getDate',
'loader',
'%fshash');

my $base_dir = getOSPath("../webapps"); 

sub getOSPath {
	my ($path) = @_;
	
		if ($^O =~ m/MS/) {
			$path =~ s|/|\\|g;
		}
	
	return $path;
}

sub getDate {
    my $tm = localtime;
    my ($year, $month, $day) = ($tm->year+1900, ($tm->mon)+1, $tm->mday);
    my ($hour, $min, $sec) = ($tm->hour, $tm->min, $tm->sec);

    my $date = sprintf("%4s-%2s-%2s", ${year},${month}, ${day});
    my $time = sprintf("[%2s:%2s:%2s]", ${hour}, ${min}, ${sec});
    my $date_time = sprintf("%4s%2s%2s%2s%2s%2s", ${year},${month}, ${day}, ${hour}, ${min}, ${sec});

    $date =~ s/ /0/g;
    $time =~ s/ /0/g;
    $date_time =~ s/ /0/g;

    return $date_time;
}

sub getRand {
	my $range = 1000;
	return int(rand($range));
}

sub loader{
	my @files = `find $base_dir -type f -print`;
	chomp (@files);
	foreach (@files){
		$fshash{$_}++;
	}
	return %fshash;
}


1;

