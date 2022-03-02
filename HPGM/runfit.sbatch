#!/bin/sh
#SBATCH --job-name=runfit							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=0-01:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/runfit.out					# Standard output and error log
pwd; hostname; date;




### CLEAN UP LAST RESULTS ###

echo Beginning Cleaning *sweep* *sweep*
rm output/fit*
echo Removed job outputs




### SYSTEM FIT ###

number=5000
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(500 1250 2500 3750 5000)


for n in "${numbers[@]}"
do
    # Run system fit
	jid3=$(sbatch --job-name=fit_$n --output=output/fit_$n.out --export=number=$n fit.sbatch | head -n1 | cut -d " " -f4)
	echo $jid3
done


date
