#!/bin/sh
#SBATCH --job-name=fullsid							# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=2gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/fullsid_%j.out				# Standard output and error log
pwd; hostname; date;



# Need to add " | head -n1 | cut -d " " -f4" to the sbatch command to get just the job id
# Pass variables with --export=datatype=$datatype,number=$number



# Run Testing for 5000 experiments
datatype="Testing"
number=5000

# Generate VALIDATION data
jid1=$(sbatch --export=datatype=$datatype,number=$number tpipe.sbatch | head -n1 | cut -d " " -f4)
echo $jid1


# Run Validation for 500 experiments
datatype="Validation"
number=500

# Generate VALIDATION data
jid2=$(sbatch --export=datatype=$datatype,number=$number --dependency=afterok:$jid1 vpipe.sbatch | head -n1 | cut -d " " -f4)
echo $jid2


# Compare the systems and save .figs
#jid3=$(sbatch --dependency=afterok:$jid2 sidp3.sbatch | head -n1 | cut -d " " -f4)
#echo $jid3


date