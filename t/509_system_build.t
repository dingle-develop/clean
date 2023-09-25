; use lib 't/lib'
; use Test::dIngle::Application

; use Test2::V0 qw(ok dies like done_testing)

; use dIngle::System
; use dIngle::Generator

; use Data::Dumper

; $dIngle::Log::Testing::LEVEL->{'debug'} = 1;
; $dIngle::Log::Testing::LEVEL->{'info'} = 1;


; my $gen = new dIngle::Generator::( project => new dIngle::System:: )

; $gen->hive->add_layer($gen->project->name)
; $gen->setup_project
; $gen->setup_context

; my $context = $gen->context
; like dies { $context->make("Build module","Shell") }, 
    qr/^Failure during check of arguments for Build module\./,
    'not a module object'

; ok(1)
; done_testing()
