#!/bin/sh
#SBATCH --job-name=comparesystems					# Job name
#SBATCH --mail-type=FAIL,END						# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=16gb							# Memory per processor
#SBATCH --time=00:10:00								# Time limit [days-]hrs:min:sec
#SBATCH --output=job_%j.out							# Standard output and error log

pwd; hostname; date

# Load MATLAB 2020b module
module load matlab

./compareallsystems