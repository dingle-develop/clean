  package dIngle::Structure::Std::Root
# ****************************************
; our $VERSION='0.04'
#********************
; use strict; use warnings; no warnings 'void'; use utf8
; use basis 'dIngle::Structure' => ['dIngle::Structure::Root']

; import from vishtml() => qw/Table Tr Td Div/

; sub init
    { my ($st,$obj) = @_

    ; $st->SUPER::init($obj)
    ; my $A  = $st->area_setter()    
    
   	# Content Root
    ; my $tab = Table(); #$obj->take("TAB ROOT")
    
    ; my ($hp,$bp) =Td()->valign("top")->copy(2)
    ; $hp->id('sitehead')->insert("<!-- Kopfbereich -->\n")
    ; $bp->id('sitebody')->insert("<!-- Datenbereich -->\n")
    
    ; $tab << Tr($hp) << Tr($bp)

    ; &$A( "dIngle Header"  , $hp )
    ; &$A( "dIngle Content" , $bp )
    ; my $dbg = node()
    ; &$A( "dIngle Debug"   , $dbg )    

    ; $st->fill("dIngle Body",node($tab,$dbg))	
    ; return $st
    }

; 1

__END__

