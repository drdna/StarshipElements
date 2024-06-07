# Identify contigs that potentially belong to mini-chromosomes
1. BLAST raw assembly against repeat-masked B71 reference genome minus mini-chromosome (Chr8) and identify contigs lacking extended matches
```bash
blastn -query U269_minion.fasta -query B71v2sh_masked.fasta -outfmt 7 -task dc-megablast -min_raw_gapped_score 40000 | grep ' 0 hits' -B 3
```
This will return a list like this:
\# BLASTN 2.14.1+
\# Query: tig00000269 len=35708 reads=8 class=contig suggestRepeat=no suggestCircular=no
\# Database: User specified sequence set (Input: B71v2sh_masked.fasta)
\# 0 hits found
--
# BLASTN 2.14.1+
# Query: tig00000402 len=168017 reads=91 class=contig suggestRepeat=no suggestCircular=no
# Database: User specified sequence set (Input: B71v2sh_masked.fasta)
# 0 hits found
--
# BLASTN 2.14.1+
# Query: tig00000404 len=37922 reads=9 class=contig suggestRepeat=no suggestCircular=no
# Database: User specified sequence set (Input: B71v2sh_masked.fasta)
# 0 hits found
--
# BLASTN 2.14.1+
# Query: tig00000446 len=38836 reads=8 class=contig suggestRepeat=no suggestCircular=no
# Database: User specified sequence set (Input: B71v2sh_masked.fasta)
# 0 hits found
--

