; use lib 't/lib'
# test t/config
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 4

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use Path::Tiny qw(path)

; BEGIN
  { use_ok('dIngle::Light')
  ; my $real= realpath(dirname($FindBin::Bin))
  ; is(dIngle::Light->basepath,$real, "default base path: $real" )
  ; my $expect = path(dirname(__FILE__))->child('config')
  ; is(dIngle::Light->configpath,$expect,"configpath (1): $expect")
  ; is(dIngle::Light->configpath,$expect,"configpath:(2): $expect")
  }


; 1

__END__


