; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle ()
; use Package::Subroutine ()

; my @class_methods = qw/
    backend
    project
    hive
    register
    config
    configuration
    debug
    dump
    load
/

; my %methods
; foreach my $method (@class_methods)
    { ok(dIngle->can($method),"dIngle can $method")
    ; $methods{$method} = 1
    }

; is(dIngle->backend, 'dIngle::Registry::Backends', 'backend registry')

; my @methods = Package::Subroutine->findsubs('dIngle')
; my @unknown = grep { !/^_/ && ! defined $methods{$_} } sort @methods

; is([sort grep { !/^_/ } @methods],[sort @class_methods],"all methods")
; ok(@unknown == 0,"Unknown methods " . join(", ",@unknown))

; done_testing()
