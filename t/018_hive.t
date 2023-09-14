; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use Test2::V0

; use dIngle::Hive

; my $hive = new dIngle::Hive::

; ok($hive->can('exists'))
; ok($hive->can('insert_task'))

; like( dies { $hive->set_current('unknown') }, qr/Layer '.*' is unknown./)
; ok( lives { $hive->add_layer("system") })
; ok( $hive->has_layer('system'),'layer "system" exists')

; done_testing
