; use lib 't/lib'

# test the real dIngle sitelib
; use Test::dIngle::Light '-dingle-env'
; use strict; use warnings

; use Test::More tests => 6
; use Test::Exception

; use_ok('dIngle::Library')

; dies_ok { require Shari::Code::Loader } 'Empty site lib means this is not loadable'
; is_deeply( [dIngle::Library->get_library ],[],"no default sitelib anymore")

; use_ok('dIngle::Library', 'site-lib.conf')
; isnt( scalar dIngle::Library->get_library, 0,"site lib loaded" )

; use_ok("Shari::Code::Loader")
