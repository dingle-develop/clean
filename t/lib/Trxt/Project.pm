  package Trxt::Project
# *********************
; our $VERSION = '0.01'
# *********************

; use dIngle::Project ()
; use dIngle::Waypoint ()

; use subs qw/init/

; use parent 'dIngle::Project'

; sub init
    { my $self = shift
    ; $self->SUPER::init('Trxt')
    ; dIngle::Waypoint::Init->project($self)
    ; $self
    }

; sub get_submodules
    { return qw/Tasks/
    }

; sub on_load_module
    { my ($self,$module) = @_
    ; $module->buildable(1)
    }

; 1

__END__

=head1 NAME

Trxt::Project

=head1 SYNOPSIS

  use Trxt::Project;
  
  my $project = Trxt::Project->new

=head1 DESCRIPTION

This is a very simple dIngle project for testing purpose. Only C<Tasks> are
defined as submodules. It does not use a C<ModuleList>, so the directory
C<Module> is read, to load modules.

In this project all modules are buildable.


