  package dIngle::Registry;
# *************************
  our $VERSION = '0.02';
# **********************

; use strict; use warnings; use utf8

; use Package::Subroutine ()

; use dIngle::Log (_log => 'dIngle.registry')

; use HO::class

; my %backends

; sub backend
    { my ($self,$id) = @_
    ; if(exists $backends{$id})
        { _log('warn',"Backend \"$id\" is already registered.")
        ; return
        }
    ; $backends{$id} = 1
    ; install Package::Subroutine:: dIngle->backend, $id, sub
        { return $id
        }
    }

; 1

__END__

