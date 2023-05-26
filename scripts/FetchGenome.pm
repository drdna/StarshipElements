package FetchGenome;

sub getAlign {

  my %GenomeHash;

  open(GENOME, "$_[0]") || die "Can't open genome file\n";

  while(my $alignRecord = <GENOME>) {

    my ($ID, $Seq) = split(/\t/, $alignRecord, 2);

    $ID =~ s/[^A-Za-z-0-9]|//g;

    $ID =~ s/.+?(\d+)$/$1/;

    $AlignHash{$ID} = $Seq 

  }

  close GENOME;

  return(\%AlignHash)

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

    $ID =~ s/ +.+//;

    $ID =~ s/.+?([0-9]+)$/$1/ unless $stripID eq 'no';

    $Seq =~ s/[^A-Za-z-]//g;

    $Seq =~ s/\r//g;

    $GenomeHash{$ID} = $Seq

  }

  close GENOME;

  $/ = $EOL;

  return(\%GenomeHash)

}


sub getLens {

  my %GenomeHash;

  my $EOL = $/;

  $/ = undef;

  open(GENOME, "$_[0]") || die "Can't open genome file\n";

  my $wholeRecord = <GENOME>;

  my @GenomeList = split(/>/, $wholeRecord);

  shift @GenomeList;

  foreach my $fastaRecord (@GenomeList) {

    my ($ID, $Seq) = split(/\n/, $fastaRecord, 2);

    $ID =~ s/[^A-Za-z0-9-_]//g;

# comment next line to STOP stripping everything off sequence identifier except numeric identifiers

    $ID =~ s/.+?(\d+$)/$1/;

    $Seq =~ s/[^A-Za-z-]//g;

    $RefSeqLen = length($Seq);

    $GenomeLenHash{$ID} = $RefSeqLen;

  }

  close GENOME;

  $/ = $EOL;

  return(\%GenomeLenHash)

}

1;
