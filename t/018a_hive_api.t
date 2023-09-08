; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use Test2::V0 ('isa_ok','is','ok','done_testing')

; use dIngle::Hive::API ('task','alias','const')

; use dIngle::Hive::Container

; dIngle->hive(new dIngle::Hive::Container::)

; isa_ok(task('123'),'dIngle::Tasks::Task')

; my $task = dIngle->hive->take(task => "123")

; is($task->module,'main','current module is "main"')
; ok(! defined $task->perform,"Hive can store undefined tasks")



; done_testing
