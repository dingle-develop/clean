  package dIngle::Tasks::Task;
# ****************************
  our $VERSION = '0.02';
# **********************
; use strict; use warnings; use utf8

; use Ref::Util ()

; use HO::class
    _ro => label => '$',
    _ro => module => sub { scalar caller(2) . "::" },
    _rw => backend => sub { 'generic' },
    _rw => 'on_destroy' => '$',
    _rw => perform => '$',
    _rw => require  => '$',
    _rw => ensure  => '$',
    init => 'hashref'
    
; sub DESTROY
    { my $self = shift
    ; $self->on_destroy->($self) if Ref::Util::is_coderef($self->on_destroy)
    }
    
; sub run
    { my ($self,$context,@args) = @_
    ; $context->task = $self
    ; my $key = $self->label

    ; if( $self->require )
        { unless( $self->require->($context,@args) )
            { Carp::carp "Failure during check of arguments for $key."
            ; return undef
            }   
        }
    ; unless( $self->ensure )
        { return $self->perform->($context, @args)
        }
    ; if( wantarray )
        { my @result = $self->perform->($context, @args)
        ; unless( $self->ensure->($context, @result) )
            { Carp::carp "Failure during check of \@result from $key."
            ; return ()
            }
        ; return @result
        }
      else
        { my $result = $self->perform->($context, @args)
        ; unless( $self->ensure->($context, $result) )
            { Carp::carp "Failure during check of \$result from $key."
            ; return undef
            }
        ; return $result
        }
    }

; 1

__END__
