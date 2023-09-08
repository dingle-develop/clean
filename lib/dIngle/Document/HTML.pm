  package dIngle::Document::HTML;
# *******************************
  our $VERSION = '0.1';
# *********************
; use strict; use warnings; use utf8
; no warnings "void"

; use parent 'HO::Structure'

; use dIngle::Generic qw(node newline vishtml)

; import from:: vishtml() => qw/Html Head Body/

; __PACKAGE__->auto_slots

; sub init
   { my $self = shift()
   ; my $a = $self->area_setter
   ; my ($root) = node()
   ; $root << node( $self->doctype, newline() )

   ; my ($html,$head,$body) = (Html(),Head(),Body())
   ; $root << ($html << newline() 
                     << ($head << newline())
                     << newline()
                     << ($body << newline()) << newline())
                     << newline()
   
   ; &$a('header',$head) 
   ; &$a('content',$body)
   ; return $self->set_root($root);
   }
   
; sub doctype { "<!DOCTYPE html>" }

; sub get { "" . $_[0]->get_root }

; sub insert { shift->content->insert(@_) }

; 1

__END__
