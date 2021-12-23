; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::Registry
; use dIngle::System

; my $registry = new dIngle::Registry::

; my $system = new dIngle::System::

; $registry->backend('generic',$system)

; is( dIngle->backend->generic, 'generic', "backend generic registered" )

; done_testing()
