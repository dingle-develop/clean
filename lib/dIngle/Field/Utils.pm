  package dIngle::Field::Utils
# ****************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8

; use dIngle

; sub dbfield
    { my ($fieldname,@args)=@_
    ; dIngle->take("DB Field",$fieldname,@args)
    }

; sub checkcond
    { my ($condition,$if,$else)=@_
    ; if(defined $else)
        { return dIngle->take("If Else",$condition,$if,$else)
        }
      else
        { return dIngle->take("If _",$condition,$if)
        }
    }

; 1
  
__END__
  

