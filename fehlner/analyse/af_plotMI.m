function af_plotMI(PROJ_DIR,id,prestr)

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

for kslice = 

load(fullfile(PROJ_DIR,'MI_DIR',['DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]))

load(['DATA_' id '_sub' int2str(subj) '_' prestr '_kslice' int2str(kslice)]

load(fullfile(PROJ_DIR,['mutual_' id '_' prestr]),'MIGLCM_o','MIGLCM_c','MI_o','MI_c',...
    'MIGLCMnomask_o','MIGLCMnomask_c','MInomask_o','MInomask_c','IMI','IIGLCM',...
    'MIGLCM_A','MIGLCM_Anc','MIGLCM_P','MIGLCM_Pnc');

    [ht_all2,pt_all2] = ttest(MIGLCM_o',MIGLCM_c');

    mMIGLCM_o = MIGLCM_o;
    mMIGLCM_c = MIGLCM_c;
    
    mMIGLCM_o(isnan(mMIGLCM_o)) = 0;
    mMIGLCM_c(isnan(mMIGLCM_c)) = 0;

for kslice = 1: size(MIGLCM_c,1)
    [ps_all2(kslice),hs_all2(kslice)] = signrank(squeeze(mMIGLCM_o(kslice,:)),squeeze(mMIGLCM_c(kslice,:)));    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure

hold on, 
mseb([],mean(MIGLCM_c,2)',std(MIGLCM_c,[],2)',[],1);
% hold on, plot(MIGLCM_c,'b.')
lineProps.col={'r'}; mseb([],mean(MIGLCM_o,2)',std(MIGLCM_o,[],2)',lineProps,1);
% hold on, plot(MIGLCM_o,'r.')
plot(mean(MIGLCM_c,2) - mean(MIGLCM_o,2), 'g');
hline2(0.05);
plot(ps_all2*10,'k-.');
plot(pt_all2*10,'k--');
%xlim([100 140]);
ylim([-0.1 0.9]);

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

saveas(gcf,fullfile(PIC_DIR,['mutual_' id '_' prestr '.png']));

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

%% Transparent shaded error bands
figure, hold on, mseb([],mean(MI_o(:,2:end),2)',std(MI_o(:,2:end),[],2)',[],1);
% hold on, plot(MI_o(:,2:end),'b.')
lineProps.col={'r'}; mseb([],mean(MI_c(:,2:end),2)',std(MI_c(:,2:end),[],2)',lineProps,1);
% hold on, plot(MI_c(:,2:end),'r.')


%% Welchen Einfluss hat Smoothing bzw. Inversion des Kontrastes?
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