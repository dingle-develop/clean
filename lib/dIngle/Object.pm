  package dIngle::Object
# **********************
; our $VERSION = '0.01'
# *********************

; use dIngle::Generic qw/newline node/

; use subs qw/init/

; use HO::class
    _ro => header    => sub { node() },
    _ro => document  => sub { node() },
    init => 'hash';

; sub insert
    { my $self = shift
    ; $self->document->insert(@_)
    }

; sub string
    { my ($self) = @_
    ; my $header = $self->header->string()
    ; return $self->document->string() unless length($header)
    ; return $header . newline() . $self->document->string()
    }

; 1

__END__

