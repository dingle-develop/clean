  package dIngle::Instance
# ************************
; our $VERSION = '0.02'
# *********************
; use strict; use warnings; use utf8

; use HO::class
    _rw => name => '$',
    _rw => fallback => '$',
    _rw => configuration => '$'

; use Sys::Hostname ()
; use Perl6::Junction ()
; use Carp ()

; use overload
    '""' => sub { return  $_[0]->name || do
        { Carp::croak("Name of instance not defined, call detect to set the name!")
        ; return ''
        }},
    'cmp' => sub { $_[0]->name cmp $_[1] }

; sub from_configfile
    { require Config::General
    ; my ($self,$configfile) = @_
    ; my $cg = new Config::General::(
        -ConfigFile => $configfile, 
        -ExtendedAccess => 1)
    ; $self->configuration($cg)
    ; return $self
    }

; sub _fetch_fallback
    { my ($self) = @_
    ; my $fallback = $self->configuration->obj('fallback');
    ; return $fallback->value('instance')
    }

; sub _check_isinstance
    { my ($self,$config,$name) = @_
    ; Carp::croak "Instance configuration without a name."
        unless $name or $name = $config->value('name')

    ; if($config->exists('hostname'))
        { my @hostnames = $config->is_array('hostname') 
            ? $config->array('hostname') : $config->value('hostname')
        ; if(Sys::Hostname::hostname() eq Perl6::Junction::any(@hostnames))
            { return $name
            }
        }
    ; if($config->exists('os'))
        { my @os = map { lc } $config->is_array('os') 
             ? $config->array('os') : $config->value('os')
        ; if(lc($^O) eq Perl6::Junction::any(@os))
            { return $name
            }
        }
    ; undef
    }

; sub detect
    { my ($self) = @_
    ; $self->fallback($self->_fetch_fallback)

    ; my $obj = $self->configuration->is_array('instance') 
        ? $self->configuration->obj('instance')
        : [ $self->configuration->obj('instance') ]
    ; foreach my $config (@$obj)
        { my $name = $self->_check_isinstance($config)
        ; if($name)
            { $self->name($name)
            ; last
            }
        }
    ; unless($self->name)
        { Carp::carp("Fallback configuration used.")
        ; $self->name($self->fallback)
        }
    ; return $self
    }

; 1

__END__

=head1 NAME

dIngle::Instance

=head1 SYNOPSIS

    my $instance = dIngle::Instance->new();
    $instance->from_configfile($instanceconfig)->detect();

=head1 DESCRIPTION

Semiautomatical detection which instance should be chosen. The
concept of instance is similar to environment, which is usualy
development, production or testing.

Each project can have different instances. They needs to be
configured in the config file C<instances.conf>. This config file
is written in Config::General syntax.

   <instance>
       name     testsystem
       hostname dingletest
   </instance>

   <instance>
       name     production
       hostname dingleserv
       hostname fmserver
   </instance>

   <instance>
       name     demosystem
       hostname dingledemo
   </instance>

   <instance>
       name freerunner
       os linux
   </instance>

   <fallback>
      instance testsystem
   </fallback>
   
Each instance has a name and at least one property.

=head2 Supported Properties

=over 4

=item hostname

=item os

=back
