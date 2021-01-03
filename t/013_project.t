; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle
; use dIngle::Project
; use dIngle::Waypoint

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;


; diag("Config $ENV{'DINGLE_CONFIG_PATH'}")
; diag(dIngle::Light->configpath)

; is(dIngle->project, undef, "no default project loaded")

; ok( lives { my $project = new dIngle::Project:: ('Trxt')
  ; dIngle::Waypoint::Init->project($project,{'instance' => 'testsystem'})
  }, "Project initialization") or note($@)

; isa_ok(dIngle->project, ['dIngle::Project'], "project loaded")
; is(dIngle->configuration->instance,'testsystem','instance testsystem')

; ok(scalar dIngle->project->modules->modules,'Modules found')

; done_testing
