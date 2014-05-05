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

use IPC::Run qw();
use File::Temp qw(tempdir);
use Cwd qw(abs_path);
use File::Basename qw(dirname);

use JSON qw(decode_json to_json);

my $tmpdir = tempdir(
    template => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

my $home = abs_path(dirname($0));
chdir $tmpdir or die $!;

symlink("$home/../mbank-cli", 'mbank-cli');
symlink('/dev/null', 'mbank-cli.conf');

local $ENV{MBANK_CLI_HOST} = 'howsmyssl.com';

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    ['./mbank-cli', 'debug-https-get', 'https://www.howsmyssl.com/a/check'],
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

chdir '/';

# vim:ts=4 sw=4 et
