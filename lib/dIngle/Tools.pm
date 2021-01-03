  package dIngle::Tools
# ***********************
; our $VERSION='0.03'
# *******************
# changes:
# 0.3 - 2010-01-27
#     - bom_rx method

; use strict; use warnings; use utf8
; use base 'Exporter'

; use English qw( -no_match_vars )

; our @EXPORT_OK=('vis_timestamp','copyyear','vis_version'
                 ,'vis_contact','checkpath','uni_newline_rx'
                 ,'pairlist_to_hash','split_csv_line','check_email'
                 ,'addslashes','quote_dbl','quote_sng'
                 , 'fm_time','bom_rx'
                 ,'winpath','OS_is_windows','achomp'
                 )

; use File::Path

; sub achomp
    { $_[0] =~ s/^\s*(.*?)\s*$/$1/m
    }

; sub requirements
    { my ($class,$modul,$hash,$array,$recprot)=@_
    ; my %deps = %$hash
    ; my @required
    ; if( defined $deps{'ALL'} )
        { @required = @{$deps{'ALL'}}
        ; delete($deps{'ALL'})
        }
      else
        { @required = @$array }

    ; my %recursive
    ; %recursive = %$recprot if $recprot

    ; if( defined($deps{$modul}) )
        { foreach my $mod ( @{$deps{$modul}} )
            { unless( $recursive{$mod} )
                { $recursive{$mod} = 1
                ; @required=$class->requirements($mod,\%deps,\@required,\%recursive)
                ; push @required,$mod
                }
              else
                { warn "circular dependencies detected for $mod." }
            }
        }
    ; wantarray ? @required : \@required
    }

; sub vis_timestamp
    { my @time = (localtime)[5,4,3,2,1,0]
    ; $time[0]+= 1900
    ; $time[1]+= 1
    ; sprintf("%d%02d%02d%02d%02d%02d", @time )
    }

# Important - dokumentieren
; sub winpath
    { my $str=shift
    ; if( $OSNAME =~ /cygwin/ )
        { if( my $device = lc($str =~ /([a-zA-Z])\:/ && $1) )
            { $str =~ s"[a-zA-Z]\:"/cygdrive/$device"
            }
        ; return $str
        }
    ; $str =~ s/\//\\/g
    ; $str
    }

; sub OS_is_windows
    { substr($^O,0,5) eq "MSWin"
    }

# neu und wichtig - dokumentieren
# Credits to Adam Kennedy
; sub uni_newline_rx ()
    { qr'(?:\015{1,2}\012|\015|\012)' }

; sub bom_rx
    { qr'(?:\xEF\xBB\xBF|\xFE\xFF|\xFF\xFE|\x00\x00\xFE\xFF|\xFF\xFE\x00\x00)' }


=head2 copyyear

Return a string with the given year as begin and the current year as end.

=cut

; sub copyyear
    { shift if $_[0] eq __PACKAGE__
    ; my ($startyear)=@_
    ; my $now = (localtime)[5]+1900
    ; if($now > $startyear)
        { return "$startyear - $now" 
        }
      else
        { return $startyear 
        }
    }

; sub vis_version  { 'dIngle 2.9' }
; sub vis_contact  { 'dingle@computer-leipzig.com' }

=head2 checkpath

Checks if the path contains the trailing slash and creates the directory
if necessary.

=cut

sub checkpath
    { shift if $_[0] eq __PACKAGE__
    ; my ($path)=@_
    ; chomp $path
    ; $path =~ s/\\/\//g
    ; $path.='/' if substr($path,-1) ne '/'
    ; mkpath($path) unless -d $path
    ; $path
    }

; sub pairlist_to_hash
    { shift if $_[0] eq __PACKAGE__
    ; my @list = ref $_[0] eq 'ARRAY' ? @{$_[0]} : @_

    ; my %hash
    ; while( @list)
        { my ($key,$args)=splice(@list,0,2)
        ; $hash{$key} = $args
        }
    ; wantarray ? %hash : \%hash
    }

# Diese Funktion wird verwendet um eine Zeile aus einer Filmaker-Exportdatei
# zu verarbeiten.
# Auch wenn ein split nahe liegt, so ist damit die Codierung von " als ""
# schwer aufzulösen.
; sub split_csv_line
    { shift if $_[0] eq __PACKAGE__
    ; my $line = shift

    ; chomp $line
    ; $line =~ s/[\s\x0b\x0a\x09]*$//

    ; my @fields
    ; my $linelength = length($line)
    ; my ($start,$index) = (1,1)

    ; while(($index = index($line,'"',$index)) > 0)
        { if(substr($line,$index+1,1) eq '"')
            { $index += 2
            ; next
            }
        ; push @fields, substr($line,$start,$index-$start)
        ; if($index+1 < $linelength)
            { $index += 3
            ; $start = $index
            }
          else
            { last
            }
        }

    ; return map { s/""/"/g; s/\x0b*$//; s/\x0b/\n/g; $_ } @fields
    }

# bisher wird nur Whitespace entfernt und eine Kommaseparierte Zeichenkette
# erstellt.
; sub check_email
    { shift if $_[0] eq __PACKAGE__
    ; my $email = shift
    ; join(",", map({ s/\s*//g ; $_ } split( /\s*[,;:\/|]\s*/,$email)))
    }

# wie die php Funktion
; sub addslashes
    { shift if $_[0] eq __PACKAGE__
    ; my $str = shift
    ; $str =~ s/([\\'"\0])/\\$1/g
    ; return $str
    }

; sub quote_dbl  { return "\"@_\"" }
; sub quote_sng  { return "'@_'" }

# irgendwie liefert localtime eine Stunde zu wenig
# diese Funktion sollte das korrigieren
; sub fm_time
    { my @l=localtime(time+3600);
    # warn sprintf("%02d:%02d:%02d",$l[2],$l[1],$l[0]);
    ; sprintf("%02d:%02d:%02d",$l[2],$l[1],$l[0]);
    }

; 1

__END__
