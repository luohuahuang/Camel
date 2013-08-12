use strict;
use camelcgi;

my $cgiinst = camelcgi->new(PARAMS => $ARGV[0]);
my $time = time();
my $test = "Please click submit button";
if ($cgiinst->{test}){
	$test = "Succeed";
}

print <<END_HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Auth - Update Page</title>
<style type="text/css">
img {border: none;}
</style>
</head>
<body>
<p>*** Auth - Update Page - It is a simple page to demonstrate the Authentication ***</p>
<p>You are going to update something - If you can see this page, that means prvs is working!</p>
<p>time: $time</p>
<p>Username: $cgiinst->{username} | password: $cgiinst->{password}</p>
<form action="/firstapp/auth_update.pl" method="post">
<p>Result: $test </p>
<p><input type="text" name="test" value=""></p>
<p><input type="hidden" name="username" value="$cgiinst->{username}"></p>
<p><input type="hidden" name="password" value="$cgiinst->{password}"></p>
<p><input type="submit" name="Submit" value="Submit" /></p>
</form>
</body>
</html>
END_HTML
