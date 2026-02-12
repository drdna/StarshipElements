# Starship mobilization
Starship mobilization is expected to produce extrachromosomal molecules and possibly result in the excision of an element from its 5S rRNA gene target. Extrachromosomal transposition intermediates could be in linear or circular forms. Element excision is expected to reconsititute an intact (empty) 5S rrNA gene because we have not found any "empty" 5S rRNA genes with target site duplications in the genomes analyzed thus far.

## Detecting extrachromosomal elements
1. Create database of sequence structures expected from starship excision ([Extrachromosomal_starships.fasta](/data/Extrachromosomal_starships.fasta)).

## Download Project fastq datasets from Teams directory
1. Visit this link and request access if needed (https://luky.sharepoint.com/:f:/r/sites/FarmanLab2/Shared%20Documents/CorrectedReads?csf=1&web=1&e=7DTVJX)

## Download fastq data from Teams Drive
https://luky.sharepoint.com/sites/FarmanLab2/Shared%20Documents/Forms/AllItems.aspx?id=%2Fsites%2FFarmanLab2%2FShared%20Documents%2FRAW%5FNANOPORE%5FDATA&viewid=dc238588%2Ddb89%2D4df9%2Da19e%2Dcb3beaac2f3a

## or...
## Download fastq datasets from NCBI
1. Download correct version of the SRA toolkit from NCBI (https://github.com/ncbi/sra-tools/wiki/01.-Downloading-SRA-Toolkit)
2. Install SRA toolkit on your local machine (https://github.com/ncbi/sra-tools/wiki/02.-Installing-SRA-Toolkit)
3. Configure the tool using these instructions: https://github.com/ncbi/sra-tools/wiki/03.-Quick-Toolkit-Configuration (NO NOT select the SRA Lite option)
4. Open a terminal and test the installation using this command:
```bash
fastq-dump --stdout -X 2 SRR390728
```
This should produce the following output and nothing else:
```bash
Read 2 spots for SRR390728
Written 2 spots for SRR390728
@SRR390728.1 1 length=72
CATTCTTCACGTAGTTCTCGAGCCTTGGTTTTCAGCGATGGAGAATGACTTTGACAAGCTGAGAGAAGNTNC
+SRR390728.1 1 length=72
;;;;;;;;;;;;;;;;;;;;;;;;;;;9;;665142;;;;;;;;;;;;;;;;;;;;;;;;;;;;;96&&&&(
@SRR390728.2 2 length=72
AAGTAGGTCTCGTCTGTGTTTTCTACGAGCTTGTGTTCCAGCTGACCCACTCCCTGGGTGGGGGGACTGGGT
+SRR390728.2 2 length=72
;;;;;;;;;;;;;;;;;4;;;;3;393.1+4&&5&&;;;;;;;;;;;;;;;;;;;;;<9;<;;;;;464262
```
If it doesn't work, specify the exact path to where the tools is installed (eg. SRAtoolkitFolder/bin/fastq-dump)
## Find the accession numbers of _Pyricularia oryzae_ Nanopore datasets
1. Go to the NCBI website. In the search bar, select SRA and type Pyricularia oryzae. Then select Oxford Nanopore on the left:

![NCBI](/data/NCBI.png)

2.Click on the link in one of the resulting entries and then note down the SRA number (ERXXXXXXX) in the **Run** field

![SRA.png](/data/SRA.png)

3. Go back to the terminal window and download the relevant dataset:
```bash
fastq-dump ERR3602158 --gzip
```
(don't close the terminal window until the data are completely transferred)

## Identify linear/circular extrachromosomal starship molecules
1. Align raw Nanopore reads (fastq or fasta format) to the database of starship structure and filter results to identify reads whose starts/ends coincide with starship borders, or span a left border/right border junction expected for a circular molecule:
```bash
minimap2 /pscratch/farman_uksr/Extrachromosomal_starships.fasta US71_nanopore.fastq.gz | awk '($3 < 20 && $8 < 20 && $5 == "+") || ($2 - $4 <20 && $8<20 && $5 == "-") || ($11 > 3000)'
```
where:
($3 < 20 && $8 < 20 && $5 == "+") identifies reads where the start coincides with the left or right border
($2 - $4 < 20 && $8 < 20 && $5 == "-") identifies reads where the end coincides with the left or right border
($11 > 3000) identifies reads that span a fused left/right border

## Detecting recent starship excisions
1. Generate database of sequences expected when each starship present in a genome excises from its 5S rRNA gene target
    a. Use table of starship coordinates to find each starship insertion in IGV browser
    b. Select 500 bp of sequence flanking the left starship border
    c. Select 500 bp of sequence flanking the right starship border
    d. Join the two borders together to create a 1 kb sequence that resembles the structure produced if the element were to excise
    e. Repeat for all starships in the genome
3. Select 1 kb flanking the insertion position in the 5S rRNA gene (e.g. [Arcadia2_popouts.fasta](/data/Arcadia2_popouts.fasta))
4. Align raw Nanopore reads (fastq or fasta format) to these structures and filter results to identify reads that span the empty 5S rRNA targets:
```bash
minimap2 /pscratch/farman_uksr/Arcadia_popouts.fasta Arcadia2_nanopore.fastq.gz | awk '$11 > 1500'
```
