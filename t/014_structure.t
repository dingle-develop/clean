; use lib 't/lib'
; use Test::dIngle::Application
# *****************************
; use strict; use warnings; use utf8

; use Test2::V0

; use dIngle
; use dIngle::Project
; use dIngle::Structure
; use dIngle::Waypoint

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; diag("Config $ENV{'DINGLE_CONFIG_PATH'}")
; diag(dIngle::Light->configpath)

; my $project = new dIngle::Project:: ('Trxt')
; dIngle::Waypoint::Init->project($project)

; ok(1)
; done_testing
