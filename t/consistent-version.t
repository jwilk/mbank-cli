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

use Cwd qw(abs_path);
use English qw(-no_match_vars);
use File::Basename qw(dirname);
use IPC::Run qw();

use Test::More tests => 5;

my $home = abs_path(dirname(__FILE__));

my $cli_version_re = qr/\Ambank-cli (\S+)\n\z/;
my $news_version_re = qr/\Ambank-cli [(](\S+)[)] \S+; urgency=\S+\n\z/;

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    ["$home/../mbank-cli", '--version'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 0, 'no error');
cmp_ok($stderr, 'eq', '', 'empty stderr');
like($stdout, $cli_version_re , 'well-formed version information');
my ($cli_version) = $stdout =~ $cli_version_re;
open(my $fh, '<', "$home/../doc/NEWS") or die $ERRNO;
my $news = <$fh> // die $ERRNO;
close($fh) or die $ERRNO;
like($news, $news_version_re, 'well-formed NEWS title line');
my ($news_version) = $news =~ $news_version_re;
cmp_ok(
    ($cli_version // ''),
    'eq',
    ($news_version // ''),
    'CLI version == NEWS version'
);

# vim:ts=4 sw=4 et
