; use lib 't/lib'
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 3

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use Path::Tiny qw(path)

; BEGIN
  { use_ok('dIngle::Light')
  ; my $expect = path(dirname(__FILE__))->child('base')
  ; $ENV{'DINGLE_BASE_PATH'} = $expect
  ; is(dIngle::Light->basepath,$expect,"basepath by %ENV (1): $expect")
  ; is(dIngle::Light->basepath,$expect,"basepath by %ENV (2): $expect")
  }
  
; 1

__END__
