function [versions, locs, filenums, topicnums] =importMallet(basedir)
% 1)import word - doc sparse text matrix (DP file) 
% 2)import doc-name information of doc-topics file
% 3)import topic name information sand save the matfile to 
% its subdirectory. Input should be the project we would like to process
% for example, we want to process ant. The base directory should be ant,
% and we store the topicdoc mat to ant/mat directory. Version name
% is also specified in the result. Also create empty fig/mat directory
[versions, locs, filenums, topicnums]=loadversioninfor(basedir);

% regex pattern for extracting filename information
pattern1 = '(?<=.*mallet-data).*';
% regex pattern for extracting topic information
pattern2 = '(.*?\s){5,8}'; % select top 8 topics

if(isdir(basedir)==1)
    mkdir(fullfile(basedir,'mat'));
    mkdir(fullfile(basedir,'fig'));
    
    for i=1:size(versions,1)
        version = versions{i};
        filenum = filenums(i);
        topicnum = topicnums(i);
        
        DPpath = fullfile(basedir,'LDA',sprintf('%s%s',version,'-DP.txt'));
        DnamePath =  fullfile(basedir,'LDA',sprintf('%s%s',version,'-doc-topics.txt'));
        TnamePath = fullfile(basedir,'LDA',sprintf('%s%s',version,'-topic-keys.txt'));
        
        saveDP = fullfile(basedir,'mat',sprintf('%s%s',version,'-topicdoc.mat'));
        saveDname =  fullfile(basedir,'mat',sprintf('%s%s',version,'-docname.mat'));
        saveTname =  fullfile(basedir,'mat',sprintf('%s%s',version,'-topicname.mat'));
          
        % init a spave for storing information
        topicdoctemp = zeros(filenum, topicnum);
        
        temp= load(DPpath);
        % change the format of DP text to readable matrix
        for j=1:size(temp,1)
            topicdoctemp(temp(j,1), temp(j,2)) = temp(j,3);
        end
        
        % regex of text of file name and to store it as cell array
        fileID = fopen(DnamePath);
        text = textscan(fileID,'%s %s %*[^\n]','HeaderLines',1);
        dnametemp = regexp(text{1,2}, pattern1, 'match');
        fclose(fileID);
        
        % regex of text of topic name and to store it as cell array
        fileID = fopen(TnamePath);
        text = textscan(fileID, '%d %d %s', 'Delimiter', '\t');
        tnametemp = regexp(text{1,3}, pattern2, 'match');
        fclose(fileID);

        % save topicdoc variable
        save(saveDP,'topicdoctemp');
        save(saveDname,'dnametemp');
        save(saveTname,'tnametemp');
        
    end
end
end

