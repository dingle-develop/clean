  package dIngle::Tasks;
# **********************
  our $VERSION='0.03';
# ********************
; use strict; use warnings; use utf8

; use subs qw/import/

; use HO::class

########################
# indirect use of import
########################
; use dIngle::Generic ()
; use dIngle::Hive::API ()
; use dIngle::Tasks::Perform ()

; BEGIN
    { our %REQUEST_MAP = ()

    ; sub import
        { my ($self,%args) = @_

        ; if(my @requested = @{$args{'with'}||[]})
            { foreach my $sub (@requested)
                { if(my $mod = $REQUEST_MAP{$sub})
                    { export from $mod => $sub
                    }
                  else
                    { Carp::carp
                        ( "There is no package defined for subroutine $sub during "
                        . "import from dIngle::Tasks in ".caller."." )
                    }
                }
            }

        ; export from 'dIngle::Hive::API' => qw/alias const task/
        ; export from 'dIngle::Tasks::Perform' => qw/make prepare/
        ; export from 'dIngle::Generic'
            => vishtml     # HTML Elemente
            => visform     # Eingabeelemente
            => visstyle    # Stylesheet
            => vismarkup   # CDML und co
            => visscript   # Javascript
            =>

        ; export from _ => qw/Debug/
        ; export from 'dIngle::I18N::i18n' => qw/i18n/
        ; export from 'HO::Common' => qw/node newline/

        # now I can spare one line more without a loss on functionality
        ; strict->import
        ; warnings->import
        ; warnings->unimport('void')
        ; utf8->import
        }
    }

; sub domain
    { my $self = (ref $_[0] ? ref $_[0] : $_[0])
    ; return lc(join "_", splice(@{[split(/::/, $self)]},1,2))
    }

; sub setup_submodules
    { my ($pkg,@submodules) = @_
    ; my $class = ref($pkg) || $pkg
    ; my @mod = split /::/,$class
    ; my $act = pop @mod
    ; foreach my $submod ( @submodules )
        { my @moddef = (@mod,$submod)
        ; $pkg->_setup_code_unit(\@moddef)
        }
    }

; sub use_submodule
    { my ($pkg,$modul,@sub)=@_
    ; my @gen    = split /::/,$pkg
    ; my @moddef = (@gen[0,1],$modul,@sub)
    ; $pkg->_setup_code_unit(\@moddef)
    }

# this is private because it does not take care of the current container
# what is ok for the two methods above but not if it is in public use.
; sub _setup_code_unit
    { my ($self,$unitdef) = @_

    ; my $unit = dIngle->load('unit')->by_ns(@$unitdef)->buildunit
    ; if($unit->is_ready)
        { $unit->modulename->setup
        }
      else
        { Carp::croak("Failure setup module " . $unit->modulename.":\n $@")
        }
    }

; 1

__END__

=head1 NAME

dIngle::Tasks

=head1 SYNOPSIS

    package dIngle::Module::Something::Tasks;
    use basis 'dIngle::Tasks';

    sub setup
        {

    __PACKAGE__->setup_submodules('Links')
    __PACKAGE__->use_submodule('User','Auth')

        }

=head1 DESCRIPTION

This module is the base class for all B<tasks> modules. Some useful methods
are implemented used to be statically called. The main purpose for this  is
that it exports all functions needed to define B<tasks>.

=head2 Static Methods

=over 4

=item C<setup_submodules>

=item C<use_submodule>

=item C<task_caller>

Returns the file and the line number from where the current task is called.

=back

=head2 Exported Functions

... is a todo
