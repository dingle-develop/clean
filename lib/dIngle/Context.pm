  package dIngle::Context;
# ************************
  our $VERSION='0.02';
# ************************
; use strict; use warnings; use utf8

; use Carp()
; use ReleaseAction ()
; use subs 'init'

; use dIngle::Log (_log_store => 'dIngle.builder.progress')

; use HO::class
    _ro => hive => '$',
    _lvalue => task => '$',
    _rw => object => '$',
    _rw => stash => '%',
    _ro => backend => [ '$', sub { dIngle->backend->generic } ],
    _ro => fallbacks => [ '$', sub { [dIngle->backend->generic] } ],
    init => 'hash'
    
; sub take 
    { my ($self, $task) = @_
    ; foreach my $backend ( $self->get_backends )
        { if(my $task = $self->hive->take(task => $task, backend => $backend))
            { return $task
            }
        }
    ; _log_store("error","Task \"$task\" is undefined.")
    ; if( $self->hive->exists("Error - Task undefined") ) 
        { return $self->take("Error - Task undefined")
        }
    ; Carp::croak("Task \"$task\" undefined.") 
    }
    
; sub run
    { my ($self,$task,@args) = @_
    ; return $self->take($task)->run($self,@args)
    }
    
; sub set_backend
    { my $self = $_[0]
    ; my $current = $self->backend
    ; $self->[&_backend] = $_[1]
    ; if(@_ == 3)
        { $_[2] = ReleaseAction->new(sub { $self->[&_backend] = $current })
        }
    ; $self
    }
    
; sub get_backends
    { my ($self) = @_
    ; return ($self->backend, grep { $_ ne $self->backend } @{$self->fallbacks})
    }

; 1

__END__

=head1 NAME

dIngle::Context - 
