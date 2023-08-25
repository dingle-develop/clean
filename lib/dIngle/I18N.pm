  package dIngle::I18N
# ********************
; use strict; use warnings; use utf8;
  our $VERSION='0.07';
# ********************

#; use YAML::Syck
; use dIngle::Log ( _logger => 'dIngle.i18n' )

# Changes:
#   0.07 - enable yaml as text source
#   0.06 - can create language locale on the fly
#   0.05 - i18n function got a hash ref for finer control
#   0.04 - current_language replaces global var $LANGUAGE
#   0.03 - third try with own stuff
#        - pseudo support for .mo files droped

########################
#  Global Locale Handle
########################
#; sub Locale::Maketext::DEBUG () { 1 }
; use dIngle::I18N::Locale

########################
# Domain Locale Handle
########################
; use dIngle::I18N::Domain
; use dIngle::I18N::PO::Entry
; use dIngle::I18N::PO::File

; use Encode ()

; use Carp ()

########################
#      Base Class
########################
; use Class::Data::Localize
; { my ($mka,$self) = (\&Class::Data::Localize::mk_classdata,__PACKAGE__)
  ; $mka->($self,"current_language",undef)
  ; $mka->($self,"_all_languages",undef)
  }

; our $ALL_LANGUAGES = 0       # load all languages

# used to set the right place when .po files are created
; our $CALL = 0                # search for calling position higher in the stack frame

; our $DOMAIN = undef          # sometimes it is better to set the domain 
                               # from outside 

; our $LOCALEFILE_TMPL = "locale/%s/LC_MESSAGES/%s.%s"

; my %handle   # internal global i18n handle


; sub setup_handle
    { my ($self,$lang) = @_
    ; my $locale = dIngle::I18N::Locale->new
    ; my $handle = $locale->get_handle($lang)
    ; # Do not like the idea having a file which contains only 
      # C<our %Lexicon> variable. Unless more functionality is required
      
    ; unless($handle)
        { no strict 'refs'
		; my $module = ref($locale) . '::' . $lang
        ; @{$module . '::ISA'} = (ref $locale)
        ; %{$module . '::Lexicon'} = ()
        ; $handle = $module->new
	    }
    ; $handle{$lang} = $handle
    ; _logger('info',"Setup i18n handle of class " . ref($handle) . 
        " for '$lang'.")
    }

; sub get_handles
    { return %handle
    }
    
; sub all_languages
    { return sort keys %handle
    }
  
# for easy checking of current language  
; sub is_language
    { my ($self,$lang) = @_
    ; return lc($self->current_language) eq lc($lang)
    }
    
; sub maketext
    { my ($self,@args) = @_
    ; return Sub::Uplevel::uplevel
        ( 1, \& dIngle::I18N::i18n::i18n , @args )
    }

# keep it out of the inheritence tree
; package dIngle::I18N::i18n

; import from 'dIngle::I18N' => qw/_logger/

# aliasing an local - scheint zu klappen
; *CALL     = \$dIngle::I18N::CALL
; *DOMAIN   = \$dIngle::I18N::DOMAIN


