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

; is($tasks02->domain,'module_brom')

; done_testing
