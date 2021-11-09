#!/bin/sh
#SBATCH --job-name=tpipe							# Job name
#SBATCH --mail-type=NONE							# Mail events (NONE, BEGIN, END, FAIL, ALL, ARRAY_TASKS)
#SBATCH --mail-user=jaxtonwillman@ufl.edu			# Where to send mail	
#SBATCH --nodes=1									# Use one node
#SBATCH --ntasks=1									# Run a single task
#SBATCH --mem-per-cpu=2gb							# Memory per processor
#SBATCH --time=1-00:00:00							# Time limit [days-]hrs:min:sec
#SBATCH --output=output/tpipe.out					# Standard output and error log
pwd; hostname; date;

# Passing in $datatype and $number


# Need to add " | head -n1 | cut -d " " -f4" to the sbatch command to get just the job id
# Pass variables with --export=datatype=$datatype,number=$number



# For motion file creation and CMC...
PER_TASK=25
arrmax=$(( $number/$PER_TASK ))


# Motion file creation
jid1=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK mcp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid1


# CMC
jid2=$(sbatch --array=1-$arrmax --export=datatype=$datatype,PER_TASK=$PER_TASK --dependency=afterok:$jid1 mcp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid2


# Collect files and turn them into .mat files
jid3=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid2 mcp3.sbatch | head -n1 | cut -d " " -f4)
echo $jid3


# Create data file
jid4=$(sbatch --export=datatype=$datatype --dependency=afterok:$jid3 sidp1.sbatch | head -n1 | cut -d " " -f4)
echo $jid4


# For system order identification
numbers=($((number / 10)) $((number / 5)) $((number / 2)) $number)
orders=(10 11 12 13 14 15)
arrmax=$(( ${#numbers[@]} * ${#orders[@]} ))


# System identification
jid5=$(sbatch --array=1-$arrmax --export=datatype=$datatype,numbers=$numbers,orders=$orders --dependency=afterok:$jid4 sidp2.sbatch | head -n1 | cut -d " " -f4)
echo $jid5



date