#!/bin/sh
#SBATCH --job-name=vpipe							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=500mb							# Memory per processor
#SBATCH --time=0-01:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/vpipe.out					# Standard output and error log
pwd; hostname; date;




### CLEAN UP LAST RESULTS ###
echo Beginning Cleaning *sweep* *sweep*


# Wipe working directories
rm opensim.log
echo Removed OpenSim log

rm -rf output
echo Removed job outputs

rm systems/validation*
echo Removed system files

rm -rf validation/*
echo Removed validation directories


# Make new directories
mkdir output
mkdir -p validation/{cmc,motions,temp}

echo Remade directories




### VALIDATION DATA ###

# Run validation for 500 experiments

# Initialize properties
datatype="validation"
number=50
arrmax=10
PER_TASK=$(( $number/$arrmax ))

# Motion file creation
jid6=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK motionmaker.sbatch | head -n1 | cut -d " " -f4)
echo $jid6

# CMC
jid7=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid6 cmc.sbatch | head -n1 | cut -d " " -f4)
echo $jid7

# Collect files and turn them into .mat files among other things
jid8=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid7 datawrangle.sbatch | head -n1 | cut -d " " -f4)
echo $jid8



date