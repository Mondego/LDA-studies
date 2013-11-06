% generate tangling plot for all versions of all files
D= dir;
locs = [];
filenums =[];
alltangling= [];
for dir_it= 1:size(D,1)
    % iterate each dir
    %if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..'))
    %   continue
    %end
	if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..') || strcmpi(D(dir_it,1).name,'megameklab'))
    continue
    end
	
    project = D(dir_it,1).name;
    load(fullfile(project,'mat','avgtangling'));
    alltangling = [alltangling, avg_tangling(1,:)];
    locs = [locs avg_tangling(2,:)];
    filenums = [filenums avg_tangling(3,:)];
    disp(project);
end

sizeproj = size(alltangling,2);

len = max(alltangling(1,:))- min(alltangling(1,:));
y1 = min(alltangling(1,:))-0.1*len;
y2 = max(alltangling(1,:))+0.1*len;

%loc
lencode = max(locs) - min(locs);
x1 =min(locs) - 0.05*lencode;
x2= max(locs) + 0.05*lencode;
for i=1: sizeproj     
    plot(locs(1,i), alltangling(1,i),'r.','MarkerSize',15);
    hold on;    
end
xlabel ('LOC');
ylabel ('average tangling');
title('repository');
axis([x1,x2,y1,y2]);
saveas(gcf,'all-tangling-loc','emf');
clf;

%filenum
lenfile = max(filenums) - min(filenums);
x1 =min(filenums) - 0.05*lenfile;
x2= max(filenums) + 0.05*lenfile;
for i=1: sizeproj     
    plot(filenums(1,i), alltangling(1,i),'r.','MarkerSize',15);
    hold on;
end
xlabel ('file number');
ylabel ('average tangling');
title('repository');
axis([x1,x2,y1,y2]);
saveas(gcf,'all-tangling-filenum','emf');
clf;
save('alltanglingres.mat','alltangling','locs','filenums');



