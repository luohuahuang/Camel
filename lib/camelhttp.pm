package camelhttp;

use strict;
use HTTP::Daemon;
use HTTP::Status;
use Carp;  
use FileHandle;  
use camellogger;
use camelutils;
use camelxml;
use camelauth;
use camelcgi;

use constant UNAUTH	=> "UNAUTH";
use constant WRGACNT	=> "WRGACNT";
use constant NOPRVS	=> "NOPRVS";
use constant AUTH => "AUTH";
use constant PUB => "PUB";

my %AUTHHASH = {};
$AUTHHASH{UNAUTH} = "Unauthorized. Log on firstly";
$AUTHHASH{WRGACNT} = "User credential is wrong";
$AUTHHASH{NOPRVS} = "You have no privilege. Check with your system administrator";

sub new{
	my $classname = shift;
	my $self = {};
	bless($self, $classname);
	return $self; 
}

my $xmlinst = camelxml->new();

my $portno = $xmlinst->{PortNumber};
my $base_dir = $xmlinst->{BaseDir};
my $temp_dir = $xmlinst->{TemporaryDir};
my $host = $xmlinst->{ServerHost};
my $logpath = camellogger::getLogFilename();
my $manager_login = $base_dir . "/manager/page/login_portal.pl";

camellogger::createLogFile();
camelutils::loadUri();

logger(0, "$0 - Camel is starting - Logging in $logpath");
my $SERVER = HTTP::Daemon->new(LocalPort => $portno, LocalAddr => $host) or die; 
logger(0, "$0 - Camel is listening at host: $host, port: $portno");

camelHttpCore();

END{
	#_destroy();
}

sub camelHttpCore{  
	
	# autoreaping of zombies. Has to comment out that or the child process could not run perl command
	#$SIG{CHLD} = 'IGNORE';  
	while (1)  
	{   
		while (my $con = $SERVER->accept){
			logger(0, "$0 - Camel is forking a worker");
			next if my $pid = fork; #parent
			die logger(0, "$0 - Camel can't fork a worker : $!") unless defined $pid;
			while (my $req = $con->get_request){
				my $path = $base_dir . $req->uri->path;
				#_getRequestInfo($req);
				logger(0, "$0 - Camel is working for $path ");
				if (_getFile($path) eq "YES"){		
					my %params = camelcgi::getParams($req->content);	
					my $auth = camelauth::authAgent($params{username}, $params{password}, $req->uri->path);
					logger(0, "$0 - $params{username} $params{password} " . $req->uri->path . "- $auth");
					if (($auth eq UNAUTH) or ($auth eq WRGACNT) or ($auth eq NOPRVS)) {
						$req->method("GET");
						#my $params = "originaluri=" . $req->uri->path . "\&" . "message=" . $AUTHHASH{$auth};
						my $params = "originaluri=" . $req->uri->path;
						my $path = $manager_login;
						my $result = `perl $path "$params"` or die "can't execute $path : $!";
						my $tmpfile = $temp_dir . "/" . camelutils::getDate() . "_" . camelutils::getRand() . ".html";
						open OUT, "> $tmpfile" or $con->send_error(RC_INTERNAL_SERVER_ERROR);
						print OUT $result;
						close OUT;
						$con->send_file_response("$tmpfile");
						undef($result);
						system("rm -fr $tmpfile");
					} else {
						if (($req->method eq 'POST') or ($path =~ m/\.pl$/)) {
						my $params = $req->content;
						unless($params =~ m/\S+/){
							$params = $req->uri->query;
						}
						chomp($params);
						$req->method("GET");
						my $result = `perl $path "$params"` or die "can't execute $path : $!";
						my $tmpfile = $temp_dir . "/" . camelutils::getDate() . "_" . camelutils::getRand() . ".html";
						open OUT, "> $tmpfile" or $con->send_error(RC_INTERNAL_SERVER_ERROR);
						print OUT $result;
						close OUT;
						$con->send_file_response("$tmpfile");
						undef($result);
						system("rm -fr $tmpfile");
						} elsif ($req->method eq 'GET'){
							$con->send_file_response("$path");
						} elsif ($req->method eq 'HEAD'){
							# by deafult, HTTP/1.1 200 OK
							$con->send_basic_header;
						}else {
							$con->send_error(RC_FORBIDDEN);
						}	
					}
					
				} elsif ($req->method ne 'HEAD') {
					logger(0, "$0 - Oops, broken request - $path");
					my $wlcpage = _getWelcomePage($req->uri->path);
					if (defined $wlcpage) {
						logger(0, "$0 - Oops, sending welcome page $wlcpage");
						$req->method("GET");
						$con->send_redirect("$wlcpage");
					} else {
						$con->send_error(RC_NOT_FOUND);
					}
				}
				logger(0, "$0 - Camel has done request of $path ");
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

sub _getWelcomePage{
	my $path = shift;
	my ($t,$appsname) = split(/\//,$path);
	my $s = "WelcomeFile";
	my $count = 1;
	while(my $w = $xmlinst->{"WelcomeFile" . $count}){
		if($xmlinst->{"WelcomeFile" . $count}){
			my $p = "$base_dir" . "/" . $appsname . "/" . $w;
			if (_getFile($p) eq "YES"){
				return "/" . $appsname . "/" . $w;
			}
		}
		$count++;
	}	
	return undef;
}

sub _destroy {
	logger(0, "$0 - Camel is destroying itself");
	close ($SERVER) if (defined $SERVER);
	undef $SERVER;
}

sub _getRequestInfo{
	my $req = shift;
	print "=============================================== \n";
	print "uri: \n" . $req->uri . "\n";
	print "content: \n" . $req->content . "\n";
	print "parameters via  url: \n" . $req->uri->query . "\n";
	print "as_string: \n" . $req->as_string . "\n";
	print "=============================================== \n";
}


1;
