#!/usr/bin/perl

use FetchGenomeOrig;

open(LIST, $ARGV[0]);

open(TEMP, '>', "Starship.temp") || die "Can't open temp file\n";

while($L = <LIST>) {

  chomp($L);

  ($Genome, $Chr, $Start, $End) = split(/\t/, $L);

  $genomePath = `ls MINION/$Genome*nh.fasta`;

  $genomePath =~ s/\n//;

#  print "$genomePath\n";

#  print "I'm here\n";

  $SeqRef = FetchGenomeOrig::getSeqs($genomePath);

  %SeqHash = %$SeqRef;

  $Chr = "Chr".$Chr;

  $LFseq = substr($SeqHash{$Chr}, $Start - 499, 500); 

  $LFheader =  "$Genome"."_".$Chr."_".$Start."-".$End."_LF";

  $Seqs{$LFheader} = $LFseq;

  $RFseq = substr($SeqHash{$Chr}, $End - 1, 500);

  print TEMP ">$LFheader\n$LFseq\n";

  $RFheader = "$Genome"."_".$Chr."_".$Start."-".$End."_RF";
 
  $Seqs{$RFheader} = $RFseq;

  print TEMP ">$RFheader\n$RFseq\n";

}

close LIST;

close TEMP;

$blastcmd = "-subject 5SrRNA.fasta -query Starship.temp -outfmt '6 qseqid sseqid qstart qend'";

$blast = `blastn $blastcmd`;

@blast = split(/\n/, $blast);

open(OUT, '>', "Starship_flanks.fasta") || die "Can't open outfile\n";

foreach $line (@blast) {

  $trimmed = 'no';

  ($id, $rRNA, $qs, $qe) = split(/\t/, $line);

  if($id =~ /LF/ && $qe > 490) {

    substr($Seqs{$id}, $qs-1, ($qe-$qs)-1, '');

    $trimmed = 'yes'

  }

  if($id =~ /RF/ && $qs < 10) {

    substr($Seqs{$id}, $qs-1, ($qe-$qs)-1, '');

    $trimmed = 'yes'

  }

  print OUT ">$id\n$Seqs{$id}\n" if $trimmed eq 'yes';

}

close OUT;

unlink "starship.temp";

system("cat 5SrRNA.fasta Starship_flanks.fasta > Starship_flanks2.fasta; mv Starship_flanks2.fasta Starship_flanks.fasta");

