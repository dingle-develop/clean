  package dIngle::Unit;
# *********************
  our $VERSION = '0.02';
# **********************
; use strict; use warnings; use utf8
; use Shari::Code::Unit

; sub spawn { shift; Shari::Code::Unit->spawn(@_) }

; sub harvest { shift; Shari::Code::Unit->harvest(@_) }

; sub discover { shift; Shari::Code::Unit->discover(@_) }

; sub collect { shift; Shari::Code::Unit->collect(@_) }

; sub pick
    {
    }

; 1

__END__

=head1 NAME

dIngle::Unit

=head1 SYNOPSIS

   use dIngle::Unit;

   my $unit = spawn dIngle::Unit:: qw/Base Dir Name/;

=head1 DESCRIPTION

Simplified wrapper around Code::Loader::Unit::Module or
maybe in future other code loader packages.

=head2 C<spawn>

Load a unit by namespace.

head2 C<discover>

Load a unit by filename.

=head2 C<harvest>

Load all files in a give namespace.

=head2 C<collect>

Find files matching name/space/*/filename.pm

=head1 TODO

   * sort param for harvest



