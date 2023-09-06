  package dIngle::Hive::API;
# **************************
  our $VERSION='0.01_001';
# ************************
; use strict; use warnings; use utf8

; use Carp ()
; use Ref::Util ()
; use Package::Subroutine ()
; use dIngle::Log ()
; use dIngle::Tasks::Task ()

; sub import
    { my ($package,@imports) = @_
    ; export Package::Subroutine::( _ => @imports)
    }

; sub task
    { my ($id,$perform)=@_
        
    ; my $module = scalar caller
    ; my $task = new dIngle::Tasks::Task::({
        label => $id,
        module => $module,
        on_destroy => sub 
            { my $self = shift
            ; dIngle->hive->insert_task($self)
            ; $self->on_destroy(undef)
            }
      })
    ; if($perform)
        { unless( Ref::Util::is_coderef($perform) )
            { Carp::croak("Second parameter for task needs to be a coderef.")
            }
        ; $task->perform($perform)
        }
    ; return $task
    }

; sub alias
    { my $key=shift
    ; my @arg=@_
    ; sub { my $obj=shift(@_)
          ; my @args=(@arg,@_)
          ; $obj->take($key,@args)
          }
    }

; sub const
    { my @const=@_
    ; sub { wantarray ? @const : $const[0] } 
    }

; 1

__END__

=head1 NAME

dIngle::Hive::API - the public functions used for task definition

=head1 SYNOPSIS

    use dIngle::Hive::API ('task','alias','const');
    
    task("my task", sub { ... });
    
=head1 DESCRIPTION

The function C<task> is used  for creating tasks. The created 
task object (C<dIngle::Tasks::Task>) uses a DESTROY hook to insert
the task into the global C<dIngle-E<gt>hive>.

=head1 SEE ALSO

=over 4

=item L<dIngle::Tasks::Task>

=back

