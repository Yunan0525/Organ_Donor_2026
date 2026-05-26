#!/bin/bash

echo -e "Species\tPCo1\tPCo2\tPCo3\tCluster\tColor" > $1.plot-data.txt
cut -f 1-4 $1.bracken-5000-20.ord.txt | \
    awk -f scripts/aux/join.awk ../${1}.bracken-5000-20.species.mapping-2.txt - | \
    awk -f scripts/aux/add-colors.awk - >> $1.plot-data.txt

for i in PHG1 PHG2 PHG3 PHG4 PHG5 PHG6 PHG7 PHG8 PHG9
do    
    echo -e "Species\tPCo1\tPCo2\tPCo3\tCluster\tColor" > ${1}-${i}.plot-data.txt
    cut -f 1-4 $1.bracken-5000-20.ord.txt | \
	awk -f scripts/aux/join.awk ../${1}.bracken-5000-20.species.mapping-2.txt - | \
	awk -f scripts/aux/add-subplot-colors.awk -vSELECT=$i - >> ${1}-${i}.plot-data.txt
done

module add python/3.9.6
ln -s $1.plot-data.txt plot.data.txt
python3 scripts/python/plot-3D.py
mv plot-3D.pdf $1.plot-3D.pdf
rm plot.data.txt $1.plot-data.txt

for i in PHG1 PHG2 PHG3 PHG4 PHG5 PHG6 PHG7 PHG8 PHG9
do    
    ln -s ${1}-${i}.plot-data.txt plot.data.txt
    python3 scripts/python/plot-3D.py
    mv plot-3D.pdf ${1}-${i}.plot-3D.pdf
    rm plot.data.txt ${1}-${i}.plot-data.txt
done
module rm python/3.9.6

