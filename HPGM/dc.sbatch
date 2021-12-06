#!/bin/sh
#SBATCH --job-name=dmgctrl							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=16gb							# Memory per processor
#SBATCH --time=0-00:30:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/dmgctrl.out					# Standard output and error log
pwd; hostname; date;


module load matlab


datatype="Testing"
number=5000

# Run the loop of runs for this task.
for (( run=1; run<=10; run++ )); do
	setupfilename="sysid/setup/$run.xml"
	
	# Run the CMC Tool
	opensim-cmd run-tool $setupfilename	
done


date