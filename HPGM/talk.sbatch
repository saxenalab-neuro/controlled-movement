#!/bin/bash
#SBATCH --job-name=talk
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jaxtonwillman@ufl.edu
#SBATCH --ntasks=1
#SBATCH --mem=4gb
#SBATCH --time=72:00:00
#SBATCH --output=talk-%j.out
#SBATCH --error=talk-%j.err

module load matlab
./talk 8 2