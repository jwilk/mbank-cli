#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use v5.10;

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

local $ENV{MBANK_CLI_HOST} = 'localhost';
local $ENV{LD_PRELOAD} = "libsocket_wrapper.so";
local $ENV{SOCKET_WRAPPER_DIR} = "$tmpdir";

my $server = IPC::Run::start(
    'openssl', 's_server',
    '-accept', '443',
    '-cert', "$home/server.pem",
    '-quiet',
    '-www',
);

my ($stdout, $stderr);
my $cli = IPC::Run::start(
    ['./mbank-cli'],
    '>', \$stdout,
    '2>', \$stderr,
);
$cli->finish();
cmp_ok($cli->result, '==', 2, 'failed with exit code 2');
cmp_ok($stdout, 'eq', '', 'empty stdout');
like($stderr, qr{ SSL negotiation failed: .*:certificate verify failed }, 'certificate verification failed');

IPC::Run::kill_kill($server);

chdir '/';

# vim:ts=4 sw=4 et
