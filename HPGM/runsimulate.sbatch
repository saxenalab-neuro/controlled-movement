#!/bin/sh
#SBATCH --job-name=runsimulate						# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=0-01:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/runsimulate.out				# Standard output and error log
pwd; hostname; date;




### CLEAN UP LAST RESULTS ###

echo Beginning Cleaning *sweep* *sweep*
rm output/simulate*
echo Removed job outputs




### SYSTEM SIMULATION ###

number=5000
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(500 1250 2500 3750 5000)


for n in "${numbers[@]}"
do
    # Run system simulate
	jid2=$(sbatch --job-name=sim_$n --output=output/simulate_$n.out --export=number=$n simulate.sbatch | head -n1 | cut -d " " -f4)
	echo $jid2
done


date
