#!/bin/bash

for fn in ./*at7147
do

# get the path to the file
dir=`dirname $fn`;

# get just the file (without the path)
base=`basename $fn`;

# the read filename, without the *at7147 suffix
rf=${base%at7147};

#remove everything in between the {}, including the {}, and send to a new .fasta file
sed -e ':again' -e N -e '$!b again' -e 's/{[^}]*}//g' ${dir}/${rf}at7147 > ${dir}/${rf}at7147.fasta

#some didn't have {} for some reason, so get rid of stragglers
sed -i '' -e ':again' -e N -e '$!b again' -e 's/"[^}]*"//g' ${dir}/${rf}at7147.fasta

#delete everything after the : including the :, edits done in place without a new file
sed -i '' -e 's/:[^:]*$//g' ${dir}/${rf}at7147.fasta

#AGAIN delete everything after the : including the :, edits done in place without a new file
sed -i '' -e 's/:[^:]*$//g' ${dir}/${rf}at7147.fasta

#rename based on precompiled tab delimited file "species_rename.txt"
awk '
FNR==NR{
  a[$1]=$2
  b[$1]=++c[$2]
  next
}
($2 in a) && /^>/{
  print ">"a[$2]
  next
}
1
' species_rename.txt FS="[> ]"  ${dir}/${rf}at7147.fasta > ${dir}/${rf}at7147_renamed.fasta

done