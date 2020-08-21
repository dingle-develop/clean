  package dIngle::Debug
# ***********************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8

; my $state = $ENV{'DINGLE_DEBUG'}

; sub import
    { my ($self,$debug)=@_
    ; my $export=caller

    ; $state=$debug if !defined($state) && defined($debug)

    ; $debug = $state unless defined $debug
    ; DEFDEBUG:
        { no strict 'refs'
        ; my $DEBUG = join '::',($export,'DEBUG')
        ; if( $debug )
            { *{$DEBUG} = sub { 1 }
            }
          else
            { *{$DEBUG} = sub { 0 }
            }
        }
    }

; 1

__END__

=head1 NAME

dIngle::Debug

