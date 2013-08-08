use strict;
use Test::More ;
use camellogger;

ok (camellogger::getLogLevel()  eq 2, 'camellogger can retrieve log level properly');
like (camellogger::createLogFile(), qr/camel\.\d{14}\.log/, 'camellogger can create a log file properly');
like (camellogger::getLogFilename(), qr/camel\.\d{14}\.log/, 'camellogger can create a log file properly');
is(camellogger::logger(0, '$0 - I am Camel'), 0, 'camellogger can log an event properly');
done_testing();

