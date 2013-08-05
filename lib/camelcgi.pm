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

sub getParams{
	my $s = shift;
	#$s = "hahaid=haha1&abcid=abc2&Submit=submit";
	chomp($s);
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
