#!/bin/bash

#SBATCH --job-name=vetri_serial_job_test    # Job name
#SBATCH --mail-type=NONE             # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=vetri.brainscience@gmail.com     # Where to send mail	
#SBATCH --nodes=16
#SBATCH --ntasks=16                    # Run on a single CPU
#SBATCH --partition=all
#SBATCH --time=8:00:00               # Time limit hrs:min:sec
#SBATCH --output=serial_test_%j.out   # Standard output and error log
#SBATCH --error=serial_test_%j.err
pwd; hostname; date


echo "script on a single CPU core"

srun bash MyBatch.sh
date
