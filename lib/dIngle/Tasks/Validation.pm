  package dIngle::Tasks::Validation
# *********************************
; our $VERSION='0.01'
# *******************

; use strict; use warnings; use utf8

; use autouse 'Carp' => qw/carp/
; use Package::Subroutine
; use Ref::Util ()

########################
# Object Definition
########################
; use HO::class
    _ro => object => '$',
    _ro => args   => '@'

#########################
# Class Methods
#########################

; sub valid
    { my ($self,@args) = @_
    ; $self = ref($self) ? $self : __PACKAGE__->new
    ; $self->[_object] = shift @args
    ; $self->[_args] = \@args
    ; $self
    }

########################
# Object Methods
########################
    
; sub even_args
    { my ($self) = @_
    ; if(@{[$self->args]} % 2)
        { carp "Odd argument count."
        ; return 0
        }
    ; 1
    }

; sub hash_ref
    { my ($self,$def,$pos) = @_
    ; my $hash
    ; my $errors = 0
    ; if(Ref::Util::is_hashref($pos))
        { $hash = $pos
        }
      else
        { unless($pos =~ /^\d+$/)
            { carp "Positition argument is not an integer."
            ; return 0
            }
        ; $hash = [$self->args]->[$pos]
        ; unless(Ref::Util::is_hashref($hash))
            { carp "Argument at position $pos is not a hashref."
            ; return 0
            }
        }
    # check for required arguments
    ; foreach my $key (keys %$def)
        { next unless $def->{$key}
        ; unless(defined $hash->{$key})
            { carp "Required key $key is missing in argument hash."
            ; $errors++
            }
        }
    # check for unknown arguments
    ; foreach my $key (keys %$hash)
        { next if exists $def->{$key}
        ; carp "Found unknown argument key $key."
        ; $errors++
        }
    ; return $errors == 0
    }
    
; sub hash_list
    { my ($self,$def) = @_
    ; return 0 unless $self->even_args
    ; return $self->hash_ref($def,{$self->args})
    }

; 1

__END__

=head1 NAME

dIngle::Validation

=head1 SYNOPSIS

    use dIngle::Validation;

    dIngle::Validation->valid(@_)->hash_list({foo => 1,bar => 0,baz => 1});

=head1 DESCRIPTION

=head2 C<valid (@_)>

This is the constructor. The arguments will be stored in the object as
object and args.

=head2 C<hash_list (hashdef)>

Validates the ars as a hash. The hashdef contains all keys, the value 0
means a key is opional, 1 means it is a required entry.




