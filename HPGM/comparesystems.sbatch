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


numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(500 1250 2500 3750 5000)

# Convert task ID to array index
numberindex=$(( ($SLURM_ARRAY_TASK_ID - 1) % ${#numbers[@]} ))
expnumber=${numbers[$numberindex]}
echo $numberindex $expnumber

# Run system compare
jid1=$(sbatch --job-name=comp_$expnumber --output=output/compare_$expnumber.out --export=number=$expnumber compare.sbatch | head -n1 | cut -d " " -f4)
echo $jid1

# Run system simulate
jid2=$(sbatch --job-name=sim_$expnumber --output=output/simulate_$expnumber.out --export=number=$expnumber simulate.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

# Run system fit
jid3=$(sbatch --job-name=fit_$expnumber --output=output/fit_$expnumber.out --export=number=$expnumber --dependency=afterok:$jid2 fit.sbatch | head -n1 | cut -d " " -f4)
echo $jid3



date
