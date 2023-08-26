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
    _method => create_layer => sub {
        return new dIngle::Hive::Layer:: (name => $_[1]) 
    }

; sub add_layer
    { my ($self, $name) = @_
    ; my $layer = $self->create_layer($name)
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
    { my ($self, %args) = @_
    ; foreach my $layer (reverse $self->layer)
        { if(my $task = $layer->take(%args) )
            { return $task
            }
        }
    ; return ()
    }
    
; sub dump
    { my ($self) = @_
    ; my @result
    ; foreach my $layer ($self->layer)
        { my @layer = ($layer->name, [])
        ; foreach my $container (sort keys %{$layer->container})
            { my @tasks = sort $layer->container->{$container}->list_tasks
            ; push @{$layer[1]}, [$container, \@tasks]
            }
        ; push @result, \@layer
        }
    ; \@result
    }

; 1

__END__

=head1 NAME

dIngle::Hive - Organize the subroutine container for a build

=head1 DESCRIPTION
