#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More;

if ($ENV{MBANK_CLI_ONLINE_TESTS}) {
    plan tests => 3;
} else {
    plan skip_all => 'set MBANK_CLI_ONLINE_TESTS=1 to enable online tests';
}

use IPC::Run ();
use JSON::PP qw(decode_json);

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/cookies
CAfile <test>/howsmyssl-ca.crt
EOF

my ($stdout, $stderr);
my $url = 'https://www.howsmyssl.com/a/check';
my $cli = IPC::Run::start(
    [code_file(), '--config', $config_file, 'debug-https-get', $url],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 0, 'successful download');
cmp_ok($stderr, 'eq', '', 'empty stderr');
SKIP: {
    if (($cli->result != 0) and ($stdout eq '')) {
        skip('no JSON to parse', 1)
    }
    my $result = decode_json $stdout;
    if (not cmp_ok($result->{'rating'}, 'eq', 'Probably Okay', 'www.howsmyssl.com rating')) {
        delete $result->{'given_cipher_suites'};
        note(JSON::PP->new->ascii->pretty->encode($result));
    }
}

# vim:ts=4 sts=4 sw=4 et
