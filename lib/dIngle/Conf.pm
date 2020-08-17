  package dIngle::Conf
# ********************
; our $VERSION='0.03'
# *******************
; use strict; use warnings; use utf8
; use Shari::Conf

; use dIngle::Log (_log => 'dIngle.config')

; Shari::Conf->register_config_provider
    (
        'PerlModule', sub
            { my ($self,$module,$method) = @_
            ; eval "require $module"
            ; die "Can't load module $module as config provider." if $@
            ; $self->merge_config($module->$method)	
            }
    )

; use Carp ()
; use Data::Dumper ()
; use Path::Tiny ()

; use dIngle::Instance ()

; my $_configpath = dIngle::Light->configpath
; my $config

; sub import
    { my ($pkg,$instance)=@_
    ; $pkg->retrieve(instance => $instance) if $instance
    }

; sub detect_instance
    { my ($pkg,$nomsg)=@_
    ; my $instanceconfig = Path::Tiny::path($_configpath)->child('instances.conf')

    ; my $instance = dIngle::Instance->new()
    ; $instance->from_configfile($instanceconfig)->detect()

    ; return $instance
    }

; sub retrieve
    { my ($self,%args) = @_
    ; my $tempinstance = !! $args{'instance'} && defined($config)
    ; return $config if !$tempinstance && defined($config)

    ; my $project = delete($args{'project'}) || 'dingle'
    ; $args{'config_file'} ||= Path::Tiny::path($_configpath)->child("${project}.conf")

    ; my $realinstance  = dIngle::Conf->detect_instance()
    ; $args{'instance'} ||= $realinstance
    
    ; _log("info","Load config from file $args{'config_file'}")
    ; _log("info","Config instance is $args{'instance'}")
    ; my $c = Shari::Conf->load_main_config(\%args)

    #########################
    # Some Required Presets
    #########################
    ; $c->{'realinstance'} = $realinstance
    ; $c->{'virtualmode'}  = $realinstance eq $c->{'configuration'} ? 0 : 1
        if defined $c->{'configuration'}
    ; $c->{'configuration'} = $args{'instance'}
        unless defined $c->{'configuration'}

    ; $config = $c unless $tempinstance
    ; $c
    }

; sub entry
    { my ($self,$key)=@_
    ; $self->retrieve unless $config
    ; unless( exists $config->{$key} )
        { Carp::carp("No entry $key in current config.")
        ; return undef
        }
    ; if( ref $config->{$key} )
        { return wantarray ? %{$config->{$key}} : $config->{$key}
        }
      else
        { return $config->{$key}
        }
    }

; sub dump
    { print Data::Dumper::Dumper(\$config) }

; sub destroy
    { $config=undef
    }

# TODO modernization
; { my %extensions
  ; sub _extend
      { my ($self,$section,$filename) = @_
      ; Carp::croak("Configuration should be extended after loading.")
          unless $config

      ; my $file = $_configpath . $filename

      ; unless(-f $file)
          { Carp::croak("Configuration extension $filename does not exist.")
          }

      ; return if $extensions{$file}

      ; my $cfg = new Config::General( -ConfigFile => $file, '-UTF8' => 1)

      ; $config = Hash::Merge::merge($config,{$section => {$cfg->getall}})

      ; $extensions{$file} = 1
      }
  }

; 1

__END__

=head1 NAME

dIngle::Conf

=head2 Environment variables

   VISCONTI_CONFIG_PATH

=head2 retrieve -- lade eine Konfiguration

Diese Funktion lädt ohne Parameter die passende Konfiguration automatisch.
Verantwortlich dafür ist die Methode C<detect_instance>, die über das OS und
die IP den richtigen Parameter sucht. Wird der Parameter C<< instance => ... >>
angegeben so wird die Konfiguration nicht gecacht sondern nur diese Instanz
als Rückgabewert geliefert.

Als zweiter Parameter kann mit C<< config_file => ... >> eine alternative
Konfigurationsdatei angegeben werden.

=cut
