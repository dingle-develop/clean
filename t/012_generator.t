; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0 qw/like dies is ok isa_ok done_testing/

; use dIngle::Generator

; like dies { my $generator = new dIngle::Generator:: },
    qr/A Generator needs a project to build. at t\/012_generator.t/,
    "constructor dies without a project"
    
; use dIngle::Project ()
    
; my $project = new dIngle::Project::('testproject')

; my $generator = new dIngle::Generator::(project => $project)

; is($generator->starttask,"Build all","default start task")

; isa_ok($generator->hive,['dIngle::Hive'],'default hive setup done')

; done_testing
