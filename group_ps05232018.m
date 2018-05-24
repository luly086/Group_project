function group_ps05232018
  holder = dir('*.mat');
  num_files = size(holder,1);
  for f = 1:num_files
    filemat = holder(f).name
    csvfile = strcat(filemat(1:end-4),'_PS_num.csv')
    load(filemat)
    file_subPS = strcat(filemat(1:end-4),'.dat')
    file_sub_PS = fopen(file_subPS,'w');

    file_subPS1 = strcat(filemat(1:end-4),'_process.dat')
    file_sub_PS1 = fopen(file_subPS1,'w');

    
    num_PS = struct;
    label = [];
    k = 1;
    for i = 1:size(ps,2)
        if ismember(i,label)
            continue;
        end
        ps_ele = ps{i};
        fprintf(file_sub_PS,'%d ',i);
        label = [label i];
        group = i;
        for j = i+1:size(ps,2)
            if ismember(j,label)
                continue;
            end
            %{
            if length(ps_ele) < length(ps{j})
              inte = length(intersect(ps_ele,ps{j}))/length(ps_ele);
            else
              inte = length(intersect(ps_ele,ps{j}))/length(ps{j});
            end
%}
            if length(intersect(ps_ele,ps{j}))/length(ps_ele) >= 0.7
                 fprintf(file_sub_PS,'%d ',j);
                 group = [group j];
                 label = [label j];
            end
        end
        if length(group) >1
            runIntersect = mintersect(ps{group});
            num_PS(k).PS_id = k;
            num_PS(k).PS_num = length(group);
            num_PS(k).ele_num = length(runIntersect); 
            fprintf(file_sub_PS,'\n');
            fprintf(file_sub_PS,'%s %d: ','Axon', k);
            fprintf(file_sub_PS,'%s, ',runIntersect{1:end-1});
            fprintf(file_sub_PS,'%s\n\n', runIntersect{end});
            
            fprintf(file_sub_PS1,'\n');
            fprintf(file_sub_PS1,'%s %d: ','Axon', k);
            fprintf(file_sub_PS1,'%s, ',runIntersect{1:end-1});
            fprintf(file_sub_PS1,'%s\n\n', runIntersect{end});
        else
            ps_unq = unique(ps{group});
            fprintf(file_sub_PS,'\n');
            fprintf(file_sub_PS,'%s %d: ','Axon', k);
            fprintf(file_sub_PS,'%s, ',ps_unq{1:end-1});
            fprintf(file_sub_PS,'%s\n\n', ps_unq{end});

            fprintf(file_sub_PS1,'\n');
            fprintf(file_sub_PS1,'%s %d: ','Axon', k);
            fprintf(file_sub_PS1,'%s, ',ps_unq{1:end-1});
            fprintf(file_sub_PS1,'%s\n\n', ps_unq{end});
	    
            num_PS(k).PS_id = k;
            num_PS(k).PS_num = length(group);
            num_PS(k).ele_num = length(unique(ps{group}));
        end
        k = k+1;
	
    ps_fow = ps(group);
    for row = 1:size(ps_fow,2)
      fprintf(file_sub_PS1,'%s %d: ','Branches', group(row));
      fprintf(file_sub_PS1, '%s, ', ps_fow{row}{1:end-1});
      fprintf(file_sub_PS1, '%s\n',ps_fow{row}{end});
    end
    fprintf(file_sub_PS1,'\n\n');
   
    end
    num_PS = struct2table(num_PS);
    writetable(num_PS,csvfile);
  end
    
    
