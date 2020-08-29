; use lib 't/lib'
; use Test::dIngle::Light

; use Test2::V0

; use dIngle::I18N::Domain

; my $class = 'dIngle::I18N::Domain'
; ok(!$class->exists_domain('Filme'))

; ok( lives { $class->setup
          ( 'langsource' => {'en' => 't/locale/module_filme.po'}
          , domain => 'Filme') } , "setup with file is worky" ) or note($@)

; done_testing()
