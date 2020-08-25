  package dIngle::I18N::PO::Entry
# *********************************
; our $VERSION='0.02'
# *******************
; use strict; use warnings; use utf8
; use Carp ()

; use HO::class
    ( init => 'hash'
    , _rw => 'domain'         => '$'
    , _rw => 'msgid'          => '@'
    , _rw => 'msgstr'         => '@'
    , _rw => 'author_comment' => '@'
    , _rw => 'auto_comment'   => '@'
    , _rw => 'occurrence'     => '@'
    )
    
; use overload
    '""' => sub { return  join('',$_[0]->msgid) || do
        { Carp::carp("Empty msgid in PO Entry!")
        ; return ''
        }}

; use dIngle::I18N::PO::Newline ('newline')

########################
# usual OO
########################
; sub compare
    { my ($self,$other) = @_

    ; return
      join('',$self->msgid,$self->msgstr,$self->author_comment
             ,$self->auto_comment,$self->occurrence)
      cmp
      join('',$other->msgid,$other->msgstr,$other->author_comment
             ,$other->auto_comment,$other->occurrence)
    }
   
########################     
# render an entry
########################
; sub render
    { my ($self) = @_
    ; my @lines
    
    ; push @lines, $self->_render_comment("#. ",$self->auto_comment)
                 , $self->_render_comment("# ",$self->author_comment)
                 , $self->_render_comment("#: ",$self->occurrence)
    ; push @lines, $self->_render_msg("msgid",$self->msgid)
                 , $self->_render_msg("msgstr",$self->msgstr)
                 
    ; return join($self->newline,@lines).$self->newline
    }
    
; sub _render_comment
    { my ($self,$prefix,@lines) = @_
    ; return () unless @lines
    ; return map { "${prefix}$_" } @lines
    }
    
; sub _render_msg
    { my ($self,$prefix,@lines) = @_
    ; my $first  = shift @lines
    ; $first =~ s/"/\\"/g
    ; my @result = "$prefix \"${first}\"" 
    ; push @result, map( { s/"/\\"/g; "\"${_}\"" } @lines )
    
    ; return @result
    }
    
########################
# retrieve partial text
########################
; sub _gettext_text
    { my ($self,$what) = @_
    ; return join("\n",$self->$what)    
    }
    
; sub gettext_msgid  
    { return $_[0]->_gettext_text('msgid')
    }
    
; sub gettext_msgstr
    { return $_[0]->_gettext_text('msgstr')
    }
    
########################
# When used in code
########################
; sub sanitize_msgid
    { my ($self) = @_
    ; my @msgid = $self->msgid
    ; chomp $msgid[$#msgid] # trailing newline removed
    ; @msgid = map { s/\n/\\n/sg; $_ } @msgid
    ; $self->msgid(\@msgid)
    }
  
########################
# add new entry
# modify self content
########################
; sub maketext_to_gettext
    { my ($self) = @_
    ; $self->msgid([map({_maketext_to_gettext($_)} $self->msgid)])
    ; $self->msgstr([map({_maketext_to_gettext($_)} $self->msgstr)])
    }  

# gemauster code  
sub _maketext_to_gettext {
    my $text = shift;
    return '' unless defined $text;

    $text =~ s{((?<!~)(?:~~)*)\[_([1-9]\d*|\*)\]}
              {$1%$2}g;
    $text =~ s{((?<!~)(?:~~)*)\[([A-Za-z#*]\w*),([^\]]+)\]} 
              {"$1%$2(" . _escape($3) . ')'}eg;

    $text =~ s/~([\~\[\]])/$1/g;
    return $text;
}

sub _escape {
    my $text = shift;
    $text =~ s/\b_([1-9]\d*)/%$1/g;
    return $text;
}
########################
# build lexicon from
# entry: return
# a key => value pair    
########################
; sub maketext_entry
    { my ($self) = @_
    ; return (_gettext_to_maketext(join('',$self->msgid))
             ,_gettext_to_maketext(join('',$self->msgstr))
             )    	
    }
  
# gemauster code  
; sub _gettext_to_maketext {
    my $str = shift;
    $str =~ s/[\r\n]//g;
    $str =~ s{([\~\[\]])}{~$1}g;
    $str =~ s{
        ([%\\]%)                        # 1 - escaped sequence
    |
        %   (?:
                ([A-Za-z#*]\w*)         # 2 - function call
                    \(([^\)]*)\)        # 3 - arguments
            |
                ([1-9]\d*|\*)           # 4 - variable
            )
    }{
        $1 ? $1
           : $2 ? "\[$2,"._unescape($3)."]"
                : "[_$4]"
    }egx;
    $str;
}

; sub _unescape {
    join(',',
        map { /\A(\s*)%([1-9]\d*|\*)(\s*)\z/ ? "$1_$2$3" : $_ }
          split(/,/, $_[0]));
}   
    

; 1

__END__

