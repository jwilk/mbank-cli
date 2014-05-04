#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use v5.10;

use LWP;
use IPC::Run qw();
use File::Temp qw(tempdir);
use Cwd qw(getcwd);

my $tmpdir = tempdir(
    template => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

my $home = getcwd();
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
