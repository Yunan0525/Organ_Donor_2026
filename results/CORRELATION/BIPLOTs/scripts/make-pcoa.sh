#!/bin/bash

module add qiime2/2022.2
qiime tools import \
      --input-path ../$1.species.dist \
      --type 'DistanceMatrix' \
      --input-format  DistanceMatrixDirectoryFormat \
      --output-path ${1}-distance.qza

qiime diversity pcoa \
      --i-distance-matrix ${1}-distance.qza \
      --o-pcoa ${1}-pcoa.qza

module rm qiime2/2022.2

rm ${1}-distance.qza
