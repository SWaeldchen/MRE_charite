function MInf_af(PROJ_DIR,Asubject,id,prestr)

PIC_DIR = fullfile(PROJ_DIR,'PICS');

parfor subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1};
%     Dx = int32(spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\' SUBJ_DIR '\ANA\wx_Twarp_RLdicoma.nii'])));
    X =  int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA','MNI_MPRAGE.nii'))));
    Yo = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_orig.nii']))));
    Yc = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_dico.nii']))));
    
    disp(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_modico.nii']));
    
    Mm(:,:,:,1) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_orig.nii']))));
    Mm(:,:,:,2) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_moco.nii']))));
    Mm(:,:,:,3) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_dico.nii']))));
    Mm(:,:,:,4) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'MAGm_modico.nii']))));
    
    A(:,:,:,1) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_orig.nii']))));
    A(:,:,:,2) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_moco.nii']))));
    A(:,:,:,3) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_dico.nii']))));
    A(:,:,:,4) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_modico.nii']))));
    A_nc(:,:,:,1) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_orig_nc.nii']))));
    A_nc(:,:,:,2) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_moco_nc.nii']))));
    A_nc(:,:,:,3) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_dico_nc.nii']))));
    A_nc(:,:,:,4) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'ABSG_modico_nc.nii']))));
    
    P(:,:,:,1) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_orig.nii']))));
    P(:,:,:,2) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_moco.nii']))));
    P(:,:,:,3) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_dico.nii']))));
    P(:,:,:,4) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_modico.nii']))));
    P_nc(:,:,:,1) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_orig_nc.nii']))));
    P_nc(:,:,:,2) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_moco_nc.nii']))));
    P_nc(:,:,:,3) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_dico_nc.nii']))));
    P_nc(:,:,:,4) = int32(spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'ANA',[prestr 'PHI_modico_nc.nii']))));    
    

    TMPBW1 = getLargestCc(Yo>200);
    TMPBW2 = getLargestCc(Yc>200);
    BW1 = imfill(TMPBW1,'holes');
    BW2 = imfill(TMPBW2,'holes');
    BW = (BW1+BW2) > 0.9;
    mask1 = BW;
    mask2 = BW;

    
    for s=1:size(X,3)
        disp([subj s]);
        %         Dxs(s,subj)   = sum(abs(Dx(Yc(:,:,s)>30)))/numel(Yc(:,:,s)>30);
        MI_o(s,subj)     = MI_GG(X(:,:,s).*int32(mask2(:,:,s)), Yo(:,:,s) .*int32(mask2(:,:,s)));
        MI_c(s,subj)     = MI_GG(X(:,:,s).*int32(mask2(:,:,s)), Yc(:,:,s) .*int32(mask2(:,:,s)));
        MInomask_o(s,subj) = MI_GG(X(:,:,s),Yo(:,:,s));
        MInomask_c(s,subj) = MI_GG(X(:,:,s),Yc(:,:,s));
        IMI(s,subj) = MI_GG(X(:,:,s),X(:,:,s));
        
        IIGLCM(s,subj) = mutualInformationGLCM(double(X(:,:,s)), double(mask1(:,:,s)), double(X(:,:,s)), double(mask1(:,:,s)));
        MIGLCM_o(s,subj) = mutualInformationGLCM(double(X(:,:,s)), double(mask1(:,:,s)), double(Yo(:,:,s)), double(mask2(:,:,s)));
        MIGLCM_c(s,subj) = mutualInformationGLCM(double(X(:,:,s)), double(mask1(:,:,s)), double(Yc(:,:,s)), double(mask2(:,:,s)));
        MIGLCMnomask_o(s,subj) = mutualInformationGLCM(double(X(:,:,s)), double(mask1(:,:,s)), double(Yo(:,:,s)), double(mask2(:,:,s)));
        MIGLCMnomask_c(s,subj) = mutualInformationGLCM(double(X(:,:,s)), ones(size(mask1(:,:,s))), double(Yc(:,:,s)), ones(size(mask2(:,:,s))));        
        
        for kmod = 1:4
            MIGLCM_A(s,subj,kmod) = mutualInformationGLCM(double(A(:,:,s,kmod)), double(mask1(:,:,s)), double(X(:,:,s)), double(mask2(:,:,s)));
            MIGLCM_Anc(s,subj,kmod) = mutualInformationGLCM(double(A_nc(:,:,s,kmod)), double(mask1(:,:,s)), double(X(:,:,s)), double(mask2(:,:,s)));
            MIGLCM_P(s,subj,kmod) = mutualInformationGLCM(double(P(:,:,s,kmod)), double(mask1(:,:,s)), double(X(:,:,s)), double(mask2(:,:,s)));
            MIGLCM_Pnc(s,subj,kmod) = mutualInformationGLCM(double(P_nc(:,:,s,kmod)), double(mask1(:,:,s)), double(X(:,:,s)), double(mask2(:,:,s)));
        end
        
    end
   
