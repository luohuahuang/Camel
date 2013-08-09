package camelauth;

use strict;
use camelxml;
use XML::Simple;

use constant UNAUTH	=> "UNAUTH";
use constant WRGACNT	=> "WRGACNT";
use constant NOPRVS	=> "NOPRVS";
use constant AUTH => "AUTH";
use constant PUB => "PUB";



#print authAgent("luhuang","luhuang123","/firstapp/auth_admin.pl");

sub authAgent{
	my ($username, $password, $page) = @_;
	if (camelxml::isPageAuth($page)){
		if($username){
			my $pwd = camelxml::getPasswordByUsername($username);
			if ($pwd){
				if ($pwd eq $password) {
					if (camelxml::getAuthByUsernameAndPage($username, $page)){
						return AUTH;
					} else {
						return NOPRVS;
					}
				} else {
					return WRGACNT;
				}
			} else {
				return WRGACNT;
			}

		} else {
			return UNAUTH;
		}
	} else {
		return PUB;
	}
}

1;
