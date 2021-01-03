; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle::Tasks

; my $tasks01 = new dIngle::Tasks::

; ok($tasks01)

; use Trxt::Module::Brom::Tasks

; my $tasks02 = new Trxt::Module::Brom::Tasks

; my ($base,$modul,$action)=$tasks02->name_split

; is($base,'Trxt::Module::Brom')
; is($modul,'Brom')
; is($action,'Tasks')

; is($tasks02->domain,'module_brom')

; done_testing
