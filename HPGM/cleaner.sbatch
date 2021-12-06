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

# Clean OpenSim log
rm opensim.log
echo Removed OpenSim log

# Clean output folder
rm output/*
echo Removed job outputs


# Clean the Testing and Validation folders
rm -rf sysid/Testing/*
rm -rf sysid/Validation/*
echo Removed testing and validation directories


# Make new directories in Testing and Validation
mkdir -p sysid/Testing/{cmc,motions,SavedSystems,temp}
mkdir -p sysid/Validation/{cmc,motions,temp}
echo Remade directories


date