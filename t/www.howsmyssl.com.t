#!/usr/bin/perl

# Copyright © 2014 Jakub Wilk <jwilk@jwilk.net>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the “Software”), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use Cwd qw(abs_path);
use English qw(-no_match_vars);
use File::Basename qw(dirname);
use File::Temp qw(tempdir);
use IPC::Run qw();

use JSON qw(decode_json to_json);

my $tmpdir = tempdir(
    template => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

my $home = abs_path(dirname(__FILE__));

my $config = <<"EOF";
Country pl
CookieJar $tmpdir/cookies
CAfile $home/ca.crt
EOF
open(my $fh, '>', "$tmpdir/mbank-cli.conf") or die $ERRNO;
print {$fh} $config;
close($fh) or die $ERRNO;

my ($stdout, $stderr);
my $url = "https://www.howsmyssl.com/a/check";
my $cli = IPC::Run::start(
    ["$home/../mbank-cli", '-c', "$tmpdir/mbank-cli.conf", 'debug-https-get', $url],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 0, 'successful download');
cmp_ok($stderr, 'eq', '', 'empty stderr');
my $result = decode_json $stdout;
if (not cmp_ok($result->{'rating'}, 'eq', 'Probably Okay', 'www.howsmyssl.com rating')) {
    delete $result->{'given_cipher_suites'};
    note(to_json($result, { ascii => 1, pretty => 1 }));
}

# vim:ts=4 sw=4 et
