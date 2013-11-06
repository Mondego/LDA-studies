function plotscattering(project,versions, locs, filenums, option)
% given the version information of project, plot its scattering graph
% option:1 version
% option:2 loc
% option:3 filenum

% store average scattering for each version of given project
sizeproj = size(versions,1);
avg_scattering = zeros(3,sizeproj);


for i=1:sizeproj
    load(fullfile(project,'mat',sprintf('%s%s',versions{i},'-scattering.mat'))); %load scattering
    load(fullfile(project,'mat',sprintf('%s%s',versions{i},'-topicprob.mat'))) ; %load topic prob
    avg_scattering(1,i) = sum(scattering.*topicprob);
    %avg_scattering(1,i) = sum(scattering)/size(scattering,2);
    avg_scattering(2,i) = locs(i,1);
    avg_scattering(3,i) = filenums(i,1);
end

%y range
len = max(avg_scattering(1,:))- min(avg_scattering(1,:));
y1 = min(avg_scattering(1,:))-0.1*len;
y2 = max(avg_scattering(1,:))+0.1*len; 

% version
if(option==1)
     savefigpath = fullfile(project,'fig','avgscattering-version');
     x1 = 1-0.05*(sizeproj-1);
     x2 = sizeproj + 0.05*(sizeproj-1);
     for i=1: sizeproj     
        plot(i, avg_scattering(1,i),'r.','MarkerSize',15);
        hold on;    
     end
    xlabel ('version');

%loc
elseif(option==2)
     savefigpath = fullfile(project,'fig','avgscattering-loc');
     lencode = max(locs) - min(locs);
     x1 =min(locs) - 0.05*lencode;
     x2= max(locs) + 0.05*lencode;
     for i=1: sizeproj     
        plot(locs(i,1), avg_scattering(1,i),'r.','MarkerSize',15);
        hold on;    
     end
    xlabel ('LOC');
    
elseif(option==3)
     savefigpath = fullfile(project,'fig','avgscattering-filenum');
     lenfile = max(filenums) - min(filenums);
     x1 =min(filenums) - 0.05*lenfile;
     x2= max(filenums) + 0.05*lenfile;
     for i=1: sizeproj     
        plot(filenums(i,1), avg_scattering(1,i),'r.','MarkerSize',15);
        hold on;    
     end
    xlabel ('file number');
else
    disp('check option');
    
end

ylabel ('average scattering');
title(project);
axis([x1,x2,y1,y2]);
saveas(gcf,savefigpath,'emf');
clf;

save(fullfile(project,'mat','avgscattering.mat'),'avg_scattering');


