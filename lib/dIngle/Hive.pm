  package dIngle::Hive
# ********************
; our $VERSION='0.05'
# *******************
; use strict; use warnings; use utf8

; use dIngle::Hive::Layer

; use Carp ()

; use dIngle::Log (_log_store => 'dIngle.builder.progress')

; use HO::class
    _ro => layer => '@',
    _ro => layermap => '%',
    _lvalue => _current => '$',
    _method => create_layer => sub { new dIngle::Hive::Layer:: }

; sub add_layer
    { my ($self, $name) = @_
    ; my $layer = $self->create_layer
    ; push @{$self->[_layer]}, $layer
    ; $self->layermap->{$name} = $layer
    ; $self->_current = $layer
    ; _log_store("info","Add hive layer '$name' of class @{[ref($layer)]}.")
    ; return $self    
    }
    
; sub set_current
    { my ($self, $name) = @_
    ; my $layer = $self->layermap->{$name}
    ; Carp::croak("Layer '$name' is unknown.")
    ; $self->_current = $layer
    ; _log_store("info", "Layer '$name' set to current layer.")
    ; return $self
    }
    
; sub exists
    { my ($self,$taskname) = @_
    ; foreach my $layer (reverse $self->layer)
        { return 1 if $layer->exists($taskname)
        }
    ; return 0
    }
    
; sub insert_task
    { my ($self, $task) = @_
    ; $self->_current->insert_task($task)
    }
    
; sub take
    { my ($self, $context, $task, @args) = @_
    ; foreach my $layer (reverse $self->layer)
        { return $layer->take($context, $task, @args) if $layer->exists($task)
        }
    ; _log_store("error","Task \"$task\" not found.")
    }

; 1

__END__

=head1 NAME

dIngle::Hive - Organize the subroutine container for a build

=head1 DESCRIPTION
