  package dIngle::Tasks::Perform
# ******************************
; our $VERSION='0.02'
# *******************

############################
# $obj Sparfunktionen
# und explizite Backendauswahl
############################
; sub make
    { my ($task,$context,@args) = @_
    ; $Carp::CarpLevel++
    ; my ($r,@r)
    ; if( wantarray )
        { @r = $context->take($task)->run($context,@args)
        }
      else
        { $r = $context->take($task)->run($context,@args)
        }
    ; $Carp::CarpLevel--
    ; wantarray ? @r : $r
    }

# this does now the same as make but it is used during setup
# and not inside of another task.
; sub prepare
    { my (@args)=@_
    ; $Carp::CarpLevel++
    ; my ($r,@r)
    ; if( wantarray )
        { @r = dIngle->object->take(@args)
        }
      else
        { $r = dIngle->object->take(@args)
        }
    ; $Carp::CarpLevel--
    ; wantarray ? @r : $r
    }

; sub make_php { _local_switched_make('PHP',@_) }

; sub _local_switched_make
    { my $switch = shift
    ; my (@args)=@_
    ; my ($r,@r)
    ; $Carp::CarpLevel += 2
    ; dIngle->backend($switch, my $local)
    ; if( wantarray )
        { @r = make(@args) }
      else
        { $r = make(@args) }
    ; $Carp::CarpLevel -= 2
    ; wantarray ? @r : $r
    }

; 1

__END__

