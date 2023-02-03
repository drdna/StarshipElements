#!/usr/bin/perl

use FetchGenome;

die "Usage: perl Truncated5SrRNAs.pl <blast-report> <minion-genome>\n" if @ARGV != 2;

open(BLAST, $ARGV[0]);

while($B = <BLAST>) {

  chomp($B);

  @B = split(/\t/, $B);

  # grab truncated

  if($B[6] <= 5 && $B[7] <=65) {

    @{$TruncHash{$B[1]}{$B[9]}} = ($B[8], 'L', 'F') if $B[8] < $B[9];

    @{$TruncHash{$B[1]}{$B[9]}} = ($B[8], 'L', 'R') if $B[9] < $B[8];

  }

  elsif($B[6] > 60 && $B[7] > 112) {

    @{$TruncHash{$B[1]}{$B[8]}} = ($B[9], 'R', 'F') if $B[8] < $B[9];

    @{$TruncHash{$B[1]}{$B[8]}} = ($B[9], 'R', 'R') if $B[9] < $B[8];

  }

}

close BLAST;

$RefRef = FetchGenome::getSeqs($ARGV[1]) || die "problem! $!\n";

%Ref = %$RefRef;

foreach $Seq (sort {$a cmp $b} keys %TruncHash) {

  foreach $pos (sort {$a <=> $b} keys %{$TruncHash{$Seq}}) {

    if(${$TruncHash{$Seq}{$pos}}[1] eq 'L') {

      $subSeq = substr($Ref{$Seq}, ${$TruncHash{$Seq}{$pos}}[0]-501, 500) if ${$TruncHash{$Seq}{$pos}}[2] = 'F';

      $subSeq = substr($Ref{$Seq}, ${$TruncHash{$Seq}{$pos}}[0]-501, 500) if ${$TruncHash{$Seq}{$pos}}[2] = 'R';

      $subSeq .= substr($Ref{$Seq}, $pos, 500)

    }

    elsif(${$TruncHash{$Seq}{$pos}}[1] eq 'R'){

      $subSeq = substr($Ref{$Seq}, $pos-501, 500);

      $subSeq .= substr($Ref{$Seq}, ${$TruncHash{$Seq}{$pos}}[0], 500) ${$TruncHash{$Seq}{$pos}}[1];

    }

    print ">$Seq"."_"."$pos\n$subSeq\n";

  }

}
;



 
