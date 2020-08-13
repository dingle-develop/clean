; use lib 't/lib'
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 2

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use Path::Tiny qw(path)

; BEGIN
  { use_ok('dIngle::Light') 
  ; my $expect = path(dirname(__FILE__))->child('config')
  ; is(dIngle::Light->configpath,$expect,"configpath: $expect")
  }
  
; 1

__END__
