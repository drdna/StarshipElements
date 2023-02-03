#!/usr/bin/perl

#---------------------------------------------------------------------

# Identifies and reports transition mutations in the query and subject sequences

# Usage:  DeRIP_repeats.pl BLAST_file Repeats_directory

#---------------------------------------------------------------------

open(BLAST, "$ARGV[0]") or die "Cannot open file\n";

# open(RIPd_SITES_LIST, '>', $ARGV[2]);

print "Processing\n";

# declare variables

@TSQ = ();
@TSSub = ();
@RIPS_list = ();
@TotalNonRIP = ();
@QMatchStart = ();
@SMatchStart = ();
%RIPmutations = ();


while(<BLAST>) {
    $TheLine = $_;
    chomp($TheLine);

#Get Query sequence name and record length

    if($TheLine eq "") {
        next
    }

    if($TheLine =~ /^Query= (\S+)/) {
        $Query = $1; print "$Query\n"; next
    }

    if($TheLine =~ /\((.+) letters\)/) {
        $Length = $1; print "$Length\n"; next
    }

    
# Find start of High Scoring Pairs and read the HSP into two lists: @QueryList & @SubjectList
# Concatenate the Query and Subject sequences into two separate strings

    if($TheLine =~ /^Query/) { 
        @QueryList = split(/ +/, $TheLine);
        $QuerySeq .= $QueryList[2];
        $QMatchEnd = $QueryList[3];
        $Query_sequence{$Query} = $QuerySeq;
        push(@QMatchStart, $QueryList[1]); # capture start position of alignment
        next 
    } 	

    if($TheLine =~/^Sbjct/) { 
        @SubjectList = split(/ +/, $TheLine);
        $SubjectSeq .= $SubjectList[2];
        $SMatchEnd = $SubjectList[3];
        push(@SMatchStart, $SubjectList[1]);  # capture start position of alignment
        $HSP = "done";
        next
    }

# Check to see if the end of a BLAST hit has been reached
# If so, run the LookforRIP script and substitute the results
# into a 2-dimensional array

    if(($TheLine =~ /^>(\w+)|Score = |Matrix/) && ($HSP eq "done")) {

        &LookForRIP; 

        &Annotate_site_lists;  

        push @RIPQ_List, [@TSQ];
        $QuerySeq = undef;
        $SubjectSeq = undef;
        @QMatchStart = ();
        @SMatchStart = ();
        $HSP = "not done";
   }

    if($TheLine =~ /^>(\S+)/) {
        $Subject = $1
    }
}

# Make a hash containing nucleotide positions that are RIPd 
# in the query and how many times each mutation occurs

for $row (@RIPQ_List) {

    splice(@$row, 1, 6);

    $Repeat = splice(@$row, 0, 1);

    foreach $element (@$row) {

        if(exists($Ripd_sites{$Repeat}{$element})) {

            $Ripd_sites{$Repeat}{$element} ++

        }

        else {

            $Ripd_sites{$Repeat}{$element} = 1

        }

    }

}

# print RIPd_SITES_LIST "$Repeat\t$element\t$Ripd_sites{Repeat}{$element}\n";

$Row_Counter = -1;

for $row (@RIPQ_List) {

    $Row_Counter ++ 

}   

for ($i = 0; $i<=$Row_Counter; $i++) {

    $NumQTS = @{$RIPQ_List[$i]} - 7;

    $NumSTS = @{$RIPS_list[$i]} - 7;

    if($NumQTS != 0) {

        $QSTS_ratio = $NumSTS/$NumQTS

    }

    else {

        $QSTS_ratio = $NumSTS

    }
         
}

# The following module does the deRIP'ing

# open a new document to write the DeRIP'd sequence

open(DERIP, '>', "$ARGV[1]"."_DeRIPd");


# Retrieve individual sequences

