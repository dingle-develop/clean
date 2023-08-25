; use lib 't/lib'

# test the real dIngle sitelib loaded from t/config
; use Test::dIngle::Light
; use strict; use warnings

; use Test2::V0 ('isnt','plan')

; use dIngle::Library ('site-lib.conf')

; plan(1)
; isnt( scalar dIngle::Library->get_library, 0,"site lib loaded" )

; use Shari::Code::Loader
