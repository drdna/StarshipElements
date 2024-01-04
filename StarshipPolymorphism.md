# Characterization of Starship Polymorphism
Starship elements display remarkable strain-to-strain variation in their occupancy of specific chromosomes. The goal of the methods reported below is to analyze the structure of specific 5S rRNA gene loci that are known to contain starship insertions in at least one genome. The specific steps involved include retrieval of sequences flanking the target 5S rRNA gene, alignment of those sequences against all other genomes and then visualization of the alignments in the IGV browser.

## A. Retrieving Starship flanks (minus truncated 5S rRNA genes) from each genome:

1. Start with a list of the coordinates of starship left and right borders in each genome ([Starship_coordinates.txt](/data/Starship_coordinates.txt)).
2. Run the [Starship_flanks.pl](/scripts/Starship_flanks.pl) script which reads each genome assembly, retrieves 500 bp of left and right flank from each starship contained therein, clips off the 5S rRNA genes, and then adds 5SrRNA gene sequences to resulting outfile ([Starship_flanks.fasta](/data/Starship_flanks.fasta)):
```bash
perl Starship_flanks.pl Starship_coordinates.txt
```
2. Run FACET to align starship flank sequences to each genome (in no clean/GFF format):
```bash
for f in `ls MINION_GENOMES/*nh.fasta`; do FACET db_free $f Starship_flanks.fasta -nc -g; done
```
3. Use [StarshipRe-color.sh](/scripts/StarshipRe-color.sh) script to modify GFF file to color full-length 5S rRNA gene alignments in red (for easier interpretation of locus structure). The script also filters out partial alignments of flanking sequences which greatly de-clutters the IGV workspace.
```bash
for f in `ls FACET_output/*/*Starship_flanks*gff`; do ./StarshipRe-color.sh $f; rm $f; done
```
## Visualizing output files in the IGV browser:
By filtering out partially aligned flank sequences and using queries that contain just starship flanks without the adjacent, interrupted 5S rRNA gene targets, this greatly simplifies the interpretation of alignments:

![WholeChromosomeView.png](/data/WholeChromosomeView.png)

Figure 1. Whole chromosome view of chromosome 1 in strain Arcadia2 showing intact 5S rRNA copies (red), truncated 5S rRNA genes (orange and yellow) and alignments to intact starship flanks (blue).


![Intact5SrRNA.png](/data/Intact5SrRNA.png)

Figure 2. Zoomed in view showing that sequences flanking a starship insertion present on Chromosome 1 in strains CD156 and FR13 flank an intact 5S rRNA gene copy in strain Arcadia2.

## Improving efficiency with IGV navigation:
1. Create a .bed file listing coordinates of relevant features present in the gff file:
```bash
awk '{print $1, ($4)-1000, ($5)+1000}' FACET_output/Arcadia2-c1/Arcadia2-c1_Starship_flanks_recolored_noclean.gff > Arcadia_flanks.bed
```
2. Use the [igv-reports](https://github.com/igvteam/igv-reports) tool to generate easily navigable html renditions of IGV windows:
```bash
igv_reports/report.py Arcadia2_flanks.bed --fasta Arcadia2-c1.fasta  --flanking 1000 --tracks FACET_output/Arcadia2-c1/Arcadia2-c1_Starship_flanks_recolored_noclean.gff --output Arcadia_reports2.html
```
 
