; use lib 't/lib'
; use Test::dIngle::Light
; use strict; use warnings

; use Test::More tests => 3

; use Cwd('realpath')
; use FindBin
; use File::Basename (qw/dirname/)
; use File::Spec

; BEGIN { use_ok('dIngle::Light') }

# this will not work
#; { no warnings 'ambiguous'
#  ; local *{dIngle::Light::basepath} = \&{dIngle::Light::basepath}
#  ; local $ENV{'DINGLE_BASE_PATH'} = '.'
#  ; is(dIngle::Light->basepath,'.')
#  }

; { local $ENV{'DINGLE_BASE_PATH'}
  ; is(dIngle::Light->basepath,realpath(dirname($FindBin::Bin)))
  }

; { my $expect = File::Spec->catdir(dirname(__FILE__),'config')
  ; is(dIngle::Light->configpath,$expect,"configpath: $expect")
  }

; 1

__END__
