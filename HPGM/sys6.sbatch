#!/bin/bash
#SBATCH --job-name=SYS6
#SBATCH --mail-type=FAIL,END
#SBATCH --mail-user=jaxtonwillman@ufl.edu
#SBATCH --ntasks=1
#SBATCH --mem=16gb
#SBATCH --time=72:00:00
#SBATCH --output=sys6-%j.out
#SBATCH --error=sys6-%j.err

module load matlab
./sysid 6