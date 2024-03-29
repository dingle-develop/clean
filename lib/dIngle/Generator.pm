  package dIngle::Generator;
# **************************
  our $VERSION='0.06';
# ********************
; use strict; use warnings; use utf8

; use dIngle::Waypoint
; use dIngle::Hive
; use dIngle::Context ()

; use Carp ()

############################
# C L A S S
############################
; use subs qw/init/

; use HO::class
    _ro     => project => '$',
    _ro     => hive    => '$',
    _ro     => context => '$',
    _rw     => formats => '@',
    _rw     => styles  => '@',
    _rw     => starttask => sub { "Build all" }

############################
# I N I T
############################
; sub init
    { my ($self,%args) = @_
    ; $self->[&_project] = defined($args{'project'}) ?
        $args{'project'} : dIngle->project
    ; unless( ref $self->project )
        { local $Carp::CarpLevel = $Carp::CarpLevel + 1
        ; Carp::croak "A Generator needs a project to build."
        }
    ; defined($args{'hive'}) ? $self->[&_hive] = $args{'hive'}
                             : $self->setup_hive
    ; return $self
    }

# update as hive evolves
; sub setup_hive
    { my ($self) = @_
    # only a single container hive so far
    ; my $container = new dIngle::Hive::
    ; $self->[&_hive] = $container
    ; dIngle::Waypoint::Init->hive($container)
    ; return $container
    }

############################
# S E T U P
############################
; sub setup_project
    { my ($self, %args) = @_
    ; my $project = delete($args{'project'}) || $self->project
    ; my $module_arg  = delete($args{'module'})
    ; my $modules_arg = delete($args{'modules'})

    ; my %modules_arg = map { $_ => 1 } @$modules_arg if $modules_arg
    ; $modules_arg{$module_arg} = 1 if $module_arg
    
    ; my @modules = $project->list_modules(buildable => 0)

    ; foreach my $module (@modules)
        { next if %modules_arg && !exists($modules_arg{$module->name})
        ; $self->setup_module($module)
        }
    }
    
; sub setup_module
    { my ($self,$module) = @_
    ; my @submodules = $module->get_submodules
    ; foreach my $class (@submodules)
        { if( (my $unit = $module->submodule_unit($class))->is_ready)
            { $unit->modulename->setup
            }
        }
    }
    
; sub setup_context
    { my ($self) = @_
    ; $self->[&_context] = new dIngle::Context::
        ( _hive => $self->hive, project => $self->project )
    }

; sub use_projects
    { my ($gen,@projects) = @_
    ; foreach my $project (@projects)
        { $gen->hive->add_layer($project->name)
        ; $gen->setup_project(project => $project)
        }
    }

; sub use_module_layer
    { my ($gen,$name,@modules) = @_
    ; return unless @modules
    ; unless(!ref($name) && length($name))
        { Carp::croak("The layer name is not correct.")
        }
    ; unless($gen->hive->has_layer($name))
        { $gen->hive->add_layer($name)
        }
      else
        { $gen->hive->set_current($name)
        }
    ; foreach my $module (@modules)
        { $gen->setup_module($module)
        }
    }
    
; sub build
    { my ($gen,@args) = @_
    ; $gen->setup_context unless $gen->context
    ; $gen->context->take($gen->starttask)->run($gen->context, @args)
    }

; 1

__END__

=head1 NAME

dIngle::Generator - bookkeeping for the generating environment

=head1 SYNOPSIS

    my $project = Trxt::Project->new;
    my $system  = dIngle::System->new;

    my $gen = new dIngle::Generator::(project => $project)
    $gen->use_projects($system,$project);
    
    $gen->build();

=head1 DESCRIPTION


