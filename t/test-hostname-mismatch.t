#!/usr/bin/perl

use strict;
use warnings;

use v5.10;

use Test::More tests => 3;

use Cwd qw(abs_path);
use File::Basename qw(dirname);
use File::Temp qw(tempdir);
use IPC::Run qw();

my $tmpdir = tempdir(
    template => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

my $home = abs_path(dirname($0));
chdir $tmpdir or die $!;

symlink("$home/../mbank-cli", 'mbank-cli');
symlink('/dev/null', 'mbank-cli.conf');

local $ENV{MBANK_CLI_HOST} = 'mbank';
local $ENV{HOSTALIASES} = "$home/hostaliases";

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    ['./mbank-cli'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 2, 'failed with exit code 2');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr, qr(\bcertificate verify failed\b), 'certificate verification failed');

chdir '/';

# vim:ts=4 sw=4 et
