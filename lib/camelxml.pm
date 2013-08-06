use strict;
use warnings;

use XML::Simple;

my $ctxfile = "../conf/context.xml";

my $parser = XML::Simple->new();
my $data = $parser->XMLin($ctxfile);

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

#debug();
sub debug{
	print $data->{ServerHost} . "\n";
	print $data->{PortNumber} . "\n";
	print $data->{BaseDir} . "\n";
	print $data->{TemporaryDir} . "\n";
	print $data->{LogDir} . "\n";
	print $data->{DebugLevel} . "\n";
	print $data->{WelcomeList}->{WeclomeFile}->[0] . "\n";
	print $data->{WelcomeList}->{WeclomeFile}->[1] . "\n";
	print $data->{WelcomeList}->{WeclomeFile}->[2] . "\n";
}


