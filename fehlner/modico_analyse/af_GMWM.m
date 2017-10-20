function res = af_GMWM(PROJ_DIR,Asubject)

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1};
    
    MAG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_orig.nii')));
    MAG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_moco.nii')));
    MAG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_dico.nii')));
    MAG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_MAGm_modico.nii')));
    
    ABSG_X(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_orig.nii')));
    ABSG_X(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_moco.nii')));
    ABSG_X(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_dico.nii')));
    ABSG_X(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_ABSG_modico.nii')));    

    c1(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c1_epi2ana_1.nii')));
    c2(:,:,:,1) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c2_epi2ana_1.nii')));
    
    c1(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c1_epi2ana_2.nii')));
    c2(:,:,:,2) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c2_epi2ana_2.nii')));
    
    c1(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c1_epi2ana_3.nii')));
    c2(:,:,:,3) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c2_epi2ana_3.nii')));
    
    c1(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c1_epi2ana_4.nii')));
    c2(:,:,:,4) = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','EPI_c2_epi2ana_4.nii')));
    
    %     B0 = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\BACKUP\ANA\wmy_field.nii']));  

%     load('Mask.mat')
%     Mask = (Mask>9);

for k=1:4
    for s = 1:size(MAG_X,3)
        
        MAG_X1 = MAG_X(:,:,s,k) .* (0.5<c1(:,:,s,k));
        MAG_X2 = MAG_X(:,:,s,k) .* (0.5<c2(:,:,s,k));
        res.GM_M_m(s,subj,k) = mean(MAG_X1(MAG_X1>0));
        res.GM_M_s(s,subj,k) = std(MAG_X1(MAG_X1>0));
        res.WM_M_m(s,subj,k) = mean(MAG_X2(MAG_X2>0));
        res.WM_M_s(s,subj,k) = std(MAG_X2(MAG_X2>0));
        
        ABSG_X1 = ABSG_X(:,:,s,k) .* (0.5<c1(:,:,s,k));
        ABSG_X2 = ABSG_X(:,:,s,k) .* (0.5<c2(:,:,s,k));
        res.GM_A_m(s,subj,k) = mean(ABSG_X1(MAG_X1>0));
        res.GM_A_s(s,subj,k) = std(ABSG_X1(MAG_X1>0));
        res.WM_A_m(s,subj,k) = mean(ABSG_X2(MAG_X2>0));
        res.WM_A_s(s,subj,k) = std(ABSG_X2(MAG_X2>0));
        
    end
end
   
%     dB = 10; % frequency step [Hz]
%     for k = 1:31
%     B = 10*(k-16); % -150 .. +150 Hz
%         
%         X1 = X .* (0.5 < c1) .* ((B-dB/2 < B0) & (B+dB/2 > B0)); % Mask .*
%         X2 = X .* (0.5 < c2) .* ((B-dB/2 < B0) & (B+dB/2 > B0)); 
%         GM_m(k,subj) = mean(X1(X1>0));
%         WM_m(k,subj) = mean(X2(X2>0));
%     
%     end

% figure(88), hold on, mseb( [], GM_m(:,subj)', GM_s(:,subj)' ,[],1); 
% % hold on, plot(GM_m,'b.')
% lineProps.col={'r'}; mseb( [], WM_m(:,subj)', WM_s(:,subj)',lineProps,1); xlim([0 80]), ylim([0 2000])
% % hold on, plot(WM_m,'r.')
% pause(1), close(figure(88)) 

ABC=squeeze(nanmean(res_WMGM.WM_M_m-res_WMGM.GM_M_m,1));

figure;
hold on;
plot(ABC(:,1),'r');
plot(ABC(:,4),'b');



ABC=squeeze(nanmean(res_WMGM.WM_A_m-res_WMGM.GM_A_m,1));

% figure;
% hold on;
% plot(ABC(:,1),'r');
% plot(ABC(:,4),'b');
figure;
plot(ABC(:,4) - ABC(:,1))

BB14= (ABC(:,4) - ABC(:,1));
signrank(BB14)

BB12= (ABC(:,2) - ABC(:,1));
[p,h]=signrank(BB12)

BB13= (ABC(:,3) - ABC(:,1));
signrank(BB13)

disp([mean(ABC(:,4)) mean(ABC(:,1))]);


end



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