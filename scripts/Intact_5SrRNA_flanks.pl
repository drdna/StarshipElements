#!/usr/bin/perl

use FetchGenome;

use RevComp;

die "Usage: perl Truncated5SrRNAs.pl <blast-report> <minion-genome>\n" if @ARGV != 2;

die "Blast report must be named according to the format query.subject.BLAST, where query = 5SrRNA; subject = genome\n" if $ARGV[0] !~ /.+?\.(.+)?\.BLAST/;

open(BLAST, $ARGV[0]);

($strain = $ARGV[0]) =~ s/.+?\.(.+)?\.BLAST/$1/;

while($B = <BLAST>) {

  chomp($B);

  @B = split(/\t/, $B);

  # grab intact 5S loci hits
  # store in a hash keyed by contig, start coordinate in genome
  # with values 

  if($B[6] <= 5 && $B[7] >=112) {

    $B[1] =~ s/Chr//i;





    @{$TruncHash{$B[1]}{$B[9]}} = ($B[8], 'L', 'F') if $B[8] < $B[9];

    @{$TruncHash{$B[1]}{$B[9]}} = ($B[9], 'L', 'R') if $B[9] < $B[8];

    @{$TruncHash{$B[1]}{$B[8]}} = ($B[9], 'R', 'F') if $B[8] < $B[9];

    @{$TruncHash{$B[1]}{$B[8]}} = ($B[8], 'R', 'R') if $B[9] < $B[8];

  }

}

close BLAST;

$RefRef = FetchGenome::getSeqs($ARGV[1]) || die "problem! $!\n";

%Ref = %$RefRef;

foreach $Seq (sort {$a cmp $b} keys %TruncHash) {

  foreach $pos (sort {$a <=> $b} keys %{$TruncHash{$Seq}}) {

    if(${$TruncHash{$Seq}{$pos}}[1] eq 'L') {

      $subSeq = substr($Ref{$Seq}, ${$TruncHash{$Seq}{$pos}}[0]-5001, 5000);

      $subSeq = RevComp::rc($subSeq) if ${$TruncHash{$Seq}{$pos}}[2] eq 'R';

    }

    elsif(${$TruncHash{$Seq}{$pos}}[1] eq 'R'){

      $subSeq = substr($Ref{$Seq}, ${$TruncHash{$Seq}{$pos}}[0]-1, 5000);

      $subSeq = RevComp::rc($subSeq) if ${$TruncHash{$Seq}{$pos}}[2] eq 'R';

    }

    print ">$strain"."_Chr"."$Seq"."_"."$pos\n$subSeq\n";

  }

}
;



 
