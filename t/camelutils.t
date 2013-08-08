use strict;
use Test::More ;
use camelutils;

ok (defined(camelutils::loadUri()), 'camelutils can load URI properly');
like (camelutils::getDate(), qr/\d{14}/, 'camelutils can generate a date timestamp properly');
like (camelutils::getRand(), qr/\d{1,4}/, 'camelutils can create a rand number properly');
done_testing();