; sub i18n
    { my ($key,@args) = @_
    
    # default
    ; my $html_encode = 1
    
    # new param interface
    ; if(ref $key eq 'HASH')
        { my %args = %$key
        ; $key  = $args{'msgid'}
        ; @args = $args{'args'} ? @{$args{'args'}} : ()
        ; $html_encode = 0 if $args{'no_html_encode'}
        }
    
    ; my $language = dIngle::I18N->current_language
    
    ########################
    #   CHECK REQUIREMENTS
    ########################	
    ; unless(defined $language)
        {
        	Carp::croak "No language. Maybe i18n_setup was not executed?"
        }
        
    ########################
    #     TEXTDOMAIN
    ########################
    ; my @caller = caller()
    ; my $domain
    
    ; if(ref($key) && $key->can('domain'))
        { $domain = $key->domain
        }
      else
        { if($DOMAIN)
            { $domain = $DOMAIN 
            }
          else
            { unless($caller[0]->can('domain'))
        	    { _logger("warn","Package $caller[0] does not have method domain: $@");
                  Carp::croak("Package $caller[0] does not have method domain: $@")
        	    }
        	; $domain = $caller[0]->domain() 
            }
        }
    ########################
    #    ENTRY OR STRING
    ########################
    ; unless(ref $key)
        { $key = dIngle::I18N::PO::Entry->new(msgid => [$key])
        
        ########################
        # GET POS WHERE IT WAS
        # CALLED FROM
        ########################
        ; my (@poscaller)
 
        ; if($dIngle::WRITEPO || dIngle::Config->debug_mode)
            { if($CALL)
                { # search where it was really called
                ; my $l=1+$CALL
                ; for( @poscaller = caller($l)
                     ; $l<100 && ( $poscaller[0] eq 'dIngle::Hive' 
                                 || $poscaller[0] eq 'dIngle'
                                 || !($poscaller[3] =~ /[tm]ake$/)
                                 )
                     ; @poscaller = caller(++$l) )
                    {# warn "$key $l $CALL @poscaller" 	
                    }
                }
              else
                {
            	     @poscaller = @caller 
                }
            
            # Hope this is the real place where it was called.
            ; $key->occurrence('<',"$poscaller[1]:$poscaller[2]")
            }
        }
        
    #########################
    # Prepare msgid
    #########################
    ; $key->sanitize_msgid

    ; my $return

    ; my %languages = dIngle::I18N::_get_language_source($domain)
    
    ; if(%languages)
        { unless(dIngle::I18N::Domain->exists_domain($domain))
            { dIngle::I18N::Domain->setup
                ( langsource => \%languages
                , domain     => $domain
                )
            }
        
        ; dIngle::I18N::_logger
            ("debug","$domain $language (po/mo) $key")
            ; $return = eval
                { dIngle::I18N::Domain->maketext
                    ( domain   => $domain
                    , language => $language
                    , msgid    => "$key"
                    , args     => \@args
                )}
            
        ; if($return)
            { dIngle::I18N::_logger
                ("debug","$domain $language (po/mo) $key => $return")
            }
        }
      else
        {
        	_logger("warn","no .po files for domain $domain")
        }
    # Otherwise use global lexicon
    ; unless(defined($return))
        { $return = dIngle::I18N::Locale::__maketext($handle{$language},"$key",@args)
        ; if($@)
            { _logger("warn","No such entry in global lexicon ($language): $key")
            ; if($dIngle::WRITEPO)
                { $key->msgstr('<',"$key")
                ; $key->maketext_to_gettext
                ; my %entry
                ; foreach my $lang (keys %languages)
                	{ $entry{$lang} = $key
                	}
                ; dIngle::I18N::Domain->add_entry
                    ( domain  => $domain
                    , entries => \%entry
                    )
                }
            	
            ; $return = "I18N_TODO"
            }
          elsif($dIngle::WRITEPO)
            { my %entry
            ; foreach my $lang (keys %languages)
                { my $msgstr = dIngle::I18N::Locale::__maketext
                    ($handle{$lang},"$key",@args)
                    
                ; my $entry = dIngle::I18N::PO::Entry->new
                    ( msgid  => ["$key"]
                    , msgstr => [$msgstr] 
                    )
                ; $entry->maketext_to_gettext
                ; $entry{$lang} = $entry
                }
            ; dIngle::I18N::Domain->add_entry
                    ( domain  => $domain
                    , entries => \%entry
                    )	
            }
        }

    ; if($html_encode)
        { return output($return)
        }
      else
        { return $return
        }
    }
    
; use HTML::Entities qw/encode_entities/  
  
; sub output
    { if( dIngle->backend eq 'CDML' )
        { return encode_entities($_[0]) # html only ???
        }
      else
        { return $_[0]
        }
    }
    
##########################
#    Precreate an entry
##########################
; sub e
    { my ($msgid) = @_
    ; my @poscaller = caller()
    ; my $entry = dIngle::I18N::PO::Entry->new
        ( msgid  => [$msgid]
        , domain => $poscaller[0]->domain 
        )
    ; $entry->occurrence('<',"$poscaller[1]:$poscaller[2]")
    ; return $entry
    }
 
 
# back again   
; package dIngle::I18N

; use File::Spec
    
; END
    { if( $dIngle::WRITEPO )
        { 
        	dIngle::I18N::Domain->writepo
        }
    }
    
