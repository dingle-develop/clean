  package dIngle::System::Utilities::Tasks;
# *****************************************
  our $VERSION='0.02';
# ********************
; use strict; use warnings; use utf8

; use basis 'dIngle::Tasks'

; sub setup
    {
; task "NO OP", sub { wantarray ? () : '' }

; task "NO OP not implemented", alias("NO OP")

; task "U USE", sub
    { my ($obj,$pre,@list)=@_
    ; my $ret=node()
    ; make("$pre $_",$ret) foreach @list
    ; $ret
    }
    
; task "U DO", sub
    { my ($obj,$pre,@list)=@_
    ; my $ret=node()
    ; $ret << make("$pre $_") foreach @list
    ; $ret
    }

    } # end setup
    
; 1
