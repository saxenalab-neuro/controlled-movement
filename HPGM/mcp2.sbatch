#!/bin/sh
#SBATCH --job-name=mcp2								# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=1gb							# Memory per processor
#SBATCH --time=4-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/mcp2_%A-%a.out				# Standard output and error log
#SBATCH --array=1-200								# Array range
pwd; hostname; date;


# Load OpenSim 4.3 module
module load opensim



#Set the number of runs that each SLURM task should do
PER_TASK=25


# Calculate the starting and ending values for this task based on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))


# Print the task and run range
echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM


# Run the loop of runs for this task.
for (( run=$START_NUM; run<=END_NUM; run++ )); do
	echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run
	
	setupfilename="sysid/setup/$run.xml"
	
	# Run the CMC Tool
	opensim-cmd run-tool $setupfilename	
done


date