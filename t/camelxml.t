use strict;
use Test::More tests=>7;
use camelxml;

my $xmlinst = camelxml->new();
my $base_dir = $xmlinst->{BaseDir};

ok ($xmlinst->{ServerHost}  eq 'localhost', 'xml engine could retrieve ServerHost properly');
ok ($xmlinst->{PortNumber} eq '8080', 'xml engine could retrieve PortNumber properly');
ok ($xmlinst->{BaseDir} eq '../webapps', 'xml engine could retrieve BaseDir properly');
ok ($xmlinst->{LogDir} eq '../logs', 'xml engine could retrieve LogDir properly');
ok ($xmlinst->{TemporaryDir} eq '../temp', 'xml engine could retrieve TemporaryDir properly');
ok ($xmlinst->{DebugLevel} eq 2, 'xml engine could retrieve DebugLevel properly');

ok ($xmlinst->{WelcomeFile2} eq 'welcome.html', 'xml engine could retrieve WelcomeFile2 properly');

