function af_plotMIvsmeanmprageMNI(PROJ_DIR,id,prestr)

if ~exist('PROJ_DIR','var')
    id = 'data3T';
    prestr = 'w';
    PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/';
end

% if ~exist('PROJ_DIR','var')
%     id = 'data7T';
%     prestr = 'w';
%     PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/7T/';
% end

PIC_DIR = fullfile(PROJ_DIR,'PICS');
if strcmp(id,'data3T');
    nslices = 79;
    nproband = 14;
    xlimits = [24 68];
end

if strcmp(id,'data7T');
    nslices = 156;
    nproband = 18;
    xlimits = [100 150];
end

load(fullfile(PROJ_DIR,['MIB0_id' id '_prestr' prestr 'data.mat'])); 
load(fullfile(PROJ_DIR,['MIfirst_id' id '_prestr' prestr 'data.mat']));
%load(fullfile(PROJ_DIR,['MI_id' id '_prestr' prestr 'data.mat']));

for kcase = 4 %1:4    
    %if kcase == 1, DATA1 = MI_mpragevsMo12_all; DATA1str = 'mpragevsMo12'; DATA2 = MI_mpragevsMm12_all; DATA2str = 'mpragevsMm12'; end
    %if kcase == 2, DATA1 = MI_mpragevsMo14_all; DATA1str = 'mpragevsMo14'; DATA2 = MI_mpragevsMmd14_all; DATA2str = 'mpragevsMmd14'; end
    %if kcase == 3, DATA1 = MI_mpragevsMd34_all; DATA1str = 'mpragevsMd34'; DATA2 = MI_mpragevsMmd34_all; DATA2str = 'mpragevsMmd34'; end
    if kcase == 4, DATA1 = MI_mpragevsMfo_all;  DATA1str = 'mpragevsMfo'; DATA2 = MI_mpragevsMfc_all; DATA2str = 'mpragevsMfc'; end   
    
    mDATA1 = DATA1;
    mDATA2 = DATA2;    
    mDATA1(isnan(mDATA1)) = 0;
    mDATA2(isnan(mDATA2)) = 0;
    
    for kslice = 1:size(DATA1,1)
        [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure
    hold on,
    mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
    % hold on, plot(DATA1,'b.')
    lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
    % hold on, plot(DATA2,'r.')
    DATA3 = DATA2-DATA1;
    lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);    
    hline2(0.05);
    plot(p_signrank,'k-.');
    hold on
    plot(h_signrank/2,'c-.');
    hold on
    ylim([-0.1 0.6]);
    xlim(xlimits);    
    xlabel(['final_slice_mutualmeanmprage p signrank' id ' ' prestr]);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    legend(DATA1str,DATA2str);
    save(fullfile(PIC_DIR,['final_slice_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
    saveas(gcf,fullfile(PIC_DIR,['final_slice_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
    saveas(gcf,fullfile(PIC_DIR,['final_slice_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
    figure
    hold on
    DATA3 = DATA2-DATA1;
    lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
    hline2(0.0);
    hold on
    ylim([-0.05 0.15]);
    xlim(xlimits);
    xlabel('slice-mutualmeanmprage-diff');
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    legend('final-slice-mutualmeanmprage-diff');
    save(fullfile(PIC_DIR,['final_slice_mutualmeanmprage_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
    saveas(gcf,fullfile(PIC_DIR,['final_slice_mutualmeanmprage_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
    saveas(gcf,fullfile(PIC_DIR,['final_slice_mutualmeanmprage_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
    
end


%%%% B0
xlimits = [7 31];

for kcase = 1 %1:4    
    %if kcase == 1, DATA1 = MI_mpragevsMo12_all; DATA1str = 'mpragevsMo12'; DATA2 = MI_mpragevsMm12_all; DATA2str = 'mpragevsMm12'; end
    %if kcase == 2, DATA1 = MI_mpragevsMo14_all; DATA1str = 'mpragevsMo14'; DATA2 = MI_mpragevsMmd14_all; DATA2str = 'mpragevsMmd14'; end
    %if kcase == 3, DATA1 = MI_mpragevsMd34_all; DATA1str = 'mpragevsMd34'; DATA2 = MI_mpragevsMmd34_all; DATA2str = 'mpragevsMmd34'; end
    if kcase == 1, DATA1 = B0mpragemni_orig_all;  DATA1str = 'B0mpragemni-orig-all'; DATA2 = B0mpragemni_dico_all; DATA2str = 'B0mpragemni-dico-all'; end
   %,'B0mpragemni_orig_all','B0mpragemni_orig_all')
    
    mDATA1 = DATA1;
    mDATA2 = DATA2;    
    mDATA1(isnan(mDATA1)) = 0;
    mDATA2(isnan(mDATA2)) = 0;
    
    for kslice = 1:size(DATA1,1)
        [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure
    hold on,
    mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
    % hold on, plot(DATA1,'b.')
    lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
    % hold on, plot(DATA2,'r.')
    DATA3 = DATA2-DATA1;
    lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
    %plot(mean(DATA2,2) - mean(DATA1,2),'g');
    hline2(0.05);
    plot(p_signrank,'k-.');
    hold on
    plot(h_signrank/2,'c-.');
    hold on
    ylim([-0.1 1]);
    xlim(xlimits);    
    xlabel([ 'p signrank' id ' ' prestr]);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    legend(DATA1str,DATA2str);
    save(fullfile(PIC_DIR,['final_B0Mask_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
    saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
    saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_mutualmeanmprage_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
    figure
    hold on
    DATA3 = DATA2-DATA1;
    lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
    hline2(0.0);
    hold on
    ylim([-0.1 0.2]);
    xlim(xlimits);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    legend('final-B0Mask-mutualmeanmprage-diff');
    save(fullfile(PIC_DIR,['final_B0Mask_MutualmeanMPRAGE_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.mat']),'DATA1','DATA2','DATA3','h_signrank','p_signrank');
    saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_mutualmeanmprage_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
    saveas(gcf,fullfile(PIC_DIR,['final_B0Mask_mutualmeanmprage_diff_' id '_' prestr '_' DATA1str '_' DATA2str '.fig']));
    
end




