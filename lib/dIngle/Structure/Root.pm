  package dIngle::Structure::Root
# *********************************
; our $VERSION='0.01'
# *******************
; use strict; use warnings

; use basis 'dIngle::Structure'

; use HO::HTML::Document

; sub init
    { my ($st,$obj) = @_
    ; my $A  = $st->area_setter()

    # Document Root
    ; my $doc=new HO::HTML::Document::
    ; $doc->EnCoding()
    ; $doc->NoCache()

    ; &$A("dIngle Title" ,$doc->get_area("title"))
    ; &$A("dIngle Meta"  ,$doc->get_area("meta"))
    ; &$A("dIngle Style" ,$doc->get_area("style"))
    ; &$A("dIngle Script",$doc->get_area("script"))
    ; &$A("dIngle Head"  ,$doc->get_area("head"))
    ; #$obj->take("dIngle BodyAttrib",$doc->get_area("body"))
    ; &$A("dIngle Body"  ,$doc->get_area("body"))

    ; $st->set_root( $doc )
    ; $st
    }

; 1

__END__
