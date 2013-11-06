% generate topic-doc matfile and tangling/scattering for each project
D= dir;
for dir_it= 1:size(D,1)
    % iterate each dir
    if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..'))
        continue
    end
    project = D(dir_it,1).name;
    % create empty fig directory; create mat directory and import DP as
    % readable .mat file; load version information for given project
    [versions, locs, filenums, topicnums]=importMallet(project);
    
    % iterate each version, save scattering and tangling result to file
    for ver_it = 1:size(versions)
        cal_tangling(project,versions{ver_it});
        cal_scattering(project,versions{ver_it});
    end
    
    disp(project);
end
