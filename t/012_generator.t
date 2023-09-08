; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0 qw/like dies done_testing/

; use dIngle::Generator

; like dies { my $generator = new dIngle::Generator:: },
    qr/A Generator needs a project to build. at t\/012_generator.t/,
    "constructor dies without a project"
    


    
; done_testing
