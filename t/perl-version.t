#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 1;

use Perl::MinimumVersion ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $path = code_file();
my $mv = Perl::MinimumVersion->new($path);
cmp_ok(
    $mv->minimum_explicit_version,
    'ge',
    $mv->minimum_syntax_version,
    'explicit version >= syntax version',
);

# vim:ts=4 sts=4 sw=4 et
