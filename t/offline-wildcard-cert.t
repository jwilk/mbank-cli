#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use IPC::Run ();

use LWP ();
use IO::Socket::SSL ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/cookies
CAfile <certs>/ca.crt
EOF

setup_network_wrappers();
my $server = start_https_server('server-wildcard.pem'),

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    [code_file(), '--config', $config_file, 'debug-https-get'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
TODO: {
    local $TODO = 'LWP::protocol::https stomps on SSL_verifycn_scheme'
        # https://bugs.debian.org/747225
        if $LWP::VERSION >= 6  ## no critic (PostfixControl)
        and $IO::Socket::SSL::VERSION < 1.969;
    cmp_ok($cli->result, '==', 2, 'failed with exit code 2');
    cmp_ok($stdout, 'eq', '', 'empty stdout');
    like($stderr,
        qr/\b(hostname verification|certificate verify|IO::Socket::IP configuration) failed\b/,
        'certificate verification failed'
    );
}

IPC::Run::kill_kill($server);

# vim:ts=4 sts=4 sw=4 et
