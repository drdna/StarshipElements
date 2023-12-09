# Basecalling and Genome Assembly
# MinION basecalling and assembly
1. Convert fast5 files to pod5 format:
```bash
pod5 convert fast5 <directory-of-fast5s> --output output_pod5s/ --one-to-one <directory-of-fast5s>
```
2A. Dorado basecalling on laptop:
```bash
dorado download --model <model-name>
dorado basecaller --emit-fastq <directory-of-pod5s> | gzip > output.fq.gz # try and implement pigz parallel compression
```
2B. Dorado basecalling on LCC cluster using [dorado.sh](/scripts/dorado.sh) script:
```bash
sbatch $scripts/dorado.sh pod5_directory
```
3. Use [canu.sh](/scripts/canu.sh) SLURM script for Canu assembly:
```bash
assembly=<assembly-prefix>
nano_reads=<fastq directory>
canu -d ${assembly}_canu_run -p $assembly genomeSize=45m useGrid=false gridOptionsOVS=" --time 96:00:00 --partition=CAC48M192_L --ntasks=1 --cpus-per-task=4 " minReadLength=1000 -nanopore-raw $nano_reads
```
4. Rescuing raw files from failed MinION runs:
```bash
./recover_reads <Representative-fast5-file> </Library/MinKNOW/data/queued_reads/complete-reads-directory> --output-directory Recovered_fast5
```

# Access [MINION genomes](https://luky.sharepoint.com/:f:/r/sites/FarmanLab/Shared%20Documents/4_MINION_GENOMES?csf=1&web=1&e=tGH6ee)

# Determine contig lengths

1. Run the SeqLen.pl script:
```bash
perl SeqLen.pl <genome.fasta>
```
