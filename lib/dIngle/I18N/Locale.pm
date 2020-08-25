  package dIngle::I18N::Locale
# ****************************
; our $VERSION='0.02'
# *******************
; use strict; use warnings
; use parent 'Locale::Maketext'


; sub __maketext
    { my ($handle,$key,@args) = @_
    ; unless($handle)
        { Carp::croak("Undefined I18N handle used: $key")
        }
    ; return $handle->maketext($key,@args)
    }

; 1

__END__

