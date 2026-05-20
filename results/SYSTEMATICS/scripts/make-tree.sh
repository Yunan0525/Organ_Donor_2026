#!/bin/bash

awk -f scripts/aux/make-tree.awk nodes.dmp K.name-id.txt P.name-id.txt C.name-id.txt O.name-id.txt F.name-id.txt G.name-id.txt $1.name-id.txt
