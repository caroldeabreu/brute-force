#!/bin/bash 
#SBATCH -n 1 # Numero de CPU cores a serem alocados 
#SBATCH -N 1 # Numero de nodes a serem alocados
#SBATCH -t 8-00:00 # Tempo limite de execucao (D-HH:MM)
#SBATCH -p short
#SBATCH --qos qos_short

T=$1
n=5

for i in {50..54}; do
	date +"%T"
    if [ $i -lt 10 ] 
    then
        echo "python bruteforce_v2.py net0$i $T $n" 
        python bruteforce_v2.py net0$i $T $n 
    else
        echo "python bruteforce_v2.py net$i $T $n" 
        python bruteforce_v2.py net$i $T $n
    fi    
    echo "Done" 
    date +"%T"

done
