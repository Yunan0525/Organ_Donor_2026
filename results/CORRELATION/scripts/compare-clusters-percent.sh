#!/bin/bash

awk -f scripts/aux/compare-clusters-percent.awk \
    $1.bracken-5000-20.species.mapping.txt \
    $2.bracken-5000-20.species.mapping.txt

