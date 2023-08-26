  package dIngle::Hive::Container;
# ********************************
  our $VERSION='0.01';
# ********************
; use strict; use warnings; use utf8

; use HO::class
    _ro => tasks => '%';

; sub insert_task
    { my ($self,$task) = @_
    ; my $id = $task->label
    ; my $module = $task->module
    ; $self->[&_tasks]->{$id} = $task
    ; dIngle::Log->get_logger('dIngle')->debug("insert [$id] from $module.")
    }

; sub exists
    { my ($self,$key)=@_
    ; CORE::exists $self->[&_tasks]->{$key}
    }
    
; sub take
    { my ($self,%args) = @_
    ; return $self->[&_tasks]->{ $args{'task'} }
    }
    
; sub list_tasks
    { return keys %{$_[0]->[&_tasks]}
    }

; 1

__END__

=head1 NAME

dIngle::Hive::Container

