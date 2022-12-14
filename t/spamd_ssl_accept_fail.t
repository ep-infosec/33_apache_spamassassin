#!/usr/bin/perl -T
# bug 4107

use lib '.'; use lib 't';
use SATest; sa_t_init("spamd_ssl_accept_fail");

use Test::More;
plan skip_all => "Spamd tests disabled" if $SKIP_SPAMD_TESTS;
plan skip_all => "SSL is unavailble" unless $SSL_AVAILABLE;
plan tests => 12;

# ---------------------------------------------------------------------------

%patterns = (
  q{ Return-Path: sb55sb55@yahoo.com}, 'firstline',
  q{ Subject: There yours for FREE!}, 'subj',
  q{ X-Spam-Status: Yes, score=}, 'status',
  q{ X-Spam-Flag: YES}, 'flag',
  q{ X-Spam-Level: **********}, 'stars',
  q{ TEST_ENDSNUMS}, 'endsinnums',
  q{ TEST_NOREALNAME}, 'noreal',
  q{ This must be the very last line}, 'lastline',
);

my $port = probably_unused_spamd_port();
ok (start_spamd ("-L --ssl --port $port --server-key data/etc/testhost.key --server-cert data/etc/testhost.cert"));
ok (spamcrun ("--port $port < data/spam/001", \&patterns_run_cb));
sleep(1);
ok (spamcrun ("--ssl --port $port < data/spam/001", \&patterns_run_cb));
ok (stop_spamd ());

ok_all_patterns();

