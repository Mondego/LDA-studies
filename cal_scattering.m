function  [scattering, topicprob] = cal_scattering(project,version)
% calculate scattering and generate scattering array for the given version of project
% In this function, the input is the basedir name of project and version
% name. The output is the scattering array after calculation 

%       topic1 topic2 ... topick ... topicn
% doc1    p11    p12  ...   p1k  ...   p1n      
% doc2    p12
% ...
% docm    p1m
% This matrix has following property:
% 1) sum of each row is 1
% 2) scattering of topic k 
%    = normalized H(pk) = [- sum(i=1~m) pki * log (pki) ] / logm
% H(pk) = 0, means topic is only exhibited in one file
% H(pk) = 1, means topic is uniformly distributed in all files

% load topic-doc mat file after importing Mallet data given the project 
% and version name 

DPpath = fullfile(project,'mat', sprintf('%s%s',version,'-topicdoc.mat'));
topicdoc = load(DPpath);
topicdoc = topicdoc.topicdoctemp; % convert strct to matrix
[ndoc,ntopic] = size(topicdoc);

Alltopiccount = sum(topicdoc(:));
Eachtopiccount = sum(topicdoc);
% array to store proportion of each topic
topicprob = Eachtopiccount./Alltopiccount;

repmat_weight = repmat(Eachtopiccount, ndoc,1);

% get the new matrix for topic probability within each topic and also

topicdoc = topicdoc./repmat_weight;
topicdoc(isnan(topicdoc))=0; % change NAN value to zero

% calculate scattering
scattering = zeros(1, ntopic);
for i=1:size(topicdoc,2)
    for j=1:size(topicdoc,1)
        if (topicdoc(j,i)==0) 
            continue; 
        end
        scattering(1,i)=scattering(1,i)+topicdoc(j,i)*log(1/topicdoc(j,i));
    end
end

% divide log(doc_num) for normalization
scattering = scattering./log(ndoc);

%save file
savepath_scattering = fullfile(project,'mat', sprintf('%s%s',version,'-scattering.mat'));
savepath_topicprob = fullfile(project,'mat', sprintf('%s%s',version,'-topicprob.mat'));
save(savepath_scattering,'scattering');
save(savepath_topicprob,'topicprob');

end

