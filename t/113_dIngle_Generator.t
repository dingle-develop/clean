; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0

; use dIngle::System
; use dIngle::Generator
; use Trxt::Project

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; my $project = Trxt::Project->new
; my $system  = dIngle::System->new

; my $module = "Brom"

; my $gen = new dIngle::Generator::

; $gen->hive->add_layer($system->name)
; $gen->setup_project(project => $system)

; $gen->hive->add_layer($project->name)
; $gen->setup_project($project => $project)

; ok($gen->hive->exists("NO OP"),"System Utilities loaded")

; is($gen->project->name,"Trxt","Project global set")
; isa_ok($gen->hive,["dIngle::Hive"],"Hive")
; isa_ok($gen->module($module),['dIngle::Generator'],"check fluent interface")
; isa_ok($gen->module,['dIngle::Module'],"check module getter/setter")

; dIngle->dump($gen->hive->dump)

; done_testing()

