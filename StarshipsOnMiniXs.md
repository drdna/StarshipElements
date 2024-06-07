# Identify contigs that potentially belong to mini-chromosomes
1. BLAST raw assembly against repeat-masked B71 reference genome minus mini-chromosome (Chr8) and identify contigs lacking extended matches. Here, we require alignments to be about 20 kb in length or larger by using a -min_raw_gapped_score flag > 40000.
```bash
blastn -query U269_minion.fasta -query B71v2sh_masked.fasta -outfmt 7 -task dc-megablast -min_raw_gapped_score 40000 | grep ' 0 hits' -B 3
```
This will return a list list this:

![BLASToutput.png](/data/BLASToutput.png)

Note that tig0000402 does not have an extended match to the B71 reference genome even though it is > 160 kb in length. This make it a good candidate for a mini-chromosome segment.

2. If we only want a list of candidate contigs, we can modify the above code:
```bash
blastn -query U269_minion.fasta -query B71v2sh_masked.fasta -outfmt 7 -task dc-megablast -min_raw_gapped_score 40000 | grep ' 0 hits' -B 3 | awk '$0 ~ /tig/ {print $2}'
```
