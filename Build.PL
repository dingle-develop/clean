#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Module::Build;

my $builder = Module::Build->new(
    module_name => 'dIngle',
    dist_version => '0.4001',
    dist_author => [
        'Sebastian Knapp <sknpp@cpan.org>'
    ],
    license => 'perl',
    dist_abstract => 'a software generator',
    requires => {
       'perl' => '5.12.0'
    },
);

$builder->create_build_script();
