; use lib 't/lib'
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 2

; use_ok('dIngle::Library')
; use_ok('dIngle::Library', 'site-lib.conf')

; use Data::Dumper

#; print Dumper ( \%INC )
