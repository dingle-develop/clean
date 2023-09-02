; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle ()

; my @class_methods = qw/
    backend
    config
    configuration
    debug
    dump
    isdef
    load
    register
/

; ok(dIngle->can($_),"dIngle can $_") foreach @class_methods

; is(dIngle->backend, 'dIngle::Registry::Backends', 'backend registry')

; done_testing()
