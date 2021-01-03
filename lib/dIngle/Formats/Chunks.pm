  package dIngle::Formats::Chunks;
# ********************************
  our $VERSION='0.01';
#########################
# It defines Tasks
# so it exports the
# same things as
# dIngle::Tasks
#########################
; use Package::Subroutine::Sugar
; use dIngle::Tasks ()
; import from:: 'dIngle::Tasks' => qw/import domain/

; my %chunkcache

#########################
# Class Methods
#########################
; sub load { return [] }

; sub load_module
    { my ($obj,$module,%args) = @_
    ; my $unit = dIngle->load('unit')->chunks($module)
    ; return unless $unit->is_ready

    ; my $modname = $unit->modulename

    ; unless($chunkcache{$modname})
        { $chunkcache{$modname} = $modname->setup
        }
    ; return wantarray ? @{$chunkcache{$modname}}
                       :   $chunkcache{$modname}
    }

; sub setup
    { my ($self) = @_
    ; my @chunkdata = @{$self->load}
    ; my @chunks

    ; while(@chunkdata)
        { my $filename = shift @chunkdata
        ; my $buildopt = shift @chunkdata

        ; my $chunk = $self->new(filename => $filename)

        ; my ($task,@args) = @$buildopt
        ; if( ref $task eq 'CODE' )
            { unshift @args,$task
            ; $chunk->task("Build From Coderef")
            }
          else
            { $chunk->task($task)
            }
        ; $chunk->args(\@args)
        ; push(@chunks,$chunk)
        }
    ; return \@chunks
    }

###########################
# Task Methods
###########################
#; sub set_tasks
#    { my ($self,$obj) = @_
#    ; return
#    }

###########################
# Object Methods
###########################

; use subs qw/init/

; use HO::class
    _rw => filename => '$',
    _rw => task     => '$',
    _rw => args     => '@'

; sub init
    { my ($self,%args) = @_

    ; foreach my $method (qw/filename task args/)
        { $self->$method($args{$method})
            if $args{$method}
        }
    ; return $self
    }

; sub gen_dingle
    { my ($self,$style,%args) = @_
    ; %args = (%args,$self->chunk_args)
    ; my $format =
        { VisFormatdir => dIngle->default_chunkdir(),
        , VisFile      => $self->filename
        , VisMaintask  => $self->task
        , VisStyle     => $style
        , extension    => dIngle::Module->module_extension(dIngle->module)
        , %args
        }
    ; my $obj = dIngle::Object->new ( 
	VisFormat => dIngle::Formats::Info->new($format), %$format )
    ; $obj->stash->{maintask_args} = $self->args
    ; return $obj
    }

# das ist erstmal nur eine Dummy-Methode
; sub style_args
    { my ($self,%args) = @_
    ; return
        { 'stylecategory' => 'basic',
        , 'VisFile'       => $self->filename
        , %args
        }
    }

; sub chunk_args
    { return ()
    }

########################
# List of formatnames
########################
; sub list_chunknames
    { my ($self,$module) = @_
    ; return map { $_->filename } $self->load_module($module)
    }

; 1

__END__

