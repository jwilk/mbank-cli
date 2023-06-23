#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More;

use IPC::Run ();
use Net::SSLeay ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

eval {
    Net::SSLeay::SSLv2_method()
} or do {
    plan(skip_all => 'SSLv2 not supported');
};
plan(tests => 3);

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/cookies
CAfile <certs>/ca.crt
EOF

setup_network_wrappers();
my $server = start_https_server('server-default.pem', '-ssl2'),

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    [code_file(), '--config', $config_file, 'debug-https-get'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 2, 'exit code 2');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr, qr/\b(unsupported protocol|wrong version number|00000000)\b/, 'unsupported protocol');

IPC::Run::kill_kill($server);

# vim:ts=4 sts=4 sw=4 et
