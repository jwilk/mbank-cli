#!/usr/bin/env perl

# Copyright © 2014-2023 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More;

my $var = 'MBANK_CLI_ONLINE_TESTS';
if ($ENV{$var}) {
    plan tests => 3;
} else {
    plan skip_all => "set $var=1 to enable online tests";
}

use English qw(-no_match_vars);

use IPC::Run ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $config_file = create_config(<<"EOF");
Country sk
CookieJar <tmp>/cookies
CAfile <certs>/ca.crt
EOF

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    [code_file(), '--config', $config_file, 'debug-https-get'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 2, 'exit code 2');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr,
    qr/\b(certificate verify|IO::Socket::IP configuration) failed\b/,
    'certificate verification failed'
);

# vim:ts=4 sts=4 sw=4 et
