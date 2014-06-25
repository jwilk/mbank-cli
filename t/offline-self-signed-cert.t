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

BEGIN {
    (my $t =  __FILE__ ) =~ s{[^/]*\z}{};
    unshift(@INC, $t);
}
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
cmp_ok($cli->result, '==', 2, 'failed with exit code 2');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr, qr/\bcertificate verify failed\b/, 'certificate verification failed');

IPC::Run::kill_kill($server);

# vim:ts=4 sw=4 et
