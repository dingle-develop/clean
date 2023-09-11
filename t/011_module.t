; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use Test2::V0 qw(done_testing is isa_ok ok)

; use dIngle::Module
; use dIngle::Project

; my $project = new dIngle::Project::('test')
; $project->set_namespace('TestModule::dIngle')

; my $module = new dIngle::Module::(['Namnambulu','NNB','nam',1])
; is($module->name,'Namnambulu','name')
; is($module->short,'NNB','short')
; is($module->prefix,'nam','prefix')
; ok($module->buildable,'is buildable')

; $module->project($project)
; is($module->project->name,'test')
; is([$module->formats],[],'formats')

; use Trxt::Project

; my $trxt = new Trxt::Project::

; my @modules = $trxt->list_modules

; ok(@modules > 0,"Modules loaded")

; foreach my $module (@modules)
    { isa_ok($module,'dIngle::Module')
    ; ok($module->buildable,"Module @{[$module->fullname]} is buildable")
    ; my $object = $module->build_object
    ; isa_ok($object,'dIngle::Object')
    ; is($object->string,"","empty object")
    ; ok(! $module->has_submodule('XXX'),'no XXX submodule')
    ; ok($module->has_submodule('Tasks'),'module has Tasks')
    ; my @formats = $module->formats
    }




; done_testing
