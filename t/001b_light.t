; use lib 't/lib'
; use Test::dIngle::Light ()
; use strict; use warnings

; use Test::More tests => 3

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use Path::Tiny qw(path)

; BEGIN
  { use_ok('dIngle::Light')
  ; my $expect = path(dirname(__FILE__))->child('config')->child('light')
  ; local $ENV{'DINGLE_CONFIG_PATH'} = $expect
  ; is(dIngle::Light->configpath,$expect,"configpath (1): $expect")
  ; is(dIngle::Light->configpath,$expect,"configpath (2): $expect")
  }
  
; 1

__END__
