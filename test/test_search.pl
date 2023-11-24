#!/bin/perl 
# test script src/search.pl unsing some common patterns in patterns.txt
# usage: test_search.pl
# uses patterns.txt for regex patterns 
# uses tags.txt for common repo tags to seach 
# uses result.txt for expected results

use strict;
use warnings;
use Test::More;
use lib 'src';

require 'search.pl';

my $patterns_file = "test/patterns.txt";
my $tags_file = "test/tags.txt";
my $result_file = "test/result.txt";

my @patterns = ();
my @tags = ();
my @results = ();

# read patterns 
open(my $fh, '<:encoding(UTF-8)', $patterns_file)
  or die "Could not open file '$patterns_file' $!";

while (my $row = <$fh>) {
  chomp $row;
  push @patterns, $row;
}

# read results 
open($fh, '<:encoding(UTF-8)', $result_file)
  or die "Could not open file '$result_file' $!";

while (my $row = <$fh>) {
  chomp $row;
  push @results, $row;
}

# execute search for each paaterns and ensure results match
for (my $i = 0; $i < scalar @patterns; $i++) {
  my $pattern = $patterns[$i];
  my $result = $results[$i];
  my $output = Search::find_last($pattern, $tags_file);
  is($output, $result, "search($pattern, tags.txt) == $result");
}

done_testing();

