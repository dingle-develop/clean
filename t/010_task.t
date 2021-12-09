; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle::Tasks::Task

; my $task01 = new dIngle::Tasks::Task::({label => 'TEST'})

; is($task01->label,'TEST')
; is($task01->backend,'generic')

; done_testing
