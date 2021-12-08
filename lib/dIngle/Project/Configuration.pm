  package dIngle::Project::Configuration;
# ***************************************
  our $VERSION = '0.03';
# **********************
; use strict; use warnings; use utf8;

; use dIngle::Conf
; use dIngle::Log (_log => 'dIngle.config')

; sub new
    { my $class = shift
    ; my $self = { __config__ => {} }
    ; return bless( $self, $class )
    }

; sub retrieve
    { my ($self,%args) = @_
    ; foreach my $k (sort keys %args)
        { _log("debug","Config param $k: $args{$k}")
        }
    ; $self->{'__config__'} = dIngle::Conf->retrieve(%args)
    ; return $self->{'__config__'}
    }

; sub entry
    { my ($self,@path) = @_
    ; my $config = $$self{__config__}
    ; $config = $self->retrieve unless $config
    ; return $config unless scalar @path

    ; my $entry = $config->{$path[0]}
    ; for (1 .. (scalar @path - 1))
        { $entry = $entry->{ $path[$_] };
        }

    ; if(ref $entry eq 'HASH')
        { return  wantarray ? %$entry : $entry
        }
      elsif(ref $entry eq 'ARRAY')
        { return wantarray ? @$entry : $entry
        }
      else
        { return $entry
        }
    }

; sub instance 
    { $_[0]->entry('configuration')
    }

; 1

__END__

