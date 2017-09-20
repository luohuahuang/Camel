# Camel Server – a Pure Perl Web Server
Camel  v.1.0 - Aug 12th 2013

Table of Contents
* Preface
* License
* Release note
* Architecture & Technology
* Configuration of Server/CGI/Authentication
* When all else fails

## Preface
This file is meant to be a primer for the release note, initial installation and configuration of the Light Weight Perl Web Server (referred to as Camel) project.  

## License
Copyright (C) 2013 HUANG, LUOHUA

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

######It would be nice to share your changes/thought about Camel Server with me.

## Release note
This is the first version of Camel Server. It includes the following features.
* Support HTTP GET/POST/HEAD methods.
* Support multi-processes.
* Support any static text pages.
* Support PERL files execution.
* Support default pages.
* Support Form & CGI parameters.
* Support XML configuration.
* Support Authentication & Session management page per page.
* Certified by Perl Testing framework (of course it is not bug-free!)

System Requirements
* The Camel Server is developed under ‘perl 5, version 16, subversion 3 (v5.16.3) built for i686-linux-thread-multi’ on Ubuntu 11.10-i686. It is not applicable to any MSWin platforms.

Installation
* Download and unzip https://github.com/luohuahuang/Camel/archive/master.zip under an empty directory (Supposed here the .zip file is extracted under /u01/).
* Go to directory /u01/Camel/bin. Edit startup.sh with your favorite editor. Change following line

```
From-
PERL5LIB=/home/luhuang/workspace/Camel/lib
To-
PERL5LIB=/u01/Camel/lib
```
* Add your Perl path into $PATH. Ensure you can issue command ‘perl –v’ from a fresh session.
* Verify your installation. If you see similar information as following, it means Camel is working!

```
luhuang@luhuang-VirtualBox:~/workspace/Camel/bin$ sh startup.sh 
20130812225811 - Camel.pl - Camel is starting - Logging in ../logs/camel.20130812225740.log 
20130812225811 - Camel.pl - Camel is listening at host: localhost, port: 8080
```
## Architecure & Technology
The architecure of this server is very straight forward. It has similar file system layout as Apache Tomcat (Hats off to Tomcat!). You can refer to below links for your interested topics.

* Introduction: http://luohuahuang.org/2013/08/12/camel-a-pure-perl-web-server/  
* Socket: http://luohuahuang.org/2013/08/04/perl-in-socket/ 
* HTTP::Daemon: http://luohuahuang.org/2013/08/05/httpdaemon-in-perl/ 
* CGI Engine: http://luohuahuang.org/2013/08/05/tricky-way-to-instantiate-a-class-in-perl/ 
* Form: http://luohuahuang.org/2013/08/06/form-content-enctype/ 
* XML Engine: http://luohuahuang.org/2013/08/07/parsing-xml-in-perl/ 
* Testing: http://luohuahuang.org/2013/08/08/perl-testing/ 
* Authentication: http://luohuahuang.org/2013/08/12/auth-mechanism-in-camel/ 

## Configuration
The section outlines the configuration options that are available in this server.
#### Server
This server runs upon configuration file Camel/conf/context.xml. In this .xml file, you can configure its server host, port number, base dir, temporary dir, debug level, and default pages.

Please note: 

```
All of the paths specified in context.xml should be a relative path to conf/. 
You need to restart the server if you change its server host or port number.
```
#### CGI
Camel supports forms submission, CGI parameters. For example, supposed your request is a form and it has two parameters (username, password), you can retrieve them with following snippet.

```
use camelcgi;
my $cgiinst = camelcgi->new(PARAMS => $ARGV[0]);
	my $username = $cgiinst->{username};
	my $password = $cgiiinst->{password};
```

#### Authentication
Camel Server does page per page authentication. Its authentication mechanism works upon Camel/conf/auth.xml. The setup is simple. In the auth.xml, you can edit it with your accounts, roles, and pages which require privilege control.
For example, 
* If you want to add user homersimpon/doevilpwd and grant it with access to page /firstapp/doevil.pl. You can add below snippet. Then Camel server will be smart enough to take care of the privilege for you.

```
<user username=" homersimpon " password="doevilpwd"/>
 <page path="/firstapp/doevil.pl ">
        	<users> homersimpon </users>
 </page>
```

* If you have not yet logged on, it will redirect you to page Camel/webapps/manager/page/login_portal.pl and you can input credential information there. ASA your account is verified, it will redirect back to your page.
* If you want to transfer your login information to other pages from your current forms/pages, you can add below snippet into your .pl file.

```
use camelcgi;
my $cgiinst = camelcgi->new(PARAMS => $ARGV[0]);
…
<form …>
<p><input type="hidden" name="username" value="$cgiinst->{username}"></p>
<p><input type="hidden" name="password" value="$cgiinst->{password}"></p>
</form>
```	
Please note: 
```
currently authentication supports .pl extension only.
```
## When all else fails
You can reach me at
Email: luohua.huang@gmail.com
Blog: http://luohuahuang.org 

  

