# Do Starship elements contain copies of chromosomal genes? Are starship elements picking up chromosomal genes and moving them around?
## Approach: BLAST predicted starship genes against the host genome.
### 1. Obtain nucleotide sequences of predicted starship genes (from Morgan)
2. Perform BLAST search and filter results to retrieve matches that cover ≥90% of each starship gene copy
```bash
blastn -query Starship_genes.fasta -subject Host_genome.fasta -outfmt '6 qseqid sseqid qlen pident length mismatch gapopen qstart qend sstart send evalue score' | awk '$5/$3 > 0.9' | sort -k1,1 -k4,4nr -k5,5n > Starship_gene_hits.BLAST
```
3. Summarize results in Starship_Gene_Copies data sheet. Document blast report and summarize the duplication: Chromosome, position, % alignment, % identity

# Did chromosomal genes found on starship originate in another strain?

# Evidence for the existence of Starship para-orthologs?
## Approach: perform parallel blastn and blastp searches
