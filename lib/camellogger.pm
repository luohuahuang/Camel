package camellogger;

use strict;
use FileHandle;  
use camelutils;

use Exporter;
our @ISA=('Exporter');
our @EXPORT=('logger',
'createLogFile');

# for internal development only
my $debug = 0;
sub debugPrint
{
 if ( $debug eq 0 ) {
  print "@_ \n";
 }
}

my $log_dir = getOSPath("../logs");
my $base_dir = getOSPath("../webapps"); 
# level - 0 - ERROR - Error info 
# level - 1 - INFO - useful info
# level - 2 - Dev - Debug info
sub logger{
	my ($level, $logstr) = @_;
	if ($level le getLogLevel()){
		my $currentlog = getLogFilename();
		my $time = getDate();
		open OUT, ">> $currentlog";
		print OUT "$time - $logstr \n";
		close OUT;
	} 
}

sub getLogLevel{
	return 2;
}

sub getLogFilename{
	my @files = <$log_dir/*>;
	my $logfilename = pop @files;
	return $logfilename;
}

sub createLogFile{
	my $date = getDate();
	my $filename = getOSPath("$log_dir" . "/" . "camel." . $date . ".log");
	logger(2,"creating log file $filename");
	open OUT, "> $filename" or die "can't create log file $filename $!";
	close OUT;
}

1;

