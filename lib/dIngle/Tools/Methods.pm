  package dIngle::Tools::Methods;
# *******************************
  our $VERSION='0.04';
# ********************
; use strict; use warnings; use utf8

; sub name_split
    { my $self=shift
    ; my $package=shift || (ref $self ? ref $self : $self)
    ; my @gen=split /::/,$package
    
    ; if(@gen==4)
        { my $action=pop @gen
        ; my $base  =join("::",@gen)
        ; my $modul =pop @gen
        ; ($base,$modul,$action)
        }
      else
        { my $format=pop @gen
        ; my $action=pop @gen
        ; my $base  =join("::",@gen)
        ; my $modul =pop @gen
        ; ($base,$modul,$action,$format)
        }
    }

; 1

__END__

=head1 NAME

dIngle::Tools::Methods - methods used in different places


