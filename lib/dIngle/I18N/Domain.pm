  package dIngle::I18N::Domain
# ******************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8

; use IO::File
; use Locale::Maketext

; use dIngle::I18N::PO::File
; use dIngle::Log ( _logger => 'dIngle.i18n.domain' )

# store the PO-File objects
; my %Files
; my %Lexicon

#########################################
# Check if the lexicon for a given
# domain is already created
#########################################
; sub exists_domain
    { my ($self,$domain) = @_
    ; exists $Lexicon{$domain}
    }

#########################################
# Creates for each used domain and language
# an object in the global lexica.
#########################################
; sub setup
    { my ($self,%args) = @_
    ; local $_
    ; # required arguments:
      #    langsource => a hash ref wich maps langs to files
      #    domain     => used i18n domain name
    ; my %languages = %{$args{'langsource'}}
    ; my $domain    = $args{'domain'}
    ; my %result

    ; my $namespace = "dIngle::I18N::domain::" . $domain

    ; _logger("debug","Create Package $namespace")

    ; eval "package $namespace; our \@ISA = qw/Locale::Maketext/"
    ; Carp::croak("Error during setup textdomain $domain") if $@

    ; foreach my $lang (keys %languages)
        { my $export = join('::',$namespace,$lang)
        ; _logger("debug","Create Package $export")
        ; eval "package $export; our \@ISA = qw/$namespace/"
        ; Carp::croak("Error during setup textdomain $domain / $lang") if $@

        ; $Files{$domain}{$lang} =
            $self->load_po_file
                ( domain   => $domain
                , language => $lang
                , source   => $languages{$lang}
                )
        ; my %lexicon =
            map { ($_->maketext_entry) } $Files{$domain}{$lang}->entries

        ; { no strict 'refs'
          ; *{"$export\::Lexicon"} = { %{"$export\::Lexicon"},%lexicon }
          }

        ; _logger("debug","$_ -- $lexicon{$_}") foreach keys %lexicon

        ; $result{$lang} = $namespace->get_handle($lang)
        }

    ; $Lexicon{$domain} = \%result
    }

; sub load_po_file
    { my ($self,%args) = @_
    ; my $domain   = $args{'domain'}
    ; my $language = $args{'language'}
    ; my $source   = $args{'source'}

    ; my $fh = IO::File->new($source,'<:encoding(UTF-8)')
        or Carp::croak("Can't open filehandle: $source")

    ; my $file = dIngle::I18N::PO::File->new
        ( domain   => $domain
        , filename => $source
        )
    ; return $file->process_fh($fh)
    }

; sub maketext
    { my ($self,%args) = @_

    ; my $domain = $args{'domain'}
    ; my $lang   = lc($args{'language'})
    ; my $key    = $args{'msgid'}
    ; my @args   = @{$args{'args'}}
    ; my $debuginfo =  "\ndomain: $domain\n"
                     . "language: $lang\n"
                     . "msgid: $key"

    ; my $error = sub
        { my $msg = join("\n",@_) . $debuginfo
        ; _logger("error",$msg)
        ; Carp::croak($msg)
        }

    ; my $handle = $Lexicon{$domain}{$lang}
    ; $error->("Undefined I18N handle used!") unless($handle)

    ; my $return = eval { $handle->maketext($key,@args) }
    ; if($@)
        { $error->("Error retrieving message via maketext: ".$@)
        }
    ; unless(defined $return)
        { my $msg = "Undefined return value frome maketext.$debuginfo"
        ; _logger("warn",$msg)
        }
    ; return $self->process_maketext_result($return)
    }

; sub process_maketext_result
    { my ($self,$result) = @_
    ; $result =~ s/\\n/\n/g
    ; return $result
    }

##########################
#      W R I T E P O
##########################
; sub add_entry
    { my ($self,%args) = @_
    ; my $domain  = $args{'domain'}
    ; my %entries = %{$args{'entries'}}

    ; foreach my $lang (keys %entries)
        {
          $Files{$domain}{$lang}->entries('<',$entries{$lang})
        }
    }

; sub writepo
    { my ($self) = @_
    ; foreach my $domain (keys %Files)
        { foreach my $lang (keys %{$Files{$domain}})
            { my $entryfile = $Files{$domain}{$lang}
            ; my $filename  = $entryfile->filename
            ; my $fh = IO::File->new($filename,'>:utf8')
                or Carp::croak("Can't open filehandle for writing: $filename")
            ; $entryfile->write_fh($fh)
            }
        }
    }

; 1

__END__
