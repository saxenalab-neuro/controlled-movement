#!/bin/sh
#SBATCH --job-name=tmcp2							# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=1gb							# Memory per processor
#SBATCH --time=0-00:20:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/tmcp2_%j.out				# Standard output and error log
pwd; hostname; date;


# Load OpenSim 4.3 module
module load opensim

run=1

# Get filename
setupfilename="sysid/setup/$run.xml"
	
# Run the CMC Tool
opensim-cmd run-tool $setupfilename	


date