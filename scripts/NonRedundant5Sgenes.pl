#!/usr/bin/perl
 
open(B, $ARGV[0]);

while($B = <B>) {

  chomp($B);

  @B = split(/\t/, $B);

  ($a, $b) = @B[0..1];

  unless(exists($Hash{$b})) {

    print "$a\n";

  }

  $Hash{$b} = 1

}

