#!/bin/sh
#SBATCH --job-name=talk								# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=0-00:10:00							# Time limit [days-]hrs:min:sec
#SBATCH --array=1-100                 				# Array range
#SBATCH --output=output/talk.out					# Standard output and error log
pwd; hostname; date;


echo Something dumb

echo also

while :
do
	echo "Press [CTRL+C] to stop.."
	sleep 1
done

date