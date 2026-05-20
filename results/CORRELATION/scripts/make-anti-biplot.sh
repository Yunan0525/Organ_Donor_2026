#!/bin/bash

mkdir -p ${1}.anti-dist
awk -f scripts/aux/make-anti-distance-matrix.awk $1.score.txt > ${1}.anti-dist/distance-matrix.tsv

. ~/Q2/q2.source

qiime tools import \
      --input-path $1.anti-dist \
      --type 'DistanceMatrix' \
      --input-format  DistanceMatrixDirectoryFormat \
      --output-path ${1}-anti-distance.qza

qiime diversity pcoa \
      --i-distance-matrix ${1}-anti-distance.qza \
      --o-pcoa ${1}-anti-pcoa.qza

qiime emperor plot \
      --i-pcoa ${1}-anti-pcoa.qza \
      --m-metadata-file $1.mapping.txt \
      --o-visualization ${1}-anti-emperor.qzv

rm ${1}-anti-distance.qza ${1}-anti-pcoa.qza
