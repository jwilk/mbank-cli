#!/usr/bin/env perl

# Copyright © 2025 Jakub Wilk <jwilk@jwilk.net>
# SPDX-License-Identifier: MIT

no lib '.';

use strict;
use warnings;

use v5.10;

use Test::More tests => 14;

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

# Test 6: Accounts with missing name or number are skipped
{
    my $json = '{"accounts":[{"name":"Valid Account","number":"123456"},{"name":"Missing Number"},{"number":"987654"}]}';
    my @accounts = parse_offline_accounts($json);
    cmp_ok(scalar(@accounts), '==', 1, 'only account with both name and number is parsed');
    cmp_ok($accounts[0]->{name}, 'eq', 'Valid Account', 'valid account name is correct');
}

# Test 7: Parse accounts from "payload" key (AccountsAggregation API format)
{
    my $json = '{"status":"ok","code":200,"payload":[{"accountNumber":"PL12345678901234567890123456","externalAccountName":"Konto Freemium","accountTypeName":"Konto Freemium","currency":"PLN","availableBalance":1000.50,"bankAvatarName":"AliorAvatar"}]}';
    my @accounts = parse_offline_accounts($json);
    cmp_ok(scalar(@accounts), '==', 1, 'one account from payload key');
    cmp_ok($accounts[0]->{name}, 'eq', 'Konto Freemium', 'externalAccountName used as account name');
    cmp_ok($accounts[0]->{number}, 'eq', 'PL12345678901234567890123456', 'accountNumber extracted');
    cmp_ok($accounts[0]->{currency}, 'eq', 'PLN', 'currency extracted');
}

# vim:ts=4 sts=4 sw=4 et
