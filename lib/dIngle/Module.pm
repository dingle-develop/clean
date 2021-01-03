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
    
################################################################################

; use dIngle::Tools
; use Perl6::Junction qw/any one/
; use Package::Subroutine

; our @MODULES             # which fills this Variable

# Häufiger als Fieldprefix verwendet
; our %MODULE2PREFIX = map { ($_->[0] => $_->[2]) } @MODULES

# Mappt Abkürzung der Funktionen auf Modulnamen
; our %SHORT2MODULE = map { ($_->[1] => $_->[0]) } @MODULES

# Mappt Module auf die Abkürzungen
; our %MODULE2SHORT = map { ($_->[0] => $_->[1]) } @MODULES

; our %MODULE2BACKEND = map { ($_->[0] => $_->[4]) } @MODULES

; sub required
    { my ($class,$modul) = @_
   # ; dIngle::Tools->requirements($modul,\%REQUIREMENTS)
    }

; sub module_exists
    { my ($self,$module) = @_
    ; return exists $MODULE2PREFIX{$module}
    }

; sub module_prefix
    { my ($self,$module) = @_
    ; Carp::carp "deprecated dIngle::Module->module_prefix"
    ; return dIngle->module($module)->prefix
    }

; sub modules_to_build
    { sort map { $_->[0] } grep { $_->[3]==1 } @MODULES
    }

; sub list_names
    { map { $_->[0] } @MODULES
    }

; sub module_name
    { my ($pack,$short)=@_
    ; $SHORT2MODULE{$short}
    }

; sub module_shortcut
    { my ($self,$modul)=@_
    ; $modul ||= dIngle->module
    ; $MODULE2SHORT{$modul}
    }
;

=item is_buildable

Checks if the module with the given name is buildable. Returns undef if
no such module exists, 0 if it was not a buildable one and 1 otherwise.

=cut

; sub is_buildable
    { my ($self,$modul) = @_
    # unknown module
    ; return undef unless $self->module_shortcut($modul)
    # yeah it is buildable
    ; return 1 if any($self->modules_to_build) eq $modul
    ; return 0
    }

; sub module_backend
    { my ($self,$modul)=@_
    ; return 'CDML' unless $modul
    ; return $MODULE2BACKEND{$modul} || 'CDML'
    }

; our @KSEARCHABLE = qw(Adressen Einreichungen Filme Gaeste)

; sub is_ksearchable
    { my ($self,$modul) = @_
    ; my @ksearch = @KSEARCHABLE
    ; return $modul eq one(@ksearch)
    }

; sub module_extension
    { my ($self,$modul) = @_
    ; return '.html' unless $modul
    ; my $backend = $MODULE2BACKEND{$modul} || 'DEFAULT'
    ; $backend = dIngle->backend if $backend eq 'DEFAULT'

    ; return
        $backend eq 'CDML'   ? '.html'  :
        $backend eq 'PHP'    ? '.php'   :
        $backend eq 'TT'     ? '.html.tt' : ''
    }

; 1

__END__

=head1 NAME

dIngle::Module - base class for dIngle::Module objects

=head1 SYNOPSIS

  # Get a list of required other modules
  ; my @req = dIngle::Module->required($modul)

  # Get the prefix for a given module
  ; my $pre = dIngle::Module->module_prefix($modul)

  # Get a list of all modules which are buildable
  ; my @mods = dIngle::Module->modules_to_build

=head1 DESCRIPTION

For different reasons there has to be a central configuration module
for all modules integrated in the dingle build system. So creating
a new module means to edit this file to build the module properly.

The new object part represents a dingle generator module.

=head2 Class Methods

=over 3

=item module_prefix

Get the prefix for a given module. This prefix could be used for formats
and fields.

=item modules_to_build

List of all modules which should produce at least one senseful output files.

=item list_names

Get a list of all module names.

=item module_name

Get the module name for a given shortcut.

=item module_shortcut

Get the shortcut for a module name.

=item module_has_submodule

   Param 1: module name
   Param 2: sub module name

This method returns true if the module has a given sub module.

   my $bln = dIngle::Module->module_has_submodule("AdressenPlus","Links");

=item all_with_submodule

Returns a list of all buildable modules with a given submodule.

=cut

Falls Fehler auftreten...
