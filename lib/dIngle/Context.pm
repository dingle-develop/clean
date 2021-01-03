  package dIngle::Context;
# ************************
  our $VERSION='0.01_001';
# ************************
; use strict; use warnings; use utf8

; use Carp()
; use subs 'init'

; use HO::class
    _rw => container => '$',
    _rw => object => '$',
    _ro => stash => '%',
    init => 'hash'
    
; sub take { local $Carp::CarpLevel += 1; shift->container->take(@_) }
    
; 1

__END__

