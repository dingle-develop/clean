  package dIngle::Hive::Container;
# ********************************
  our $VERSION='0.01';
# ********************
; use strict; use warnings; use utf8

; use parent 'Subroutine::Container::Contractual'

; sub insert_task
    { my ($self,$task) = @_
    ; my $id = $task->label
    ; my $module = $task->module
    
    ; my $code = {}
    ; foreach my $action (qw/require perform ensure/)
        { if( $task->$action )
            { $code->{$action} = sub{ $task->$action }
            }
        }
    ; $self->insert_always($id,$code)
    ; dIngle::Log->get_logger('dIngle')->debug("insert [$id] from $module.")
    }

; 1

__END__
