; use lib 't/lib'
; use Test::dIngle::Light

; use Test2::V0

; use dIngle::I18N
; use dIngle::Project
; use dIngle::Waypoint

; my $project = dIngle::Project->new('Trxt')

; ok( lives { dIngle::Waypoint::Init->project($project,{'instance' => 'testsystem'}) }, 
    "project setup") or note($@)

; ok( lives { dIngle::Waypoint::Init->i18n }, "i18n setup") or note($@)


; done_testing()
