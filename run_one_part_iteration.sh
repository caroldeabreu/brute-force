#!/bin/bash 
#SBATCH -n 1 # Numero de CPU cores a serem alocados 
#SBATCH -N 1 # Numero de nodes a serem alocados
#SBATCH -t 8-00:00 # Tempo limite de execucao (D-HH:MM)
#SBATCH -p short
#SBATCH --qos qos_short

T=$1
n=5

declare -a names

for file in */
do
file=${file:3:2}
names=(${names[@]} "$file")
done

for i in ${names[@]}; do
	date +"%T"
    echo "python bruteforce_v2.py net$i $T $n" 
    python bruteforce_v2.py net$i $T $n

    echo "Done" 
    date +"%T"

done
