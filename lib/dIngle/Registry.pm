  package dIngle::Registry;
# *************************
  our $VERSION = '0.01';
# **********************

; use strict; use warnings; use utf8

; use Package::Subroutine ()

; use dIngle::Log (_log => 'dIngle.registry')

; use HO::class

; my %backends

; sub backend
    { my ($self,$id,$project) = @_
    ; if(exists $backends{$id})
        { _log('warn',"Backend \"$id\" is already registered.")
        ; return
        }
    ; $backends{$id} = $project
    ; install Package::Subroutine:: dIngle->backend, $id, sub
        { return $id
        }
    }

; 1

__END__

