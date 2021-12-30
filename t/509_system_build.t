; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0

; use dIngle::System
; use dIngle::Generator

; use Data::Dumper

#; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
#; $dIngle::Log::Testing::LEVEL->{'info'} = 1;


; my $gen = new dIngle::Generator::( project => new dIngle::System:: )

; $gen->hive->add_layer($gen->project->name)
; $gen->setup_project



; ok(1)
; done_testing()
; exit(0)

; my $dingle = Test::dIngle->dingle
    ( module => "JavaScriptFiles"
    , file   => "textelinks"
    )
    
; isa_ok($dingle,'dIngle')

; dIngle::I18N->i18n_setup

; $dingle->take("dIngle Init")

; my $source = "./Web/js/".$dingle->take("JSF Filename")

; print $dingle->take("Build TemplateFromFile"
    , source => $source)
