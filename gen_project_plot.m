% generate tangling and scattering plot for each project 
D= dir;
for dir_it= 1:size(D,1)
    % iterate each dir
    if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..'))
        continue
    end
    project = D(dir_it,1).name;
    [versions, locs, filenums, topicnums]=loadversioninfor(project);
    %plotscattering(project,versions, locs, filenums, 1);
    plotscattering(project,versions, locs, filenums, 2);
    plotscattering(project,versions, locs, filenums, 3);
    %plottangling(project,versions, locs, filenums, 1);
    plottangling(project,versions, locs, filenums, 2);
    plottangling(project,versions, locs, filenums, 3);
    disp(project);
end
    

