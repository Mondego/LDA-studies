function [versions, LOCs, filenums, topicnums]=loadversioninfor(basedir)
% load the version information for each project,store the version
% information to variable named versioninfor
versionpath = fullfile(basedir, 'version.txt');
fileID = fopen(versionpath);
versioninfor = textscan(fileID, '%s %f %f %f', 'delimiter', ',');
        versions = versioninfor{1};
        LOCs = versioninfor{2};
        filenums = versioninfor{3};
        topicnums = versioninfor{4};
end

