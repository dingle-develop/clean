; use lib 't/lib'

# test the real dIngle sitelib
; use Test::dIngle::Light ()
; use strict; use warnings

; use Test2::V0 ('plan','dies','isnt','ok')
; use Test2::Bundle::More ('is_deeply')

; BEGIN { plan(3) }

; BEGIN 
    { use dIngle::Library

    # site-lib is loaded by Test::dIngle::Light import
    ; is_deeply( [dIngle::Library->get_library ],[],"no default sitelib anymore")
    ; ok( dies { require Shari::Code::Loader }, 'Empty site lib means the stuff isnt loadable')
    }
    
; use dIngle::Library 'site-lib.conf'
; isnt( scalar dIngle::Library->get_library, 0,"site lib loaded" )

; use Shari::Conf
; use Shari::Code::Loader
