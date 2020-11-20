  package dIngle::Modules
# ***********************
; our $VERSION = '0.02'
# *********************
; use strict; use warnings; use utf8

; use dIngle ()
; use dIngle::Module ()

; use dIngle::Log (_log => 'dIngle.project.modules')

; use Carp ()
; use Path::Tiny ()
; use File::Spec ()

; use subs 'init'

; use HO::class
    _ro => path => '@',
    _ro => modules => '@',
    _ro => namemap => '%',
    _ro => formatmap => '%'

; sub init
    { my ($self,%opts) = @_
    ; $opts{'path'} = [split( /::/, $opts{'path'})] unless ref $opts{'path'}
    ; $self->[_path] = $opts{'path'}

    ; my $setup
    ; if(defined $opts{'listfile'})
        { $setup = $self->_setup_by_listfile(%opts)
        ; _log("info","$setup modules loaded")
        }
    ; unless($setup)
        { $self->_setup_by_directory(%opts) unless $opts{'nodirscan'}
        }
    ; $self
    }

; sub names
    { my ($self) = @_
    ; return keys %{$self->namemap}
    }

; sub fetch
    { my ($self,$name) = @_
    ; return $self->namemap->{lc $name} || Carp::croak
        "Can't fetch unknown module '$name'."
    }

; sub add_module
    { my ($self,$module) = @_
    ; my @caller = caller
    ; _log('debug' => sprintf("Module '$module' loaded from %s",$caller[0]))
    ; push @{$self->[_modules]},$module
    ; $self->[_namemap]->{lc $module->name} = $module
    ; $self
    }

; sub _setup_by_listfile
    { my ($self,%opts) = @_
    ; my $unit = dIngle->load('unit')->by_ns
        ($self->path,$opts{'listfile'})->buildunit
    ; if($unit->is_ready)
        { my $modulelist = $unit->modulename
        ; my @list = $modulelist->list
        ; foreach my $moddef (@list)
            { my $moduleclass = $self->_module_class($opts{'class'},$modulelist)
            ; _log('debug', "Use module class $moduleclass.")
            ; $self->add_module($moduleclass->new($moddef))
            }
        ; return scalar @list
        }
    ; return 0
    }

; sub _setup_by_directory
    { my ($self,%opts) = @_
    ; my $unit = my $dirinfo = dIngle->load('unit')
	    ->by_ns($self->path,'DirInfo')->buildunit
    ; if($unit->has_error)
        { Carp::croak("Module DirInfo Failure: " . join("\n",@{$unit->errors}))
        }
    
    ; unless( $dirinfo->is_ready )
        { $dirinfo = dIngle->load('unit')->by_ns('dIngle::Module::DirInfo')->buildunit
        ; if( $dirinfo->has_error)
            { Carp::croak("Default DirInfo Failure: " . join("\n",@{$unit->errors}))
            }
        }

    ; my $path
    ; if( $unit->is_ready )
        { $path = Path::Tiny::path($unit->realpath)
        }
      else
        { foreach my $inc (@INC)
            { next if ref $inc
            ; my $p = Path::Tiny::path($inc)->child($unit->filename)->parent
            ; _log(debug => "Check path $p")
            ; if( $p->is_dir )
               { $path = $p
               ; last
               }
            }
        }
    ; if( $path )
        { foreach my $entry ($path->children)
            { next unless $entry->is_dir
            ; _log(debug => "Found module directory $entry")
            ; my $di = $dirinfo->modulename->new($self->path,$entry->basename)
            ; my $moduleclass = $self->_module_class
                ($opts{'class'},$di,$di->module_args)
            ; my $module = $moduleclass->new($di->module_args)
            ; $self->add_module($module)
                unless defined $self->namemap($module->name)
            }  
        }
    }

; sub _module_class
    { my ($self,$class,$setup,$moddef) = @_
    ; local $@
    ; $class ||= $setup->module_class($moddef)
        if $setup->can('module_class')
    ; $class ||= 'dIngle::Module'
    ; unless( $class->can('new') )
        { my $unit = dIngle->load('unit')->by_pkg($class)->buildunit
        ; unless($unit->is_ready)
            { Carp::croak("$class not found.")
            }
        }
    ; $class
    }

; sub sort_modules
    { my ($self,$coderef) = @_
    ; $self->[&_modules] = [$coderef->($self->[&_modules])]
    }

; sub with_submodule
    { my ($self,$submodule) = @_

    ; my @list
    ; foreach my $module ($self->modules)
        { push @list,$module
            if $module->has_submodule($submodule)
        }
    ; return @list
    }

##########################
# Helper Methods old
##########################
; sub module_with_format
    { my ($self,$formatname) = @_
    ; unless(%{$self->formatmap})
        { my $fmap = {}
        ; foreach my $module ($self->modules)
            { foreach my $format ($module->formats)
                { $fmap->{"$format"} = $format
                }
            }
        ; $self->[&_formatmap] = $fmap
        }
    ; if(my $format = $self->formatmap->{$formatname})
        { return $format->module
        }
    ; return
    }

; 1

__END__

=head1 NAME

dIngle::Modules

=head1 DESCRIPTION


=head2 Object methods

=over 4

=item sort_modules

This method takes a coderef. this coderef is called with the array
reference of the modules and it should return a sorted list of the modules.
This method can filter the list. Modules removed this way are kept in
the module hash. So fetching a module by name still works.

=back

=head2 Helper methods

=over 4

=item with_submodule

Returns a list wth all modules, which contain a gven submodle like
Tasks, I18n, Formats, etc.

=item module_with_format

Returns the module for a given formatname.

=back

=head1 TODO

setup_by_namespace ?

=head1 CHANGELOG

   # 0.02 - 2017-04-26
   #   - module object class can now be specified by module definition 
   #     classes
