# Starship Gene Predictions

## Repeat masking of Starship transposons for Funannotate
1. Blast MoRepeat.fasta file against the 25PolishedSS.fasta file
```bash
blastn -query MoRepeats.fasta -subject 25PolishedSS.fasta -outfmt '6 qseqid sseqid qstart qend sstart send btop' > MoRepeats.25PolishedSS.BLAST
```
2. Run CrossMaskLC.pl script:
```bash
perl CrossMaskLC.pl MoRepeats.25PolishedSS.BLAST 25PolishedSS.fasta > 25PolishedSS_masked.fasta
```
3. Rename headers for Funannotate:
```bash
perl SimpleFastaHeaders_SB.pl 25PolishedSS_masked.fasta 25ss.fasta
mv 25ss_nh.fasta 25SS.fasta
```
## Funannotate Setup
```bash
funannotate setup -i all --update
```
## Funannotate Train
```bash
singularity run --app funannotate1817 /share/singularity/images/ccs/conda/amd-conda22-rocky9.sinf \
  funannotate train -i $genome -o funannotate --single $forwardreads --jaccard_clip --species "Pyricularia oryzae" --strain FR13 --cpus 16
```
## Funannotate Predict
```bash
singularity run --app funannotate1817 /share/singularity/images/ccs/conda/amd-conda22-rocky9.sinf \
  funannotate predict -i $genome -o $outdir -s $species --strain $strain --augustus_species magnaporthe_grisea --cpus 16
```
## Funannotate Update
```bash
funannotate update -i funannotate --cpus 16
```
## eggnog-mapper
```bash
emapper.py -i $fasta -o $outfile --cpu 32 --override
```
## Phobius
```bash
  perl jphobius_models/phobius/phobius.pl -long /scratch/farman/24NewSS_maker.proteins.fasta 2>/dev/null > 24NewSSphobius.txt
```
## antismash
```bash
sbatch antismash.sh /scratch/farman/24NewSS_maker.proteins.fasta
```
## Funannotate annotate

## Summarizing Gene Content
Determine how many distinct genes are contained on starships and their distribution across elements:
```bash
blastn -query 25SS_genes.fasta -subject 25SSgenes.fasta -outfmt 6 > 25SSgenes.25SSgenes.BLAST
```
Group genes based on BLAST overlaps:
```bash
python UniqueSSgenes.py
```
This identified 216 gene groups but revealed some genes with as many as 63 distinct blast matches (>> number of starships). This suggested that some genes were mis-predicted and bridged intergenic spaces between genes. Therefore, we examined annotations for members of each cluster to identify possible gene merging (e.g.):
```bash
echo "FUN_000018, FUN_000034, FUN_000035, FUN_000100, FUN_000102, FUN_000104, FUN_000105, FUN_000112, FUN_000128, FUN_000129, FUN_000133, FUN_000137, FUN_000142, FUN_000158, FUN_000159, FUN_000181, FUN_000248, FUN_000249, FUN_000261, FUN_000310, FUN_000314, FUN_000320, FUN_000325, FUN_000329, FUN_000339, FUN_000347, FUN_000348, FUN_000409, FUN_000434, FUN_000435, FUN_000550, FUN_000577, FUN_000606, FUN_000607" | tr -d ' ' | tr ',' '\n' | xargs -I{} grep {} 25SSnewPredict.proteins.emapper.annotations
```
We further examined overlaps by mapping predicted genes to the starships using minimap2:
```bash
minimap2 25SS_genes.fasta 25SS.fasta > 25SSgenes.25SS.paf
```
Merged genes were then manually split to determine final counts.
## DeRIP'ing a presumed full-length element that is present in several genomes
The B71 genome contains a large Starship element that is 349.5 kb in length but genome comparisons using BLAST searches revealed a large number of transition mutations. Comparison with progenitor strains revealed that most of these mutations arose in a series of recent matings that ultimately resulted in the evolution of the wheat blast pathogen and in doing so identified Repeat-Induced Point mutation (RIP) as the mutational process. By its nature, RIP increases the AT-content of its target sequences, which in turn results in the generation of a large number of premature stop codons that negatively impact the prediction of genes within the Starship elements. Therefore, we sought to De-RIP a canonical element in B71. Briefly, we masked high copy sequences corresponding to other transposon "hitchhikers" within the Starship sequence and then BLASTed the masked element against several *P. oryzae* genome assemblies. Then, we used a custom script to convert As and Ts back to Gs and Cs, respectively, but only if there were at least 10 BLAST alignments that supported the presence of a G/C at the position in question.

1. BLAST the B71 Starship sequence against all known repeats within the *P. oryzae* genome:
```bash
blastn -query B71Starship.fasta -subject MoRepeats.fasta -evalue 1e-20 -max_target_seqs 20000 -outfmt '6 qseqid sseqid qstart qend sstart send btop' > B71Starship.MoRepeats.BLAST
```
2. Use the [CrossMask.pl](/scripts/CrossMask.pl) script to mask known transposons within the Starship sequence (CrossMask uses the [FetchGenome](scripts/FetchGenome.pm) module that must be installed in a location in the PERL libraries path, and made executable):
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
### Fgenesh
1. mRNA transcript and protein sequences were extracted from the Fgenesh output files using the [Fgenesh_to_mRNA_protein.pl](/scripts/Fgenesh_to_mRNA_protein.pl) script:
```bash
perl path/to/Fgenesh_to_mRNA_protein.pl path/to/B71Starship.fgenesh.out
```
This produces two output files. One with the the transcript sequences and the other with proteins.
2. Conversion of fegenesh outputs to gff format using [fgenesh2gff.pl](/scripts/fgenesh2gff.pl) script (needs Bio-Perl installed):
```bash
perl fgenesh2gff.pl <fegenesh_outfile>
```
3. The protein sequences were use to search NCBI using blastp
### MAKER


## Functional annotation using eggnog-mapper
```bash
fasta="Bm88324_SSproteins_nh.fasta"; for f in $(grep ">" $fasta | sed 's/>//'); do samtools faidx $fasta $f > ${f/:/_}.fasta; singularity run --app eggnogmapper2112 /share/singularity/images/ccs/conda/amd-conda22-rocky9.sinf emapper.py -i ${f/:/_}.fasta -o ${f/:/_} --cpu 8 --override; done
```
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
## Starship Phylogenetics
1. Use [Intact_5SrRNA_flanks.pl](/scripts/Intact_5SrRNA_flanks.pl) script to retrieve 5 kb of each flanking sequence from intact 5S rRNA genes:
```bash
perl Intact_5SrRNA_flanks.pl 5SrRNA.CD156.BLAST > CD156_5S_flanks.fasta
```
# Exploration of Large Language Models for Gene Prediction
Data for the B71 startship and the corresponding region of the 70-15 genome were processed through SegmentNT to produce output files, [SegmentNToutput_region_70-15.csv](/data/SegmentNToutput_region_70-15.csv) and [SegmentNToutput_region_B71.csv](/data/SegmentNToutput_region_B71.csv). These were plotted using the [SegmentNTplots.R](/scripts/SegmentNTplots.R) script. Predicted genes were added to the plot using [70-15_target_region.gff](/data/70-15_target_region.gff) and [B71_target_region.gff](/data/B71_target_region.gff) annotation files.
## B71 plot
![SegmentNTplot_B71.png](/data/SegmentNTplot_B71.png)

## 70-15 plot
![SegmentNTplot_70-15.png](/data/SegmentNTplot_70-15.png)

