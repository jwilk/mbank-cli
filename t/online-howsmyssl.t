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

use IPC::Run ();
local $SIG{CHLD} = sub {
    # https://github.com/cpan-authors/IPC-Run/issues/166
    # ("delay after child exit")
};

use JSON::PP qw(decode_json);

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $je = JSON::PP->new->ascii->pretty;

my $config_file = create_config(<<"EOF");
Country pl
CookieJar <tmp>/cookies
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
        note($je->encode($result));
    }
}

# vim:ts=4 sts=4 sw=4 et
