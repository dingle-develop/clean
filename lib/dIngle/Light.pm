  package dIngle::Light;
# **********************
  our $VERSION = '0.03';
  use strict; use warnings; use utf8
# **********************************

; use Cwd ()
; use File::Basename ()
; use Path::Tiny ()

; my $dirname = \&File::Basename::dirname

; my $getbasepath = sub
    { if($ENV{'DINGLE_BASE_PATH'}) 
       { return $ENV{'DINGLE_BASE_PATH'}
       }
     else
       { return Cwd::realpath($dirname->($dirname->($dirname->(__FILE__))));
       }
    }
    
; my $getconfigpath = sub
    { if($ENV{'DINGLE_CONFIG_PATH'})
       { return $ENV{'DINGLE_CONFIG_PATH'}
       }
     else
       { return Path::Tiny::path(__PACKAGE__->basepath)->child('config')
       }
    }

; sub basepath
   { my $path = $getbasepath->() ;# uncoverable statement
   ; no strict 'refs';
   ; no warnings 'redefine';
   ; *{__PACKAGE__ . '::basepath'} = sub { $path };
   ; return $path ;# uncoverable statement  
   }

; sub configpath
   { my $path = $getconfigpath->() ;# uncoverable statement
   ; no strict 'refs';
   ; no warnings 'redefine';
   ; *{__PACKAGE__ . '::configpath'} = sub { $path };
   ; return $path; # uncoverable statement
   }

; 1

__END__

=head1 NAME

dIngle::Light - the basic informations

=head1 SYNOPSIS

   say dIngle::Light->basepath;
   say dIngle::Light->configpath;

=head1 DESCRIPTION

A complex software needs needs some foundational information. This
information should be defined in one place. The Light shines over the
whole project - this is where the name comes.

=head2 Class Methods

=over 4

=item C<basepath>

This could be set with environment variable  C<DINGLE_BASE_PATH>.
Usually it is the place where dIngle is installed.

=item C<configpath>

The place where the configuration files reside.
This could be set with environment variable C<DINGLE_CONFIG_PATH>.

=back
