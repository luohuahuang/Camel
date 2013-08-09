use strict;
use camelcgi;

my $cgiinst = camelcgi->new(PARAMS => $ARGV[0]);

print <<END_HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>Camel Server - Login Form</title>
<style type="text/css">
img {border: none;}
</style>
</head>
<body>
<p>*** Camel Server - Applications Login Portal ***</p>
<p>You are going to $cgiinst->{originaluri}. $cgiinst->{message1}</p>
<form action="$cgiinst->{originaluri}" method="post">
<p>User name: &nbsp;&nbsp;<input type="text" name="username" value="apps"/></p>
<p>Password: &nbsp;&nbsp;&nbsp;&nbsp;<input type="password" name="password" /></p>
<p><input type="submit" name="Submit" value="Submit" /></p>
</form>
</body>
</html>
END_HTML
