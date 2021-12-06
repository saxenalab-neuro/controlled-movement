#!/bin/sh
#SBATCH --job-name=fullsid							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/fullsid.out					# Standard output and error log
pwd; hostname; date;



# Need to add " | head -n1 | cut -d " " -f4" to the sbatch command to get just the job id
# Pass variables with --export=datatype=$datatype,number=$number


### CLEANER ###

# Clean up last results
#jid1=$(sbatch cleaner.sbatch | head -n1 | cut -d " " -f4)
#echo $jid1




### TESTING DATA ###

# Run Testing for 50000 experiments

# Initialize properties
datatype="Testing"
number=5000
PER_TASK=$(( $number/$arrmax ))
arrmax=50

# Motion file creation
jid2=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK mcp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

# CMC
jid3=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid2 mcp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid3

# Collect files and turn them into .mat files
jid4=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid3 mcp3.sbatch | head -n1 | cut -d " " -f4)
echo $jid4

# Create data file
jid5=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid4 sidp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid5

# For system order identification
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) )
orders=(8 9 10 11 12 14 15)
arrmax=$(( ${#numbers[@]} * ${#orders[@]} ))

# System identification
jid6=$(sbatch --array=1-$arrmax --export=datatype=$datatype,number=$number --dependency=afterok:$jid5 sidp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid6




### VALIDATION DATA ###

# Run Validation for 500 experiments

# Initialize properties
datatype="Validation"
number=500
PER_TASK=$(( $number/$arrmax ))
arrmax=50

# Motion file creation
jid7=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid5 mcp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid7

# CMC
jid8=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid7 mcp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid8

# Collect files and turn them into .mat files
jid9=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid8 mcp3.sbatch | head -n1 | cut -d " " -f4)
echo $jid9

# Create data file
jid10=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid9 sidp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid10




### SYSTEM COMPARISON ###

# Compare the systems and save .figs
jid11=$(sbatch --array=1-${#numbers[@]} --export=number=$number --dependency=afterok:$jid6:$jid10 comparesystems.sbatch | head -n1 | cut -d " " -f4)
echo $jid11



date