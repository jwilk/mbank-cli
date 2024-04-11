# Copyright © 2014-2018 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

package TestUtils;

use strict;
use warnings;

use v5.10;

use base qw(Exporter);

our @EXPORT = qw(
    cert_file
    code_dir
    code_file
    create_config
    setup_network_wrappers
    start_https_server
    test_dir
    test_file
    tmp_dir
);

use English qw(-no_match_vars);
use File::Temp ();
use FindBin ();

use IPC::Run ();

# ==========
# networking
# ==========

sub _check_ld
{
    my ($stdout, $stderr);
    my $cli = IPC::Run::start(
        ['true'],
        '>', \$stdout,
        '2>', \$stderr,
    );
    $cli->finish();
    $stdout eq ''
        or die;
    $stderr eq ''
        or die "preloading wrappers failed: $stderr";
    $cli->result == 0
        or die 'preloading wrappers failed';
    return;
}

sub setup_network_wrappers
{
    ## no critic (LocalizedPunctuationVars)
    $ENV{LD_PRELOAD} = 'libsocket_wrapper.so:libnss_wrapper.so';
    $ENV{SOCKET_WRAPPER_DIR} = tmp_dir();
    $ENV{NSS_WRAPPER_HOSTS} = test_file('hosts.local');
    ## use critic
    _check_ld();
    return;
}

sub start_https_server
{
    my ($cert_file, @options) = @_;
    my @ipv4_opts = ();
    $cert_file = cert_file($cert_file);
    stat($cert_file) or die "$cert_file: $ERRNO";
    my $help;
    IPC::Run::run(['openssl', 's_server', '-help'], '>&', \$help);
    if ($help =~ /\s-4\s/) {
        push @ipv4_opts, '-4';
    }
    my $server = IPC::Run::start(
        'openssl', 's_server',
        @ipv4_opts,
        '-accept', '443',
        '-cert', $cert_file,
        '-quiet',
        '-www',
        @options,
    );
    return $server;
}

# ==========
# filesystem
# ==========

my $_tmp_dir = File::Temp::tempdir(
    TEMPLATE => 'mbank-cli.test.XXXXXX',
    TMPDIR => 1,
    CLEANUP => 1,
) or die;

sub tmp_dir
{
    return $_tmp_dir;
}

my $_test_dir = $FindBin::Bin;

sub test_dir
{
    return $_test_dir;
}

sub test_file
{
    my ($path) = @_;
    return "$_test_dir/$path";
}

sub cert_file
{
    my ($path) = @_;
    return "$_test_dir/certs/$path";
}

sub code_dir
{
    return "$_test_dir/..";
}

sub code_file
{
    my ($path) = @_;
    $path //= 'mbank-cli';
    return "$_test_dir/../$path";
}

sub create_config
{
    my ($config) = @_;
    $config =~ s/<tmp>/$_tmp_dir/g;
    $config =~ s/<test>/$_test_dir/g;
    $config =~ s{<certs>}{$_test_dir/certs}g;
    my $path = "$_tmp_dir/mbank-cli.conf";
    open(my $fh, '>', $path) or die $ERRNO;
    print {$fh} $config;
    close($fh) or die $ERRNO;
    return $path;
}

1;

# vim:ts=4 sts=4 sw=4 et
