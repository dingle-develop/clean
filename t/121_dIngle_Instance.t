; use lib 't/lib'
; use Test::dIngle::Light # -*- perl -*-
# *************************
; use Test2::V0
; use FindBin

; plan(9)

; use dIngle::Instance

; my $instance = new dIngle::Instance
; isa_ok($instance,'dIngle::Instance')

; like( dies { "$instance" }
    , qr/Name of instance not defined, call detect to set the name! at.*/
    , "stringify undetected instance dies") 

; my $configdir = "$FindBin::Bin/config/"

########################################
# erste einfache Konfiguration
########################################
; $instance->from_configfile($configdir . 'instances-simple-ok.conf')

; $instance->detect()

; is($instance->fallback,'gurumeditation','fallback detected')

; my $obj = $instance->configuration->obj('instance')

; is(0+@{$obj},2,'two defined instances')

; my $expect = $^O eq 'MSWin32' ? 'one' : 'two'
; is("$instance",$expect,"instance detected by os")

########################################
# Konfiguartion mit einer Instanz
########################################
; $instance->from_configfile($configdir . 'instances-one-simple.conf')

; $instance->detect()

; is($instance->fallback,'one-fallback','fallback ok')
; $obj = $instance->configuration->obj('instance')
; $expect = 'one'
; is("$instance",$expect,"instance detected")

########################################
# cmp - operator
########################################
; ok("$instance" eq "one","cmp on left side")
; ok("one" eq "$instance","cmp on right side")

#; use Data::Dumper
#; print Dumper({$instance->configuration->getall})

