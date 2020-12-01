#!/bin/bash

for fn in ./*at7147
do

# get the path to the file
dir=`dirname $fn`;

# get just the file (without the path)
base=`basename $fn`;

# the read filename, without the *at7147 suffix
rf=${base%at7147};

# grab out matches from diptera list and those from the fasta files
fgrep -of diptera_count.txt ${dir}/${rf}at7147_renamed.fasta > ${dir}/${rf}at7147_list.txt

# combine those list and count instances, will be either 1, or 2
cat ${dir}/${rf}at7147_list.txt diptera_count.txt | sort | uniq -c | awk '{print $2 " " $1}' > ${dir}/${rf}at7147_counts.txt

# add with file names as header
echo "rows $(basename ${dir}/${rf}at7147_counts.txt _counts.txt)" > ${dir}/${rf}at7147_header.txt
cat ${dir}/${rf}at7147_header.txt ${dir}/${rf}at7147_counts.txt > ${dir}/${rf}at7147_labeled.txt

# change all spaces to tab
sed -i '' -E $'s/ /\t/g' ${dir}/${rf}at7147_labeled.txt

#combined all 2nd columns into one file
cut -f2 -d$'\t' ${dir}/${rf}at7147_labeled.txt > ${dir}/${rf}at7147_column_2.txt

done

#dont get caught in a loop within a loop here

for f in *at7147_column_2.txt; do cat combined_counts.txt | paste - $f >temp; cp temp combined_counts.txt; done; rm temp
 
#delete all middle-man files clogging up space (don't delete _column_2.txt because it affects the combined_test.txt file)
rm *_header.txt
rm *_list.txt
rm *_counts.txt
rm *_labeled.txt

done
