; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use Test2::V0

; use dIngle::Conf
; $dIngle::Log::Testing::LEVEL->{'info'} = 1

; my $instance = dIngle::Conf->detect_instance('instances-one-simple.conf')
; isa_ok($instance,'dIngle::Instance')
; is($instance->name,'one','instance name')
; is($instance->fallback,'one-fallback','instance fallback')

; my $testinstance = dIngle::Conf->detect_instance # from instances.conf
; is($testinstance->name,'testsystem','testsystem instance')

; my $conf = dIngle::Conf->retrieve('project' => 'hello')

; use Data::Dumper
; print Dumper($conf)

; done_testing()
