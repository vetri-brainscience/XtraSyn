#!/bin/bash

#SBATCH --job-name=vetri_serial_job  # Job name
#SBATCH --mail-type=NONE             # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=vetri.brainscience@gmail.com     # Where to send mail	
#SBATCH --nodes=1
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --partition=all
#SBATCH --time=1:00:00               # Time limit hrs:min:sec
#SBATCH --output=./Report/serial_job_%j.out   # Standard output and error log
#SBATCH --error=./Report/serial_job_%j.err
pwd; hostname; date

echo "script on a single CPU core"
COUNTER=11
PARAM=1
./MyBatch.sh $COUNTER $PARAM $SLURM_JOB_ID
date
