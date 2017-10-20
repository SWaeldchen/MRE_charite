function af_plotMI2(PROJ_DIR,id,prestr)

% if ~exist('PROJ_DIR','var')
%     id = 'data3T';
%     prestr = 'w';
%     PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/';
% end

if ~exist('PROJ_DIR','var')
    id = 'data7T';
    prestr = 'w';
    PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/7T/';
end

PIC_DIR = fullfile(PROJ_DIR,'PICS');

for kslice = 1:79
    for subj = 1:14
        
        load(fullfile(PROJ_DIR,'MI_DIR',['DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]));
        
        MI_mpragevsAo_all(kslice,subj) = MI_mpragevsAd;
        MI_mpragevsAm_all(kslice,subj) = MI_mpragevsAm;
        MI_mpragevsAmd_all(kslice,subj) = MI_mpragevsAmd;
        MI_mpragevsAo_all(kslice,subj) = MI_mpragevsAo;
        MI_mpragevsMfc_all(kslice,subj) = MI_mpragevsMfc;
        MI_mpragevsMfo_all(kslice,subj) = MI_mpragevsMfo;
        
    end
end


%[ht_all2,pt_all2] = ttest(MI_mpragevsMfo_all',MI_mpragevsMfc_all');

DATA1 = MI_mpragevsMfo_all;
DATA1str = 'mpragevsMfo';
DATA2 = MI_mpragevsMfc_all;
DATA2str = 'mpragevsMfc';
% DATA1 = MI_mpragevsAo_all;
% DATA2 = MI_mpragevsAm_all;
% mMI_mpragevsMfo_all = MI_mpragevsMfo_all;
% mMI_mpragevsMfc_all = MI_mpragevsMfc_all;

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
plot(p_signrank*10,'k-.');
plot(h_signrank,'c-.');
%plot(pt_all2*10,'k--');
%xlim([100 140]);
ylim([-0.1 1.1]);
legend(DATA1str,DATA2str);
xlabel('p signrank * 10');

saveas(gcf,fullfile(PIC_DIR,['Mutual_' id '_' prestr '_' DATA1str '_' DATA2str '.png']));


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