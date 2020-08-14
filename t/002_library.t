; use lib 't/lib'

# test the real dIngle sitelib
; use Test::dIngle::Light '-dingle-env'
; use strict; use warnings

; use Test::More tests => 3


; use_ok('dIngle::Library')
; is_deeply( [dIngle::Library->get_library ],[],"no default sitelib anymore")

; use Data::Dumper

; print Dumper ()

; use_ok('dIngle::Library', 'site-lib.conf')


; print Dumper ( [dIngle::Library->get_library] )
