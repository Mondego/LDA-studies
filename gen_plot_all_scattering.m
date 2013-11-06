% generate scattering plot for all versions of all files
D= dir;
locs = [];
filenums =[];
allscattering= [];
for dir_it= 1:size(D,1)
    % iterate each dir
%     if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..'))
%         continue
%     end
	if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..') || strcmpi(D(dir_it,1).name,'megameklab'))
    continue
    end
    project = D(dir_it,1).name;
    load(fullfile(project,'mat','avgscattering'));
    allscattering = [allscattering, avg_scattering(1,:)];
    locs = [locs avg_scattering(2,:)];
    filenums = [filenums avg_scattering(3,:)];
    disp(project);
end

sizeproj = size(allscattering,2);

len = max(allscattering(1,:))- min(allscattering(1,:));
y1 = min(allscattering(1,:))-0.1*len;
y2 = max(allscattering(1,:))+0.1*len;

%loc
lencode = max(locs) - min(locs);
x1 =min(locs) - 0.05*lencode;
x2= max(locs) + 0.05*lencode;
for i=1: sizeproj     
    plot(locs(1,i), allscattering(1,i),'r.','MarkerSize',15);
    hold on;    
end
xlabel ('LOC');
ylabel ('average scattering');
title('repository');
axis([x1,x2,y1,y2]);
saveas(gcf,'all-scattering-loc','emf');
clf;

%filenum
lenfile = max(filenums) - min(filenums);
x1 =min(filenums) - 0.05*lenfile;
x2= max(filenums) + 0.05*lenfile;
for i=1: sizeproj     
    plot(filenums(1,i), allscattering(1,i),'r.','MarkerSize',15);
    hold on;
end
xlabel ('file number');
ylabel ('average scattering');
title('repository');
axis([x1,x2,y1,y2]);
saveas(gcf,'all-scattering-filenum','emf');
save('allscatteringres.mat', 'allscattering','filenums','locs');
clf;



