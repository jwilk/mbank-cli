#!/usr/bin/env perl

# Copyright © 2014-2019 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use IPC::Run ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/nonexistent/cookies
CAfile /dev/null
EOF

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    [code_file(), '--config', $config_file, 'debug-noop'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 4, 'exit code 4');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr, qr{/nonexistent/cookies\b}, 'cookie jar write error message');

# vim:ts=4 sts=4 sw=4 et
