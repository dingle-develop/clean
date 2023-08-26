; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0 ('is','ok','done_testing')

; use dIngle::System
; use dIngle::Generator

; use Data::Dumper

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;


; my $gen = new dIngle::Generator::( project => new dIngle::System:: )

; $gen->hive->add_layer($gen->project->name)
; $gen->setup_project(module => "Shell")
; $gen->setup_context

; my $task = dIngle->hive->take('task' => "Shebang",backend => 'generic');
; is($task->run($gen->context,"/usr/bin/perl"),"#!/usr/bin/perl")
#; print dIngle->hive->take("Shebang","perl")
#; print dIngle->dump(dIngle->hive->dump)

; ok(1)
; done_testing()
