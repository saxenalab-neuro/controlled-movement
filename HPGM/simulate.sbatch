#!/bin/sh
#SBATCH --mail-type=END,FAIL						# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=4gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
pwd; hostname; date;

# Passing in $number


# Load MATLAB 2020b module
module load matlab


scripts/syssimulate $number

date
