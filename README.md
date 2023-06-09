# A repository of methods and codes for analyzing Starship Transposons in *Pyricularia oryzae*

# Access [MINION genomes](https://luky.sharepoint.com/:f:/r/sites/FarmanLab/Shared%20Documents/4_MINION_GENOMES?csf=1&web=1&e=tGH6ee)

# Determine genome lengths

1. Run the SeqLen.pl script:
```bash
perl SeqLen.pl <genome.fasta>
```
# Characterization of 5s rRNA gene targets (Brianna)

## A. Retrieving 5S rRNA genes plus flanks from each genome

1. Blast [5S rRNA gene sequence](/data/5SrRNA.fasta) against target genome:
```bash
cd GenomeDir
blastn -query 5SrRNA.fasta -subject target1.fasta -outfmt 6 > 5SrRNA.target1.BLAST
```
2. Use [5SrRNA_genes_flanks.pl](/scripts/5SrRNA_genes_flanks.pl) script to retrieve intact 5S rRNA gene sequences & 5S rRNA gene sequences + flanks (200 bp):
```bash
perl 5SrRNA_genes_flanks.pl 5SrRNA.target1.BLAST target1.fasta
```
This will create two files, one named target1_5S_genes.fasta and the other, target1_5S_genes_plus.fasta

