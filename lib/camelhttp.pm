package camelhttp;

use strict;
use HTTP::Daemon;
use HTTP::Status;
use Carp;  
use FileHandle;  
use camellogger;
use camelutils;

my $portno = "8080";
my $base_dir = "../webapps";
my $SERVER = HTTP::Daemon->new(LocalPort => $portno, LocalAddr => 'localhost') or die; 
loader();
camelHttpCore();

END{
	_destroy();
}

sub camelHttpCore{  
	
	# autoreaping of zombies
	$SIG{CHLD} = 'IGNORE';  
	while (1)  
	{   
		while (my $con = $SERVER->accept){
			logger(0, "$0 - Camel is forking a worker");
			next if my $pid = fork; #parent
			die logger(0, "$0 - Camel can't fork a worker : $!") unless defined $pid;
			while (my $req = $con->get_request){

				my $path = $base_dir . $req->uri->path;
				if ($req->method eq 'GET'){
					if (_handleGet($path) eq "YES"){
						$con->send_file_response("$path");
					} else {
						$con->send_error(RC_NOT_FOUND);
					}
					
				} elsif ($req->method eq 'POST') {
					$con->send_error(RC_FORBIDDEN);
				}
			}
			close($con); 
			exit;
		} continue {
			# nothing here so far.
		}
	}  	
}

sub _handleGet{
	my ($path) = @_;
	if ($fshash{"$path"}){
		return "YES";
	} else {
		return "NO";
	}
}

sub _destroy {
	logger(0, "$0 - Camel is destroying itself");
	close ($SERVER) if (defined $SERVER);
}


1;
