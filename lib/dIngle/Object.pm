  package dIngle::Object
# **********************
; our $VERSION = '0.01'
# *********************

; use dIngle::Generic qw/newline node/

; use HO::class
    _rw => _header    => '$',
    _rw => _document  => '$';

; sub init 
    { my $self = shift;
    ; $self->_header(node())
    ; $self->_document(node())
    ; $self
    }

; sub insert
    { my $self = shift
    ; $self->_document->insert(@_)
    }

; sub string
    { my ($self) = @_
    ; my $header = $self->_header->string
    ; return $self->_document->string unless length($header)
    ; return $header . newline() . $self->_document->string
    }

; sub document
    { my $self = shift
    ; return $self->_document unless @_
    ; my $type = shift
    ; unless(ref $type)
        { my $doc = dIngle::Document->new($type,@_)
        ; $self->_document($doc)
        ; return $doc
        }
    }

; 1

__END__

