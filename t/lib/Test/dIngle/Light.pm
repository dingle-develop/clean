  package Test::dIngle::Light
# ***************************
; our $VERSION = '0.01'
# *********************
; use strict; use warnings; use utf8
; use lib 'lib'
; use Sub::Uplevel

; use File::Basename ('dirname')

; BEGIN { $ENV{'DINGLE_CONFIG_PATH'} = 
    dirname(dirname(dirname(dirname(__FILE__)))) . '/config'
  }

; use dIngle::Library
; 1

__END__


