; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(plan done_testing is isnt ok isa_ok like)
; use Capture::Tiny qw(capture)

; BEGIN { undef $dIngle::LOGGING }

; use dIngle::Log

; my $logger = dIngle::Log->get_logger

; isnt($logger,'dIngle::Log::Testing','Logger is not the testing logger class')
; isa_ok($logger,['dIngle::Log::Private'],'it is the default null logger')

; is($dIngle::Log::DEBUG, undef, 'DEBUG is undefined')
; my ($stdout,$stderr,@result) = capture
    { $logger->warn("Oh no - a warning is made") }
; ok( $stdout eq '' && $stderr eq '', 'default logger does not log anything')

; $dIngle::Log::DEBUG = 1

; ($stdout,$stderr,@result) = capture
    { $logger->warn("Yes - a second warning happens.") }
; is( $stdout, '', "No output on stdout")
; like( $stderr, qr/^warn: Yes - a second warning happens. at t\/026_logdefault\.t/, 
    'default logger writes to stderr if DEBUG is on')

; done_testing()
