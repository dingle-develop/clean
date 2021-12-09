; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0

; use dIngle::System
; use dIngle::Generator
; use Trxt::Project

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; my $project = Trxt::Project->new

; my $module = "Brom"

; my $gen = new dIngle::Generator::

; $gen->setup_project( project => new dIngle::System:: )

; ok($gen->hive->exists("NO OP"),"System Utilities loaded")

; is($gen->project->name,"Trxt","Project global set")
; isa_ok($gen->hive,["dIngle::Hive::Container"],"only during development valid - FIXIT")
; isa_ok($gen->module($module),['dIngle::Generator'],"check fluent interface")
; isa_ok($gen->module,['dIngle::Module'],"check module getter/setter")


; done_testing()

