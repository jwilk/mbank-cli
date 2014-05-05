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
use File::Basename qw(dirname);
use File::Temp qw(tempdir);
use IPC::Run qw();

use LWP;

my $tmpdir = tempdir(
    template => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

my $home = abs_path(dirname($0));
chdir $tmpdir or die $!;

symlink("$home/../mbank-cli", 'mbank-cli');
symlink('/dev/null', 'mbank-cli.conf');

local $ENV{MBANK_CLI_HOST} = 'encrypted.google.com';

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    ['./mbank-cli'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
TODO: {
    local $TODO = 'LWP::protocol::https stomps on SSL_verifycn_scheme' if $LWP::VERSION >= 6;
    cmp_ok($cli->result, '==', 2, 'failed with exit code 2');
    cmp_ok($stdout, 'eq', '', 'empty stdout');
    like($stderr, qr(\bcertificate verify failed\b), 'certificate verification failed');
}

chdir '/';

# vim:ts=4 sw=4 et
