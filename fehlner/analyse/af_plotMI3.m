function af_plotMI3(PROJ_DIR,id,prestr)

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
    xlimits = [0 80];
end

if strcmp(id,'data7T');
    nslices = 156;
    nproband = 18;
    xlimits = [100 150];
end

for kslice = 1:nslices
    for subj = 1:nproband
        
        load(fullfile(PROJ_DIR,'MI_DIR',['N2DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]));
        
        MI_mpragevsAo_all(kslice,subj) = MI_mpragevsAo;
        MI_mpragevsAm_all(kslice,subj) = MI_mpragevsAm;
        MI_mpragevsAd_all(kslice,subj) = MI_mpragevsAd;
        MI_mpragevsAmd_all(kslice,subj) = MI_mpragevsAmd;
        
        MI_mpragevsAnco_all(kslice,subj) = MI_mpragevsAnco;
        MI_mpragevsAncm_all(kslice,subj) = MI_mpragevsAncm;
        MI_mpragevsAncd_all(kslice,subj) = MI_mpragevsAncd;
        MI_mpragevsAncmd_all(kslice,subj) = MI_mpragevsAncmd;
        
        MI_mpragevsPo_all(kslice,subj) = MI_mpragevsPo;
        MI_mpragevsPm_all(kslice,subj) = MI_mpragevsPm;
        MI_mpragevsPd_all(kslice,subj) = MI_mpragevsPd;
        MI_mpragevsPmd_all(kslice,subj) = MI_mpragevsPmd;
        
        MI_mpragevsPnco_all(kslice,subj) = MI_mpragevsPnco;
        MI_mpragevsPncm_all(kslice,subj) = MI_mpragevsPncm;
        MI_mpragevsPncd_all(kslice,subj) = MI_mpragevsPncd;
        MI_mpragevsPncmd_all(kslice,subj) = MI_mpragevsPncmd;
        
        MI_mpragevsMfc_all(kslice,subj) = MI_mpragevsMfc;
        MI_mpragevsMfo_all(kslice,subj) = MI_mpragevsMfo;
        
        MI_mpragevsMo_all(kslice,subj) = MI_mpragevsMo;
        MI_mpragevsMm_all(kslice,subj) = MI_mpragevsMm;
        MI_mpragevsMd_all(kslice,subj) = MI_mpragevsMd;
        MI_mpragevsMmd_all(kslice,subj) = MI_mpragevsMmd;
        
        
    end
end


%[ht_all2,pt_all2] = ttest(MI_mpragevsMfo_all',MI_mpragevsMfc_all');

for kcase = 1:16
    
    if kcase == 1, DATA1 = MI_mpragevsMfo_all; DATA1str = 'mpragevsMfo';DATA2 = MI_mpragevsMfc_all; DATA2str = 'mpragevsMfc'; end
    
    if kcase == 2, DATA1 = MI_mpragevsAo_all; DATA1str = 'mpragevsAo'; DATA2 = MI_mpragevsAm_all;  DATA2str = 'mpragevsAm';  end
    if kcase == 3, DATA1 = MI_mpragevsAo_all; DATA1str = 'mpragevsAo'; DATA2 = MI_mpragevsAmd_all; DATA2str = 'mpragevsAmd'; end
    if kcase == 4, DATA1 = MI_mpragevsAd_all; DATA1str = 'mpragevsAd'; DATA2 = MI_mpragevsAmd_all; DATA2str = 'mpragevsAmd'; end
    
    if kcase == 5, DATA1 = MI_mpragevsAnco_all; DATA1str = 'mpragevsAnco'; DATA2 = MI_mpragevsAncm_all;  DATA2str = 'mpragevsAncm';  end
    if kcase == 6, DATA1 = MI_mpragevsAnco_all; DATA1str = 'mpragevsAnco'; DATA2 = MI_mpragevsAncmd_all; DATA2str = 'mpragevsAncmd'; end
    if kcase == 7, DATA1 = MI_mpragevsAncd_all; DATA1str = 'mpragevsAncd'; DATA2 = MI_mpragevsAncmd_all; DATA2str = 'mpragevsAncmd'; end
    
    if kcase == 8, DATA1 = MI_mpragevsPo_all; DATA1str = 'mpragevsPo'; DATA2 = MI_mpragevsPm_all;  DATA2str = 'mpragevsPm';  end
    if kcase == 9, DATA1 = MI_mpragevsPo_all; DATA1str = 'mpragevsPo'; DATA2 = MI_mpragevsPmd_all; DATA2str = 'mpragevsPmd'; end
    if kcase == 10, DATA1 = MI_mpragevsPd_all; DATA1str = 'mpragevsPd'; DATA2 = MI_mpragevsPmd_all; DATA2str = 'mpragevsPmd'; end
    
    if kcase == 11, DATA1 = MI_mpragevsPnco_all; DATA1str = 'mpragevsPnco'; DATA2 = MI_mpragevsPncm_all;  DATA2str = 'mpragevsPncm';  end
    if kcase == 12, DATA1 = MI_mpragevsPnco_all; DATA1str = 'mpragevsPnco'; DATA2 = MI_mpragevsPncmd_all; DATA2str = 'mpragevsPncmd'; end
    if kcase == 13, DATA1 = MI_mpragevsPncd_all; DATA1str = 'mpragevsPncd'; DATA2 = MI_mpragevsPncmd_all; DATA2str = 'mpragevsPncmd'; end
    
    if kcase == 14, DATA1 = MI_mpragevsMo_all; DATA1str = 'mpragevsMo'; DATA2 = MI_mpragevsMm_all;  DATA2str = 'mpragevsMm';  end
    if kcase == 15, DATA1 = MI_mpragevsMo_all; DATA1str = 'mpragevsMo'; DATA2 = MI_mpragevsMmd_all; DATA2str = 'mpragevsMmd'; end
    if kcase == 16, DATA1 = MI_mpragevsMd_all; DATA1str = 'mpragevsMd'; DATA2 = MI_mpragevsMmd_all; DATA2str = 'mpragevsMmd'; end
    
    
    mDATA1 = DATA1;
    mDATA2 = DATA2;
    
    mDATA1(isnan(mDATA1)) = 0;
    mDATA2(isnan(mDATA2)) = 0;
    
    for kslice = 1:size(MI_mpragevsAo_all,1)
        [p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure
    hold on,
    mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
    % hold on, plot(DATA1,'b.')
    lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
    % hold on, plot(DATA2,'r.')
    plot(mean(DATA1,2) - mean(DATA2,2),'g');
    hline2(0.05);
    plot(p_signrank,'k-.');
    hold on
    plot(h_signrank/2,'c-.');
    hold on
    ylim([-0.1 0.6]);
    xlim(xlimits);
    
    xlabel([ 'p signrank' id ' ' prestr]);
    set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
    legend(DATA1str,DATA2str);
    
    saveas(gcf,fullfile(PIC_DIR,['Mutual_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));
    close
end

%legend('MI_mpragevsAo_all','MI_mpragevsAm_all')
% blue: corrected ??
% red: orig ??

%
% subplot(2,1,2)
% hold on,
% mseb([],mean(MI_c,2)',std(MI_c,[],2)',[],1);
% % hold on, plot(MIGLCM_c,'b.')
% lineProps.col={'r'}; mseb([],mean(MI_o,2)',std(MI_o,[],2)',lineProps,1);
% % hold on, plot(MIGLCM_o,'r.')
% plot(mean(MI_c,2) - mean(MI_o,2), 'k');



% subplot(3,1,3)
% hold on,
% mseb([],mean(MInomask_c,2)',std(MInomask_c,[],2)',[],1);
% % hold on, plot(MIGLCM_c,'b.')
% lineProps.col={'r'}; mseb([],mean(MInomask_o,2)',std(MInomask_o,[],2)',lineProps,1);
% % hold on, plot(MIGLCM_o,'r.')
% plot(mean(MInomask_c,2) - mean(MInomask_o,2), 'k');


% figure;plot(R_c - R_o), hold on, plot(0*[1:80])     % Negative for smoothing. Useful for same contrast only?
% figure;plot(MSE_c - MSE_o), hold on, plot(0*[1:80]) % Positive for smoothing. Useful for same contrast only?

%% Matlab errorbar
% figure, errorbar(mean(MI_c(:,2:end),2), std(MI_c(:,2:end),[],2))
% % hold on, plot(MI_c(:,2:end),'b.')
% hold on, errorbar(mean(MI_o(:,2:end),2), std(MI_o(:,2:end),[],2))
% % hold on, plot(MI_o(:,2:end),'r.')

%% Dotted error bands
% figure, hold on
% plot(mean(MI_c(:,2:end),2),'r')
% plot(mean(MI_c(:,2:end),2) + std(MI_c(:,2:end),[],2),'b:')
% plot(mean(MI_c(:,2:end),2) - std(MI_c(:,2:end),[],2),'b:')
% plot(mean(MI_o(:,2:end),2),'r')
% plot(mean(MI_o(:,2:end),2) + std(MI_o(:,2:end),[],2),'r:')
% plot(mean(MI_o(:,2:end),2) - std(MI_o(:,2:end),[],2),'r:')
%
% %% Transparent shaded error bands
% figure, hold on, mseb([],mean(MI_o(:,2:end),2)',std(MI_o(:,2:end),[],2)',[],1);
% % hold on, plot(MI_o(:,2:end),'b.')
% lineProps.col={'r'}; mseb([],mean(MI_c(:,2:end),2)',std(MI_c(:,2:end),[],2)',lineProps,1);
% % hold on, plot(MI_c(:,2:end),'r.')
%
%
% %% Welchen Einfluss hat Smoothing bzw. Inversion des Kontrastes?
% X = spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\MREPERF-SH_20150625-145714\SEGNORM\wMPRAGE.nii']));
% X = int32(X);
% Yo = X;
% Yo = int32(X); % ggf. Inversion
%
% for sm = 1:2:20
%     Yc = int32(smooth3(X,'box', [sm sm sm]));
%     for s=1:size(X,3)
%         MI_o(s,sm) = MI_GG(X(:,:,s), Yo(:,:,s));
%         MI_c(s,sm) = MI_GG(X(:,:,s), Yc(:,:,s));
%         R_o(s,sm) = corr2(X(:,:,s), Yo(:,:,s));
%         R_c(s,sm) = corr2(X(:,:,s), Yc(:,:,s));
%         MSE_o(s,sm) = immse(X(:,:,s), Yo(:,:,s));
%         MSE_c(s,sm) = immse(X(:,:,s), Yc(:,:,s));
%     end
% end
%
% figure;plot(MI_c - MI_o), hold on, plot(0*[1:80])   % (!)
% figure;plot(R_c - R_o), hold on, plot(0*[1:80])     % Negative for smoothing. Useful for same contrast only?
% figure;plot(MSE_c - MSE_o), hold on, plot(0*[1:80]) % Positive for smoothing. Useful for same contrast only?


%end