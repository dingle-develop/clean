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
        { my $task = $self->_hive->take(task => $task, backend => $backend)
        ; return $task if $task
        }
    ; undef
    }
    
; sub make
    { my ($self, $label, @args) = @_
    ; my $task = $self->take($label)
    ; return $task->run($self,@args) if $task
    
    ; my $autoload = $self->take_autoload($label)
    ; return $autoload->run($self,$label,@args) if $autoload
    
    ; _log_store("error","Task\"$label\" is undefined and no AUTOLOAD found.")
    ; my $error = $self->take("Error - Task undefined")
    ; return $error->run($self, $label) if $error

    ; Carp::croak("Can not run task '$label'.")
    }

; sub take_autoload
    { my ($self, $label) = @_

    ; my $autoload = $self->take("$label AUTOLOAD")
    ; return $autoload if $autoload
    
    ; my $idx = length($label)
    ; while($idx >= 0)
        { $idx--
        ; $idx = rindex($label,' ',$idx)
        ; if($idx > 0)
            { my $pre = substr($label,0,$idx)
            ; $autoload = $self->take("$pre AUTOLOAD")
            ; return $autoload if $autoload
            }
        }
    ; undef
    }

# isdef and isautoload together
; sub can_do
    { my ($self,$key) = @_
    ; return 1 if $self->take($key)
    ; return 1 if $self->take_autoload($key)
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
    
; sub set_module
    { my ($self,$modul)=@_

    ; unless(ref $modul)
        { $modul = $self->project->module($modul)
        }
    # Fix this XXX
    ; if( defined($self->_module) && $self->_module ne $modul )
        { #$self->formats([])
        }
    ; $self->_module = $modul
    ; return $self
    }
    
; sub get_module
    { $_[0]->_module
    }

; 1

__END__

=head1 NAME

dIngle::Context - 
