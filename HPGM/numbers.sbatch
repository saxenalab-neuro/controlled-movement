#!/bin/sh
#SBATCH --job-name=numbers							# Job name
#SBATCH --mail-type=FAIL,END						# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=4-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=numbers_%A.out						# Standard output and error log
#SBATCH --array=1-30								# Array range


# Create arrays to loop through for the tasks
numbers=(100 250 750 1000 1500 2000)
orders=(2 4 6 8 10)
#slurm=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30)

#for t in ${slurm[@]}; do

# Divide by numel of orders to get number index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))

# Divide by numel of numbers to get order index
orderindex=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#numbers[@]} ))


echo Task $SLURM_ARRAY_TASK_ID >> logfile.txt
echo numberindex $numberindex >> logfile.txt
echo orderindex $orderindex >> logfile.txt
echo ${numbers[$numberindex]} experiments >> logfile.txt
echo ${orders[$orderindex]} system order >> logfile.txt
echo >> logfile.txt


#for t in {1..30}; do numberindex=$(( ($t - 1) % ${#numbers[@]} )); orderindex=$(( ($t - 1) / ${#numbers[@]} )); echo $numberindex $orderindex; done