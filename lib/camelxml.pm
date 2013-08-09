package camelxml;

use strict;

use XML::Simple;

use constant AUTH => "AUTH";

# This path must be a hard coded.
my $ctxfile = "/home/luhuang/workspace/Camel/conf/context.xml";
my $ctx_parser = XML::Simple->new();
my $ctx_data = $ctx_parser->XMLin($ctxfile);

my $authfile = "/home/luhuang/workspace/Camel/conf/auth.xml";
my $auth_parser = XML::Simple->new();
my $auth_data = $auth_parser->XMLin($authfile);

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
		$config{$key} = $ctx_data->{$key};
	}
	my $count = 1;
	for (@{ $ctx_data->{WelcomeList}->{WeclomeFile} }) {
		my $id = "WelcomeFile" . $count++;
    	$config{$id} = $_;
	}
	return %config;
}

sub getPasswordByUsername{
	my $username = shift;
	for(@{$auth_data->{user}}){
		if($_->{username} eq $username) {
			return $_->{password};
		}
	}
	return undef;
}

sub getRolesByUsername{
	my $username = shift;
	for(@{$auth_data->{user}}){
		if($_->{username} eq $username) {
			return $_->{roles};
		}
	}
	return undef;
}

sub isPageAuth{
	my $path = shift;
	my %auth;
	for(@{ $auth_data->{pagecontrol}->{page} }){
		if($_->{path} eq $path) {
			$auth{"roles"} = $_->{roles};
			$auth{"users"} = $_->{users};
			return %auth;
		}
	}
	return undef;
}

sub getAuthByUsernameAndPage{
	my ($username, $path) = @_;
	my %seen = isPageAuth($path);
	if (%seen){
		if ($seen{"users"}){
			my @user = split(/,/,$seen{"users"});
			foreach my $user (@user) {
				$user =~ s/^\s*|\s$//g;
				if ($user eq $username) {
					return AUTH;
				}
			}
		} 
		if (my $roles = getRolesByUsername($username)) {
			my @role = split(',', $roles);
			foreach my $r (@role) {
				$r =~ s/^\s*|\s$//g;
				if ($seen{"roles"}) {
					my @karray = split(/,/,$seen{"roles"});
					foreach my $k (@karray){
						$k =~ s/^\s*|\s$//g;
						if ($k eq $r){
							return AUTH;
						}
					}
				}
			}
		}
		
	} else {
		return AUTH; #it is a public page
	}
	return undef;
}

1;
