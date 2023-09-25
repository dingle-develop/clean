; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(plan done_testing is isnt ok)

; BEGIN { $dIngle::LOGGING = 'default' }

; use dIngle::Log

; my $logger = dIngle::Log->get_logger

; isnt($logger,'dIngle::Log::Testing','Logger is not the testing logger class')


; ok(1)

; done_testing()
