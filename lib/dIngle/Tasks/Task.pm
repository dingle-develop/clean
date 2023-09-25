  package dIngle::Tasks::Task;
# ****************************
  our $VERSION = '0.02';
# **********************
; use strict; use warnings; use utf8

; use Ref::Util ()

; use dIngle::Log (_log_task_run => 'dIngle.builder.task.run')

; use HO::class
    _ro => label => '$',
    _ro => module => sub { scalar caller(2) . "::" },
    _rw => backend => sub { 'generic' },
    _rw => 'on_destroy' => '$',
    _rw => perform => '$',
    _rw => require  => '$',
    _rw => ensure  => '$',
    _rw => layer => sub { '' },
    init => 'hashref'
    
; sub DESTROY
    { my $self = shift
    ; $self->on_destroy->($self) if Ref::Util::is_coderef($self->on_destroy)
    }
    
; sub run
    { my ($self,$context,@args) = @_
    ; $context->task = $self
    ; $context->inc_recursion_level(my $temp)
    ; if( $context->recursion_level > $context->max_recursion_level )
        { Carp::croak("Max recursion level reached: " . $context->recursion_level)
        }
    ; my $key = $self->label
    
    # Backend/Layer Modul Recursion>Label
    ; my $log = "Run from %-4s/%-6s %-14s %s>%s"
    ; my $rec = '+'x$context->recursion_level
    ; _log_task_run('debug',sprintf($log,
        $self->backend, $self->layer, $self->module, $rec, $self->label));

    ; if( $self->require )
        { unless( $self->require->($context,@args) )
            { Carp::croak "Failure during check of arguments for $key."
            }   
        }
    ; unless( $self->ensure )
        { return $self->perform->($context, @args)
        }
    ; if( wantarray )
        { my @result = $self->perform->($context, @args)
        ; unless( $self->ensure->($context, @result) )
            { Carp::carp "Failure during check of \@result from $key."
            ; return ()
            }
        ; return @result
        }
      else
        { my $result = $self->perform->($context, @args)
        ; unless( $self->ensure->($context, $result) )
            { Carp::carp "Failure during check of \$result from $key."
            ; return undef
            }
        ; return $result
        }
    }

; 1

__END__

=head1 NAME

dIngle::Tasks::Task - a task object

=head1 SYNOPSIS

    my @result = dIngle::Tasks::Task->new({label => 'ultima ratio')
        ->require( ... )->perform( ... )->ensure( ... )->run(@args);
        
=head1 DESCRIPTION

=head2 Creation

In the dIngle framework most task objects are created in the setup
method of L<dIngle::Tasks> classes. The helper function C<task> exists
for this reason in L<dIngle::Hive::API>. It uses the C<DESTROY> method 
to run the on_destroy hook of the object. Normally this hook is used to 
store the task object into the hive.

The constructor expects his arguments as a hash reference.

=head2 Object Properties

Each task needs to have a C<label>. The label is used to fetch them from
hive. This is a read only property.

The C<module> property contains normally the package name where the task is
defined.

