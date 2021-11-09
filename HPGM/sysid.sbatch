#!/bin/sh
#SBATCH --job-name=sidp2							# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=8gb							# Memory per processor
#SBATCH --time=4-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/sidp2_%a.out				# Standard output and error log
#SBATCH --array=1-24
pwd; hostname; date;

datatype="Testing"
number=5000
numbers=($((number / 10)) $((number / 5)) $((number / 2)) $number)
orders=(10 11 12 13 14 15)


# Load MATLAB 2020b module
module load matlab


echo
echo $datatype $SLURM_ARRAY_TASK_ID 
echo "${numbers[@]}"
echo "${orders[@]}"
echo

# Divide by numel of orders to get number index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))
echo $numberindex ${numbers[$numberindex]}

# Divide by numel of numbers to get order index
orderindex=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#numbers[@]} ))
echo $orderindex ${orders[$orderindex]}


# Do task
echo
echo This is task $SLURM_ARRAY_TASK_ID, which will do system identification for ${numbers[$numberindex]} experiments with a system order of ${orders[$orderindex]}
echo

scripts/sysid $datatype ${numbers[$numberindex]} ${orders[$orderindex]}

