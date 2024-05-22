#!/usr/bin/env perl

# Copyright © 2024 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use English qw(-no_match_vars);
use POSIX ();

use IPC::Run ();
local $SIG{CHLD} = sub {
    # https://github.com/cpan-authors/IPC-Run/issues/166
    # ("delay after child exit")
};

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $module = code_file();
require "$module";  ## no critic (RequireBareword)

my %uuids = map { gen_uuid() => 1 } (0..99);
my $cli = IPC::Run::start(
    ['uuidparse', '-n', keys %uuids],
    '>', \my $stdout,
    '2>', \my $stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 0, 'no error');
cmp_ok($stderr, 'eq', '', 'empty stderr');
my (@lines) = split(/\n/, $stdout);
for (@lines) {
    (my $uuid) = m/\A(\S+)\s+DCE\s+random\s+\z/
        or next;
    delete($uuids{$uuid}) or die;
}
my @bad_uuids = keys %uuids;
cmp_ok("@bad_uuids", 'eq', '', 'no bad UUIDs');

# vim:ts=4 sts=4 sw=4 et
