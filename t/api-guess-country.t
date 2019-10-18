#!/usr/bin/env perl

# Copyright © 2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 6;

use English qw(-no_match_vars);
use POSIX ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $module = code_file();
require "$module";  ## no critic (RequireBareword)

sub t
{
    my ($locale, $expected_cc) = @_;
    POSIX::setlocale(POSIX::LC_ALL(), 'C') or die 'setlocale(LC_ALL, "C") failed';
    my @label = ();
    SKIP: {
        while(my ($symcat, $value) = each %{$locale}) {
            my $cat = ${$POSIX::{$symcat}};
            if (not POSIX::setlocale($cat, $value)) {
                skip(qq(setlocale($symcat, "$value") failed), 1);
            }
            push(@label, "$symcat=$value");
        }
        if (not @label) {
            push(@label, 'LC_ALL=C');
        }
        my $label = join(' ', @label);
        my $actual_cc = guess_country();
        if (defined($expected_cc)) {
            cmp_ok($actual_cc, 'eq', $expected_cc, $label);
        } else {
            ok(!defined($actual_cc), $label);
        }
    }
    return;
}

t({}, undef);
t({LC_ALL => 'cs_CZ.UTF-8'}, 'cz');
t({LC_ALL => 'pl_PL.UTF-8'}, 'pl');
t({LC_ALL => 'sk_SK.UTF-8'}, 'sk');
t({LC_CTYPE => 'pl_PL.UTF-8'}, 'pl');
t({LC_CTYPE => 'pl_PL.UTF-8', LC_NUMERIC => 'cs_CZ.UTF-8'}, undef);

# vim:ts=4 sts=4 sw=4 et
