  package Test::dIngle::Light
# ***************************
; our $VERSION = '0.01'
# *********************
; use strict; use warnings; use utf8
; use lib 'lib'
; use Sub::Uplevel

; use File::Basename ('dirname')
; use Path::Tiny ()

; BEGIN
    { delete $ENV{ 'DINGLE_BASE_PATH' }
	; delete $ENV{ 'DINGLE_CONFIG_PATH' }
    }

; sub import 
    { my ($class,$config) = @_
	; my $testconfig = dirname(dirname(dirname(dirname(__FILE__)))) . '/config'
    ; if( defined $config )
        { $testconfig = Path::Tiny($testconfig)->child( $config )
	    }
	; $ENV{'DINGLE_CONFIG_PATH'} = $testconfig
	}

; 1

__END__


