#!/bin/bash

#SBATCH --time 48:00:00
#SBATCH --job-name=trim-velvet
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --partition=normal
#SBATCH --mem=256GB
#SBATCH --mail-type ALL
#SBATCH -A coa_vaillan_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user sgo293@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST


# Usage: sbatch trim-velvet.sh <username> <Reads-directory> <reads-prefix> <trim?: yes, no> <start-kmer> <end-kmer>

username=$1

dir=$2

readsprefix=$3

mkdir $readsprefix

cp $dir/$readsprefix*_1*f*q* $readsprefix/

cp $dir/$readsprefix*_2*f*q* $readsprefix/

cd $readsprefix

if [ $4 == 'yes' ]
then
  singularity run --app trimmomatic039 /share/singularity/images/ccs/conda/amd-conda2-centos8.sinf trimmomatic PE \
  -threads 16 -phred33 -trimlog ${readsprefix}_errorlog.txt \
  $readsprefix*_1*.f*q* $readsprefix*_2*.f*q* \
  ${readsprefix}_R1_paired.fq ${readsprefix}_R1_unpaired.fq \
  ${readsprefix}_R2_paired.fq ${readsprefix}_R2_unpaired.fq \
  ILLUMINACLIP:/project/vaillan_uksr/adapters/NexteraPE-PE.fa:2:30:10 SLIDINGWINDOW:20:20 MINLEN:90;
fi


# interleave F and R fastq files

module load python-2.7.18-gcc-9.3.0-5efgwu4

python /project/vaillan_uksr/bash_scripts/interleave-fastq.py *1_paired.fq *2_paired.fq > interleaved.fq

module unload python-2.7.18-gcc-9.3.0-5efgwu4

# now run velvetoptimiser

singularity run --app perlvelvetoptimiser226 /share/singularity/images/ccs/conda/amd-conda2-centos8.sinf VelvetOptimiser.pl \
 -s $5 -e $6 -x 10 -d velvet_assembly -f ' -shortPaired -interleaved -fastq interleaved.fq'

# rename assembly

mv velvet_assembly/contigs.fa velvet_assembly/${readsprefix}".fasta"

# create ASSEMBLIES directory

mkdir /scratch/$username/ASSEMBLIES

# copy assembly into ASSEMBLIES directory

cp velvet_assembly/${readsprefix}".fasta" /scratch/$username/ASSEMBLIES/${readsprefix}".fasta"

# rename log file

prefix=`ls velvet_assembly/*logfile.txt'

mv $prefix /scratch/$username/ASSEMBLIES/${readsprefix}_${prefix/*\//}
