; use lib 't/lib'

# test the real dIngle sitelib loaded from t/config
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 3
; use Test::Exception

; use_ok('dIngle::Library', 'site-lib.conf')
; isnt( scalar dIngle::Library->get_library, 0,"site lib loaded" )

; use_ok("Shari::Code::Loader")
