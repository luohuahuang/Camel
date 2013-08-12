use strict;
use camelcgi;

my $cgiinst = camelcgi->new(PARAMS => $ARGV[0]);

print "Set-Cookie:  reqid=123;domain=localhost:8080;expires=Fri, 04-Jan-2020 12:00:00 GMT\n";
print <<END_HTML;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>File Upload Application</title>
<style type="text/css">
img {border: none;}
</style>
</head>
<body>
<p>*** It is a simple page to demonstrate the CGI form submission ***</p>
<form action="/firstapp/form.pl" method="post" enctype="multipart/form-data">
<a>Choose Database:&nbsp;</a>
<select name="dbsid" >
<option value="fx1">fx1</option>
<option value="fx2">fx2</option>
<option value="fx3">fx3</option>
</select>
<p>abcid: $cgiinst->{abcid} | hahaid: $cgiinst->{hahaid}  | appspass: $cgiinst->{appspass} | reqid=$cgiinst->{reqid} </p>
<p>Apps Schema: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="appsschema" value="apps"/></p>
<p>Apps Password: &nbsp;&nbsp;&nbsp;<input type="password" name="appspass" /></p>
<p>System Schema: &nbsp;&nbsp;&nbsp;<input type="text" name="systemschema" value="system"/></p>
<p>System Password: <input type="password" name="systempass" /></p>
<p><input type="submit" name="Submit" value="Submit" /></p>
</body>
</html>
END_HTML
