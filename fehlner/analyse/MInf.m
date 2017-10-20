function [MI_o, MI_c] = Minf(Asubject)

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1}
%     Dx = int32(spm_read_vols(spm_vol(['H:\HETZER\mrdata\MODICO\' SUBJ_DIR '\ANA\wx_Twarp_RLdicoma.nii'])));
    X =  int32(spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\MNI_MPRAGE.nii'])));
    Yo = int32(spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wMAGm_orig.nii'])));
    Yc = int32(spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wMAGm_dico.nii'])));

    for s=1:size(X,3)
%         Dxs(s,subj)   = sum(abs(Dx(Yc(:,:,s)>30)))/numel(Yc(:,:,s)>30);
        MI_o(s,subj)  = MI_GG(X(:,:,s), Yo(:,:,s));
        MI_c(s,subj)  = MI_GG(X(:,:,s), Yc(:,:,s));
%         R_o(s,subj)   = corr2(X(:,:,s), Yo(:,:,s));
%         R_c(s,subj)   = corr2(X(:,:,s), Yc(:,:,s));
%         MSE_o(s,subj) = immse(X(:,:,s), Yo(:,:,s));
%         MSE_c(s,subj) = immse(X(:,:,s), Yc(:,:,s));
    end
   
end
% figure;plot(MI_c - MI_o), hold on, plot(0*[1:80])   % (!)
figure;plot(mean(MI_c(:,2:end),2) - mean(MI_o(:,2:end),2)), hold on, plot(0*[1:80])
figure;plot(MI_c(:,4)), hold on, plot(MI_o(:,4)), plot(0*[1:80])

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
