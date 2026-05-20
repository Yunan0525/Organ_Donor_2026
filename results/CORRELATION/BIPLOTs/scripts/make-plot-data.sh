#!/bin/bash

echo -e "Species\tPCo1\tPCo2\tPCo3\tCluster\tColor" > $1.plot-data.txt
cut -f 1-4 $1.bracken-5000-20.ord.txt | \
    awk -f scripts/aux/join.awk ../${1}.bracken-5000-20.species.mapping.txt - | \
    awk -f scripts/aux/add-colors.awk - >> $1.plot-data.txt
