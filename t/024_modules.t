; use lib 't/lib'
; use Test::dIngle::Light
# ***********************
; use strict; use warnings; use utf8

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; use Test2::V0 qw(done_testing is isa_ok ok)

; use Trxt::Project
; use dIngle::System

; my $trxt = new Trxt::Project::

; my @modules = $trxt->list_modules
; my @taskmods = $trxt->modules->with_submodule('Tasks')

; ok(@modules > 0,"Modules loaded")
; ok(@taskmods > 0,"Modules with Tasks")

; my $system = new dIngle::System::
; $system->modules->sort_modules( sub
    { my @modules = sort { $a->name cmp $b->name } @{$_[0]}
    ; @modules
    })

; my @sorted_names = $system->list_modules

; my @expect = qw/
    Build
    Config
    File
    Shell
    Utilities
    /
; is(\@sorted_names,\@expect,"Modules sorted")
    


; done_testing
