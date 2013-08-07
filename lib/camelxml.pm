package camelxml;

use strict;
use warnings;

use XML::Simple;

# This path must be a hard coded.
my $ctxfile = "../conf/context.xml";
my $parser = XML::Simple->new();
my $data = $parser->XMLin($ctxfile);

sub new{
	my $classname = shift;
	my $self = {};
	bless($self, $classname);
	
	$self->_init(readConfig());
	return $self; 
}

sub _init {
	my $self = shift;
	if (@_) {
		my %extra = @_;
		@$self{keys %extra} = values %extra;
	}
}

sub readConfig{
	my %config;
	my @element = qw(ServerHost PortNumber BaseDir TemporaryDir LogDir DebugLevel);
	foreach my $key (@element){
		$config{$key} = $data->{$key};
	}
	my $count = 1;
	for (@{ $data->{WelcomeList}->{WeclomeFile} }) {
		my $id = "WelcomeFile" . $count++;
    	$config{$id} = $_;
	}
	return %config;
}

1;
