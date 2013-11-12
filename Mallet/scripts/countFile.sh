#!/bin/bash

#store the document length of each file for each version of software
dirs=`ls -d /mnt/System/mallet-data/*/`
outputdir=/home/sunxi/Desktop/doclen/

#rm -rf ${outputdir}
#mkdir ${outputdir}

for dir in $dirs
do
	# Read names of major versions
	project=`basename $dir`
	echo -e "#######################################################################"
	echo -e "         " ${project}
	echo -e "#######################################################################"
	if [[ $project == "netbeansADDRAW" ]]
	then 
		continue
	fi
	text=`cut -d',' -f1 ${dir}"version.txt"`
	for version in $text
	do 
		# get doclength for training mallet file corresponds to given version
		../bin/mallet run cc.mallet.util.DocumentLengths --input ${dir}"LDA/"${version}".mallet" | tail -n +2 > ${outputdir}${project}${version}"-doclengs.txt"
	done
done
