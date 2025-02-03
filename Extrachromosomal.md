# Starship mobilization
Starship mobilization is expected to produce extrachromosomal molecules and possibly result in the excision of an element from its 5S rRNA gene target. Extrachromosomal transposoition intermediates could be in linear or circular forms. Element excision is expected to reconsititute an intact (empty) 5S rrNA gene because we have not found any "empty" 5S rRNA genes with target site duplications in the genomes analyzed thus far.

1. Create database of sequence structures expected from starship excision ([Extrachromosomal_starships.fasta](/data/Extrachromosomal_starships.fasta)).
2. Align raw Nanopore reads (fastq or fasta format) to these structures and filter results to identify reads whose starts/ends coincide with starship borders, or span a left border/right border junction expected for a circular molecule:
```bash
minimap2 /pscratch/farman_uksr/Extrachromosomal_starships.fasta /pscratch/farman_uksr/MISC_NANOPORE_DATA/US71_nanopore.fastq.gz | awk '($3 < 20 && $8 < 20 && $5 == "+") || ($2 - $4 <20 && $8<20 && $5 == "-") || ($11 > 3000)'
```
where:
($3 < 20 && $8 < 20 && $5 == "+") identifies reads where the start coincides with the left or right border
($2 - $4 < 20 && $8 < 20 && $5 == "-") identifies reads where the end coincides with the left or right border
($11 > 3000) identifies reads that span a fused left/right border

