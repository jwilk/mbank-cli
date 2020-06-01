#!/usr/bin/env perl

# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More;

my $var = 'MBANK_CLI_ONLINE_TESTS';
if ($ENV{$var}) {
    plan tests => 9;
} else {
    plan skip_all => "set $var=1 to enable online tests";
}

use English qw(-no_match_vars);

use IPC::Run ();

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

for my $country (qw(cz sk pl)) {

    my $config_file = create_config(<<"EOF");
Country $country
CookieJar <tmp>/cookies
EOF

    my ($stdout, $stderr);
    my $cli = IPC::Run::start(
        [code_file(), '--config', $config_file, 'debug-https-get'],
        '>', \$stdout,
        '2>', \$stderr,
    );
    $cli->finish();
    cmp_ok($cli->result, '==', 0, 'no error');
    like($stdout, qr/<html>/i, 'HTML output');
    cmp_ok($stderr, 'eq', '', 'empty stderr');
    unlink(tmp_dir . '/cookies') or die $ERRNO;

}

# vim:ts=4 sts=4 sw=4 et