end



save(fullfile(PROJ_DIR,['mutual_' id '_' prestr]),'MIGLCM_o','MIGLCM_c','MI_o','MI_c',...
    'MIGLCMnomask_o','MIGLCMnomask_c','MInomask_o','MInomask_c','IMI','IIGLCM',...
    'MIGLCM_A','MIGLCM_Anc','MIGLCM_P','MIGLCM_Pnc');

id = 'data3T';
prestr = 'w';
PROJ_DIR = '/store01_analysis/stefanh/MRDATA/MODICOISMRM/3T/';


load(fullfile(PROJ_DIR,['mutual_' id '_' prestr]),'MIGLCM_o','MIGLCM_c','MI_o','MI_c',...
    'MIGLCMnomask_o','MIGLCMnomask_c','MInomask_o','MInomask_c','IMI','IIGLCM',...
    'MIGLCM_A','MIGLCM_Anc','MIGLCM_P','MIGLCM_Pnc');

    [ht_all2,pt_all2] = ttest(MIGLCM_o',MIGLCM_c');

    mMIGLCM_o = MIGLCM_o;
    mMIGLCM_c = MIGLCM_c;
    
    mMIGLCM_o(isnan(mMIGLCM_o)) = 0;
    mMIGLCM_c(isnan(mMIGLCM_c)) = 0;

for kslice = 1:79
    [ps_all2(kslice),hs_all2(kslice)] = signrank(squeeze(mMIGLCM_o(kslice,:)),squeeze(mMIGLCM_c(kslice,:)));    
end




% figure
% % subplot(2,2,1)
% plot(mean(MIGLCM_c(:,2:end),2) - mean(MIGLCM_o(:,2:end),2)), hold on, plot(0*[1:80]);
% plot(mean(MIGLCMnomask_c(:,2:end),2) - mean(MIGLCMnomask_o(:,2:end),2),'r'), hold on,
% %subplot(2,2,2)
% hold on
% 
% figure
% for ksub = 1:4
% hold on;
% subplot(2,2,ksub)
% plot(MIGLCM_c(:,ksub)), hold on, plot(MIGLCM_o(:,ksub),'r'), plot(0*[1:80]);
% %plot(MIGLCMnomask_c(:,ksub),'r--'), hold on, plot(MIGLCMnomask_o(:,ksub),'r'), plot(0*[1:80]);
% end
% 
% figure
% for ksub = 1:4
% hold on;
% subplot(2,2,ksub)
% hold on
% plot(MIGLCM_c(:,ksub)-MIGLCM_o(:,ksub),'k'), plot(0*[1:80]);
% ylim([-0.2 0.2]);
% end
% 
% figure
% hold on
% subplot(2,1,1)
% hold on
% plot(mean(MIGLCM_c,2)-mean(MIGLCM_o,2),'k'), plot(0*[1:80]);
% subplot(2,1,2)
% hold on
% plot(mean(MIGLCMnomask_c,2)-mean(MIGLCMnomask_o,2),'k'), plot(0*[1:80]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
subplot(2,1,1)
hold on, 
mseb([],mean(MIGLCM_c,2)',std(MIGLCM_c,[],2)',[],1);
% hold on, plot(MIGLCM_c,'b.')
lineProps.col={'r'}; mseb([],mean(MIGLCM_o,2)',std(MIGLCM_o,[],2)',lineProps,1);
% hold on, plot(MIGLCM_o,'r.')
plot(mean(MIGLCM_c,2) - mean(MIGLCM_o,2), 'g');
hline2(0.05);
plot(ps_all2,'k-.');
plot(pt_all2,'k--');
xlim([20 70]);

subplot(2,1,2)
hold on, 
mseb([],mean(MI_c,2)',std(MI_c,[],2)',[],1);
% hold on, plot(MIGLCM_c,'b.')
lineProps.col={'r'}; mseb([],mean(MI_o,2)',std(MI_o,[],2)',lineProps,1);
% hold on, plot(MIGLCM_o,'r.')
plot(mean(MI_c,2) - mean(MI_o,2), 'k');

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
