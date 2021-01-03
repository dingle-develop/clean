  package dIngle::System;
# ***********************
  our $VERSION='0.03';
# ********************
; use strict; use warnings; use utf8

; use parent 'dIngle::Project'

; sub init
    { my $self = shift
    ; $self->name('dIngle::System')
    ; $self->modulepath(['System'])
    ; $self->structurepath(['Structure'])
    ; $self->set_namespace( 'dIngle' )
    ; $self->load_modules
    #; dIngle::Waypoint::Init->project($self)
    ; $self
    }

; 1

__END__

