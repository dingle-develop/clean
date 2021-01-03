  package Test::dIngle::Application
# *********************************
; our $VERSION = '0.01'
# *********************
; use strict; use warnings; use utf8
; use lib 'lib'

; use Test::dIngle::Light

; sub import
    { my $package = shift
	; Test::dIngle::Light->import(@_)
	; require dIngle::Application
    }

; 1

__END__

=pod

=head1 NAME

Test::dIngle::Application

=head1 DESCRIPTION
