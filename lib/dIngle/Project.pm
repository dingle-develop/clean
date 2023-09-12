  package dIngle::Project;
# ************************
; our $VERSION='0.02_004';
# ************************
; use strict; use warnings; use utf8

; use dIngle::Modules ()
; use dIngle::Project::Configuration ()
; use Path::Tiny ()
; use Carp ()

; use dIngle::Log
    ( _log_modules => 'dIngle.project.modules'
    , _log_project => 'dIngle.project'
    )

# =========================
#         OBJECT
# =========================
; use subs qw/init/

; use HO::class
        _rw => name  => '$',               # name of the project
    _lvalue => configuration => '$',       # configuration object
    _method => namespace => sub { undef },
        _rw => modules => '$',
        _rw => modulepath => '@',
        _rw => structurepath => '@'

; sub init
    { my ($self,$name) = @_
    ; $self->name($name)
    ; $self->modulepath(['Module'])
    ; $self->structurepath(['Structure'])
    ; return $self
    }

; use overload
    '""' => sub 
        { return $_[0]->name if length $_[0]->name
        ; Carp::carp("Nameless project stringified!")
        ; return ''
        }

########################
#    CONFIGURATION
########################
; sub load_config
    { my ($self,%args) = @_
    ; my @args = (project => $self)
    ; my $config = $args{'config'}

    ; if(ref($config))
        { # it's a todo
        }
      else
        { unless(defined $config)
            { $config = lc "$self"
            ; $config =~ s/::/-/g
            }
        ; unless($config =~ m|/|)
            { $config = Path::Tiny::path( dIngle::Light->configpath)
                ->child( $config . '.conf')
        }
        ; push @args, source => $config
        ; _log_project("debug","Load configuration from source '$config'.")
        }
    ; push @args, 'instance',$args{'instance'} if $args{'instance'}

    ; $self->configuration = dIngle::Project::Configuration->new
    ; $self->configuration->retrieve(@args)

    ; my $namespace = $self->configuration->entry('namespace')
    ; if(!$self->namespace && !$namespace)
        { $self->set_namespace( ucfirst($self->name) ) 
        }
      elsif($namespace)
        { $self->set_namespace( $namespace ) 
        }

    ; if(my $mp = $self->configuration->entry('modulepath'))
        { $self->modulepath([split /::/, $mp])
        }
    ; return $self
    }

; sub set_namespace
    { my ($self,$namespace) = @_
    ; my @namespace = split /::/, $namespace
    ; $self->[&_namespace] = sub { wantarray ? @namespace : $namespace }
    ; $self
    }

########################
#       MODULES
########################
; sub load_modules
    { my ($self,%opts) = @_
    ; $opts{'path'} ||= [($self->namespace,$self->modulepath)]
    ; $opts{'listfile'} ||= 'ModuleList'
    #; $opts{'class'} ||= 'dIngle::Module'
    ; _log_modules('info' => "Load modules for project '$self'.")
    ; _log_modules('debug' => "Modules path " . join("::",@{$opts{path}}))
    ; $self->modules(new dIngle::Modules:: (%opts))
    ; foreach my $module ($self->list_modules)
        { $module->project($self)
        ; $self->on_load_module($module)
        }
    ; $self
    }

; sub module_index
    { my $self = shift
    ; scalar @{[($self->namespace,$self->modulepath)]}
    }

; sub list_modules
    { my ($self,@filter) = @_
    ; my @modules = $self->modules->modules

    ; my %filter =
        ( buildable => sub { !!$_->buildable == !!$_[0] }
        )

    ; while(@filter)
        { my ($filter,$para) = splice(@filter,0,2)
        ; @modules = grep { $filter{$filter}->($para) } @modules
        }
    ; return @modules
    }

; sub module
    { return $_[0]->modules->fetch("$_[1]")
    }
    
; sub get_submodules
    { return qw/I18N Tasks/
    }
    
; sub on_load_module
    { my ($self,$module) = @_
    }

; 1

__END__

=head1 NAME

dIngle::Project

=head1 SYNOPSIS

   $project = new dIngle::Project::('walk');
   $project->load_config;

   say "This is project $project.";
   say "It uses configuration " . $project->configuration->instance . ".";
   say "The code lives in namespace " . $project->namespace ."."

=head1 DESCRIPTION

=head2 Attributes

=over 4

=item name - rw scalar

Name of the project, internal name, should be unique and despite it is writable,
it should not change often during object life time. If the object is stringified 
this attribute will be returned.

=item configuration - lvalue method

Store a configuration object, normally of class dIngle::Project::Configuration.

=item namespace - method - data stored as closure.

A namespace where the parts of this project resides. The convention is to set
it up in the configuration file.

=item modules - rw scalar - when setup it contains a dIngle::Modules object.

=item modulepath - rw array

This attribute contains an array with sub namespace where modules reside.
Normally they are stored under C<Module> in the project namespace.

=item structurepath - rw array

Similar to modulepath but for structures.

=back

=head2 Configuration related methods

=over 4

=item C<load_configuration(%args)>

=head2 Module Related Methods

=over 4

=item C<load_modules(%args)>

Setup for the C<modules> accessor. All arguments are optional. 

=over 4

=item C<$args{'path'}> - alternative namespace for modules
    
=item C<$args{'listfile'}> - alternative name for C<ModuleList> class
    
=item C<$args{'class'}> - alternative class for the dIngle modules
    
=back

=item C<module (modulename)>

Get a module object by name.

=back

=head1 TODO

=over 4

=item Use more sources for core configuration, not only a physical file.

=item Check behavior when C<load_modules> is called more the one time.

=back
