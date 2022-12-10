#!/usr/bin/perl

# <@LICENSE>
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to you under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at:
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# </@LICENSE>

#
# RUN AND EDIT THIS SCRIPT IN ISO-8859-1 LOCALE
#
# Usage: lm_to_utf8.pl <xx.lm> [xx.utf8.lm]
#
# Helper to convert to latin1 based .lm into utf8.
#
# Run without output parameter to see what happens:
#   lm_to_utf8.pl fi.lm
#
# Check that no obvious unknown chars are found (add to %conv_utf8 as needed)
# When satisfied, give output file:
#   lm_to_utf8.pl fi.lm fi.utf8.lm
#

die "Missing lm" unless -f $ARGV[0];

my %conv_utf8 = (
  '�' => "\xC3\xAB",
  '�' => "\xC3\xBB",
  '�' => "\xC3\x9D",
  '�' => "\xC3\x9E",
  '�' => "\xC3\x9F",
  '�' => "\xC3\xA0",
  '�' => "\xC3\xA1",
  '�' => "\xC3\xA2",
  '�' => "\xC3\xA3",
  '�' => "\xC3\xA4",
  '�' => "\xC3\xA5",
  '�' => "\xC3\xA6",
  '�' => "\xC3\xA7",
  '�' => "\xC3\xA8",
  '�' => "\xC3\xA9",
  '�' => "\xC3\xAA",
  '�' => "\xC3\xAC",
  '�' => "\xC3\xAD",
  '�' => "\xC3\xAE",
  '�' => "\xC3\xAF",
  '�' => "\xC3\xB0",
  '�' => "\xC3\xB1",
  '�' => "\xC3\xB2",
  '�' => "\xC3\xB3",
  '�' => "\xC3\xB4",
  '�' => "\xC3\xB5",
  '�' => "\xC3\xB6",
  '�' => "\xC3\xB7",
  '�' => "\xC3\xB8",
  '�' => "\xC3\xB9",
  '�' => "\xC3\xBA",
  '�' => "\xC3\xBB",
  '�' => "\xC3\xBC",
  '�' => "\xC3\xBD",
  '�' => "\xC3\xBE",
  '�' => "\xC3\xB8",
);
my $conv_chars = join('', keys %conv_utf8);

load_models($ARGV[0]);

sub load_models {
  my ($indir) = @_;

  if ($ARGV[1]) {
    open(OUT, ">$ARGV[1]") or die;
    binmode OUT or die;
  }

  open(IN, $ARGV[0]) or die;
  binmode IN or die;
  my $changes = 0;
  while (<IN>) {
    s/\r?\n$//;
    /^([^0-9\s]+)/ or die;
    my $orig_g = $1;
    my $g = $orig_g;
    unless ($g =~ /^[a-zA-Z${conv_chars},.':;!`*"?()\-\x00]+$/) {
      print "UNKNOWN CHAR FOUND: $g\n"
    }
    foreach (keys %conv_utf8) {
      if ($g =~ s/$_/$conv_utf8{$_}/g) {
        $changes++;
        print "Changing: $orig_g -> $g\n" or die;
      }
    }
    if ($ARGV[1]) {
      print OUT "$g\n" or die;
    }
  }
  close OUT if $ARGV[1];
  close IN or die;
  print "Total changes: $changes\n";
}

