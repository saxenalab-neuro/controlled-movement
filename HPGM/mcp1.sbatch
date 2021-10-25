#!/bin/sh
#SBATCH --job-name=mcp1								# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=8gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/mcp1_%A-%a.out				# Standard output and error log
#SBATCH --array=1-100								# Array range
pwd; hostname; date;


# Load MATLAB 2020b module
module load matlab

datatype="Testing"


#Set the number of runs that each SLURM task should do
PER_TASK=50

# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))

# Print the task and run range
echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM

# Run the loop of runs for this task.
for (( run=$START_NUM; run<=END_NUM; run++ )); do
	echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run
	scripts/motioncreatorp1 $run $datatype
done


date