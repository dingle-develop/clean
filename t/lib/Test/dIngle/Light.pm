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
    { my ($class,$config) = (@_,'')
	; return if $config eq '-dingle-env'

	; my $testconfig = dirname(dirname(dirname(dirname(__FILE__)))) . '/config'
    ; if( $config )
        { $testconfig = Path::Tiny::path($testconfig)->child( $config )
	    }
	; $ENV{'DINGLE_CONFIG_PATH'} = $testconfig
	}

; 1

__END__

=HEAD1 NAME

Test::dIngle::Light - the test base for the dIngle light variant


   use Test::dIngle::Light;
  
Load configuration from t/config.

   use Test::dIngle::Light ('test1');
   
Load configuration from t/config/test1.

   use Test::dIngle::Light '-dingle-env';
   
Use the normal dingle config folder.
 


