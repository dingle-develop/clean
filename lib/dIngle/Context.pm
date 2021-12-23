  package dIngle::Context;
# ************************
  our $VERSION='0.02';
# ************************
; use strict; use warnings; use utf8

; use Carp()
; use ReleaseAction ()
; use subs 'init'

; use HO::class
    _ro => hive => '$',
    _rw => object => '$',
    _rw => stash => '%',
    _ro => backend => sub { 'generic' },
    init => 'hash'
    
; sub take 
    { my ($context, $task, @args) = @_
    ; local $Carp::CarpLevel += 1
    ; return $context->hive->take($context, $task, @args) 
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

; 1

__END__

