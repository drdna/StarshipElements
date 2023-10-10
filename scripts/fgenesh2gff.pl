#!/usr/bin/perl

# PURPOSE: parse fgenesh output into gff
# USAGE: fgenesh fish somefish.dna | fgenesh2gff > somefish.dna.fgenesh.gff

use strict;
use warnings;

use Bio::Tools::Fgenesh;    # to parse output into feature
use Bio::Tools::GFF;

# Remaining options should name files to process, but if none, process
# standard input:

@ARGV = ('-') unless @ARGV; 
my $fgenesh = Bio::Tools::Fgenesh->new(-fh => \*ARGV);
my $featureout = new Bio::Tools::GFF(-gff_version=>2);
my $IDNUM = 0;
while (my $gene = $fgenesh->next_prediction()) {
  my $ID =  $gene->seq_id . "_fgenesh_" . ++ $IDNUM;
  $gene->add_tag_value('ID', $ID);
  foreach ($gene->features) {
    $_->add_tag_value('Parent', $ID);
    $_->seq_id($gene->seq_id);
    $featureout->write_feature($_);
  }
}
$fgenesh->close();    
exit 0;
