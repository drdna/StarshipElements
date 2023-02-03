#!/usr/bin/perl


use FetchGenome;

open(BLAST, $ARGV[0]) || die "Can't find BLASTfile\n";

while($B = <BLAST>) {

  chomp($B);

  @BLAST = split(/\t/, $B);

  if ($BLAST[4] < $BLAST[5]) {

    push @{$RepeatHash{$BLAST[1]}}, $BLAST[4], ($BLAST[5]-$BLAST[4])+1;

  }

  else {

        push @{$RepeatHash{$BLAST[1]}}, $BLAST[5], ($BLAST[4]-$BLAST[5])+1;

  }

#  print "@{$RepeatHash{$BLAST[1]}}\n";

}

close BLAST;

  
$GenomeHashRef = FetchGenome::getSeqs($ARGV[1]);

%GenomeHash = %{$GenomeHashRef};

foreach $Sequence (keys %GenomeHash) {

#  print "$Sequence\n";

  for($i = 0; $i <= @{$RepeatHash{$Sequence}}-2; $i += 2) {

#    print "$Sequence, ${$RepeatHash{$Sequence}}[$i], ${$RepeatHash{$Sequence}}[$i+1]\n";

    substr($GenomeHash{$Sequence}, ${$RepeatHash{$Sequence}}[$i], ${$RepeatHash{$Sequence}}[$i+1], 'n' x ${$RepeatHash{$Sequence}}[$i+1]) || die "$Sequence, ${$RepeatHash{$Sequence}}[$i], ${$RepeatHash{$Sequence}}[$i+1]\n";

  }

}

foreach $Sequence (keys %GenomeHash) {

  print ">$Sequence\n$GenomeHash{$Sequence}\n";

}

 
