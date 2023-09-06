  package dIngle::Manual
# **********************
 
; use strict; use warnings;

our $VERSION = '0.001';
 
1;
__END__

=head1 NAME

dIngle::Manual - The manual for dIngle developers

=head1 DESCRIPTION



=head2 The Foundations

=over 4

=item L<dIngle::Light>

This module holds the core information about the dIngle system.

=item L<dIngle::Library>

dIngle uses software which is not mature. It is installed in site-lib
folder and defined in C<config/site-lib.conf>. C<@INC> is prefixed with
a subroutine for loading them.

=item L<dIngle::Instance>

dIngle was in it's first incarnation installed and used on separate
systems. To solve the problem of differences, which come from
this circumstances, this feature was introduced. Maybe it is useful
some time again.

=item L<dIngle::Application>

This loads what is required to run a dIngle application.

=item L<dIngle::Conf>

=back

=head2 The Framework

=over 4

=item L<dIngle::Log> - Logging

=item L<dIngle::Loader> - Loads code in various ways

=back

=head2 The Core Concepts

=over 4

=item L<dIngle::Context>

=item L<dIngle::Project>

=back
