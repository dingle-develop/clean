; use lib 't/lib'
; use Test::dIngle::Light
#; BEGIN { sub Locale::Maketext::DEBUG () { 1 } }

; use Test2::V0

; use dIngle::I18N

; dIngle::I18N->setup_handle('de')
; dIngle::I18N->setup_handle('en')

; ok( 2 == dIngle::I18N->get_handles, '%handles contains two keys' )
; is( [dIngle::I18N->all_languages],['de','en'],'loaded language handles')

; done_testing()
