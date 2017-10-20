function res = af_GMWM_MNI(PROJ_DIR,Asubject)

%PROJ_DIR = '/store01_analysis/realtime/edin7T/';
%SUBJ_DIR = 'nd81-3188_20150114-103840';

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_orig.nii')));
    MAG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_moco.nii')));
    MAG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_dico.nii')));
    MAG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MAGm_modico.nii')));
    
    ABSG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_orig.nii')));
    ABSG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_moco.nii')));
    ABSG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_dico.nii')));
    ABSG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_ABSG_modico.nii')));    

    wTPM = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','wTPM.nii')),1);
    
    c1 = wTPM(:,:,:,1);
    c2 = wTPM(:,:,:,2);

for k=1:4
    for s = 1:size(MAG_X,3)
        
        MAG_X1 = MAG_X(:,:,s,k) .* (0.5<c1(:,:,s));
        MAG_X2 = MAG_X(:,:,s,k) .* (0.5<c2(:,:,s));
        res.GM_M_m(s,subj,k) = mean(MAG_X1(MAG_X1>0));
        res.GM_M_s(s,subj,k) = std(MAG_X1(MAG_X1>0));
        res.WM_M_m(s,subj,k) = mean(MAG_X2(MAG_X2>0));
        res.WM_M_s(s,subj,k) = std(MAG_X2(MAG_X2>0));
        
        ABSG_X1 = ABSG_X(:,:,s,k) .* (0.5<c1(:,:,s));
        ABSG_X2 = ABSG_X(:,:,s,k) .* (0.5<c2(:,:,s));
        res.GM_A_m(s,subj,k) = mean(ABSG_X1(MAG_X1>0));
        res.GM_A_s(s,subj,k) = std(ABSG_X1(MAG_X1>0));
        res.WM_A_m(s,subj,k) = mean(ABSG_X2(MAG_X2>0));
        res.WM_A_s(s,subj,k) = std(ABSG_X2(MAG_X2>0));
        
    end
end

end

figure;
subplot(2,2,1)
hold on; plot(squeeze(mean(res.GM_M_m(:,:,1)-res.WM_M_m(:,:,1),2)),'b')
hold on; plot(squeeze(mean(res.GM_M_m(:,:,2)-res.WM_M_m(:,:,2),2)),'r')
subplot(2,2,2)
hold on; plot(squeeze(mean(res.GM_A_m(:,:,1)-res.WM_A_m(:,:,1),2)),'b');
hold on; plot(squeeze(mean(res.GM_A_m(:,:,2)-res.WM_A_m(:,:,2),2)),'r');
subplot(2,2,3)
hold on; plot(squeeze(mean(res.GM_M_m(:,:,3)-res.WM_M_m(:,:,3),2)),'b')
hold on; plot(squeeze(mean(res.GM_M_m(:,:,4)-res.WM_M_m(:,:,4),2)),'r')
subplot(2,2,4)
hold on; plot(squeeze(mean(res.GM_A_m(:,:,3)-res.WM_A_m(:,:,3),2)),'b');
hold on; plot(squeeze(mean(res.GM_A_m(:,:,4)-res.WM_A_m(:,:,4),2)),'r');


%mDATA1 = res.GM_A_m(:,:,1)./res.WM_A_m(:,:,1);
%mDATA2 = res.GM_A_m(:,:,2)./res.WM_A_m(:,:,2);

mDATA1 = res.GM_A_m(:,:,1) %./res.WM_M_m(:,:,1);
mDATA2 = res.WM_A_m(:,:,1) %./res.WM_M_m(:,:,2);

%mDATA1 = res.GM_M_m(:,:,1)-res.WM_M_m(:,:,1);
%mDATA2 = res.GM_M_m(:,:,4)-res.WM_M_m(:,:,4);

DATA1 = mDATA1;
DATA2 = mDATA2;

mDATA1(isnan(mDATA1)) = 0;
mDATA2(isnan(mDATA2)) = 0;

