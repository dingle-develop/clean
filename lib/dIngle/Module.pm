  package dIngle::Module;
# ***********************
  our $VERSION='0.04';
# ********************
; use strict; use warnings; use utf8
; use dIngle::Object ()

; use Ref::Util ()
; use Feature::Compat::Try 0.05

; use subs 'init'
; use HO::class
    _rw => name => '$',
    _rw => short => '$',
    _rw => prefix => '$',
    _rw => buildable => '$',
    _method => formats => sub
        { my ($self) = shift
        ; my @formats = $self->load_formats
        ; $self->[&_formats] = sub { @formats }
        ; return $self->formats
        },
    _rw => project => '$'

; use overload
    '""' => sub { return  $_[0]->name || do
        { Carp::carp("Nameless module stringified!")
        ; return ''
        }},
    'cmp' => sub { "$_[0]" cmp "$_[1]" }

; sub init
    { my ($self,$def) = @_
    ; $def = $def->module_args if Ref::Util::is_blessed_ref($def) &&
        $def->can('module_args'); 
    ; $self->name($def->[0])
           ->short($def->[1])
           ->prefix($def->[2])
           ->buildable($def->[3])
    }
    
; sub fullname
    { my ($self,$sep) = (@_,'-')
    ; join($sep,$self->project->name,$self->name)
    }
    
; sub build_object
    { my $self = shift
    ; my $object = new dIngle::Object::(@_)
    ; $object
    }
    
; sub get_submodules
    { $_[0]->project->get_submodules
    }
    
; sub submodule_unit
    { my ($self,$submodule) = @_

    ; my $project = $self->project
    ; my @ns = (
        $self->project->namespace,
        $self->project->modulepath,
        $self->name,
        $submodule
      )
    ; return dIngle->load->by_ns(@ns)->unit
    }

; sub has_submodule
    { my ($self,$submodule) = @_
    ; return $self->submodule_unit($submodule)->is_ready
    }

; sub load_formats
    { my $self = shift
    ; my $data = []
    ; try
        { if(my $formatsclass = dIngle->load->formats($self))
            { $data = $formatsclass->setup($self)
            ; die "Result of setup is not an array reference" 
                    unless Ref::Util::is_arrayref($data)
            }
        }
      catch($e)
        { Carp::croak "Failure during setup formats for @{[$self->name]}:\n $e"
        }
    ; return @$data
    }

; sub DESTROY
    { $_[0]->project(undef)
    }

; 1

__END__

=head1 NAME

dIngle::Module - base class for dIngle::Module objects

