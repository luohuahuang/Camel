package camel;

use strict;
use Socket;  
use Carp;  
use FileHandle;  
use camellogger;
use camelutils;

my $portno = "8080";
my $base_dir = getOSPath("../webapps");  

logger(0, "$0 - Loading Camel Core"); 
logger(2, "$0 - Making, Setting and binding socket");
socket(SERVER, PF_INET, SOCK_STREAM, getprotobyname('tcp')) or die "can't make the socket : $! \n";  
setsockopt(SERVER, SOL_SOCKET, SO_REUSEADDR, 1) or die "can't set socket options : $! \n";  
my $my_addr = sockaddr_in($portno, INADDR_ANY);
bind(SERVER, $my_addr) or die "can't bind to port $portno : $! \n"; 
logger(0, "$0 - Camel is listening on port $portno");
listen(SERVER, SOMAXCONN) or die "can't listen on port $portno : $! \n";   

# autoreaping of zombies
$SIG{CHLD} = 'IGNORE';  
while (1)  
{   
	while (my $newcon = accept(CLIENT, SERVER)){
		logger(0, "$0 - Camel is forking a worker");
		next if my $pid = fork; #parent
		die logger(0, "$0 - Camel can't fork a worker : $!") unless defined $pid;
		close(SERVER);
		
		CLIENT->autoflush(1); 
		my ($portno, $ipaddr) = sockaddr_in($newcon);   
		my $hostname = gethostbyaddr($ipaddr, AF_INET);  			
		logger(0, "$0 - Camel is connecting with $hostname"); 
		my $getinfo = <CLIENT> ;
		chomp($getinfo);
		print "$getinfo";		
		while (<CLIENT>){
			print $_ ;
			if ($_ =~ /^\r/) {
				last;
			}
		}
		my $rsppage = $base_dir . "/" . dispatch(<CLIENT>);
		sleep 10;
		open IN, "< $rsppage" or warn logger(0, "$0 - Camel can't talk with $hostname : $!");      
		while (<IN>)  
		{   
			print CLIENT $_ . "\n";  
		}   
	    close IN;  
		logger(0, "$0 - Goodbye with $hostname"); 
		# child leaves
		exit;
	} continue {
		# parent here
		close(CLIENT); 
	}
}  

sub dispatch{
	my ($info) = @_;
	my ($s, $url) = split(" ",$info);
	$url =~ s/^\s*|\s*$//g;
	$url = substr($url, 1);
	if ($url eq "") {
		$url = "login.html";
	}
	return $url;
}

sub parser{
	
}


1;
