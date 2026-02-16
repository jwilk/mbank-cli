#!/usr/bin/env perl

# Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 8;

use FindBin ();
use lib $FindBin::Bin;
use TestUtils;

my $module = code_file();
require "$module";  ## no critic (RequireBareword)

# Test 1: Empty JSON object returns empty list
{
    my @accounts = parse_offline_accounts('{}');
    cmp_ok(scalar(@accounts), '==', 0, 'empty JSON object returns no accounts');
}

# Test 2: Empty JSON array returns empty list
{
    my @accounts = parse_offline_accounts('[]');
    cmp_ok(scalar(@accounts), '==', 0, 'empty JSON array returns no accounts');
}

# Test 3: Invalid JSON returns empty list
{
    my @accounts = parse_offline_accounts('not valid json');
    cmp_ok(scalar(@accounts), '==', 0, 'invalid JSON returns no accounts');
}

# Test 4: Parse accounts from "accounts" key (lower case)
{
    my $json = '{"accounts":[{"name":"Test Account","number":"PL12345678901234","balance":1000.50,"currency":"PLN","bankName":"Other Bank"}]}';
    my @accounts = parse_offline_accounts($json);
    cmp_ok(scalar(@accounts), '==', 1, 'one account from accounts key');
    cmp_ok($accounts[0]->{name}, 'eq', 'Test Account', 'account name extracted');
    cmp_ok($accounts[0]->{source}, 'eq', 'Other Bank', 'bank name used as source');
}

# Test 5: Parse accounts from array root
{
    my $json = '[{"productName":"Savings","accountNumber":"DE123456789","currency":"EUR","balance":500}]';
    my @accounts = parse_offline_accounts($json);
    cmp_ok(scalar(@accounts), '==', 1, 'one account from array root');
    cmp_ok($accounts[0]->{source}, 'eq', 'external', 'missing bank name defaults to external');
}

# vim:ts=4 sts=4 sw=4 et
