#!/bin/sh
#SBATCH --job-name=talk								# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=2gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/talk_%j.out					# Standard output and error log
pwd; hostname; date;


a=Maybenot

echo $a