  package dIngle::System::ModuleList;
# ***********************************
  our $VERSION='0.01';
# ********************
; use strict; use warnings; use utf8

; my @list =
    # Name                 , Short       , Prefix  , Buildable
    ([ 'Build'             , 'Build'     , 'Build' , 0]
    ,[ 'Utilities'         , 'Util'      , 'U'     , 0]
    )

; sub list { @list }

; 1

__END__