#################################
# Creates a hash with language ids as keys
# and source filenames as values.
# TODO: How about to use a database for i18n?
#################################
; sub _get_language_source
    { my ($domain,$basedir) = @_
    ; our ($ALL_LANGUAGES,$LOCALEFILE_TMPL)
    ; my %languages
    ; $basedir ||= '.'

    ; my $localedir = $LOCALEFILE_TMPL
    ; my $language_source = sub
        { my ($lang)=@_
        ; my ($po,$mo) = map
            { File::Spec->catfile( $basedir,
                sprintf($localedir,$lang,$domain,$_) )
            } qw/po mo/
        ; my $mpo = -f $po ? (stat($po))[9] : 0
        ; my $mmo = -f $mo ? (stat($mo))[9] : -1
        
        ; if($mpo)
            { 
            	$languages{lc($lang)} = $mpo > $mmo ? $po : $mo 
            }
          else
            { Carp::carp "File '$po' not found."
            }
        }
        
    ; if($ALL_LANGUAGES)
        { foreach my $lang (dIngle::I18N->all_languages)
            { 
            	$language_source->($lang) 
            }
        }
      else
        { 
        	$language_source->(dIngle::I18N->current_language) 
        }
        
    ; return %languages
    }
    
#####################################################################
# FIRST I18N Implementation with one global Lexicon
#####################################################################

; sub addtext ($$)
    { my ($self,$hash)=@_
    ; our $ALL_LANGUAGES
    
    ; if ( $ALL_LANGUAGES )
        { $self->_addtext_alllang($hash) }
      else
        { $self->_addtext_currentlang($hash) }
    }
    
; sub _addtext_currentlang
    { my ($self,$hash)=@_
    ; my $language = dIngle::I18N->current_language
    
    ; my %h=%$hash
    
    ; my $base = ref $handle{$language}
    ; (my $cl=$base) =~ s/.*://

    ; { no strict 'refs'
      ; my $lexicon = \%{"${base}::Lexicon"}
      ; while(my($key,$entry) = each(%h) )
          { my $text = $entry->{$cl}
          ; Carp::croak("Can't find translation '$key' for language '$cl'")
              unless defined $text
          ; $lexicon->{$key}=$text
          ; _logger("debug","CURLANG $language $key = ".$lexicon->{$key})
          }
      }
    }
    
; sub _addtext_alllang
    { my ($self,$hash)=@_
    ; my %h=%$hash
    
    ; my $base = 'dIngle::I18N::Locale'
    ; my %lexi
    ; my $lexicon

    ; no strict 'refs'
    ; while(my($key,$entry) = each(%h) )
        { my %entry = %$entry
        ; while (my($lang,$text) = each(%$entry))
            { if( $lexi{$lang} )
                { $lexicon=$lexi{$lang}
                }
              else
                { $lexicon = $lexi{$lang} = \%{"${base}::${lang}::Lexicon"}
                }

            ; $lexicon->{$key}=$text
            ; _logger("debug","ALLLANG $lang => $key = ".$lexicon->{$key})
            }
        }
    }

; sub addtextdata
    { my %h
    ; my $p = caller
    ; _logger("debug","Load textdata for package $p")
    ; no strict 'refs'
    ; *FH = *{"${p}::DATA"}
    ; while(my $l=<FH>)
        { next if $l =~ /^\s*$/
        ; my @lang=map {s/^\s*//; s/\s*$//s; $_ } split /\|/,$l
        ; $h{$lang[0]}={de=>$lang[1],en=>$lang[2]}
        }
    ; $_[0]->addtext(\%h)
    }
    
; sub addtextdata_yaml
    { my %h
    ; my $p = caller
    ; _logger("debug","Load yaml data from package $p")
    ; no strict 'refs'
    ; *FH = *{"${p}::DATA"}
    ; my $str = join('',<FH>)
    ; $_[0]->addtext_yaml($str)
	}
	
; sub addtext_yaml
    { my ($self,$str) = @_
    ; my ($data) = YAML::Syck::Load($str)
    ; my %hash
    ; foreach my $lang (keys %$data)
        { foreach my $key (keys %{$data->{$lang}})
            { $hash{$key}->{$lang} = $data->{$lang}{$key}
		}}
	; $self->addtext(\%hash)
    }

; 1

__END__

=head1 NAME

dIngle::I18N - simple interface for internazionalisation

=head1 SYNOPSIS

The current language is set by configuration entry:

  <i18n>
    use        de
    language   de
    language   en
  </i18n>
  
  
  
=head1 DESCRIPTION

This handles the simple cases of i18n use for dIngle. 

=head2 i18n_setup

Do not forget this if you want to use this class directly.

=head2 addtext

This function supports two behaviours. If C<dIngle::I18N::ALL_LANGUAGES>
is true, phrases for all languages are stored in the Language Lexicon. The 
default is false, which means only the current language is setted up during
initialization process.

=head2 addtextdata

This function reads the entries as comma separated values from
the special DATA filehandle in the invoking package. The Seperator
character is the pipe symbol '|'. All leading and trailing whitespace is 
removed from the entries when they are processed.

=cut

