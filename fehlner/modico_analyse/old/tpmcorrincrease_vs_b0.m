% corr2(TPM1,average(C1)) slice-wise and B0-wise

cd('/store01_analysis/realtime/PERF3T/');
clear all

H = spm_vol('MNI_myfield_mean.nii');
B0 = spm_read_vols(H);

% BRAIN MASK
H = spm_vol('wTPM.nii,1'); TP(:,:,:,1) = spm_read_vols(H);
H = spm_vol('wTPM.nii,2'); TP(:,:,:,2) = spm_read_vols(H);
H = spm_vol('wTPM.nii,3'); TP(:,:,:,3) = spm_read_vols(H);
M = sum(TP,4);
BW = (M > 0.9);

% SELECT TISSUE:
%n = 1; % 1=GM, 2=WM, 3=CSF

for n = 1:3,
TPM = squeeze(TP(:,:,:,n));

H = spm_vol(['MNI_c' num2str(n) '_epi2mni_orig_mean.nii']);
D1 = spm_read_vols(H);

H = spm_vol(['MNI_c' num2str(n) '_epi2mni_dico_mean.nii']);
D2 = spm_read_vols(H);

for kslice = 1:79

    % CORRELATION:
    R1(kslice,n) = corr2(TPM(:,:,kslice),D1(:,:,kslice));
    R2(kslice,n) = corr2(TPM(:,:,kslice),D2(:,:,kslice));
    
    % OVERLAP:
    % X1 = TPM(:,:,s) - D1(:,:,s);
    % X2 = TPM(:,:,s) - D2(:,:,s);
    % % X1 = ( (TPM(:,:,40)>0.5) + (D1(:,:,40)>0.5) ==2 ); %2=overlap, 1=mismatch
    % % X2 = ( (TPM(:,:,40)>0.5) + (D2(:,:,40)>0.5) ==2 );
    % sX1(s) = sum(X1(:));
    % sX2(s) = sum(X2(:));
    
    % SUMME IS-VARIABILITY
%     R1(s) = mean2(squeeze(D1(:,:,s)));
%     R2(s) = mean2(squeeze(D2(:,:,s)));
    
B(kslice) = mean2(abs(squeeze( (B0(:,:,kslice).*BW(:,:,kslice)) )));
end
end

RR = 100*(R2./R1-1);
figure
% plot(R1), hold on, plot(R2,'r'), xlim([25 65]), title('red=dico')
subplot(2,1,1)
hold on
plot(RR(:,1),'r');
plot(RR(:,2),'k');
plot(RR(:,3),'b');
xlim([25 65]), ylim([-1 6.1]), ylabel('corr increase [%]'), set(gca, 'xticklabel',{[]})
subplot(2,1,2)
plot(B), ylim([0 16.5]), xlim([25 65]), ylabel('average |B_0|  [Hz]'), xlabel('slice #')

% B0 vs Ratio Dico/Moco 
figure;
plot(B(25:65) , R2(25:65,:)./R1(25:65,:)-1,'.')

%sensitive to motion correction?
% XX=100*(R2./R1-1);
%& YY(:,:)=XX(35:55,:);
% disp(['mean std']);
% disp([mean(YY(:)) std(YY(:))]);

% Korrelation der Korrelation ... B0 vs meanTPM-Kurve
YY(:,:) = RR(25:65,:);
[r, p] = corr(mean(YY,2),B(25:65)');

disp('r');
disp(r);
disp('p');
disp(p);

% figure; plot(sX1), hold on, plot(sX2,'r')

kslice=29;
figure;imagesc(cat(2,M(:,:,kslice).*B0(:,:,kslice)/120+0.5,M(:,:,kslice).*TPM(:,:,kslice),M(:,:,kslice).*D1(:,:,kslice),M(:,:,kslice).*D2(:,:,kslice)),[0 1]), axis image, axis off, colormap(gray)
% figure;imshowpair(TPM(:,:,s),D1(:,:,s))

kslice=30;
figure;imagesc(fliplr(rot90(imfill(M(:,:,kslice),'holes').*B0(:,:,kslice))),[-50 50]),axis image, axis off, colormap(gray), colorbar