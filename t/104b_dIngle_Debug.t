; use lib 't/lib'
; use Test::dIngle::Light

; use Test2::V0
; plan(1)

; BEGIN { $ENV{'DINGLE_DEBUG'} = 1 }

; use dIngle::Debug

; use subs 'DEBUG'

; ok(DEBUG,"Debug is set by environment")

