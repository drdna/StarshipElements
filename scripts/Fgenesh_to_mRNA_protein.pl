#!/usr/bin/perl

$ARGV[0] =~ s/\W+$//;

die "Input filename must end in _Starship_predicted_genes. Please rename file.\n" if $ARGV[0] !~ /_Starship_predicted_genes$/;

open(FILE, $ARGV[0]);

($ShortID = $ARGV[0]) =~ s/_Starship_predicted_genes//;

print "$ShortID\n";

($Path = $ARGV[0]) =~ s/(.+\/).+/$1/;

$ShortID =~ s/.+\///;

open(GENES, '>', "$Path"."$ShortID"."_genes.fasta") || die "Cannot open outfile $!\n";

open(PROTEINS, '>', "$Path"."$ShortID"."_proteins.pep");

while($Line = <FILE>) {

	chomp($Line);
	
	if($Line =~ />/) {

		if($Line =~ /mRNA/) {

			$Type = "Nucl"

		}

		else {

			$Type = ""

		}

        	$Line =~ s/FGENESH:/$ShortID/;

        	$Line =~ s/ +/_/g;

	}
	
	if($Type eq "Nucl") {

		print GENES "$Line\n"

	}

	else {
	
		print PROTEINS "$Line\n"

	}

}
