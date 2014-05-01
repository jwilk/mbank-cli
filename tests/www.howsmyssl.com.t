#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 3;

use JSON qw(decode_json to_json);

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
    note(to_json($result, { ascii => 1, pretty => 1 }));
}

chdir '/';

# vim:ts=4 sw=4 et
