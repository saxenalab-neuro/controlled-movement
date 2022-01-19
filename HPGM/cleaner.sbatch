#!/bin/sh
#SBATCH --job-name=cleaner							# Job name
#SBATCH --mail-type=FAIL							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=100mb							# Memory per processor
#SBATCH --time=0-01:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/cleaner.out					# Standard output and error log
pwd; hostname; date;

echo Beginning Cleaning *sweep* *sweep*


# Wipe working directories
rm opensim.log
echo Removed OpenSim log

rm -rf output
echo Removed job outputs

rm -rf systems/*
echo Removed saved systems

rm -rf training/*
echo Removed training directories

rm -rf validation/*
echo Removed validation directories


# Make new directories
mkdir -p {output,setup,systems,training,validation}
mkdir -p training/{cmc,motions,temp}
mkdir -p validation/{cmc,motions,temp}

echo Remade directories


date