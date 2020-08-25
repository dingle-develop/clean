  package dIngle::I18N::PO::File
# ********************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings; use utf8

; use HO::class
    ( init => 'hash'
    , _rw  => 'domain'   => '$'
    , _rw  => 'filename' => '$'
    , _rw  => 'header'   => '@'
    , _rw  => 'entries'  => '@'
    )
    
; use dIngle::I18N::PO::Entry
; use dIngle::I18N::PO::Newline ('newline')

; use Encode ()

; sub process_fh
    { my ($obj,$fh,$linenumber) = @_
    ; $linenumber ||= 1
    ; $obj->parse_header($fh,$linenumber)
    ; $obj->parse_lines($fh,$linenumber)

    ; return $obj
    }
    
; sub parse_header
    { my ($self,$fh,$number) = @_
    ; $_[2] = 1 unless defined $number
    
    ; my ($currentline,$line)
    
    ;  while($currentline = <$fh>)
        { $line = dIngle::I18N::PO::File::Line->new
            (content => $currentline, number => $_[2]++)
            
        ; unless($line->is_empty)
            { $currentline =~ s/[\r\n]*$// # cut of \r\n
            ; $self->header('<',$currentline)
            }
          else
            { last
            }
        }
    }

; sub parse_lines
    { my ($self,$fh,$number) = @_
    ; local $_
    
    ; my (@entries,$entry,$line)
    	
    ; my ($currentline,$nextline,$cont)
    
    ; $nextline = <$fh>
    	
    ; while(defined $nextline)
        { $currentline = $nextline
        ; $nextline    = <$fh>
        
        ; $line = dIngle::I18N::PO::File::Line->new
        	(content => $currentline, number => $number++)
        
        ; $entry = dIngle::I18N::PO::Entry->new(domain => $self->domain)
            unless defined $entry
        
        ; next if $line->is_empty
        ; if($line->is_comment)
            { if($line->is_author_comment)
                {
            	    $entry->author_comment('<',$line->match)
                }
              elsif($line->is_automatic_comment)
                {
            	    $entry->auto_comment('<',$line->match)
                }
              elsif($line->is_occurrence)
                {
            	    $entry->occurrence('<',$line->match)
                }
            ; next
            }
          elsif($line->is_msgid)
            {  
              (my $match=$line->match(0)) =~ s/\\"/"/g;
            	$entry->msgid('<',$match);
            	$cont = 'msgid'
            }
          elsif($line->is_msgstr)
            {
            	(my $match=$line->match(0)) =~ s/\\"/"/g;
            	$entry->msgstr('<',$match);
            	$cont = 'msgstr'
            }
          elsif($line->is_continuity)
            {
            	(my $match=$line->match(0)) =~ s/\\"/"/g;
            	$entry->$cont('<',$match)
            }
          else
            {
            	die "Bad input line[".$line->number."]:".$line->content
            	   ."\n in .po file for domain ".$self->domain
            }
            
        ; if($cont eq 'msgstr' && defined($nextline) && $nextline !~ /^"/)
            {
            	$self->entries('<',$entry);
            	$entry = undef
            }
        }
        $self->entries('<',$entry) if defined $entry && $entry->msgid
    }
    
########################################
# Write a .po file
########################################
; sub write_fh
    { my ($obj,$filehandle) = @_
    	
    ; $obj->write_header($filehandle)
    ; $obj->write_entries($filehandle)
    }

; sub write_header
    { my ($self,$fh) = @_
    ; print $fh join($self->newline(),$self->header).($self->newline()x2)
    }

; sub write_entries
    { my ($self,$fh) = @_
    ; local $_
    ; my @entries = $self->get_entries
    
    ; $fh->print($_->render,$self->newline()) 
        foreach @entries
    }
    
########################################
# Some additional entry accessors
########################################
# Sortierung angepasst, locale nicht verwendet da dort Ö vor Ä
# einsortiert wird???
; sub get_entries
    { my ($self) = @_
    ; my %umlmap =
        ( ä => 'a', ö => 'o', ü => 'u', ß => 'ss'
        , Ä => 'A', Ö => 'O', Ü => 'U'
        )
    ; my $replace = "[".join('',keys %umlmap)."]"
    
    ; return
        map { $_->[1] }
        sort { $a->[0] cmp $b->[0] }
        map { my $s="$_" 
            ; $s =~ s/($replace)/$umlmap{$1}/exg
            ; [ uc($s) , $_ ] 
            } $self->entries
    }
    
; sub list_msgids
    { my ($self) = @_
    ; return map { join("\n",$_->msgid) } $self->get_entries
    }
    
; package dIngle::I18N::PO::File::Line
# **************************************
; our $VERSION = '0.01'
# *********************

; use HO::class
    ( init => 'hash'
    , _ro  => 'content' => '$'
    , _ro  => 'number'  => '$'
    , _rw  => 'match'   => '@'
    )
    
; sub is_empty
    { my ($self) = @_
    ; return ($self->content =~ /^\s*$/) ? 1 : 0
    }
    
; sub is_comment
    { my ($self) = @_
    ; return ($self->content =~ /^#/) ? 1 : 0
    }
    
; sub is_msgid
    { my ($self) = @_
    ; return
      ($self->content =~ /^msgid\s+"(.*)"/) 
      ? do{ $self->match('<',$1); 1 } : 0
    }
    
; sub is_msgstr
    { my ($self) = @_
    ; return
      ($self->content =~ /^msgstr\s+"(.*)"/) 
      ? do{ $self->match('<',$1); 1 } : 0
    }
    
; sub is_continuity
    { my ($self) = @_
    ; return
      ($self->content =~ /^"(.*)"/)
      ? do{ $self->match('<',$1); 1 } : 0	
    }

; sub is_author_comment
    { my ($self) = @_
    ; return
      ($self->content =~ /^#\s+(.*)/ or $self->content =~ /^#()$/)
      ?  do{ $self->match(0,$1) ; 1 } : 0
    }
    
; sub is_automatic_comment
    { my ($self) = @_
    ; return
      ($self->content =~ /^#\.\s*(.*)/)
      ? do{ $self->match(0,$1) ; 1 } : 0	
    }

; sub is_occurrence
    { my ($self) = @_
    ; return
      ($self->content =~ /^#:\s+(.*)/)
      ? do{ $self->match(0,$1) ; 1 } : 0
    }

; 1

__END__

