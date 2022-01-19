#!/bin/sh
#SBATCH --job-name=wrangle							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=8gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/wrangle.out					# Standard output and error log
pwd; hostname; date;

# Passing in $datatype


# Load MATLAB 2020b module
module load matlab



scripts/sto2mat $datatype
echo DONE: sto2mat - data has been converted

scripts/autographer $datatype
echo DONE: autographer - motion data has been graphed

scripts/createdatafile $datatype
echo DONE: createdatafile - iddata file has been made

date