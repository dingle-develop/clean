  package dIngle::Tasks::Task;
# ****************************
  our $VERSION = '0.01_001';
# **************************
; use strict; use warnings; use utf8

; use Ref::Util ()

; use HO::class
    _ro => label => '$',
    _ro => module => '$',
    _rw => 'on_destroy' => '$',
    _rw => perform => '$',
    _rw => require  => '$',
    _rw => ensure  => '$',
    init => 'hashref'
    
; sub DESTROY
    { my $self = shift
    ; $self->on_destroy->($self) if Ref::Util::is_coderef($self->on_destroy)
    }

; 1

__END__
