function [versions, locs, filenums, topicnums] =importMallet(basedir)
% import word - doc sparse text matrix (DP file) and save the matfile to 
% its subdirectory. Input should be the project we would like to process
% for example, we want to process ant. The base directory should be ant,
% and we store the topicdoc mat to ant/mat directory. Version name
% is also specified in the result. Also create empty fig directory
[versions, locs, filenums, topicnums]=loadversioninfor(basedir);
% topicdoc = cell(size(versions,1),1);

if(isdir(basedir)==1)
    mkdir(fullfile(basedir,'mat'));
    mkdir(fullfile(basedir,'fig'))
    for i=1:size(versions,1)
        version = versions{i};
        filenum = filenums(i);
        topicnum = topicnums(i);
        
        DPpath = fullfile(basedir,'LDA',sprintf('%s%s',version,'-DP.txt'));
        savepath = fullfile(basedir,'mat',sprintf('%s%s',version,'-topicdoc.mat')); 
        
        topicdoctemp = zeros(filenum, topicnum); % init a matrix for storing DP information
        temp= load(DPpath);
        % change the format of DP text to readable matrix
        for j=1:size(temp,1)
            topicdoctemp(temp(j,1), temp(j,2)) = temp(j,3);
        end

        % save topicdoc variable
        save(savepath,'topicdoctemp');
    end
end
end

