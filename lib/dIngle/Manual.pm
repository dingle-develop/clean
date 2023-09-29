  package dIngle::Manual
# **********************
 
; use strict; use warnings;

our $VERSION = '0.001';
 
1;
__END__

=head1 NAME

dIngle::Manual - The manual for dIngle developers

=head1 DESCRIPTION

dIngle is a library for developing applications which
are build around a global namespace for function calls.

This programming paradigm has sometimes a bad reputation,
nonetheless you can tackle some problems easier with this 
approach as with a totally modularized one.

The typical use case for this programming environment is
the generation of template files, which are used in other
software projects.

=head1 OVERVIEW

=head2 The Foundations

=over 4

=item L<dIngle::Light>

This module holds the core information about the dIngle system.
Currently it is the base path of the installation and the path
to configuration.

=item L<dIngle::Library>

dIngle uses software which is not mature. It is installed in site-lib
folder and defined in C<config/site-lib.conf>. C<@INC> is prefixed with
a subroutine for loading them.

=item L<dIngle::Instance>

dIngle was in it's first incarnation installed and used on separate
systems. An Instance can solve the problem of differences in various 
environments through automatic detection of the right one. In the 
instance configuration are different setups described and the right
one is chosen automatically. The current implementation is only in a 
proof of concept state.

C<dIngle::Instance> is also used to build a project with different
configurations.

=item L<dIngle::Application>

This loads what is required to run a dIngle application. dIngle uses
the Sub::Uplevel module often. This module needs to loaded as early
as possible.

=back

=head2 The Framework

=over 4

=item L<dIngle::Conf> - Configuration

=item L<dIngle::Log> - Logging

=item L<dIngle::Loader> - Loads code in various ways

=back

=head2 The Core Concepts

=over 4

=item L<dIngle::Generator>


=item L<dIngle::Context>

=item L<dIngle::Project>

=item L<dIngle::Hive>

=back
