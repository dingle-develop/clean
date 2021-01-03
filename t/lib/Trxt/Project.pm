  package Trxt::Project
# *********************
; our $VERSION = '0.01'
# *********************

; use dIngle::Project ()

; use subs qw/init/

; use parent 'dIngle::Project'

; sub init
    { my $self = shift
    ; $self->SUPER::init('Trxt')
    ; dIngle::Waypoint::Init->project($self)
    ; $self
    }

; 1

__END__

=head1 NAME

Trxt::Project

=head1 SYNOPSIS

  use Trxt::Project;
  
  my $project = Trxt::Project->new

=head1 DESCRPTION
