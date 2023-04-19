#!/usr/bin/perl

use File::Path;
mkpath("$ARGV[1]");
open(FILE, $ARGV[0]);
$/ = undef;
$L = <FILE>;
@Seqs = split(/>/, $L);
shift @Seqs;
foreach $Entry (@Seqs) {
  ($ID, $Seq) = split(/\n/, $Entry, 2);
  $ID =~ s/\s.+//g;
  open(OUT, '>', "$ARGV[1]/$ID".".fasta");
  print OUT ">$ID\n$Seq";
  close OUT
}
close FILE;  
