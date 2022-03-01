#!/bin/bash

for fn in ./*_protein.faa_7tm4_sequences.txt
do

# get the path to the file
dir=`dirname $fn`;

# get just the file (without the path)
base=`basename $fn`;

# the read filename, without the *_protein.faa_7tm4_sequences.txt suffix
rf=${base%.*_protein.faa_7tm4_sequences.txt};

# Do whatever we want with it - pull only sequences with olfactory in the name since 7tm_4 isn't as specific apparently
grep '>' ${dir}/${rf} | sed 's/>//g' > ${dir}/${rf}_id.fa
grep 'olfactory' ${dir}/${rf}_id.fa > ${dir}/${rf}_olfactory.fa
seqtk subseq ${dir}/${rf} ${dir}/${rf}_olfactory.fa > ${dir}/${rf}_olfactory_2.fa

#cdhit with a specific threshold
#cd-hit -c 0.95 -i ${dir}/${rf}_olfactory_2.fa -o ${dir}/${rf}_cdhit_95.txt

#cut names of genes present - walkthrough step-by-step
grep '>' ${dir}/${rf}_cdhit_95.txt | sed 's/>//g' > ${dir}/${rf}_OR.fa
sed -i.bak 's/\./\t/g' ${dir}/${rf}_OR.fa
awk '{print $1}' ${dir}/${rf}_OR.fa | sort | uniq > ${dir}/${rf}_uniq_OR.fa
wc -l ${dir}/${rf}_uniq_OR.fa

done
