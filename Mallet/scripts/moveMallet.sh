#!/bin/bash
# move all DP files and mallet and version infor into one directory for further analysis

# the path that you store the mallet data
dirs=/home/sunxi/Desktop/mallet-data/*/

# the target path that you store all analysis files
target='/home/sunxi/Desktop/targetLDA/'

# create its mirror dir to store target files
if [ ! -d $target ]
then mkdir $target
fi

for dir in $dirs
do 	
	name=`basename $dir`		
	echo $name
	mkdir -p "${target}${name}/LDA"
	
	# move all mallet files from mallet-data directory	
	mv "${dir}LDA/"*.mallet "${target}${name}"/LDA
	# move all DP files	
	mv "${dir}LDA"/*DP.txt "${target}${name}"
	# move version/doc information
	mv "${dir}"*.txt "${target}${name}"

done
