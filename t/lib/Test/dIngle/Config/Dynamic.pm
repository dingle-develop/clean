  package Test::dIngle::Config::Dynamic
# *************************************
; our $VERSION='0.02'
# *******************
; use strict; use warnings
; use Sys::Hostname ('hostname')

# Changes
#  0.02 - Verwendung von Hostnamen statt IP - die Ermittlung der eigenen IP
#         ist schwer plattformunabhängig zu implementieren und außerdem
#         kann bei mehreren Adressen das System selten selbst entscheiden, 
#         welches die korrekte ist.
#  0.01 - Versuch mit Sys::HostIP die IP als Kriterium zu verwenden.

# wrapper to set right config area
; sub get_config
    { my $res = {}
    ; $res->{'url'}->{'host'} = hostname()
    ; $res
    }

; 1

__END__

