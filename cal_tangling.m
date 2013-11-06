function  [tangling, docprob] = cal_tangling(project,version)
% calculate scattering and generate scattering array for the given version of project
% In this function, the input is the basedir name of project and version
% name. The output is the scattering array after calculation 

%       topic1 topic2 ... topick ... topicn
% doc1    p11    p12  ...   p1k  ...   p1n
%   
% dock    pk1    pk2  ...   pk2  ...   pkn
% docm    p1m
% This matrix has following property:
% 1) sum of each column is 1
% 2) tangling of doc k 
%    = normalized H(k) = [- sum(i=1~n) pki * log (pki) ]
% 3) average tangling = sum(docprob.* normalized tangling H(k)


% load topic-doc mat file after importing Mallet data given the project 
% and version name 

DPpath = fullfile(project,'mat', sprintf('%s%s',version,'-topicdoc.mat'));
topicdoc = load(DPpath);
topicdoc = topicdoc.topicdoctemp; % convert strct to matrix
[ndoc,ntopic] = size(topicdoc);

Alltopiccount = sum(topicdoc(:));
Eachdoccount = sum(topicdoc,2);
% array to store proportion of each document
docprob = Eachdoccount./Alltopiccount;

repmat_weight = repmat(Eachdoccount,1,ntopic);

% get the new matrix for topic probability within each doc

topicdoc = topicdoc./repmat_weight;
topicdoc(isnan(topicdoc))=0; % change NAN value to zero

% calculate scattering
tangling = zeros(1, ndoc);
for i=1:size(topicdoc,1)
    for j=1:size(topicdoc,2)
        if (topicdoc(i,j)==0) 
            continue; 
        end
        tangling(1,i)=tangling(1,i)+topicdoc(i,j)*log(1/topicdoc(i,j));
    end
end

% divide log(topic) for normalization
tangling = tangling./log(ntopic);

% inverse docprob vector
docprob = docprob';

%save file
savepath_tangling = fullfile(project,'mat', sprintf('%s%s',version,'-tangling.mat'));
savepath_docprob = fullfile(project,'mat', sprintf('%s%s',version,'-docprob.mat'));
save(savepath_tangling,'tangling');
save(savepath_docprob,'docprob');

end

