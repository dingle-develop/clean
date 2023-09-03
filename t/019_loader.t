; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0 qw/ok is dies done_testing/

; use dIngle::Loader

; my $loader = new dIngle::Loader::

; ok(! defined $loader->unit)
; ok(scalar $loader->_returnargs == 0)
; ok( dies { $loader->_returnmethod } )

; my $unitloader = dIngle->load('unit')

; ok(! defined $unitloader->unit)
; ok(scalar $unitloader->_returnargs == 0)
; ok(! defined $unitloader->_returnmethod)

; use HO::class
    _rw => unit => '$',
    _ro => _returnargs => '@',
    _method => _returnmethod =>  sub 
        { $_[0]->unit->is_ready ? $_[0]->unit->modulename : undef 
        }



    
; done_testing
