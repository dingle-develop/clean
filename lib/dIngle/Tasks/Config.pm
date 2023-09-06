  package dIngle::Tasks::Config
# *****************************
; our $VERSION='0.01'
# *******************

; use strict; use warnings; use utf8


; sub default
   { my ($config,@path) = @_
   ; my $value = pop @path
   ; Carp::croak "An empty path is not allowed for configuration default value."
       unless @path
   ; my $key
   ; while( @path )
       { $key = shift @path
       ; if(@path)
           { $config->{$key} = {} unless defined $config->{$key}
           ; $config = $config->{$key}
           }
       }
   ; unless(defined $config->{$key})
       { $config->{$key} = $value
       }
   ; return $config->{$key}
   }
   
; 1

__END__


