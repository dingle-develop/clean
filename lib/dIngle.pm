  package dIngle;
# **********************
  our $VERSION='0.5001';
# **********************
; use strict; use warnings; use utf8

; use dIngle::Loader ()
; use dIngle::Registry ()

; our $LOGGING # which Logging method (log4perl, private, testing, FileSimple,...)
; our $ALL_LANGUAGES = 0 # build with all available languages

#############################
# Class State as Class Data
#############################
; { use Class::Data::Localize
  ; my ($mka,$self) = (\&Class::Data::Localize::mk_classdata,__PACKAGE__)
  ; $mka->($self,'backend','dIngle::Registry::Backends')
  ; $mka->($self,'project')
  ; $mka->($self,'hive')
  ; $mka->($self,'register', dIngle::Registry->new)
  }

#############################
# Class methods also used by dIngle::Object
#############################
; use Package::Subroutine 'dIngle::Loader' => ('load')

; sub configuration
    { return $_[0]->project->configuration
    }

; sub config
    { my $value = shift()->project->configuration->entry(@_)
    ; Carp::carp("Undefined configuration: " . join('.',@_))
        unless defined $value
    ; return $value
    }
    
; sub isdef
    { my ($obj,$key)=@_
    ; dIngle->hive->exists($key)
    }
    

############################
# Development
############################
; sub dump
    { shift;
    ; warn Data::Dumper::Dumper(@_),"\n"
    ; Carp::carp("dump - from ")
    }

sub debug
    { warn "\n@_\n"
    ; Carp::carp("debug - from ")
    }

######## DEPRECATED ? ###########

; my $i18n_setup = 0

; my $importer =
    { 'i18n'   => sub
        { my ($class) = @_
        ; _import_log("info","I18N Setup")
        ; dIngle::I18N->i18n_setup()
        ; $i18n_setup    = 1
        }
    , 'system' => sub
        { my ($class,$project) = @_
        ; _import_log("info","Lade Globale Systemmodule")
        ; $class->setup_container
            ( layer   => 'System'
            , modules => [dIngle::System->list_modules]
            , classes => [qw/I18N Tasks/]
            )
        ; if($project && $project->namespace ne 'dIngle')
            { _import_log("info","Lade Projekt Systemmodule")
            ; $class->setup_container
                ( layer   => 'System'
                , modules => [dIngle::System
                    ->list_modules($project->namespace,'System')]
                , classes => [qw/I18N Tasks/]
                )
            }
        }
    , 'widgets' => sub
        { my ($class,$module) = @_
        ; _import_log("info","Lade Widgetmodule")
        ; $class->setup_container
            ( layer   => 'Widget'
            , modules => [dIngle::Widget->required($module)]
            , classes => [qw/I18N Groups Tasks/]
            )
        }

    , 'module' => sub  # hier wird nur ein einzelnes Modul geladen
        { my ($class,$mod) = @_
        ; _import_log("info","Lade Modul: $mod")
        ; $class->currentmodule($mod)

        ; $class->setup_container
            ( layer   => 'Module'
            , modules => [$mod]
            , classes => [qw/I18N Groups Tasks/]
            )
        }
    , 'fields' => sub
        { my ($class,$mod) = @_
        ; _import_log("info","Lade Fields für Modul: $mod")
        ; $class->setup_container
            ( layer   => 'Module'
            , modules => [$mod]
            , classes => [qw/Fields/]
            )
        }
    , 'instance' => sub
        { my ($class) = @_
        ; _import_log("info","Modifikationen für Konfiguration")
        ; my $project  = $class->project
        ; my $instance = $class->configuration
        ; my @ns = ($project->namespace,"Config",$instance)
        ; my $unit = dIngle->load('unit')->by_ns(@ns)->buildunit
        ; $unit->modulename->setup if $unit->is_loaded
        }
    , 'styles' => sub
        { my ($class,$style) = @_
        ; _import_log("info","Lade Style-Spezifische Tasks")
        ; $class->setup_container
            ( layer   => 'Styles'
            , modules => [$style]
            , classes => [qw/Tasks/]
            )
        }
    , 'files' => sub
        { my ($obj,$file) = @_
        ; _import_log("info","Dateispezifische Tasks: $file")
        ; $obj->setup_container
            ( 'layer'   => 'Files'
            , 'modules' => [$file]
            , 'classes' => [qw/Tasks/]
            )
        }
    , 'chunks' => sub
        { my ($obj,$file) = @_
        ; _import_log("info","Chunk Tasks: $file")
        ; $obj->setup_container
            ( 'layer'   => 'Files'
            , 'modules' => [$file]
            , 'classes' => [qw/Chunks/]
            )
        }
    }

; sub initialize
    { my ($class,@module) = @_;

    ; if( @module )
        { $class->setup_module($module[0])
        }

    # i18n muss nur einmal initialisiert werden
    ; if($class->feature('i18n'))
        { $importer->{'i18n'}->($class) unless $i18n_setup
	    }
    ; dIngle::Fields->fielddef_cleanup()

    # Erzeugt eine neue globale Chest - wenn es noch keine gibt
    ; dIngle::Hive->create unless dIngle::Hive->CHEST

    # Lädt alle Systemmodule
    ; $importer->{'system'}->($class,$class->project)

    # Lädt alle Widgets falls kein Modul angegeben ist
    ; $importer->{'widgets'}->($class,$module[0])

    ; if(@module)
        { # Lädt ein Modul mit Abhängigkeiten
        ; $class->init_modules(@module)

        ; unless($class->module eq $class->currentmodule)
            { Carp::croak(sprintf
                "Main module %s was not the last loaded module (%s)."
                , dIngle->module
                , dIngle->currentmodule)
            }
        }
    ; dIngle::Groups->setup()
    ; return $class
    }


; sub carp_task
    { my $self = shift
    ; $self->debug(@_,"\nCalled By: ".dIngle::Tasks->task_caller(0))
    }

; 1
