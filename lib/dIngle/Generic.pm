  package dIngle::Generic
# *************************
; use strict; use warnings; use utf8

; use Package::Subroutine::Sugar

; use HO::Common      # node und newline
# Ohne dem werden die Tags nicht mehr geladen ...
# / das Laden hier ist ja auch richtig
; use HO::HTML
; use HO::HTML::Input
; use HO::HTML::Script

; use dIngle::Generic::Style

; use subs qw/newline node label/

; import from 'HO::Common' => qw/node newline/
; sub label { HO::HTML::Label(@_) }

; sub vishtml  () { 'HO::HTML' }               # viele HTML-Tags
; sub visform  () { 'HO::HTML::Input' }        # Eingabeelemente
; sub visscript() { 'HO::HTML::Script' }       # Script Elemente
; sub visutils () { 'dIngle::Field::Utils' } # in Feldern der Aufruf von statischen Tasks
; sub vismarkup() { 'dIngle::Generic::Markup' }
; sub visstyle () { 'dIngle::Generic::Style' } # Stylefunktionen

# This have to come after the upper declaration, because it uses them.
; use dIngle::Field::Utils

; 1

__END__


