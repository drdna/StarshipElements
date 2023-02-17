# A repository of methods and codes for analyzing Starship Transposons in *Pyricularia oryzae*

# Starship Gene Predictions

## DeRIP'ing a presumed full-length element that is present in several genomes
The B71 genome contains a large Starship element that is 349.5 kb in length but genome comparisons using BLAST searched revealed a large number of transition mutations. Comparison with progenitor strains revealed that most of these mutations arose in a series of recent matings that ultimately resulted in the evolution of the wheat blast pathogen and in doing so identified Repeat-Induced Point mutation (RIP) as the mutational process. By its nature, RIP increases the AT-content of its target sequences, which in turn results in the generation of a large number of premature stop codons that negatively impact the prediction of genes within the Starship elements. Therefore, we sought to De-RIP a canonical element in B71. Briefly, we masked high copy sequences corresponding to other transposon "hitchhikers" within the Starship sequence and then BLASTed the masked element against several *P. oryzae* genome assemblies. Then, we used a custom script to convert As and Ts back to Gs and Cs, respectively, but only if there were at least 10 BLAST alignments that supported the presence of a G/C at the position in question.

1. BLAST the B71 Starship sequence against all known repeats within the *P. oryzae* genome:
```bash
blastn -query B71Starship.fasta -subject MoRepeats.fasta -evalue 1e-20 -max_target_seqs 20000 -outfmt '6 qseqid sseqid qstart qend sstart send btop' > B71Starship.MoRepeats.BLAST
```
2. Use the [CrossMask.pl](/scripts/CrossMask.pl) script to mask repeated regions within the Starship sequence:
```bash
perl CrossMask.pl B71Starship.fasta B71Starship.MoRepeats.BLAST
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
1. mRNA transcript and protein sequences were extracted fron the Fgenesh output files using the [Fgenesh_to_mRNA_protein.pl](/scripts/Fgenesh_to_mRNA_protein.pl) script:
```bash
perl path/to/Fgenesh_to_mRNA_protein.pl path/to/B71Starship.fgenesh.out
```
This produces two output files. One with the the transcript sequences and the other with proteins.

2. The protein sequences were use to search NCBI using blastp

## Identification of secreted proteins among starship cargo:

1. [Multifasta files](/data/StarshipFastas/) for each starship element were uploaded into the SignalP6 server for identification of candidate secreted proteins.

## Extracting genomic sequences flanking Starship insertions to examine 5S rRNA gene targets in other genomes
1. BLAST 5S rRNA genes against all genome assemblies
```bash
for f in `ls MINION_GENOMES/*fasta`; do blastn -query 5SrRNA.fasta -subject $f -outfmt 6 > 5SrRNA.${f/_*/}.BLAST; done
```
2. Use [5SrRNA_flanks.pl](/scripts/5SrRNA_flanks.pl) script to retrieve sequences flanking truncated 5SrRNA sequences from MINION assemblies:
```bash
for f in `ls MINION_GENOMES/*fasta`; do perl 5SrRNA_flanks.pl 5SrRNA.${f/_*/}.BLAST $f >> Truncated_5SrRNA_flanks.fasta; done
```
