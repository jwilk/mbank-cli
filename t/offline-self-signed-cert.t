#!/usr/bin/env perl

# Copyright © 2014-2023 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use IPC::Run ();
local $SIG{CHLD} = sub {
    # https://github.com/cpan-authors/IPC-Run/issues/166
    # ("delay after child exit")
};

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/cookies
EOF

setup_network_wrappers();
my $server = start_https_server('server-self-signed.pem'),

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

IPC::Run::kill_kill($server);

# vim:ts=4 sts=4 sw=4 et
