addpath(genpath('/opt/MATLAB/R2016a/toolbox/spm12/'));


filt = ['^rp_*','.*\.txt$'];
b = spm_select([Inf],'any','Select realignment parameters',[],pwd,filt);
scaleme = [-3 3];
mydata = pwd;

for i = 1:size(b,1)
    
    [p nm e v] = spm_fileparts(b(i,:));
    
    printfig = figure;
    set(printfig, 'Name', ['Motion parameters: subject ' num2str(i) ],'Visible','on');
    loadmot = load(deblank(b(i,:)));
    subplot(2,1,1);
    plot(loadmot(:,1:3));
    grid on;
    s = ['x translation';'y translation';'z translation'];
    legend(s)

    
    ylim(scaleme);  % enable to always scale between fixed values as set above
    title(['Motion parameters: shifts (top, in mm) and rotations (bottom, in dg)'], 'interpreter', 'none');
    subplot(2,1,2);
    plot(loadmot(:,4:6)*180/pi);
    grid on;
    ylim(scaleme);   % enable to always scale between fixed values as  %set above
    title(['Data from ' p], 'interpreter', 'none');
    mydate = date;
    motname = [mydata filesep 'motion_sub_' sprintf('%02.0f', i) '_' mydate '.png'];
    s = ['pitch';'roll ';'yaw  '];
    %legend(ax, s, 0)
    legend(s)   
    
    % print(printfig, '-dpng', '-noui', '-r100', motname);  % enable to    print to file
    % close(printfig);   % enable to close graphic window   
    
end



 
rp = spm_load(spm_select); %select the rp*.txt file
figure;
subplot(2,1,1);plot(rp(:,1:3));
set(gca,'xlim',[0 size(rp,1)+1]);
subplot(2,1,2);plot(rp(:,4:6));
set(gca,'xlim',[0 size(rp,1)+1]);