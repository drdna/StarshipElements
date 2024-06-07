# Identify contigs that potentially belong to mini-chromosomes
1. BLAST raw assembly against repeat-masked B71 reference genome minus mini-chromosome (Chr8) and identify contigs lacking extended matches. Here, we require alignments to be about 20 kb in length or larger by using a -min_raw_gapped_score flag > 40000.
```bash
blastn -query U269_minion.fasta -query B71v2sh_masked.fasta -outfmt 7 -task dc-megablast -min_raw_gapped_score 40000 | grep ' 0 hits' -B 3
```
This will return a list list this:

![BLASToutput.png](/data/BLASToutput.png)
