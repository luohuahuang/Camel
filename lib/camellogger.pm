package camellogger;

use strict;
use FileHandle;  
use camelutils;
use camelxml;

use Exporter;
our @ISA=('Exporter');
our @EXPORT=('logger');

# for internal development only
my $debug = 0;
sub debugPrint
{
 if ( $debug eq 0 ) {
  print "@_ \n";
 }
}

my $xmlinst = camelxml->new();
my $log_dir = $xmlinst->{LogDir};
my $base_dir = $xmlinst->{BaseDir};
my $debug_level = $xmlinst->{DebugLevel};
# level - 0 - ERROR - Error info 
# level - 1 - INFO - useful info
# level - 2 - Dev - Debug info
sub logger{
	my ($level, $logstr) = @_;
	if ($level le getLogLevel()){
		my $currentlog = getLogFilename();
		my $time = getDate();
		open OUT, ">> $currentlog" or die "can't open log file $currentlog";
		print OUT "$time - $logstr \n";
		close OUT;
		print "$time - $logstr \n";
	} 
	return 0;
}

sub getLogLevel{
	return $debug_level;
}

sub getLogFilename{
	my @files = <$log_dir/*>;
	my $logfilename = pop @files;
	#unless (defined $logfilename){
	#	$logfilename = createLogFile();
	#}
	return $logfilename;
}

sub createLogFile{
	my $date = getDate();
	my $filename = getOSPath("$log_dir" . "/" . "camel." . $date . ".log");
	open OUT, "> $filename" or die "can't create log file $filename $!";
	close OUT;
	return $filename;
}

1;

