  package dIngle::Context;
# ************************
  our $VERSION='0.02';
# ************************
; use strict; use warnings; use utf8

; use Carp()
; use ReleaseAction ()
; use subs 'init'

; use dIngle::Log (_log_store => 'dIngle.builder.progress')

; use dIngle
# at least the generic backend is required to use this context
; BEGIN 
    { dIngle->register->backend('generic') unless
        dIngle->backend->can('generic')
    }
    
; { use Class::Data::Localize
  ; my ($mka,$self) = (\&Class::Data::Localize::mk_classdata,__PACKAGE__)
  ; $mka->($self,'max_recursion_level',100)
  }

; use HO::class
    _ro => project => '$',
    _lvalue => task => '$',
    _rw => stash => '%',
    _lvalue => _module => '$',
    _ro => _hive => '$',
    _rw => object => '$',
    _ro => backend => [ '$', sub { dIngle->backend->generic } ],
    _ro => fallbacks => [ '$', sub { [dIngle->backend->generic] } ],
    _ro => recursion_level => sub { 0 },
    init => 'hash'
    
; sub take 
    { my ($self, $task) = @_
    ; foreach my $backend ( $self->get_backends )
        { if(my $task = $self->_hive->take(task => $task, backend => $backend))
            { $self->task = $task
            ; return $task
            }
        }
    ; _log_store("error","Task \"$task\" is undefined.")
    ; if( $self->_hive->exists("Error - Task undefined") ) 
        { return $self->take("Error - Task undefined")
        }
    ; Carp::croak("Task \"$task\" undefined.") 
    }

; sub isdef { $_[0]->_hive->exists($_[1]) }
    
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
    
; sub inc_recursion_level
    { my $self = $_[0]
    # paranoia check disabled here
    #; if( @_ != 2 )
    #    { Carp::croak("Call inc_recursion_level with a temp var.")
    #    }
    ; $self->[&_recursion_level]++
    ; $_[1] = ReleaseAction->new(sub { $self->[&_recursion_level]-- } )
    ; $self
    }
    
; sub module
    { my ($self,$modul)=@_

    ; if($modul)
        { unless(ref $modul)
            { $modul = $self->project->module($modul)
            }
        # Fix this XXX
        ; if( defined($self->_module) && $self->_module ne $modul )
            { #$self->formats([])
            }
        ; $self->_module = $modul
        ; return $self
        }
      else
        { return $self->_module
        }
    }

; 1

__END__

=head1 NAME

dIngle::Context - 
