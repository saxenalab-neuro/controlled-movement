#!/bin/sh
#SBATCH --job-name=sidp2							# Job name
#SBATCH --mail-type=END,FAIL						# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=8gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/sidp2_%a.out				# Standard output and error log
pwd; hostname; date;

# Passing in number

datatype="Testing"
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(1000 2500 5000 7500 10000)
orders=(8 9 10 11 12 14 15)


# Load MATLAB 2020b module
module load matlab


echo
echo $datatype $SLURM_ARRAY_TASK_ID
echo "${numbers[@]}"
echo "${orders[@]}"
echo

# Convert task ID to array index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))
expnumber=${numbers[$numberindex]}
echo $numberindex $expnumber

# Convert task ID to array index
orderindex=$(( ($SLURM_ARRAY_TASK_ID - 1) / ${#numbers[@]} ))
order=${orders[$orderindex]}
echo $orderindex $order


echo
echo This is task $SLURM_ARRAY_TASK_ID, which will do system identification for $expnumber experiments with a system order of $order
echo

# Run System Identification
scripts/sysid $datatype $expnumber $order

date