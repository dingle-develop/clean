  package dIngle::Hive::Layer;
# ****************************
  our $VERSION='0.01';
# ********************
; use strict; use warnings

; use dIngle::Log (_log_store => 'dIngle.builder.progress')

; use dIngle::Hive::Container

; use HO::class
    _ro => container => '%',
    _method => create_container => sub { new dIngle::Hive::Container:: }
     
; sub exists
    { my ($self, $name) = @_
    ; foreach my $container (values %{$self->container})
        { return 1 if $container->exists($name)
        }
    ; return 0
    }
    
; sub insert_task
    { my ($self,$task) = @_
    ; unless( CORE::exists $self->container->{$task->backend} )
        { $self->[&_container]->{$task->backend} = $self->create_container
        }
    ; $self->[&_container]->{$task->backend}->insert_task($task)
    }
    
; sub take
    { my ($self,$task,@args) = @_
    ; 
    }

; 1

__END__

