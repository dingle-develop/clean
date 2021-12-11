  package dIngle::Hive::API;
# **************************
  our $VERSION='0.01_001';
# ************************
; use strict; use warnings; use utf8

; use Carp ()
; use Ref::Util ()
; use dIngle::Log ()
; use dIngle::Tasks::Task ()

; sub task
    { my ($id,$perform)=@_
        
    ; my $module = scalar caller
    ; my $task = new dIngle::Tasks::Task::({
        label => $id,
        module => $module,
        on_destroy => sub { dIngle->hive->insert_task(shift) }
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
         # ; print "KEY $key\n"
         # ; print join ".", @_
         # ; print "\n"
          ; my @args=(@arg,@_)
          ; $obj->take($key,@args)
          }
    }

; 1

__END__

=head1 NAME

dIngle::Hive::API - the public functions used for task definition

