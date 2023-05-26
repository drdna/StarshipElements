#!/usr/bin/perl

# written by Mark Farman (07/27/2022)

# Sequence to mask must be blast query (and have no spaces in header lines)
# blast -outfmt must be '6 qseqid sseqid qstart qend sstart send btop'

die "Usage: perl CrossMask.pl <blast-file> <sequence-to-mask>\n" if @ARGV != 2;

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

  
$GenomeHashRef = getSeqs($ARGV[1]);

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

sub getSeqs {

  my %GenomeHash;

  my $EOL = $/;

  $/ = undef;

  my $genomeName = $_[0];
 
  my $stripID = $_[1];

  open(GENOME, "$genomeName") || die "Can't open genome file\n";

  my $wholeRecord = <GENOME>;

  my @GenomeList = split(/>/, $wholeRecord);

  shift @GenomeList;

  foreach my $fastaRecord (@GenomeList) {

    my ($ID, $Seq) = split(/\n/, $fastaRecord, 2);

#    $ID =~ s/[^A-Za-z-0-9.]|//g;

## following line can be uncommented if sequence header prefix (but not number) differs between the genome being studied and the alignstring.

    $ID =~ s/.+?([0-9]+)$/$1/ unless $stripID eq 'no';


#    $ID =~ s/ +.+//;

    $Seq =~ s/[^A-Za-z-]//g;

    $Seq =~ s/\r//g;

    $GenomeHash{$ID} = $Seq

  }

  close GENOME;

  $/ = $EOL;

  return(\%GenomeHash)

}

 
