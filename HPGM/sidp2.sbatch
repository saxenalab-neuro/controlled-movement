#!/bin/sh
#SBATCH --job-name=sidp2							# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=16gb							# Memory per processor
#SBATCH --time=4-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/sidp2_%A-%a.out				# Standard output and error log
pwd; hostname; date;

# Passing in $datatype
# Passing in $numbers
# Passing in $orders


# Load MATLAB 2020b module
module load matlab



# Divide by numel of orders to get number index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))

# Divide by numel of numbers to get order index
orderindex=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#numbers[@]} ))


# Do task
echo
echo This is task $SLURM_ARRAY_TASK_ID, which will do system identification for ${numbers[$numberindex]} experiments with a system order of ${orders[$orderindex]}
echo

scripts/sysid $datatype ${numbers[$numberindex]} ${orders[$orderindex]}