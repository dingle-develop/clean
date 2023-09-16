  package dIngle::Tasks::Perform;
# *******************************
  our $VERSION='0.02';
# ********************
; use Package::Subroutine ()

; sub import
    { my $self = shift
    ; export Package::Subroutine:: _ => @_
    }

############################
# $obj Sparfunktionen
# und explizite Backendauswahl
############################
; sub make
    { my ($task,$context,@args) = @_
    ; local $Carp::CarpLevel = $Carp::Carplevel + 1
    ; my ($r,@r)
    ; if( wantarray )
        { @r = $context->take($task)->run($context,@args)
        }
      else
        { $r = $context->take($task)->run($context,@args)
        }
    ; wantarray ? @r : $r
    }

; 1

__END__

