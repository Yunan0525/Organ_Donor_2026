#!/bin/bash

module add r/4.2.2

Rscript scripts/R/make-pheatmap.R $1
