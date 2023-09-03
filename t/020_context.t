; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::Hive
; use dIngle::Context
; use dIngle::System
; use dIngle::Tasks::Task

; my $system = new dIngle::System::

; is(dIngle->backend->generic, 'generic')

; my $hive = new dIngle::Hive ()
; $hive->add_layer("default")

; my $task = new dIngle::Tasks::Task::(
    { label => "test"
    , perform => sub { 'run tests' }
    })

; $hive->insert_task($task)

; my $context = new dIngle::Context::(_hive => $hive)

; $context->stash->{'hallo'} = "Welt!"
; is($context->stash->{'hallo'}, "Welt!")

; is($context->backend,'generic',"default backend")
; is([$context->get_backends],[dIngle->backend->generic])

; { $context->set_backend('mason', my $temp)
  ; is($context->backend,'mason','temporary use mason backend')
  }
; is($context->backend,'generic',"back at default backend")

; is($context->run("test"),'run tests');

; my $module = $system->module("Shell")
; isa_ok($context->module($module),['dIngle::Context'],"check fluent interface")
; isa_ok($context->module,['dIngle::Module'],"check module getter/setter")


; done_testing()
