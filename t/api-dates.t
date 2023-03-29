#!/usr/bin/env perl

# Copyright © 2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 1;

use English qw(-no_match_vars);
use POSIX ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $module = code_file();
require "$module";  ## no critic (RequireBareword)

my $tp = Time::Piece->gmtime(1680126087);
my $ymd = local_date($tp);
cmp_ok($ymd, 'eq', '2023-03-29');

# vim:ts=4 sts=4 sw=4 et
