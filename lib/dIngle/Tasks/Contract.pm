  package dIngle::Tasks::Contract;
# ********************************
  our $VERSION='0.01';
# ********************

; use dIngle::Tasks::Validation

; sub requires
    { my $code = shift
    ; return (REQUIRE => sub 
        { local $SIG{__WARN__} = sub 
            { Carp::croak STDERR "FFFFFFFFFFFFFFFF",$_[0]        }
	    ; $code->(@_)
	    })
    }
    
; sub ensures
    { die "TODO"
    }

; sub valid 
    { my @args = @_
    ; dIngle::Tasks::Validation->valid(@args)
    }

; 1

__END__