for kslice = 1:size(DATA1,1)
    %[p_signrank(kslice),h_signrank(kslice)] = signrank(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
    [h_signrank(kslice),p_signrank(kslice)] = ttest(squeeze(mDATA1(kslice,:)),squeeze(mDATA2(kslice,:)));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
hold on,
mseb([],mean(DATA1,2)',std(DATA1,[],2)',[],1);
% hold on, plot(DATA1,'b.')
lineProps.col={'r'}; mseb([],mean(DATA2,2)',std(DATA2,[],2)',lineProps,1);
% hold on, plot(DATA2,'r.')
DATA3 = DATA2 - DATA1;
lineProps.col={'g'}; mseb([],mean(DATA3,2)',std(DATA3,[],2)',lineProps,1);
hline2(0.05);
%plot(p_signrank,'k-.');
%hold on
plot(h_signrank*50,'c-.');
hold on
%ylim([-0.1 1]);
        % xlim(xlimits);
% 
% 
% 
% figure, hold on, mseb( [], mean(res.GM_A_m,2)', std(res.GM_A_m,[],2)' ,[],1);  title('WM (red) vs. GM (blue)')
% % hold on, plot(GM_m,'b.')
% lineProps.col={'r'}; mseb( [], mean(res.WM_A_m,2)', std(res.WM_A_m ,[],2)',lineProps,1); xlim([0 80]), ylim([0 1500])
% % hold on, plot(WM_m,'r.')
% 
% figure, title('WM/GM ratio')
% mseb( [], mean(res.WM_A_m./res.GM_A_m,2)', std(WM_m./GM_m,[],2)' ,[],1); ylim([0.9 1.5])
% 
% 
% 
% res_WMGM = res;
% 
% ABC=squeeze(nanmean(res_WMGM.WM_M_m-res_WMGM.GM_M_m,1));
% 
% figure;
% hold on;
% plot(ABC(:,1),'r');
% plot(ABC(:,4),'b');
% 
% 
% 
% ABC=squeeze(mean(res_WMGM.WM_A_m-res_WMGM.GM_A_m,1));
% 
% % figure;
% % hold on;
% % plot(ABC(:,1),'r');
% % plot(ABC(:,4),'b');
% figure;
% plot(sort(ABC(:,4) - ABC(:,1)))
% 
% BB12= (ABC(:,2) - ABC(:,1));
% BB13= (ABC(:,3) - ABC(:,1));
% BB14= (ABC(:,4) - ABC(:,1));
% BB34= (ABC(:,4) - ABC(:,3));
% 
% disp([signrank(BB12) signrank(BB13) signrank(BB14) signrank(BB34)]);
% 
% 
% end


% figure, hold on, mseb( [], mean(GM_m,2)', std(GM_m,[],2)' ,[],1);  title('WM (red) vs. GM (blue)')
% % hold on, plot(GM_m,'b.')
% lineProps.col={'r'}; mseb( [], mean(WM_m,2)', std(WM_m ,[],2)',lineProps,1); xlim([0 80]), ylim([0 1500])
% % hold on, plot(WM_m,'r.')
% 
% figure, title('WM/GM ratio')
% mseb( [], mean(WM_m./GM_m,2)', std(WM_m./GM_m,[],2)' ,[],1); ylim([0.9 1.5])

% figure, hold on, mseb( 10*([1:31]-16), mean(GM_m,2)', std(GM_m,[],2)' ,[],1); 
% % hold on, plot(GM_m,'b.')
% lineProps.col={'r'}; mseb( 10*([1:31]-16), mean(WM_m,2)', std(WM_m ,[],2)',lineProps,1); xlim([-150 150]), ylim([0 1500])
% % hold on, plot(WM_m,'r.')
% 
% rWMGM = mean(WM_m,2)./mean(GM_m,2);
% figure, plot(10*([1:31]-16), rWMGM), ylim([1 1.5]), xlim([-150 150])
% 
% for i=1:31, if rWMGM(i) > 0, [h,p] = ttest2(GM_m(i,:),WM_m(i,:)); pval(i) = p; else pval(i)=NaN; end, end
% figure; plot( 10*([1:31]-16), pval ), xlim([-150 150])