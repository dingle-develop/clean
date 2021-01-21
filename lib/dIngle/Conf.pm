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

; sub detect_instance
    { my ($pkg,$configfile)=@_
	; $configfile ||= 'instances.conf'
    ; my $instanceconfig = Path::Tiny::path($_configpath)->child($configfile)

    ; my $instance = dIngle::Instance->new()
    ; $instance->from_configfile($instanceconfig)->detect()

    ; return $instance
    }

; sub retrieve
    { my ($self,%args) = @_
    ; my $tempinstance = !! $args{'instance'} && defined($config)
    ; return $config if !$tempinstance && defined($config)

    ; my $project = delete($args{'project'}) || 'dingle'
    ; $args{'source'} ||= Path::Tiny::path($_configpath)->child("${project}.conf")

    ; my $realinstance  = dIngle::Conf->detect_instance()
    ; $args{'instance'} ||= $realinstance
    
    ; _log("info","Load config from file $args{'source'}")
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

; 1

__END__

=head1 NAME

dIngle::Conf

=head2 Environment variables

Diese Funktion lädt ohne Parameter die passende Konfiguration automatisch.
Verantwortlich dafür ist die Methode C<detect_instance>, die über das OS und
die IP den richtigen Parameter sucht. Wird der Parameter C<< instance => ... >>
angegeben so wird die Konfiguration nicht gecacht sondern nur diese Instanz
als Rückgabewert geliefert.

Als zweiter Parameter kann mit C<< config_file => ... >> eine alternative
Konfigurationsdatei angegeben werden.

=cut
