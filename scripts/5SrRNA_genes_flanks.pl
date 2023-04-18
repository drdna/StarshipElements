#!/usr/bin/perl

# returns 5SrRNA genes & genes + flanks

use FetchGenome;

use RevComp;

die "Usage: perl Truncated5SrRNAs.pl <blast-report> <minion-genome>\n" if @ARGV != 2;

open(BLAST, $ARGV[0]);

($fiveS, $genome, $blast) = split(/\./, $ARGV[0]);

while($B = <BLAST>) {

  chomp($B);

  @B = split(/\t/, $B);

  # grab truncated

  if($B[6] <= 5 && $B[7] >=112) {

    $B[1] =~ s/Chr//g;

    @{$R5SHash{$B[1]}{$B[8]}} = ($B[9], 'F') if $B[8] < $B[9];

    @{$R5SHash{$B[1]}{$B[8]}} = ($B[9], 'R') if $B[9] < $B[8];

  }

}

close BLAST;

$RefRef = FetchGenome::getSeqs($ARGV[1]) || die "problem! $!\n";

%Ref = %$RefRef;

@keys = keys(%Ref);

print "@keys\n";

open(fiveS, '>', "$genome"."_5S_genes.fasta");

open(fiveSplus, '>', "$genome"."_5S_genes_plus.fasta");

foreach $Seq (sort {$a cmp $b} keys %R5SHash) {

  $Seq =~ s/Chr//g;

  foreach $pos (sort {$a <=> $b} keys %{$R5SHash{$Seq}}) {

    if(${$R5SHash{$Seq}{$pos}}[1] eq 'F') {  

      $R5Sseq = substr($Ref{$Seq}, $pos-1, (${$R5SHash{$Seq}{$pos}}[0] - $pos)+1);

      $R5SplusFlanksSeq = substr($Ref{$Seq}, $pos-201, (${$R5SHash{$Seq}{$pos}}[0]- $pos)+401)

    }

    if(${$R5SHash{$Seq}{$pos}}[1] eq 'R') {

      $Rev5Sseq = substr($Ref{$Seq}, ${$R5SHash{$Seq}{$pos}}[0]-1, ($pos-${$R5SHash{$Seq}{$pos}}[0])+1);

      $R5Sseq = RevComp::rc($Rev5Sseq);

      $Rev5SplusFlanksSeq = substr($Ref{$Seq}, ${$R5SHash{$Seq}{$pos}}[0]-201, ($pos-${$R5SHash{$Seq}{$pos}}[0])+ 401);

      $R5SplusFlanksSeq = RevComp::rc($Rev5SplusFlanksSeq);     

    }

    print fiveS ">$genome"."_Chr".$Seq."_"."$pos\n$R5Sseq\n";

    print fiveSplus ">$genome"."_Chr".$Seq."_"."$pos"."_plus\n$R5SplusFlanksSeq\n";

  }

}

close fiveS;

close fiveSplus;

;



 
