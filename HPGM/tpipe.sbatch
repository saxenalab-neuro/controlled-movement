#!/bin/sh
#SBATCH --job-name=tpipe							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=500mb							# Memory per processor
#SBATCH --time=0-12:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/tpipe.out					# Standard output and error log
pwd; hostname; date;




### CLEAN UP LAST RESULTS ###
echo Beginning Cleaning *sweep* *sweep*


# Wipe working directories
rm opensim.log
echo Removed OpenSim log

rm -rf output
echo Removed job outputs

rm systems/training*
echo Removed system files

rm -rf training/*
echo Removed training directories


# Make new directories
mkdir output
mkdir -p training/{cmc,motions,temp}

echo Remade directories




### TRAINING DATA ###

# Run training for 5000 experiments

# Initialize properties
datatype="training"
number=5000
arrmax=50
PER_TASK=$(( $number/$arrmax ))

# Motion file creation
jid2=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK motionmaker.sbatch | head -n1 | cut -d " " -f4)
echo $jid2

# CMC
jid3=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid2 cmc.sbatch | head -n1 | cut -d " " -f4)
echo $jid3

# Collect files and turn them into .mat files
jid4=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid3 datawrangle.sbatch | head -n1 | cut -d " " -f4)
echo $jid4

# For system order identification
numbers=( $(($number/10)) $(($number/4)) $(($number/2)) $(($number*3/4)) $(($number)) )
orders=(8 9 10 11 12 14 15)
arrmax=$(( ${#numbers[@]} * ${#orders[@]} ))

# System identification
jid5=$(sbatch --array=1-$arrmax --export=datatype=$datatype,number=$number --dependency=afterok:$jid4 sysid.sbatch | head -n1 | cut -d " " -f4)
echo $jid5



date