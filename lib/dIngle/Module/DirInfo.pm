  package dIngle::Module::DirInfo;
# ********************************
  our $VERSION = '0.01';
# **********************
; use strict; use warnings; use utf8

; use dIngle::Unit

; use File::Spec ()

; use subs qw/init/
; use HO::class
    _rw => name => '$',
    _rw => formats => '$',
    _rw => fields => '$',
    _rw => groups => '$',
    _rw => tasks => '$',
    _rw => info => '$'

; sub init
    { my ($self,@ns) = @_

    ; my @files = qw/Formats Fields Groups Tasks Info/

    ; $self->name($ns[-1])
    ; foreach my $file (@files)
        { my $attr = lc $file
        ; my $unit = dIngle->load('unit')->by_ns(@ns,$file)->buildunit
        ; $self->$attr($unit)
        }
    ; $self
    }

; sub module_args
    { my ($self) = @_
    ; my ($name,$short,$prefix,$buildable)
    ; $name = $self->name

    ; my $class = $self->info->is_ready ? $self->info->modulename : ''
    ; if($class)
        { $short = $class->short
        ; $prefix = $class->prefix
        ; $buildable = $class->buildable
        }
      else
        { $short = ucfirst($name)
        ; $prefix = lc($name)
        ; $buildable = ''
        }
    ; return [$name,$short,$prefix,$buildable]
    }

; sub module_class 
    { my ($self) = @_
    ; my $class = $self->info->is_ready ? $self->info->modulename : ''
    ; if($class and $class->can('module_class'))
        { return $class->module_class
        }
    ; 'dIngle::Module' 
    }

; 1

__END__

=head1 NAME 

dIngle::Module::DirInfo

=head1 DESCRIPTION

