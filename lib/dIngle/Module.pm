  package dIngle::Module;
# ***********************
  our $VERSION='0.04';
# ********************
; use strict; use warnings; use utf8
################################################################################
# Changes:
# 0.3 - 2009-07-05
#   * dIngle::Module is an object
# 0.4 - 2009-10-10
#   * attribute 'requires' removed
#   * depends_on method from trunk
#   * lazy load of formats
################################################################################
; use dIngle::Formats ()
; use Ref::Util ()

# =========================
#          CLASS
# =========================
; sub depends_on
    { my ($class,@args) = @_
    # localize currentmodule
    ; dIngle->currentmodule(undef,my $temp)
    ; foreach my $module (@args)
        { dIngle->load_module($module)
        }
    }

# =========================
#         OBJECT
# =========================
; use subs 'init'
; use HO::class
    _rw => name => '$',
    _rw => short => '$',
    _rw => prefix => '$',
    _rw => buildable => '$',
    _method => formats => sub
        { my ($self) = shift
        ; my @formats = dIngle::Formats->load($self)
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
    
; sub buildobject
    { my $self = shift
    ; my $object = new dIngle::Object('project' => $self->project, @_)
    ; dIngle->object($object)
    ; $object
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

; sub DESTROY
    { $_[0]->project(undef)
    }

; 1

__END__

=head1 NAME

dIngle::Module - base class for dIngle::Module objects

