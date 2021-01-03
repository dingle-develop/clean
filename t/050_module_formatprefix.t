; use lib 't/lib'
; use Test::dIngle::Light
# teste ob jedes Modul einen anderen Prefix hat

; use Perl6::Junction qw/one/
; use Path::Tiny ()

; use Test2::V0 

; my @modules
; BEGIN 
  { my $md='t/lib/Trxt/Module'
  ; @modules=grep { !/^\.svn$/ && (-d "$md/$_") }
      Path::Tiny::path($md)->children
  }

; use dIngle::Module

; my @BACKENDS = qw/CDML PHP XML/

; my %pre
; for ( @modules )
    { my $pre = dIngle::Module->module_prefix($_)
    ; my $bnd = dIngle::Module->module_backend($_)
    ; ok(defined($pre),$_)
    ; ok($bnd eq one(@BACKENDS),"Backend: '$bnd'")
    ; $pre{$_}++ if $pre
    }
    
; my $stat=0
; for (keys %pre){ $stat=1 if $pre{$_} > 1 }
; ok($stat==0,"each prefix is unique")

; done_testing
