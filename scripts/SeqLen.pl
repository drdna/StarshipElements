#!/usr/bin/perl

open(FILE, "$ARGV[0]") || die "Where is the file?\n";

# open (OUTPUT, '>', "$ARGV[1]");

$EOL = $/;

undef $/;

$TheFile = <FILE>;

$/ = $EOL;

@List = split(/>/, $TheFile);

shift(@List);

foreach $String (@List) {

    @SubList = split(/\n/, $String, 2);

    $Contig = $SubList[0];

    @NewList = split(/\s/, $Contig);

    $Gene = $NewList[0];

    $Sequence = $SubList[1];

    $Sequence =~ s/[^A-Za-z-]//g;

    $SeqLen = length($Sequence);

    if($SeqLen < 50) {

        $ShortSeq ++

    }

    $Count++;

    $TotSeqLen += $SeqLen;

    print "$Gene\t$SeqLen\t$TotSeqLen\n";

}

print "$Count\t$TotSeqLen\n"

