#!/bin/sh
#SBATCH --job-name=compsys							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/compsys_%a.out				# Standard output and error log
pwd; hostname; date;

# Passing in number

numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(1000 2500 5000 7500 10000)

# Convert task ID to array index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))
expnumber=${numbers[$numberindex]}
echo $numberindex $expnumber

# Run subtask
#jid1=$(sbatch --job-name=syscomp_$expnumber --output=output/syscomp_$expnumber.out --export=number=$expnumber sidp3.sbatch | head -n1 | cut -d " " -f4)
#echo $jid1

# Compare the of the system orders  --dependency=afterok:$jid1
jid2=$(sbatch --job-name=fit_$expnumber --output=output/fitcompare_$expnumber.out --export=number=$expnumber fitcompare.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

date