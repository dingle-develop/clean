; use lib 't/lib'
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 2

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use Path::Tiny qw(path)

; BEGIN {  }

; BEGIN
  { use_ok('dIngle::Light')
  ; is(dIngle::Light->basepath,realpath(dirname($FindBin::Bin)))
  }


; 1

__END__

; BEGIN
  { local $ENV{'DINGLE_BASE_PATH'}
  ; local $ENV{'DINGLE_CONFIG_PATH'}
 # ; local *dIngle::Light::configpath
  ; local *dingle::Light::basepath
  ; use_ok('dIngle::Light') 
  ; my $expect = path(dirname(__FILE__))->child('config')
  ; is(dIngle::Light->configpath,$expect,"configpath: $expect")
  }
