package RevComp;

sub rc {

  my $Seq = $_[0];

  $Seq =~ s/[^A-Za-z]//g;

  $Seq =~ tr/AGTCagtc/TCAGtcag/;

  $Seq =~ s/[^AGTCagtc]/N/g;

  $Seq = reverse($Seq);

#  print "$Seq\n";

  return($Seq)

}

1;

