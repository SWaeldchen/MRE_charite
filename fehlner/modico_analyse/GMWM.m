function [WM_m, GM_m] = GMWM(PROJ_DIR,Asubject)

for subj = 1:numel(Asubject)
    
    SUBJ_DIR = Asubject{subj}{1};
    
    X  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'\ANA\EPI_MAGm_orig.nii')));
%     B0 = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\BACKUP\ANA\wmy_field.nii']));  
    c1  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'\ANA\EPI_c1_epi2ana_orig.nii')));
    c2  = spm_read_vols(spm_vol(fullfile(PROJ_DIR,SUBJ_DIR,'\ANA\EPI_c2_epi2ana_orig.nii')));
    
    %c1 = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wANA_c1.nii']));
    %c2 = spm_read_vols(spm_vol(['Y:\stefanh\MRDATA\MODICOISMRM\3T\' SUBJ_DIR '\ANA\wANA_c2.nii']));

%     load('Mask.mat')
%     Mask = (Mask>9);

    for s = 1:size(X,3)

        X1 = X(:,:,s) .* (0.5<c1(:,:,s));
        X2 = X(:,:,s) .* (0.5<c2(:,:,s));
        GM_m(s,subj) = mean(X1(X1>0));
        GM_s(s,subj) = std(X1(X1>0));
        WM_m(s,subj) = mean(X2(X2>0));
        WM_s(s,subj) = std(X2(X2>0));
    
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

figure(88), hold on, mseb( [], GM_m(:,subj)', GM_s(:,subj)' ,[],1); 
% hold on, plot(GM_m,'b.')
lineProps.col={'r'}; mseb( [], WM_m(:,subj)', WM_s(:,subj)',lineProps,1); xlim([0 80]), ylim([0 2000])
% hold on, plot(WM_m,'r.')
pause(1), close(figure(88)) 

end


figure, hold on, mseb( [], mean(GM_m,2)', std(GM_m,[],2)' ,[],1);  title('WM (red) vs. GM (blue)')
% hold on, plot(GM_m,'b.')
lineProps.col={'r'}; mseb( [], mean(WM_m,2)', std(WM_m ,[],2)',lineProps,1); xlim([0 80]), ylim([0 1500])
% hold on, plot(WM_m,'r.')

figure, title('WM/GM ratio')
mseb( [], mean(WM_m./GM_m,2)', std(WM_m./GM_m,[],2)' ,[],1); ylim([0.9 1.5])

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