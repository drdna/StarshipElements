#!/bin/bash

#SBATCH --time 96:00:00
#SBATCH --job-name=canu
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=CAC48M192_L
#SBATCH --mem=180GB
#SBATCH --mail-type ALL
#SBATCH -A col_farman_uksr
#SBATCH --mail-type ALL
#SBATCH --mail-user farman@uky.edu

echo "SLURM_NODELIST: "$SLURM_NODELIST

nano_reads=$2

assembly=$1

module load ccs/canu/2.1.1

canu -d ${assembly}_canu_run -p $assembly genomeSize=45m useGrid=false gridOptionsOVS=" \
 --time 96:00:00 --partition=CAC48M192_L --ntasks=1 --cpus-per-task=4 " minReadLength=1000 -nanopore-raw $nano_reads
