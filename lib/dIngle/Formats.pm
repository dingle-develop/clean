  package dIngle::Formats
# *************************
; our $VERSION = '0.03'
# *********************
; use strict; use warnings; use utf8

; use Carp ()

########################
#     P R I V A T E
########################
; my %formatcache
; my %formatmap

; my $_fill_map = sub
    { my $modul = shift
    ; my $project = "" . $modul->project
    ; local $_
    ; my @formats = @{$formatcache{$project}{$modul}}
    ; $formatmap{$project}{$modul}{$_->{'VisFile'}} = $_ for @formats
    }

########################
#      P U B L I C
########################
; sub load
    { my $self   = shift
    ; my $modul  = shift
    ; Carp::croak("No module defined to load formats.") unless $modul
    ; Carp::croak("Module is not a dIngle::Module")
        unless $modul->isa('dIngle::Module')
    ; my $project = "" . $modul->project

    ; unless($formatcache{$project}{$modul})
        { eval
            { if(my $formatsclass = dIngle->load->formats($modul))
                { my $data = $formatsclass->setup($modul)
                ; die "Result of setup is not an array reference" 
                    unless ref($data) eq 'ARRAY'
                ; $formatcache{$project}{$modul} = $data
                ; $_fill_map->($modul)
                }
            }
        ; if($@)
            { Carp::croak "Failure during setup formats for $modul:\n".$@
            }
        }
    ; return unless defined $formatcache{$project}{$modul}
    ; wantarray ? @{$formatcache{$project}{$modul}}
                :   $formatcache{$project}{$modul}
    }

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

; sub get_format_title
    { my ($self,$modul,$formatname) = @_
    ; my $project = $modul->project . ""

    ; $self->load($modul)
    ; return dIngle::Formats->get_title
        ($formatmap{$project}{$modul}{$formatname})
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
