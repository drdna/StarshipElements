#!/usr/bin/perl

open(FILE, $ARGV[0]);

($ShortID = $ARGV[0]) =~ s/\..+//;

open(GENES, '>', "$ShortID"."_genes.fasta");

open(PROTEINS, '>', "$ShortID"."_proteins.pep");

while($Line = <FILE>) {

	chomp($Line);
	
	if($Line =~ />/) {
		
		if($Line =~ /mRNA/) {

			$Type = "Nucl"

		}

		else {

			$Type = ""

		}
		
		$Line =~ s/ +/_/g;

	}
	
	if($Type eq "Nucl") {

		print GENES "$Line\n"

	}

	else {
	
		print PROTEINS "$Line\n"

	}

}

