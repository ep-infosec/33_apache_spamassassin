#!/usr/bin/perl -T

use lib '.'; use lib 't';

use SATest; sa_t_init("db_based_welcomelist");

use Test::More;
plan skip_all => "Long running tests disabled" unless conf_bool('run_long_tests');
plan tests => 8;

# ---------------------------------------------------------------------------

%is_nonspam_patterns = (
  q{ Subject: Re: [SAtalk] auto-whitelisting}, 'subj',
);
%is_spam_patterns = (
  q{Subject: 4000           Your Vacation Winning !}, 'subj',
);

%patterns = %is_nonspam_patterns;

ok (sarun ("--remove-addr-from-welcomelist whitelist_test\@whitelist.spamassassin.taint.org", \&patterns_run_cb));

# 3 times, to get into the welcomelist:
ok (sarun ("-L -t < data/nice/002", \&patterns_run_cb));
ok (sarun ("-L -t < data/nice/002", \&patterns_run_cb));
ok (sarun ("-L -t < data/nice/002", \&patterns_run_cb));

# Now check
ok (sarun ("-L -t < data/nice/002", \&patterns_run_cb));
ok_all_patterns();

%patterns = %is_spam_patterns;
ok (sarun ("-L -t < data/spam/004", \&patterns_run_cb));
ok_all_patterns();

