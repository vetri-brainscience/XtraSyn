#!/bin/bash

#SBATCH --job-name=vetri_array_job    # Job name
#SBATCH --mail-type=NONE             # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=vetri.brainscience@gmail.com     # Where to send mail
#SBATCH --output=arrayJob_%A_%a.out
#SBATCH --error=arrayJob_%A_%a.err
#SBATCH --ntasks=1                    # Run on a single CPU
#SBATCH --partition=gpu
#SBATCH --time=1:00:00               # Time limit hrs:min:sec
#SBATCH --array=0-10

pwd; hostname; date


# Print this sub-job's task ID
echo "My SLURM_ARRAY_TASK_ID: " $SLURM_ARRAY_TASK_ID

./MyBatch.sh $SLURM_ARRAY_TASK_ID $SLURM_ARRAY_JOB_ID
date
