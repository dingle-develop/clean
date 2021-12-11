; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle::Module
; use dIngle::Project

; my $project = new dIngle::Project('test')
; $project->set_namespace('TestModule::dIngle')

; my $module = new dIngle::Module::(['Namnambulu','NNB','nam',1])
; is($module->name,'Namnambulu','name')
; is($module->short,'NNB','short')
; is($module->prefix,'nam','prefix')
; ok($module->buildable,'is buildable')

; $module->project($project)
; is($module->project->name,'test')
; is([$module->formats],[],'formats')



; done_testing
