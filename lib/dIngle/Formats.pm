  package dIngle::Formats
# *************************
; our $VERSION = '0.03'
# *********************
; use strict; use warnings; use utf8

; use Carp ()


########################
#      P U B L I C
########################


# for dynamically created formats this module creates unique ids
# this id is not necessarily unique between different runs
; { my $cnt = 1000
  ; sub getID()
      { return $cnt++
      }
  }

################################
#         Formats Format
################################
#    { format_id => '229', stylecategory => 'basic',
#      title_deu => 'Filmarchiv Suche',
#      title_eng => 'Film Archive- Search',
#      VisType  => 'SEARCH', VisFile => 'archivfilmssuche', VisDB => 'archiv_filme.fp5',
#      VisProt => 0  },
; my $format_sort = sub
    { my $sortfield = shift
    ; my $numeric =
        { format_id => 1
        , VisProt   => 1
        }
    ; if($numeric->{$sortfield})
        { return sub { $a->{$sortfield} <=> $b->{$sortfield} }
        }
      else
        { return sub { $a->{$sortfield} cmp $b->{$sortfield} }
        }
    }

; sub filter_and_sort
    { my ($self,%args) = @_
    ; $args{'filter'}    ||= undef
    ; $args{'filterarg'} ||= undef
    ; $args{'sort'}      ||= 'format_id'
    ; $args{'module'}    ||= dIngle->module
    ; $args{'paranoid'} = 1 unless defined($args{'paranoid'})

    ; my @formats
    ; foreach my $frm ( $self->load($args{'module'}) )
        { if( $args{'filter'} )
            { next unless defined $frm->{$args{'filter'}}
            ; next unless $args{'filterarg'} eq $frm->{$args{'filter'}}
            }
        ; push @formats,$frm
        }
    ; if($args{'paranoid'})
        { Carp::confess "No format with filter $args{'filter'} and value $args{'filterarg'}."
            unless @formats
        }
    ; my $sortref = $format_sort->($args{'sort'})
    ; sort $sortref @formats
    }

; sub first_with_type
    { my ($self,$type,$mod,$paranoid) = @_
    ; $mod = _module_default($mod)
    ; $mod = _module_ok($mod)
    ; [ $self->filter_and_sort
            ( filter => 'VisType'
            , filterarg => $type
            , module => $mod
            , paranoid => $paranoid
            )
      ]->[0]
    }

; sub first_with_db
    { my ($self,$db,$mod) = @_
    ; $mod = _module_default($mod)
    ; $mod = _module_ok($mod)
    ; [ $self->filter_and_sort
        ( filter => 'VisDB', filterarg => $db, module => $mod )
      ]->[0]
    }

; sub all_with_linkclass
    { my ($self,$module,$class) = @_
    ; $module = _module_ok($module)
    ; my @formats = $self->filter_and_sort
        ( filter => 'linkclass', filterarg => $class, module => $module )
    ; return wantarray ? @formats : \@formats
    }

; sub _module_default
    { my $mod = shift
    ; return $mod if defined $mod
    ; return dIngle->module
    }

; sub _module_ok
    { my $mod = shift
    ; return $mod if ref($mod) && $mod->isa('dIngle::Module')
    ; return dIngle->get_module($mod)
    }

########################
# Utility Functions for
# Format Hashes
########################
; sub get_title
    { my ($self,$format) = @_
    ; my $lang = dIngle::I18N->current_language
    ; my %map  = ( de => 'title_deu', en => 'title_eng' )
    ; my $acc  = $map{$lang} || 'title_deu'
    ; return $format->{$acc}
    }

########################
# List of formatnames
########################
; sub list_formatnames
    { my ($self,$module) = @_
    ; return map { $_->{'VisFile'} } $self->load($module)
    }

; 1

__END__
