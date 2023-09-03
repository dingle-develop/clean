  package dIngle::Loader;
# ***********************
  $VERSION = '0.02_001';
# ******************
; use strict; use warnings; use utf8

; use Carp ()
; use Shari::Code::Unit

; use dIngle::Loader::Structure ()

; use dIngle::Log
    _log_structure => 'dIngle.builder.structure',
    _log_group => 'dIngle.builder.groups',
    _log_formats => 'dIngle.builder.loadformats',
    _log_unit => 'dIngle.builder.unit'

; our %returns
; BEGIN:
    { %dIngle::Loader::returns =
        ( 'new' => sub 
            { my ($self,@rgs) = @_
            ; $self->unit->modulename->new(@rgs) 
            }
        , 'modulename' => sub 
            { $_[0]->unit->is_ready ? $_[0]->unit->modulename : undef 
            }
        , 'unit' => sub { $_[0]->unit }
        )
    }

; use HO::class
    _rw => unit => '$',
    _ro => _returnargs => '@',
    _method => _returnmethod =>  sub 
        { $_[0]->unit->is_ready ? $_[0]->unit->modulename : undef 
        }

########################
# Public one method API
########################
; sub load
    { my $self = shift
    ; my $loader = __PACKAGE__->new
    ; $loader->_setup_return(@_) if @_
    ; return $loader
    }

################################################################################

; sub _setup_return
    { my ($self,$doforreturn,@args) = @_
    ; our %returns
    ; $doforreturn ||= 'modulename'
    ; $self->[__returnargs] = \@args

    ; unless(ref($self->[&__returnmethod] = $returns{$doforreturn}) eq 'CODE')
        { Carp::carp("Returnmethod '$doforreturn' is not defined.")
        }
    ; return $self
    }

; sub _return
    { my ($self) = @_
 #   ; $self->[__returnmethod] = $returns{'modulename'} unless $self->_returnmethod
 #   ; dIngle->dump($self)
    ; if(wantarray)
        { my @return = $self->_returnmethod($self->_returnargs)
        ; return @return
        }
      else
        { my $return = $self->_returnmethod($self->_returnargs)
        ; return $return
        }
    }

################################################################################

; sub by_pkg
    { my ($self,$pkg) = @_
    ; $self->unit( Shari::Code::Unit->spawn(split /::/,$pkg))
    ; return $self
    }

; sub by_ns
    { my $self = shift
    ; my @ns = map { (split /::/,$_) } 
               map { ref($_) eq 'ARRAY' ? @$_ : $_ } @_
    ; $self->unit( Shari::Code::Unit->spawn(@ns));
    ; return $self
    }

################################################################################

; sub fieldsgroup
    { my ($self,$group,$namespace) = @_
    ; unless($self->unit)
        { unless(defined $group)
            { Carp::croak("No Fieldgroup specified.")
            }
        ; $namespace = ['dIngle','Fields','Group'] unless $namespace
        ; $namespace = [split /::/,$namespace] unless ref $namespace eq 'ARRAY'
        ; $group     = [split /::/,$group] unless ref $group eq 'ARRAY'
        ; $self->by_ns(@$namespace,@$group)
        }

    ; if($self->unit->is_ready)
        { _log_group('info','Fieldsgroup ' . $self->unit->modulename . ' geladen.')
        ; return $self->_return
        }
      else
        { my $errmsg = "Fields Group " . $self->unit->modulename ." konnte nicht geladen werden."
        ; _log_group('error',$errmsg)
        ; Carp::croak($errmsg)
        }
    }

; sub structure
    { my ($self,@args) = @_

    ; unless( defined $self->unit )
        { my @search = map { [@$_, @args] }
            @{dIngle::Loader::Structure->namespaces}

        ; foreach my $sp (@search)
            { $self->by_ns(@$sp)

            ; if($self->unit->is_ready)
                { _log_structure("info","Load structure: " . $self->unit->modulename)
                ; return $self->_return
                }
            ; unless($self->unit->has_error)
                { _log_structure("debug","Not loading structure unit: " . $self->unit->modulename)
                }
            }
        }

    ; return $self->_return unless $self->unit->has_error

    ; my $errmsg = "Failure loading structure " . $self->unit->modulename . ": \n" .
        $self->unit->get_error();
    ; _log_structure("error",$errmsg)
    ; Carp::croak($errmsg)
    }

; sub formats
    { my $self = shift
    ; $self->module_component('formats',@_)
    }

; sub chunks
    { my $self = shift
    ; $self->module_component('chunks',@_)
    }

; sub configuration
    { my $self = shift
    ; $self->module_component('configuration',@_)
    }

; sub module_component
    { my ($self,$type,$module) = @_
    ; my $project = $module->project

    ; unless(defined $self->unit)
        { $self->by_ns($project->namespace,
                       $project->modulepath, $module, ucfirst($type))
        }
    ; if($self->unit->is_ready)
        { _log_formats("info","Load $type: " . $self->unit->modulename)
        ; return $self->_return
        }
    ; unless($self->unit->has_error)
        { _log_formats("debug","Not loading $type unit: " . $self->unit->modulename)
        ; return $self->_return
        }
    ; my $errmsg = "Failure loading $type unit " . $self->unit->modulename . ":\n" .
        $self->unit->get_error();
    ; _log_formats("error",$errmsg)
    ; Carp::croak($errmsg)
    }

; sub buildunit
    { my ($self) = @_

    ; if($self->unit->is_ready)
        { _log_unit("info","Load unit: " . $self->unit->modulename)
        ; return $self->_return
        }
    ; unless($self->unit->has_error)
        { _log_unit("debug","Not loading unit: " . $self->unit->modulename)
        ; _log_unit("debug","Cannot find file: " . $self->unit->filename)
        ; return $self->_return
        }
    ; my $errmsg = "Failure loading build unit: " . $self->unit->modulename
                 . "\n" . $self->unit->get_error
    ; _log_unit("error",$errmsg)
    ; Carp::croak($errmsg)
    }


; 1

__END__

=head1 NAME

dIngle::Loader

=head1 SYNOPSIS

   $filminfo = dIngle->load('new')->fieldsgroup('Filminfo');


=head1 DESCRIPTION
