#!/bin/bash

for i in G1 G2 G3 G4 G5 G6 G7 G8 G9
do
    	echo -en '\t'$i
done
echo

for i in G1 G2 G3 G4 G5 G6 G7 G8 G9
do
    echo -n $i
    for j in G1 G2 G3 G4 G5 G6 G7 G8 G9
    do
	
	intrs=`comm -1 -2 <(awk -F"\t" -vS1=$i '($3==S1)' $1.bracken-5000-20.species.mapping.txt | cut -f 1 | sort) \
		    	  <(awk -F"\t" -vS2=$j '($3==S2)' $2.bracken-5000-20.species.mapping.txt | cut -f 1 | sort) \
			  | wc -l`
	union=`cat <(awk -F"\t" -vS1=$i '($3==S1)' $1.bracken-5000-20.species.mapping.txt | cut -f 1 | sort) \
	       	   <(awk -F"\t" -vS2=$j '($3==S2)' $2.bracken-5000-20.species.mapping.txt | cut -f 1 | sort) |\
	           sort | uniq | wc -l`

	jac=`echo "scale=6 ; $intrs / $union" | bc -l`

	echo -en '\t'$jac
    done
    echo
done


