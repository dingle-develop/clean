; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(done_testing is isa_ok ok)

; use dIngle::Tasks

; my $tasks01 = new dIngle::Tasks::

; ok($tasks01,'instance of base class')

; use Trxt::Module::Brom::Tasks

; my $tasks02 = new Trxt::Module::Brom::Tasks::
; isa_ok($tasks02,ref($tasks01))

# time will tell if namesplit is better part of a project
; my ($base,$modul,$action)=$tasks02->name_split

; is($base,'Trxt::Module::Brom','name_split base')
; is($modul,'Brom','namesplit module name')
; is($action,'Tasks','namesplit action name')

; is($tasks02->domain,'module_brom')

; done_testing
