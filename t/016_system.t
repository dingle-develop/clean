; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0 ('is','done_testing','like','dies')
; use Test2::Bundle::More ('is_deeply')

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::System

; my $sys = new dIngle::System::

; is($sys->name,'dIngle::System','Project name')
; is($sys->namespace,'dIngle')
; is($sys->configuration,undef,'Configuration is undefined')

; like( dies { $sys->load_config }, 
    qr/Config::General The file \"t\/config\/dingle-system.conf\" does not exist!/)

; print $sys->basedir

#; is($sys->configuration->instance,'testing','Test environment')


; done_testing()
