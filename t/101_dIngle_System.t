; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0

; use dIngle::System
; use dIngle::Hive::Container

; use Data::Dumper

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;

; my $container = new dIngle::Hive::Container::
; dIngle->hive($container)

; my $system = new dIngle::System
; isa_ok($system, 'dIngle::Project')

; is [$system->get_submodules],[qw/I18N Tasks/],"default classes"

; my @modules = $system->modules->modules

; foreach my $module (@modules)
    { is($module->buildable,0, $module->name . ' is not buildable')
    ; foreach my $class ($system->get_submodules)
        { if( (my $unit = $module->submodule_unit($class))->is_ready)
             { $unit->modulename->setup
             }
        }
    }
    
; is($container->take("NO OP"),'','running NO OP')

; done_testing()
