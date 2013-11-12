LDA-studies
===========

Assorted scripts for studying topic modeling in source code

This work is done by Xi Sun and Abhinav. Part of code is inherited from https://github.com/abhinavkulkarni/topic-modeling

****************
very impoartant! Do not use the mallet downloaded from official website since source code has been modified in this study. Run 'make' to compile mallet code first.

You may use https://www.ohloh.net/ as a starting point to explore the open source projects that you want to cover in this study. 

I also attach a java tool in Mallet/LOCtool to roughly get the esitmation of LOC and number of open source programs. This may be a guide for you to know the scale of project and if the project is for your interest before you apply following analysis.

****************
Pre-process java file:
go to Mallet/TopicModelling. This is the code for tokenizing the Java source files and mirrors the structure of data directory to a specified location.

****************
LDA:
Note: the following bash code are in mallet/script directory. Do not use any tutorial from website.
 
1. change output path of your own in code. run import-data.sh to import the tokenized data in a format that Mallet understands. You shold get 1 file for all data, 1 file for training , 1 file for testing.

2. create "version-major.txt" file in each directory of project.
eg. create "version-major.txt" in ant/ 
NOTE: DO NOT CREATE IN ant/LDA DIRECTORY. Sample file is attached in samplehelper. The versions in "version-major.txt" are the selected versions for each project that you are going to do perplexity analysis in next step 3. You do not need to do perplexity for each version, just pick 3 or 4 major versions that are representative, usually the early version, mid point version and latest version.

3. change output path of your own in code. run calculate-perplexity.sh. You can get perplexity result in /LDA file of each version that you specify in step 2. This result is used to pick out the best number of topics for each version of project to run LDA in step 5. Roughly infer the best topic # when the perplexity value is at turning point. You may not be accurate since best topic number is somewhere in a range. Then use extraplolation/ intrapolation on topic number based on LOC of versions in same project. (you can do it in R or Matlab)

e.g. for hadoop project, you may have 10 versions, you run perplexity on version 1, 5 and 10, then get 3 topic numbers for these 3 versions, finally infter 2,3,4,6,7,8,9 versions based on LOC.

4. create "version.txt". sample file is attached in samplehelper.
first col is version name, second col is LOC (can get by tool in Mallet/LOCtool), third col is file number (very important, make this number very accurate, DO NOT USE LOC TOOL), fourth col is best topic # that you got in step 3.

How to get file number accurate? The answer is to directly count how many files in mallet file. I wrote a bash code to generate  this information. Run countFile.sh to get the filenumber of each version for each project. Then fill the exact filenumber information in "version.txt".

5. Once optimal number of topics for each version is known, and you make sure information in version.txt is complete and accurate, run run-LDA.sh script to output sparse word-doc matrix for each version. Sample result is attached in samlplehelper directory. 

If you get result with different format, make sure you compile MALLET in the attached file and you do not use Mallet from official website since I have modified source code

In result of DP file, first col is document ID, second col is topic ID, third is word frequency for each topic. 
 
****************
Extract information:
after generate topic-document result, run moveMallet.sh to move all valuable files into your specific path. (modified path in bash code by yourself) 

****************
Matlab analysis:
put all the matlab codes in the path that you designated (e.g. I use LDAtarget/, put all matlab codes in LDAtarget/)
 
1. run gen_project_topicdoc_tangling_scattering to import DP.txt to readable topic-doc mat file for each project and calculate average scattering/tangling for each project and store the result to mat files

2. run gen_project_plot to generate tangling/ scattering plot for each project

3. run gen_plot_all_scattering/tangling to generate scattering plot for all versions of all files

All the data are automatically stored in current directory. Make modifications on code if necessary when you want to include/ exclude the projects you want to analyze.