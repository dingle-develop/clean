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
    _lvalue => _module => '$',
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
    ; Carp::croak "A Generator needs a project to build."
        unless ref $self->project
    ; $self->[&_hive] = defined($args{'hive'}) ?
        $args{'hive'} : $self->setup_hive
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
# P R O P E R T I E S
############################
; sub module
    { my ($self,$modul)=@_

    ; if($modul)
        { unless(ref $modul)
            { $modul = $self->project->module($modul)
            }

        ; if( defined($self->_module) && $self->_module ne $modul )
            { $self->formats([])
            }
        ; $self->_module = $modul
        ; return $self
        }
      else
        { return $self->_module
        }
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
    ; $self->[&_context] = new dIngle::Context::(hive => $self->hive)
    }

############################
# B U I L D
############################
; sub build_module
    { my ($self,%args) = @_
    ; Carp::croak "No module set for build_module." 
        unless $self->module( $args{'module'} )

    ; if(dIngle->isdef("Build Module " . $self->module))
        { my $obj = $self->module->buildobject
        ; $obj->take("Build Module " . $self->module)
        }
      else
        { $self->build_sites(%args)
        }

    ; unless($args{'no_chunks'})
        { my @chunks = $self->get_chunks(%args)
        ; foreach my $chunk ( @chunks )
            { next unless $self->prebuild_check($self->module,$chunk)
            ; $self->build_chunk($chunk,%args)
            }
        }
    ; return $self
    }

; sub build_sites
    { my ($self,%args) = @_    
    ; my @sites = $self->get_sites(%args)

    ; foreach my $site ( @sites )
        { next unless $self->prebuild_check($self->module,$site)
        ; $self->build_site($site,%args)

        ; # TODO use Class::Trigger?
        ; if($args{'postbuild'})
            {
              $args{'postbuild'}->()
            }
        }
    }
    
; sub get_sites
    { my ($self,%args) = @_
    ; my @sites = dIngle::Formats->load($self->module)

    ; if( $args{'filter_formats'} ) 
        { if( $args{'filter_formats'} eq "equal" )
            { @sites = grep { $_->{'VisFile'} eq $args{'filter_expr'} } @sites
            }
          elsif( $args{'filter_formats'} eq "match" )
            { @sites = grep { $_->{'VisFile'} =~ /$args{'filter_expr'}/ } @sites
            }
          elsif( $args{'filter_formats'} eq "match-not" )
            { @sites = grep { $_->{'VisFile'} !~ /$args{'filter_expr'}/ } @sites
            }
        }

    ;  return @sites
    }


# deprecated? vvvv


###################################
    
; sub setup_container
    { my ($self,%args) = @_

    ; my $layer   = $args{'layer'} 
        || Carp::croak("Missing hives 'layer' argument!")

    # Vorerst sind nur Module projektspezifisch
    ; my ($namespace,$modulepath,$moduleidx)
    ; if($layer eq Perl6::Junction::any('Module','Files'))
        { $namespace = $self->project->namespace 
        ; $modulepath = [$self->project->modulepath]
        ; $moduleidx = $self->project->module_index
        }
      else
        { $namespace = 'dIngle'
        ; $modulepath = $layer
        ; $moduleidx = 3
        }

    ; my @modules = @{$args{'modules'} || []}
    ; my @classes = @{$args{'classes'}}

    ; dIngle::Hive->set_layer($layer)
    ; dIngle::Hive->module_index($moduleidx)
    ; my ($unit)

    ; foreach my $module (@modules)
        {
        ; $module = $module->name if ref $module
        ; dIngle->currentmodule($module)
        ;
        ; foreach my $submodule (@classes)
            {
            ; my @unit = ($namespace,$modulepath,$module,$submodule)
            ; my $unit = dIngle->load('unit')->by_ns(@unit)->buildunit

            ; if($unit->is_ready || $layer eq 'Files')
                {# $setup->{$layer}->($unit,$self)
                }
            }
        }
    }

; sub set_all_formats
    { my ($self)=@_
    ; $self=_generator($self)

    ; my @formats = dIngle::Formats->load($self->_module)
    ; $self->formats([@formats])

    ; return $self
    }

# some modules should watch the folder too.
; sub add_default_dependencies
    { my ($self,$unit) = @_
    ; my $path = $unit->absfilename
    ; my ($volume,$directories,$file) = File::Spec->splitpath( $path )

    ; if($file =~ s/\..*$//)
        { my $dir  = File::Spec->catpath($volume,$directories,$file)
        ; if(-d $dir)
            {
                $unit->add_dependency($dir)
            }
        }
    }


    

; sub prebuild_check
    { my ($self,$module,$site) = @_

    ; my $dobuild = 1
    ; if(dIngle->isdef("PreBuild Check Module $module"))
        {
          $dobuild = dIngle->take("PreBuild Check Module $module")
        }

    ; if(ref($site) eq 'HASH')
        { my $file = $site->{'VisFile'}
        ; if(dIngle->can_do("PreBuild Check Format $file",$site))
            {
              $dobuild = dIngle->take("PreBuild Check Format $file")
            }
        }
      elsif($site->isa("dIngle::Formats::Chunks"))
        { my $file = $site->filename
        ; if(dIngle->can_do("PreBuild Check Chunk $file",$site))
            {
              $dobuild = dIngle->take("PreBuild Check Chunk $file",$site)
            }
        }
    ; return $dobuild
    }

; sub build_site
    { my ($self,$site,%args)=@_
    ; my @styles = dIngle->take("Build GetStyle",$site,%args)

    ; foreach my $style ( @styles )
        { dIngle->style_init($style)
        ; my $obj = $self->module->buildobject
            ( VisFormat => $site, VisStyle => $style, %$site )
        ; $obj->file_init

        ; if( $dIngle::KSEARCHFLD )
            { require dIngle::Tools::CSV
            ; my $csv = new dIngle::Tools::CSV
            ; my @lines
            ; foreach my $fld (values %{dIngle::Fields->fielddef_hash})
                { next unless $fld->{'ksearchpos'}
                ; push(@lines,[$fld->{'ksearchpos'} => $fld->{name}])
                }
            ; foreach my $row (sort { $a->[0] <=> $b->[0] } @lines)
                { $csv->addline($row)
                }
            ; print $csv->getcsv
            ; exit 0
            }
        ; if( $dIngle::DUMPFIELDS )
            { require Data::Dumper
            ; print Data::Dumper::Dumper(scalar dIngle::Fields->fielddef_hash)
            ; exit 0
            }

        ; $obj->take("Build Object",$args{'use_stdout'})
        }
    }

; sub get_chunks
    { my ($self,%args) = @_
    ; $self=_generator($self,%args)
    ; return dIngle::Formats::Chunks->load_module($self->module,%args)
    }

; sub build_chunk
    { my ($self,$chunk,%args) = @_
    ; my @styles = dIngle->take("Build GetStyle",$chunk->style_args(%args))

    ; foreach my $style ( @styles )
        { dIngle->style_init($style)
        ; my $obj = $chunk->gen_dingle($style,%args)
        ; $obj->chunk_init
        ; $obj->take("Build Object",$args{'use_stdout'})
        }
    }

########################
# Fehler sind ein TODO
########################
; sub has_errors
    { my ($self) = @_
    ; 0
    }

; 1

__END__

=head1 NAME

dIngle::Generator - bookkeeping for the generating environment

=head1 SYNOPSIS

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