Note: To automate 5S gene retrieval, use 'for' loop to iterate through genome files:
```bash
for genome in `ls GenomeDir/*fasta`; do g=${genome/\.fasta/}; perl 5SrRNA_genes_flanks.pl 5SrRNA.${g}.BLAST $genome; done
``` 

## B. Cross-genome comparison of 5S rRNA gene targets (Brianna)

1. Blast 5s rRNA genes+flanks sequence from one genome against another genome sequence and identify matches that span the entire 5S rRNA gene locus:
```bash
cd GenomeDir
blastn -query target1_5S_genes_plus.fasta -subject target2.fasta -outfmt 6 | awk '$4 > 400' > target1_intact5S.target2.BLAST
```
2. Blast 5s rRNA genes+flanks sequence from one genome against another genome sequence and identify 5S rRNA genes with Starship insertions (intact and remnants):
```bash
blastn -query target1_5S_genes_plus.fasta -subject target2.fasta -outfmt 6 | awk '$4 > 220 && $4 < 280' > target1_5SplusSS.target2.BLAST
```
## C. Search for new 5S in other genomes:

1. Mask 5S loci that have already been characterized:
```bash
perl CrossMask.pl target1_intact5S.target2.BLAST target2.fasta > target2_5S_masked.fasta
```
2. Search for new 5S rRNA genes in masked genomes (here we are repeating step A above but with the masked genome we just created):
```bash
blastn -query 5SrRNA.fasta -subject target2_5S_masked.fasta -outfmt 6 > 5SrRNA.target2_5S_masked.BLAST
```

# Starship Gene Predictions

## DeRIP'ing a presumed full-length element that is present in several genomes
The B71 genome contains a large Starship element that is 349.5 kb in length but genome comparisons using BLAST searched revealed a large number of transition mutations. Comparison with progenitor strains revealed that most of these mutations arose in a series of recent matings that ultimately resulted in the evolution of the wheat blast pathogen and in doing so identified Repeat-Induced Point mutation (RIP) as the mutational process. By its nature, RIP increases the AT-content of its target sequences, which in turn results in the generation of a large number of premature stop codons that negatively impact the prediction of genes within the Starship elements. Therefore, we sought to De-RIP a canonical element in B71. Briefly, we masked high copy sequences corresponding to other transposon "hitchhikers" within the Starship sequence and then BLASTed the masked element against several *P. oryzae* genome assemblies. Then, we used a custom script to convert As and Ts back to Gs and Cs, respectively, but only if there were at least 10 BLAST alignments that supported the presence of a G/C at the position in question.

1. BLAST the B71 Starship sequence against all known repeats within the *P. oryzae* genome:
```bash
blastn -query B71Starship.fasta -subject MoRepeats.fasta -evalue 1e-20 -max_target_seqs 20000 -outfmt '6 qseqid sseqid qstart qend sstart send btop' > B71Starship.MoRepeats.BLAST
```
2. Use the [CrossMask.pl](/scripts/CrossMask.pl) script to mask repeated regions within the Starship sequence (CrossMask uses the [FetchGenome module](scripts/README.md#2-perl-modules-used-in-various-scripts) that must be installed in a location in the PERL libraries path, and made executable):
```bash
perl CrossMask.pl B71Starship.MoRepeats.BLAST B71Starship.fasta
```
3. BLAST the masked Starship against an adhoc selection of *P. oryzae* genome assemblies (preferably non wheat blast/*Lolium* pathogens to minimize likelihood of comparing against other RIPd starships):
```bash
for f in `ls RAW_GENOMEs/[CEUZ]*fasta`; do blastn -query B71StarshipMasked.fasta -subject $f -evalue 1e-100 -outfmt 0 >> B71Starships.CEUZ.BLAST; done 
```
4. Use the alignment information in the resulting BLAST report to inform the [DeRIP.pl](/scripts/DeRIP.pl) script which sites in the Starship element it should de-RIP:
```bash
perl DeRIP.pl B71Starships.CEUZ.BLAST B71Starship_masked.fasta
```
This produced the DeRIP'd sequence: [B71StarshipMaskedDeRIPd.fasta](/data/B71StarshipMaskedDeRIPd.fasta)

## Gene prediction in Starship Transposons
1. mRNA transcript and protein sequences were extracted from the Fgenesh output files using the [Fgenesh_to_mRNA_protein.pl](/scripts/Fgenesh_to_mRNA_protein.pl) script:
```bash
perl path/to/Fgenesh_to_mRNA_protein.pl path/to/B71Starship.fgenesh.out
```
This produces two output files. One with the the transcript sequences and the other with proteins.

2. The protein sequences were use to search NCBI using blastp

## Identification of secreted proteins among starship cargo:

1. [Multifasta files](/data/StarshipFastas/) for each starship element were uploaded into the [SignalP6 server](https://services.healthtech.dtu.dk/service.php?SignalP) for identification of candidate secreted proteins.

## Determine copy number of starship genes in each host genome (Raina)
1. Download gene predictions fasta files (XXXX_genes.fasta) from the [Deripped gene predictions](https://drive.google.com/drive/u/0/folders/10hqhFidG4XRdHH0CA26XTvq_yIwpeguB) folder on GoogleDrive. For this example, I am using the DR_B71v2sh_Chr3_1528859-1878215_genes.fasta file:
2. Change into directory containing the downloaded fasta file:
```bash
cd Starships/
```
3. Blast genes against corresponding genome (note this script uses awk to give each gene a simple gene name):
```bash
i=0; awk '{if($0 ~ /^>/) {i++; print ">gene" i} else {print $0}}' DR_B71v2sh_Chr3_1528859-1878215_genes.fasta | blastn -query - -subject ~/path/to/B71v2sh.fasta -outfmt '6 qseqid sseqid qlen pident length mismatch gapopen qstart qend sstart send evalue score' | sort -k1.5,1n -k2.4,2 -k10,10n > B71v2sh_Chr3_1528859-1878215.B71v2sh.BLAST
```
note: make sure you; i) change "~/path/to/" to the actual path containing the genome file; change the input and output file names as appropriate.


## Extracting genomic sequences flanking Starship insertions to examine 5S rRNA gene targets in other genomes
1. BLAST 5S rRNA genes against all genome assemblies
```bash
for f in `ls MINION_GENOMES/*fasta`; do blastn -query 5SrRNA.fasta -subject $f -outfmt 6 > 5SrRNA.${f/_*/}.BLAST; done
```
2. Use [5SrRNA_flanks.pl](/scripts/5SrRNA_flanks.pl) script to retrieve sequences flanking truncated 5SrRNA sequences from MINION assemblies:
```bash
for f in `ls MINION_GENOMES/*fasta`; do perl 5SrRNA_flanks.pl 5SrRNA.${f/_*/}.BLAST $f >> Truncated_5SrRNA_flanks.fasta; done
```
