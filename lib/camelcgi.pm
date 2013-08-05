package camelcgi;

use strict;
use HTTP::Daemon;
use HTTP::Status;
use Carp;  
use FileHandle;  
use camellogger;
use camelutils;

sub new{
	my $classname = shift;
	my $self = {};
	bless($self, $classname);
	$self->_init(@_);
	return $self; 
}

sub _init {
	my $self = shift;
	if (@_) {
		my %extra = @_;
		my $paramstr = $extra{"PARAMS"};# PARAMS is a keyword here
		if (defined $paramstr) {
			my %params = getParams($paramstr);
			@$self{keys %params} = values %params;
		}
	}
}

# check whether form type is "multipart/form-data"
sub parseContent{
	my $paramstr = shift;
	my $pos = index($paramstr, "name=");
	my $replaced = substr($paramstr, 0, $pos);
	my @array = split(/$replaced/, $paramstr);
	my $s = "";
	my $count = 0;
	my $sclr = scalar(@array) - 1;
	foreach my $line (@array){
		if(($count > 0) and ($count < $sclr)){
			$line =~ s/name=//;
			$line =~ s/\s+/=/;
			$line =~ s/^\s*|\s*$//g;
			chomp($line);
			$s .= $line . "\&";
		}
		$count++;
	}
	$s = substr($s,0,length($s)-1);
	return $s;
}

sub getParams{
	my $s = shift;
	#$s = "hahaid=haha1&abcid=abc2&Submit=submit";
	chomp($s);
	if ($s =~ m/form-data/){
		$s = parseContent($s);
	}
	my %params = {};
	my @pairs = split(/\&/,$s); 	
	foreach (@pairs){
		my ($key, $value) = split(/=/,$_);
		$params{$key} = $value;
	}
	return %params;
}

#getParams();

1;
