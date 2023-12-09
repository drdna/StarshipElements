#!/bin/bash

gff=$1

#case $gff in (*recolored*)
#echo $gff;;
#esac

if [[ ! "$gff" =~ recolored ]]; then
awk -F '\t' '{if($3 ~ /5S/ && $5 - $4 > 100) {$9="color=#FF0000"substr($9, 14, 1000); print $0} else {print $0}; OFS="\t"}' $gff  | \
grep -v color=#999999 > ${gff/\.gff/_recolored\.gff};
fi
#rm $1
