#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 6;

use English qw(-no_match_vars);

use IPC::Run ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $cli_version_re = qr/\Ambank-cli (\S+)\n/;
my $news_version_re = qr/\Ambank-cli [(](\S+)[)] (\S+); urgency=\S+\n\z/;

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    [code_file(), '--version'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 0, 'no error');
cmp_ok($stderr, 'eq', '', 'empty stderr');
like($stdout, $cli_version_re , 'well-formed version information');
my ($cli_version) = $stdout =~ $cli_version_re;
open(my $fh, '<', code_file('doc/NEWS')) or die $ERRNO;
my $news = <$fh> // die $ERRNO;
close($fh) or die $ERRNO;
like($news, $news_version_re, 'well-formed NEWS title line');
my ($news_version, $distribution) = $news =~ $news_version_re;
SKIP: {
    if (-d code_file('.hg')) {
        skip('hg checkout', 1);
    }
    if (-d code_file('.git')) {
        skip('git checkout', 1);
    }
    cmp_ok(
        $distribution,
        'ne',
        'UNRELEASED',
        'distribution != UNRELEASED',
    );
}
cmp_ok(
    ($cli_version // ''),
    'eq',
    ($news_version // ''),
    'CLI version == NEWS version'
);

# vim:ts=4 sts=4 sw=4 et
