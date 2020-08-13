  package dIngle::Light;
# **********************
  our $VERSION = '0.02';
  use strict; use warnings; use utf8
# **********************************

; use Cwd ()
; use File::Basename ()
; use Path::Tiny ()

; my $dirname = \&File::Basename::dirname

; sub basepath
   { my ($path)
   ; if($ENV{'DINGLE_BASE_PATH'}) 
       { $path = $ENV{'DINGLE_BASE_PATH'}
       }
     else
       { $path = Cwd::realpath($dirname->($dirname->($dirname->(__FILE__))));
       }
   ; no strict 'refs'
   ; no warnings 'redefine'
   ; *{__PACKAGE__ . '::basepath'} = sub { $path }
   ; return $path;   
   }

; sub configpath
   { my $self = shift
   ; my ($path)
   ; if($ENV{'DINGLE_CONFIG_PATH'})
       { $path = $ENV{'DINGLE_CONFIG_PATH'}
       }
     else
       { $path = Path::Tiny::path($self->basepath)->child('config')
       }
   ; no strict 'refs'
   ; no warnings 'redefine'
   ; *{__PACKAGE__ . '::configpath'} = sub { $path }
   ; return $path;
   }

; 1

__END__

