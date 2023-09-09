; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0 qw(ok is done_testing isa_ok)

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use dIngle::Hive
; use dIngle::Context
; use dIngle::System
; use dIngle::Tasks::Task
; use dIngle::Tasks::Perform qw(make)

; my $system = new dIngle::System::

; is(dIngle->backend->generic, 'generic','backend "generic" is registered')

; my $hive = new dIngle::Hive ()
; $hive->add_layer("default")

; my @tasks
; $tasks[0] = new dIngle::Tasks::Task::(
    { label => "test"
    , perform => sub { 'run tests' }
    })
    
; $tasks[1] = new dIngle::Tasks::Task::(
    { label => "start"
    , perform => sub
        { ok( $_[0]->recursion_level == 1, "recursion_level in start is 1")
        ; make("subtask",$_[0])
        ; ok( $_[0]->recursion_level == 1, "recursion_level in start is 1 again")
        }
    })
    
; $tasks[2] = new dIngle::Tasks::Task::(
    { label => "subtask"
    , perform => sub
        { ok( $_[0]->recursion_level == 2, "recursion_level in subtask is 2")
        }
    })

; $hive->insert_task($_) foreach(@tasks)

; my $context = new dIngle::Context::(_hive => $hive)

; is($context->max_recursion_level, 100,'call class method max_recursion_level')
; ok($context->recursion_level == 0,'recursion_level == 0')

; $context->stash->{'hallo'} = "Welt!"
; is($context->stash->{'hallo'}, "Welt!")

; is($context->backend,'generic',"default backend")
; is([$context->get_backends],[dIngle->backend->generic])

; { $context->set_backend('mason', my $temp)
  ; is($context->backend,'mason','temporary use mason backend')
  }
; is($context->backend,'generic',"back at default backend")

; is($context->run("test"),'run tests');
; $context->run("start") # runs 3 tests

; my $module = $system->module("Shell")
; isa_ok($context->module($module),['dIngle::Context'],"check fluent interface")
; isa_ok($context->module,['dIngle::Module'],"check module getter/setter")


; done_testing()
