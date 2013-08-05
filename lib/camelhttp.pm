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
my $temp_dir = "../temp";
my $SERVER = HTTP::Daemon->new(LocalPort => $portno, LocalAddr => 'localhost') or die; 
loader();
camelHttpCore();

END{
	_destroy();
}

sub camelHttpCore{  
	
	# autoreaping of zombies
	#$SIG{CHLD} = 'IGNORE';  
	while (1)  
	{   
		while (my $con = $SERVER->accept){
			logger(0, "$0 - Camel is forking a worker");
			next if my $pid = fork; #parent
			die logger(0, "$0 - Camel can't fork a worker : $!") unless defined $pid;
			while (my $req = $con->get_request){
				my $path = $base_dir . $req->uri->path;
				_getRequestInfo($req);
				logger(0, "$0 - Camel is working for - GET $path ");
				if (_getFile($path) eq "YES"){		
					if ($req->method eq 'GET'){
						logger(0, "$0 - Retrieving $path");
						$con->send_file_response("$path");
					} elsif ($req->method eq 'POST') {
						my $params = $req->content;
						chomp($params);
						$req->method("GET");
						logger(0, "$0 - Executing $path");
						my $result = `perl $path "$params"` or die "can't execute $path : $!";
						my $tmpfile = $temp_dir . "/" . camelutils::getDate() . "_" . camelutils::getRand() . ".html";
						open OUT, "> $tmpfile" or $con->send_error(RC_INTERNAL_SERVER_ERROR);;
						print OUT $result;
						close OUT;
						$con->send_file_response("$tmpfile");
						system("rm -fr $tmpfile");
						
					} else {
						$con->send_error(RC_FORBIDDEN);
					}
				} else {
					logger(0, "$0 - Oops, broken request - $path");
					$con->send_error(RC_NOT_FOUND);
				}
			}
			close($con); 
			exit;
		} continue {
			# nothing here so far.
		}
	}  	
}

sub _getFile{
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

sub _getRequestInfo{
	my $req = shift;
	print "uri: \n" . $req->uri . "\n";
	print "content: \n" . $req->content . "\n";
	print "as_string: \n" . $req->as_string . "\n";
}


1;
