; use lib 't/lib'
; use Test::dIngle::Application
; use strict; use warnings

; use Test2::V0

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use Trxt::Project

; isa_ok(dIngle->load,"dIngle::Loader")

; my $project = Trxt::Project->new
; dIngle->register->backend('generic',$project)

# context is ne, so this is temporary here
; use dIngle::Context
; use dIngle::Hive::Container
; my $context = new dIngle::Context::
    ( hive => new dIngle::Hive::Container::
    )
    
; dIngle->context($context)
    
; my $structure = dIngle->load('new')->structure("Std::Root")
; isa_ok($structure,'dIngle::Structure')
; is(ref($structure),'dIngle::Structure::Std::Root')


; done_testing

