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
    ; $self->module($args{'module'}) if $args{'module'}
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
    
    ; my @modules = $project->modules->modules
    
    ; my @submodules = $project->get_submodules

    ; foreach my $module (@modules)
        { next if %modules_arg && !exists($modules_arg{$module->name})
        ; foreach my $class (@submodules)
            { if( (my $unit = $module->submodule_unit($class))->is_ready)
                { $unit->modulename->setup
                }
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


=head2 Properties

=head3 C<module>

Without argument it returns the current value.

With a argument it stores the module name for the generation process after
a check if the module is buildable. When not it croaks. As a setter it returns
the object itself.

=head3 C<formats>

=head2 Code Loading

=head2 Generator Methods

=head3 build_module

This class method take a module name and generates all format files and all
chunks.

=head3 get_sites

This method returs a list of all sites to build for a given module.

=head3 get_chunks

Same as above, but for the chunks which belong to the module.
