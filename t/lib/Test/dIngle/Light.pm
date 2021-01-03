  package Test::dIngle::Light
# ***************************
; our $VERSION = '0.01'
# *********************
; use strict; use warnings; use utf8
; use lib 'lib'
; use Sub::Uplevel

; use Getopt::Lucid ()
; use Path::Tiny ()

; BEGIN
    { delete $ENV{ 'DINGLE_BASE_PATH' }
	; delete $ENV{ 'DINGLE_CONFIG_PATH' }
    }

; sub import 
    { my ($class,@args) = (@_)
	; my @specs = 
	    ( Getopt::Lucid::Param( 'config' )->default('')
	    , Getopt::Lucid::Param( 'sitelib' )->default('site-lib.conf')
        )
 
    ; my $opt = Getopt::Lucid->getopt( \@specs ,\@args)
		
	; return if $opt->get_config eq 'dingle-env'

	; my $testconfig = Path::Tiny::path(__FILE__)->parent(4)->child('/config')
    ; if( $opt->get_config )
        { $testconfig = Path::Tiny::path($testconfig)->child( $opt->get_config )
	    }
	; $ENV{'DINGLE_CONFIG_PATH'} = $testconfig
	
	; local $@
	; eval "use dIngle::Library '" . $opt->get_sitelib . "'"
	; die $@ if $@
	}

; 1

__END__

=pod

=head1 NAME

Test::dIngle::Light - the test base for the dIngle light variant

=head1 DESCRIPTION

=over 1

=item Load configuration from t/config

   use Test::dIngle::Light;

=item Load configuration from t/config/test1.

   use Test::dIngle::Light ('test1');

=item

   use Test::dIngle::Light '-dingle-env';
   
Use the normal dingle config folder.
 
=back


