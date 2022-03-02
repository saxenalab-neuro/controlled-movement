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
jid1=$(sbatch cleaner.sbatch | head -n1 | cut -d " " -f4)
echo $jid1




### TRAINING DATA ###

# Run training for 5000 experiments

# Initialize properties
datatype="training"
number=5000
arrmax=50
PER_TASK=$(( $number/$arrmax ))

# Motion file creation
jid2=$(sbatch --job-name=t_mm --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid1 motionmaker.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

# CMC
jid3=$(sbatch --job-name=t_cmc --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid2 cmc.sbatch | head -n1 | cut -d " " -f4)
echo $jid3

# Collect files and turn them into .mat files and iddata files
jid4=$(sbatch --job-name=t_wrangle --export=datatype=$datatype --dependency=afterok:$jid3 datawrangle.sbatch | head -n1 | cut -d " " -f4)
echo $jid4

# Initialize properties for system identification
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) )
orders=(2 3 4 5 6 7 8 9 10 11 12 13 14 15)
arrmax=$(( ${#numbers[@]} * ${#orders[@]} ))

# System identification
jid5=$(sbatch --job-name=t_sysid --array=1-$arrmax --export=number=$number --dependency=afterok:$jid4 sysid.sbatch | head -n1 | cut -d " " -f4)
echo $jid5




### VALIDATION DATA ###

# Run validation for 500 experiments

# Initialize properties
datatype="validation"
number=500
arrmax=50
PER_TASK=$(( $number/$arrmax ))

# Motion file creation
jid6=$(sbatch --job-name=v_mm --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid4 motionmaker.sbatch | head -n1 | cut -d " " -f4)
echo $jid6

# CMC
jid7=$(sbatch --job-name=v_cmc --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid6 cmc.sbatch | head -n1 | cut -d " " -f4)
echo $jid7

# Collect files and turn them into .mat files and iddata files
jid8=$(sbatch --job-name=v_wrangle --export=datatype=$datatype --dependency=afterok:$jid7 datawrangle.sbatch | head -n1 | cut -d " " -f4)
echo $jid8




### SYSTEM COMPARISON ###

# Initialize properties
number=5000
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) )
orders=(2 3 4 5 6 7 8 9 10 11 12 13 14 15)

# Compare the systems and compute the MSE for each system
jid9=$(sbatch --array=1-${#numbers[@]} --export=number=$number --dependency=afterok:$jid5:$jid8 comparesystems.sbatch | head -n1 | cut -d " " -f4)
echo $jid9



date
