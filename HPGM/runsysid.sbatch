#!/bin/sh
#SBATCH --job-name=runsysid							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=0-01:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/runsysid.out				# Standard output and error log
pwd; hostname; date;




### CLEAN UP LAST RESULTS ###

echo Beginning Cleaning *sweep* *sweep*
rm output/sysid*
rm output/compsys*
rm output/fit*
rm output/simulate*
rm output/compare*
echo Removed job outputs




### SYSTEM IDENTIFICATION AND COMPARISON ###

# Initialize properties for system identification
number=5000
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) ) # numbers=(500 1250 2500 3750 5000)
orders=(2 3 4 5 6 7 8 9 10 11 12 13 14 15)
arrmax=$(( ${#numbers[@]} * ${#orders[@]} ))

# System identification
jid1=$(sbatch --job-name=t_sysid --array=1-$arrmax --export=number=$number sysid.sbatch | head -n1 | cut -d " " -f4)
echo $jid1


# Compare the systems and compute the MSE for each system
jid2=$(sbatch --array=1-${#numbers[@]} --export=number=$number --dependency=afterok:$jid1 comparesystems.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

date
