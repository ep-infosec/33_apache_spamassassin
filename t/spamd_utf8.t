#!/usr/bin/perl -T

use lib '.'; use lib 't';
use SATest; sa_t_init("spamd_utf8");

my $testlocale;

use Test::More;

BEGIN {
  $testlocale = 'en_US.UTF-8';

  my $havelocale = 1;
  local $ENV{'PATH'} = '/bin:/usr/bin:/usr/local/bin';  # must not be tainted
  open (IN, "LANG=$testlocale perl -e 'exit 0' 2>&1 |");
  while (<IN>) {
    /Please check that your locale settings/ and ($havelocale = 0);
  }
  close IN;

  plan skip_all => "Spamd tests disabled" if $SKIP_SPAMD_TESTS;
  plan skip_all => "No locale?"           unless $havelocale;

  plan tests => 3;
};

$ENV{'LANG'} = $testlocale;

%patterns = (
  q{ X-Spam-Status: Yes, score=}, 'status',
  q{ X-Spam-Flag: YES}, 'flag',
);

ok (sdrun ("-L", "< data/spam/008", \&patterns_run_cb));
ok_all_patterns();

