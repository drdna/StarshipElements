# Characterization of 5s rRNA gene polymorphism

## A. Retrieve 5S rRNA genes plus flanks from each genome

1. Blast [5S rRNA gene sequence](/data/5SrRNA.fasta) against target genome to determine their chromosomal locations:
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

1. Blast 5s rRNA genes+flanks sequence from one genome against another genome sequence and identify matches that span the entire 5S rRNA gene locus + the flanks. Use awk to filter the matches to find only intact 5S loci. Save matches to file so as to allow masking of the identified loci in other genomes:
```bash
cd GenomeDir
blastn -query target1_5S_genes_plus.fasta -subject target2.fasta -outfmt 6 | awk '$4 > 400' > target1_intact5S.target2.BLAST
```
2. Blast 5s rRNA genes+flanks sequence from one genome against another genome sequence and identify 5S rRNA genes with Starship insertions (intact and remnants):
```bash
blastn -query target1_5S_genes_plus.fasta -subject target2.fasta -outfmt 6 | awk '$4 > 220 && $4 < 280' > target1_5SplusSS.target2.BLAST
```
## C. Search for new 5S in next genome (target2):

1. Use the previous blast match information to mask 5S loci that have already been characterized:
```bash
perl CrossMask.pl target1_intact5S.target2.BLAST target2.fasta > target2_5S_masked.fasta
```
2. Search for new 5S rRNA genes in masked genomes (here we are repeating step A above but with the masked genome we just created):
```bash
blastn -query 5SrRNA.fasta -subject target2_5S_masked.fasta -outfmt 6 > 5SrRNA.target2_5S_masked.BLAST
```
3. Repeat from step A.2. (above)

## C. Identify non-redundant set of intact 5S rRNA genes
1. BLAST all 5S rRNA genes against one another and filter using [NonRedundant5Sgenes.pl](/scripts/NonRedundant5Sgenes.pl) script to find full length copies:
```bash
blastn -query All_5S_rRNA_genes_plus.fasta -subject All_5S_rRNA_genes_plus.fasta -outfmt 6 2>/dev/null| awk '$4 > 450 && $4 < 500' | NonRedundant5Sgenes.pl - | uniq > NonRedundant5SrRNAgenes.txt
```

