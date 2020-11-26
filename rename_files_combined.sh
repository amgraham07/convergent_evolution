#!/bin/bash

for fn in ./*.fasta
do

# get the path to the file
dir=`dirname $fn`;

# get just the file (without the path)
base=`basename $fn`;

# the read filename, without the *.fasta suffix
rf=${base%.fasta};

# make a list of first lines
awk 'NR==1 {print; exit}' ${dir}/${rf}.fasta >> firstline.txt

#delimts based on tab instead of space, grabs the 3rd column and exports to new file
awk -v OFS="\t" '$1=$1' firstline.txt > firstline_2.txt
cut -f1,4 -d$'\t' firstline_2.txt > firstline_3.txt


#replaces extraneous information from the 3rd column
sed -i -e 's/"pub_og_id":"//g' firstline_3.txt
sed -i -e 's/",//g' firstline_3.txt

sed -i -e 's/	/,/g' final_names.txt
while IFS=\, read old new; do mv "$old" "$new"; done < final_names.txt

done
