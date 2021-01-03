  package dIngle::Generic::Style
# ********************************
; our $VERSION = '0.01'
# *********************
; use strict; use warnings; use utf8

; use HO::HTML::Style
; use HO::XHTML::Style

; import from 'HO::HTML::Style' => qw/Stylefile/

; sub Style
    { my $type = dIngle->object->document->type
    ; my %classes = (
        'html5' => 'HO::HTML::Style',
        'xhtml-strict' => 'HO::XHTML::Style'
      )
    ; my $class = $classes{$type} || 'HO::HTML::Style'
    ; return $class->can('Style')->(@_)
    }

; 1

__END__

