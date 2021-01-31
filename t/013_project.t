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

; if(defined $ENV{'DINGLE_CONFIG_PATH'})
    { is $ENV{'DINGLE_CONFIG_PATH'}, dIngle::Light->configpath,
          "Config path from environment: " . dIngle::Light->configpath
    }
  else
    { fail "Config path";
    }

; is(dIngle->project, undef, "no default project loaded")

; ok( lives { my $project = new dIngle::Project:: ('Trxt')
  ; dIngle::Waypoint::Init->project($project,{'instance' => 'testsystem'})
  }, "Project initialization") or note($@)

; isa_ok(dIngle->project, ['dIngle::Project'], "project loaded")
; is(dIngle->project->name,'Trxt','name')
; is(dIngle->project . "","Trxt",'project stringified')
; is(dIngle->configuration->instance,'testsystem','instance testsystem')

; ok(scalar dIngle->project->modules->modules,'Modules found')

; diag( "Test an empty project")

; my $empty = new dIngle::Project:: 
; isa_ok($empty, ['dIngle::Project'], 'no args for building project allowed')
; ok(!defined $empty->name, "project has no name")

; like( warning { "$empty" }, qr/Nameless project stringified!/, 
    'stringify empty project warns')

; done_testing
