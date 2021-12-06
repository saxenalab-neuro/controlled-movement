#!/bin/sh
#SBATCH --job-name=vpipe							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/vpipe.out					# Standard output and error log
pwd; hostname; date;



# Initialize properties
datatype="Validation"
number=500
arrmax=50
PER_TASK=$(( $number/$arrmax ))

# Motion file creation
jid7=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK mcp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid7

# CMC
jid8=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid7 mcp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid8

# Collect files and turn them into .mat files
jid9=$(sbatch --export=datatype=$datatype,number=$number --dependency=afterok:$jid8 mcp3.sbatch | head -n1 | cut -d " " -f4)
echo $jid9

# Create data file
jid10=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid9 sidp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid10



date