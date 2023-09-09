  package dIngle::Hive::Layer;
# ****************************
  our $VERSION='0.01';
# ********************
; use strict; use warnings

; use List::Util ()

; use dIngle::Log (_log_store => 'dIngle.builder.progress')

; use dIngle::Hive::Container

; use HO::class
    _ro => name => '$',
    _ro => container => '%',
    _method => create_container => sub { new dIngle::Hive::Container:: },
    init => 'hash'
     
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
    ; $task->layer($self->name)
    ; $self->[&_container]->{$task->backend}->insert_task($task)
    }
    
; sub take
    { my ($self,%args) = @_
    ; if(  CORE::exists $self->container->{$args{'backend'}} )
        { if( $self->container->{$args{'backend'}}->exists($args{'task'}) )
            { return $self->container->{$args{'backend'}}->take(task => $args{'task'})
            }
        }
    ; return ()
    }

; 1

__END__

