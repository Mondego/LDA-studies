% write all the information as human readable matrix in excel spreadsheet

D= dir;
for dir_it= 1:size(D,1)
    
    % iterate each dir
    if (isdir(D(dir_it,1).name)==0 || strcmpi(D(dir_it,1).name,'.') || strcmpi(D(dir_it,1).name,'..'))
        continue
    end
    project = D(dir_it,1).name;
    if(isdir(sprintf('%s/datatable',project)))
        temp = sprintf('%s/datatable',project);
        rmdir(fullfile(sprintf('%s/datatable',project)),'s');
    end
    mkdir(fullfile(sprintf('%s/datatable',project))); % make empty dir for storing excel files
    
    fid = fopen(sprintf('%s/datatable/%s.xlsx',project), 'wt'); % create spreadsheet file
    [versions, locs, filenums, topicnums]=loadversioninfor(project);
    load(fullfile(project,'mat','avgscattering.mat'));
    load(fullfile(project,'mat','avgtangling.mat'));

    % iterate each version, save scattering and tangling result to file
    for ver_it = 1:size(versions)
        % write headers
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('scattering'),versions{ver_it},'G2');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('topic proportion'),versions{ver_it},'G1');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('doc proportion'),versions{ver_it},'E3');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('tangling'),versions{ver_it},'F3');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('version'),versions{ver_it},'A1');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('LOC'),versions{ver_it},'A2');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('filenumber'),versions{ver_it},'A3');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('topicnumber'),versions{ver_it},'A4');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('average_scattering'),versions{ver_it},'A5');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr('average_tangling'),versions{ver_it},'A6');
        
        load(fullfile(project,'mat',sprintf('%s-topicname.mat',versions{ver_it})));
        % convert topic to one because there are 2 col in topic cell array
        convert_topic = cell(1,topicnums(ver_it));
        for i = 1:topicnums(ver_it)          
            %in some case there is no topic in table result
            if(isempty(tnametemp{i}))
                convert_topic{i} = [];
                continue;
            end
            convert_topic{i} = tnametemp{i}{1};
        end
        % write topic name
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),convert_topic,versions{ver_it},'H3');
        
        % write file name
        convert_doc = cell(filenums(ver_it),1);
        load(fullfile(project,'mat',sprintf('%s-docname.mat',versions{ver_it})));
        for i = 1:filenums(ver_it)          
            convert_doc{i} = dnametemp{i}{1};
        end    
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),convert_doc,versions{ver_it},'G4');

        %write dp matrix
        load(fullfile(project,'mat',sprintf('%s-topicdoc.mat',versions{ver_it})));
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),topicdoctemp,versions{ver_it},'H4');

        % write doc and topic proportion
        load(fullfile(project,'mat',sprintf('%s-docprob.mat',versions{ver_it})));
        load(fullfile(project,'mat',sprintf('%s-topicprob.mat',versions{ver_it})));
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),topicprob,versions{ver_it},'H1');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),docprob',versions{ver_it},'E4');

        % write scattering/tangling 
        load(fullfile(project,'mat',sprintf('%s-scattering.mat',versions{ver_it})));
        load(fullfile(project,'mat',sprintf('%s-tangling.mat',versions{ver_it})));
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),scattering,versions{ver_it},'H2');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),tangling',versions{ver_it},'F4');

        % write version information
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),cellstr(versions{ver_it}),versions{ver_it},'B1');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),locs(ver_it),versions{ver_it},'B2');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),filenums(ver_it),versions{ver_it},'B3');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),topicnums(ver_it),versions{ver_it},'B4');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),avg_scattering(1,ver_it),versions{ver_it},'B5');
        xlswrite(sprintf('%s/datatable/%s.xls',project,project),avg_tangling(1,ver_it),versions{ver_it},'B6');
    end
    disp(project);
end