for $key1 (keys %Ripd_sites) {

# Retrieve RIP'd sites

    for $key2 (keys %{$Ripd_sites{$key1}}) {

# Determine if at least "n" alignments support the hypothesis that the base was RIPd

        if($Ripd_sites{$key1}{$key2} >=10) {

# If so, add to a list of sites to be reverted

           push @Reversion_List, $key2

        }

  }


# write list to a hash keyed by sequence_id

    $Sites_needing_reversion{$key1} = [@Reversion_List];

    @Reversion_List = ()

}

# print the list of sites to be reverted to the screen

for $key (keys %Sites_needing_reversion) {

    print "$key\t@{$Sites_needing_reversion{$key}}\n"

}


# Start writing the DeRIPd sequences

$/ = undef;

open(FILE, "$ARGV[1]") || die "can't find $Repeat_name sequence\n";

$FileIn = <FILE>;

@Seqs = split(/>/, $FileIn);

shift @Seqs;

foreach $Element (@Seqs) {

  ($Repeat_name, $RIPd_sequence) = split(/\n/, $Element, 2);

  $RIPd_sequence =~ s/\W+//g;

  $SeqLen = length($RIPd_sequence);
                
  foreach $value (@{$Sites_needing_reversion{$Repeat_name}}) {

    $Old_base = substr($RIPd_sequence, ($value - 1), 1);
    
    if($Old_base eq "A") {
                    
      $DeRIPd_sequence = substr($RIPd_sequence, ($value - 1), 1, "g")
                
    }

    elsif($Old_base eq "a") {
    
      $DeRIPd_sequence = substr($RIPd_sequence, ($value - 1), 1, "G")
      
    }
                
    elsif($Old_base eq "T") {
      
      $DeRIPd_sequence = substr($RIPd_sequence, ($value - 1), 1, "c")
 
    }

    elsif($Old_base eq "t") {

      $DeRIPd_sequence = substr($RIPd_sequence, ($value - 1), 1, "C")
      
    }
           
    else {
 
      print "problem with coordinates!\n"
      
    }

  }

  print DERIP ">$Repeat_name\n$RIPd_sequence\n";

}

sub LookForRIP {

#Determine length of sequence to be analyzed (including gaps)   

    $QueryLen = length($QuerySeq);

    $QuerySeq =~ tr/AGTCN/agtcn/;

    $SubjectSeq =~ tr/AGTCN/agtcn/;
    
#Reset variables/lists for new HSP analysis

    $QCharPosAdj = 0;  
    @TSQ = ();
    @QueryList = ();
    @SubjectList = ();        

# Scan through each nucleotide position 

   for($i = 0; $i <= ($QueryLen - 1); $i ++) {
        $QueryBase = substr($QuerySeq, $i, 1);
        $SubjBase = substr($SubjectSeq, $i, 1);


# Skip non-mutant sites

	if($QueryBase eq $SubjBase) { next }


# Skip uninformative mutations (indels and ambiguous nucleotides ("n"s))

	if($QueryBase eq "-") { $QCharPosAdj -= 1; next }

    	if($SubjBase eq "-")  { next }

    	if($QueryBase eq "n") { next }

    	if(SubjBase eq "n")   { next }


# Search for RIP-like mutations.  Append nucleotide position of each mutation to the @TotalRIP list



    	if(($QueryBase eq "a") && ($SubjBase eq "g")) {
 
            $QNuclPos = $QMatchStart[0] + $i + $QCharPosAdj; 

            push(@TSQ, $QNuclPos);

            next 

        }
        
    	if(($QueryBase eq "t") && ($SubjBase eq "c")) {

            $QNuclPos = $QMatchStart[0] + $i + $QCharPosAdj;

            push(@TSQ, $QNuclPos);

            next 

        }


    } # end of "for" loop


}  # end of LookForRIP subroutine

sub Annotate_site_lists {
      


# Add information about HSP to the front of the @TotalRIP and @TotalNonRIP lists
# Query name, Query length, Subject name, HSP start position, # RIP mutations, total mutations
 
    unshift @TSQ, ($Query);


} # end of Annotate_site_lists subroutine
